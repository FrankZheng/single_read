import 'dart:convert';
import 'dart:io';

import 'package:collection/collection.dart';
import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class CacheListener {
  void onCached(String url, File file) {
    debugPrint('onCached, $url');
  }

  void onCacheFailed(String url, Exception exception) {
    debugPrint('onCacheFailed, $url, $exception');
  }
}

enum CachePriority {
  Low,
  Normal,
  High,
}

class CacheTask {
  final String url;
  CachePriority priority;
  final List<CacheListener> _listeners = [];
  File cachedFile;
  CacheTask(this.url, this.priority, {CacheListener listener}) {
    if (listener != null) {
      _listeners.add(listener);
    }
  }

  void onError(DioError e) {
    for (CacheListener listener in _listeners) {
      listener.onCacheFailed(url, e);
    }
  }

  void onCached(File file) {
    cachedFile = file;
    for (CacheListener listener in _listeners) {
      listener.onCached(url, file);
    }
  }

  void addListener(CacheListener listener) {
    _listeners.add(listener);
  }

  //listener remember to remove itself when dispose
  //dart/flutter doesn't have a weak reference
  void removeListener(CacheListener listener) {
    _listeners.remove(listener);
  }

  @override
  String toString() {
    return "url: $url, priority: $priority";
  }
}

enum _State {
  Paused,
  Running,
}

class CacheManager {
  static CacheManager shared = CacheManager();
  _State _state = _State.Paused;
  final _dio = new Dio();
  String _cacheDir;

  Future<String> _getCacheDir() async {
    if (_cacheDir == null) {
      Directory dir = await getApplicationDocumentsDirectory();
      _cacheDir = join(dir.path, 'cache_dir');
      Directory cacheDir = Directory(_cacheDir);
      if (!cacheDir.existsSync()) {
        cacheDir.createSync();
      }
      debugPrint('$_cacheDir');
    }
    return _cacheDir;
  }

  CacheManager() {
    _taskQueue = _createTaskQueue();
  }

  PriorityQueue<CacheTask> _taskQueue;

  final Map<String, CacheTask> _tasks = {};

  PriorityQueue<CacheTask> _createTaskQueue() {
    return new PriorityQueue<CacheTask>((t1, t2) {
      return t1.priority.index.compareTo(t2.priority.index);
    });
  }

  void resume() {
    //may save the download tasks, then resume the tasks here?
  }

  void pause() {
    //pause all the download tasks
  }

  void clearCache() {
    //clear all cached files
  }

  Future<File> getCachedFile(String url) async {
    String filePath = await _getCacheFilePath(url);
    File file = File(filePath);
    if (await file.exists()) {
      return file;
    }
    return null;
  }

  Future<bool> isCached(String url) async {
    //check if the url exists in the cache
    String filePath = await _getCacheFilePath(url);
    File file = File(filePath);
    return file.exists();
  }

  Future<CacheTask> downloadUrl(String url,
      {CacheListener listener,
      CachePriority priority = CachePriority.Normal}) async {
    debugPrint('download url: $url');
    if (url == null || url.isEmpty) {
      debugPrint('invalid url');
      return null;
    }
    //check if url exists in the disk cache?
    //memory cache?
    if (await isCached(url)) {
      debugPrint('[$url] aleady cached');
      return null;
    }

    if (_tasks.containsKey(url)) {
      debugPrint('[$url] already in the task queue');
      CacheTask task = _tasks[url];
      if (task.priority != priority) {
        task.priority = priority;
        _shuffleTasks();
      }
      return task;
    }

    //if not, add the url into the priority queue
    CacheTask task = new CacheTask(url, priority, listener: listener);
    _taskQueue.add(task);
    _tasks[url] = task;

    //perform caching is not running
    _performCaching();
    return task;
  }

  void _shuffleTasks() {
    //some task's priority changed, need re-sort the tasks
    var taskQueue = _createTaskQueue();
    taskQueue.addAll(_taskQueue.toList());
  }

  void _performCaching() {
    debugPrint('perform cache tasks');
    if (_state != _State.Running) {
      //pick up tasks from the task queue
      //do download
      _state = _State.Running;
      while (_taskQueue.isNotEmpty) {
        CacheTask task = _taskQueue.removeFirst();
        _performTask(task);
        sleep(Duration(milliseconds: 10));
      }
      _state = _State.Paused;
    }
  }

  Future<void> _performTask(CacheTask task) async {
    try {
      String saveFilePath = await _getCacheFilePath(task.url);
      debugPrint('cache task: $task, file path: $saveFilePath');
      await _dio.download(task.url, saveFilePath);
      task.onCached(File(saveFilePath));
    } on DioError catch (e) {
      debugPrint('Failed to download [$url], ${e.toString()}');
      task.onError(e);
    } finally {
      _tasks.remove(task.url);
    }
  }

  Future<String> _getCacheFilePath(String url) async {
    //here need generate a unique string by using the url
    String ext = extension(url);
    String md5 = _generateMd5(url);
    String filename = md5 + ext;
    return join(await _getCacheDir(), filename);
  }

  String _generateMd5(String input) {
    return md5.convert(utf8.encode(input)).toString();
  }
}
