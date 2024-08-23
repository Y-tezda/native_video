import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:tezda_av_player/services/video/native_video_player_controller.dart';
import 'package:tezda_av_player/services/video/native_video_player_view.dart';
import 'package:tezda_av_player/services/video/video_source.dart';
import 'package:visibility_detector/visibility_detector.dart';

class VideoScrollScreen extends StatefulWidget {
  const VideoScrollScreen({super.key});

  @override
  State<VideoScrollScreen> createState() => _VideoScrollScreenState();
}

class _VideoScrollScreenState extends State<VideoScrollScreen> {
  List<String> videoSources = [
    "https://cdn.flowplayer.com/a30bd6bc-f98b-47bc-abf5-97633d4faea0/hls/de3f6ca7-2db3-4689-8160-0f574a5996ad/playlist.m3u8",
    "https://flipfit-cdn.akamaized.net/flip_hls/661f570aab9d840019942b80-473e0b/video_h1.m3u8",
    "https://flipfit-cdn.akamaized.net/flip_hls/662aae7a42cd740019b91dec-3e114f/video_h1.m3u8",
    "https://flipfit-cdn.akamaized.net/flip_hls/663e5a1542cd740019b97dfa-ccf0e6/video_h1.m3u8",
    "https://flipfit-cdn.akamaized.net/flip_hls/663d1244f22a010019f3ec12-f3c958/video_h1.m3u8",
    "https://flipfit-cdn.akamaized.net/flip_hls/664ce52bd6fcda001911a88c-8f1c4d/video_h1.m3u8",
    "https://flipfit-cdn.akamaized.net/flip_hls/664d87dfe8e47500199ee49e-dbd56b/video_h1.m3u8",
    "https://flipfit-cdn.akamaized.net/flip_hls/6656423247ffe600199e8363-15125d/video_h1.m3u8",
  ];
  final PageController _pageController =
      PageController(initialPage: 0, keepPage: true);
  int _currentPage = 0;
  bool _isOnPageTurning = false;

  void _scrollListener() {
    if (_isOnPageTurning &&
        _pageController.page == _pageController.page!.roundToDouble()) {
      setState(() {
        _currentPage = _pageController.page!.toInt();
        _isOnPageTurning = false;
      });
    } else if (!_isOnPageTurning &&
        _currentPage.toDouble() != _pageController.page) {
      if ((_currentPage.toDouble() - _pageController.page!).abs() > 0.5) {
        setState(() {
          _isOnPageTurning = true;
        });
      }
    }
  }

  //_pageController.addListener(_scrollListener);
  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: _pageController,
      scrollDirection: Axis.vertical,
      itemBuilder: (context, index) {
        return VideoListItemView(
          videoSource: videoSources[index],
          pageIndex: index,
          currentPageIndex: _currentPage,
          isPaused: _isOnPageTurning,
        );
      },
      itemCount: videoSources.length,
    );
  }
}

class VideoListItemView extends StatefulWidget {
  final String videoSource;

  const VideoListItemView({
    super.key,
    required this.pageIndex,
    required this.currentPageIndex,
    required this.isPaused,
    required this.videoSource,
  });
  final int pageIndex;
  final int currentPageIndex;
  final bool isPaused;

  @override
  State<VideoListItemView> createState() => _VideoListItemViewState();
}

class _VideoListItemViewState extends State<VideoListItemView> {
  String viewType = '<platform-view-type>';
  // Pass parameters to the platform side.
  //final Map<String, dynamic> creationParams = <String, dynamic>;

  @override
  void dispose() {
    // TODO: implement dispose
    _controller!.stop();
    super.dispose();
  }

  NativeVideoPlayerController? _controller;
  @override
  Widget build(BuildContext context) {
    final dw = MediaQuery.of(context).size.width;
    final dh = MediaQuery.of(context).size.height;

    return VisibilityDetector(
        onVisibilityChanged: _handleVisibilityDetector,
        key: Key('key_${widget.currentPageIndex}'),
        child: Container(
          color: Colors.black54,
          height: dh,
          width: dw,
          padding: EdgeInsets.all(0),
          child: NativeVideoPlayerView(
            onViewReady: (controller) async {
              _controller = controller;
              await _controller?.setVolume(1);
              _controller?.onPlaybackEnded.addListener(() {
                //  controller.play();
              });
              await _loadVideoSource();
            },
          ),
        ));
  }

  Future<void> _loadVideoSource() async {
    final videoSource = await VideoSource.init(
      type: VideoSourceType.network,
      path: widget.videoSource,
    );
    await _controller?.loadVideoSource(videoSource);
  }

  void _handleVisibilityDetector(VisibilityInfo info) async {
    if (info.visibleFraction == 0) {
      if (widget.pageIndex == widget.currentPageIndex && !widget.isPaused) {
        if (_controller != null) {
          await _controller?.pause();
        }
      }
    } else {
      await _controller?.play();
    }
  }
}
