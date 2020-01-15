import 'dart:io';

import 'package:flutter/material.dart';
import 'cache_manager.dart';

class CachedImageView extends StatefulWidget {
  final String url;
  final BoxFit fit;
  final double width;
  final double height;
  CachedImageView(
      {@required this.url, this.fit = BoxFit.cover, this.width, this.height});
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
    if (_imgFile == null) {
      return Container(
        width: widget.width,
        height: widget.height,
        alignment: Alignment.center,
        child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white)),
      );
    }
    return Image.file(
      _imgFile,
      fit: widget.fit,
      width: widget.width,
      height: widget.height,
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
