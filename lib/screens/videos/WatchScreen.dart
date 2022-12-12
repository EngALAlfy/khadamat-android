import 'package:chewie/chewie.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:khadamat_app/widgets/IsLoadingWidget.dart';
import 'package:video_player/video_player.dart';

class WatchScreen extends StatefulWidget {
  final String link;
  final bool progress;

  WatchScreen({this.link, this.progress = true});

  @override
  _VideoViewState createState() => _VideoViewState();
}

class _VideoViewState extends State<WatchScreen>
    with SingleTickerProviderStateMixin {
  VideoPlayerController _videoPlayerController;
  ChewieController chewieController;
  Future<void> _videoPlayerFuture;

  @override
  void initState() {
    super.initState();

    if (widget.link.toString().contains(RegExp(
        r"(.mkv|.mp4|.webm|.ogv|.m3u|.m3u8)",
        caseSensitive: false)) &&
        !widget.link.toString().contains(RegExp(
            r"(<iframe|<div|href=|src=|width=|height=|<frame)",
            caseSensitive: false))) {
      _videoPlayerController = VideoPlayerController.network(widget.link);
      _videoPlayerFuture = _videoPlayerController.initialize().then((_) =>
      {
        chewieController = ChewieController(
          videoPlayerController: _videoPlayerController,
          allowedScreenSleep: false,
          autoPlay: true,),
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.link.toString().contains(RegExp(
        r"(.mkv|.mp4|.webm|.ogv|.m3u|.m3u8)",
        caseSensitive: false)) &&
        !widget.link.toString().contains(RegExp(
            r"(<iframe|<div|href=|src=|width=|height=|<frame)",
            caseSensitive: false))) {
      return FutureBuilder(
        future: _videoPlayerFuture,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (_videoPlayerController.value.isInitialized &&
              snapshot.connectionState == ConnectionState.done) {
            return Scaffold(
              body: Chewie(
                controller: chewieController,
              ),
            );
          } else {
            return IsLoadingWidget();
          }
        },
      );
    } else {
      return WebviewScaffold(
        url: widget.link,
        withJavascript: true,
        withLocalStorage: true,
        appCacheEnabled: true,
        supportMultipleWindows: true,
        scrollBar: false,
        hidden: true,
      );
    }
  }

  @override
  void dispose() {
    _videoPlayerController?.dispose();
    chewieController.dispose();
    super.dispose();
  }
}
