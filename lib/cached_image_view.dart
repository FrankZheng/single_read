import 'dart:io';

import 'package:flutter/material.dart';
import 'cache_manager.dart';

class CachedImageView extends StatefulWidget {
  final String url;
  CachedImageView({@required this.url});
  @override
  _CachedImageViewState createState() => _CachedImageViewState();
}

class _CachedImageViewState extends State<CachedImageView> with CacheListener {
  File _imgFile;
  final CacheManager _cacheManager = CacheManager.shared;
  CacheTask _cacheTask;

  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  void dispose() {
    super.dispose();
    _cacheTask?.removeListener(this);
  }

  @override
  Widget build(BuildContext context) {
    return _imgFile == null
        ? Center(
            child: CircularProgressIndicator(),
          )
        : Image.file(
            _imgFile,
            fit: BoxFit.cover,
          );
  }

  Future<void> _init() async {
    File file = await _cacheManager.getCachedFile(widget.url);
    if (file != null) {
      debugPrint('img file cached already');
      setState(() {
        _imgFile = file;
      });
    } else {
      _cacheTask = await _cacheManager.downloadUrl(widget.url,
          listener: this, priority: CachePriority.High);
    }
  }

  @override
  void onCached(String url, File file) {
    debugPrint('image cached');
    if (mounted) {
      setState(() {
        _imgFile = file;
      });
    }
  }

  @override
  void onCacheFailed(String url, Exception exception) {
    super.onCacheFailed(url, exception);
  }
}
