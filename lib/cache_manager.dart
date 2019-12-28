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

enum CachePrority {
  Low,
  Normal,
  High,
}

class CacheTask {
  final String url;
  final CachePrority prority;
  final List<CacheListener> _listeners = [];
  File cachedFile;
  CacheTask(this.url, this.prority, {CacheListener listener}) {
    if (listener != null) {
      _listeners.add(listener);
    }
  }

  void onError(DioError e) {
    for (CacheListener listener in _listeners) {
      listener.onCacheFailed(url, e);
    }
  }

  void onCached() {
    for (CacheListener listener in _listeners) {
      listener.onCached(url, cachedFile);
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
}

enum _State {
  Paused,
  Running,
}

class CacheTaskRunner {
  final CachePrority prority;
  final PriorityQueue<CacheTask> taskQueue;
  final Duration sleepDuration;
  CacheTaskRunner({this.taskQueue, this.prority, this.sleepDuration});

  Future<void> run() async {
    //pick task from the queue, check if the same priority
    while (taskQueue.isNotEmpty) {
      CacheTask task = taskQueue.first;
      if (task.prority == prority) {}
    }
  }
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
    }
    return _cacheDir;
  }

  final PriorityQueue<CacheTask> _taskQueue =
      new PriorityQueue<CacheTask>((t1, t2) {
    return t1.prority.index.compareTo(t2.prority.index);
  });

  final Map<String, CacheTask> _tasks = {};

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
    if (await isCached(url)) {
      //return the real file object
      return null;
    } else {
      return null;
    }
  }

  Future<bool> isCached(String url) async {
    //check if the url exists in the cache
    return false;
  }

  Future<CacheTask> downloadUrl(String aUrl,
      {CacheListener listener,
      CachePrority prority = CachePrority.Normal}) async {
    if (aUrl == null || aUrl.isEmpty) {
      debugPrint('invalid url');
      return null;
    }
    String url = aUrl.toLowerCase();
    //check if url exists in the disk cache?
    //memory cache?
    if (await isCached(url)) {
      debugPrint('[$url] aleady cached');
      return null;
    }

    if (_tasks.containsKey(url)) {
      debugPrint('[$url] already in the task queue');
      CacheTask task = _tasks[url];
      //TODO: change the task priority and refresh the task queue if possible.
      return task;
    }

    //if not, add the url into the priority queue
    CacheTask task = new CacheTask(url, prority, listener: listener);
    _taskQueue.add(task);
    _tasks[url] = task;

    //perform caching if it is not running
    _performCaching();
    return task;
  }

  void _performCaching() {
    if (_state != _State.Running) {
      //pick up tasks from the task queue
      //do download
      while (_taskQueue.isNotEmpty) {
        CacheTask task = _taskQueue.removeFirst();
        //here NOT use await to perform muliple tasks at the same time

        _performTask(task);
        //how to download multiple tasks at the same time?
        //how to make sure high priority task could start immediately?
        //how to perform the retry mechanism?
        //how to deal with the retrying tasks and a higher priority tasks?
        //1.download file
        //2.cache file
        //3.remove task
      }
    }
  }

  Future<void> _performTask(CacheTask task) async {
    try {
      String saveFilePath = await _getCacheFilePath(task.url);
      await _dio.download(task.url, saveFilePath);
    } on DioError catch (e) {
      print('Failed to download [$url], ${e.toString()}');
    }
  }

  Future<void> _onCached(String url, File file) async {
    //cache to disk or file
  }

  Future<String> _getCacheFilePath(String url) async {
    //here need generate a unique string by using the url
    return join(await _getCacheDir(), _generateMd5(url));
  }

  String _generateMd5(String input) {
    return md5.convert(utf8.encode(input)).toString();
  }
}
