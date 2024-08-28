import 'package:flutter/widgets.dart';
import 'package:preload_page_view/preload_page_view.dart';
import 'package:tezda_av_player/services/video/native_video_player_controller.dart';
import 'package:tezda_av_player/services/video/video_source.dart';
import 'package:visibility_detector/visibility_detector.dart';

class IosNativeVideoPlayerView extends StatefulWidget {
  //final void Function(NativeVideoPlayerController)? onViewReady;
  final String url;

  const IosNativeVideoPlayerView({
    super.key,
    required this.url,
  });

  @override
  _IosNativeVideoPlayerViewState createState() =>
      _IosNativeVideoPlayerViewState();
}

class _IosNativeVideoPlayerViewState extends State<IosNativeVideoPlayerView> {
  NativeVideoPlayerController? controller;
  @override
  Widget build(BuildContext context) {
    /// RepaintBoundary is a widget that isolates repaints
    return RepaintBoundary(
      child: _buildNativeView(),
    );
  }

  Widget _buildNativeView() {
    final viewType = 'native_video_player_view';

    return VisibilityDetector(
      key: widget.key!,
      onVisibilityChanged: _handleVisibilityDetector,
      child: UiKitView(
        viewType: viewType,
        onPlatformViewCreated: onPlatformViewCreated,
        // creationParams: creationParams,
        // creationParamsCodec: const StandardMessageCodec(),
      ),
    );
  }

  /// when the native view is created.
  onPlatformViewCreated(int id) async {
    controller = NativeVideoPlayerController(id);

    await controller?.loadVideoSource(
        VideoSource(path: widget.url, type: VideoSourceType.network));
    await controller?.setVolume(1);

    controller?.onPlaybackEnded.addListener(() async {
      await controller?.play();
    });
/*     widget.pageController.addListener(() {
      controller?.pause();
    }); */
    VisibilityDetectorController.instance.updateInterval =
        Duration(milliseconds: 400);
  }

  void _handleVisibilityDetector(VisibilityInfo info) async {
    if (controller != null) {
      if (info.visibleFraction <= 0.2) {
        await controller?.stop();
      } else if (info.visibleFraction <= 0.9) {
        await controller?.pause();

        print(
            'pausing video ${widget.url} visibility :${info.visibleFraction}');
      } else {
        await controller?.play();
        print(
            'playing video ${widget.url} visibility :${info.visibleFraction}');
      }
    }
  }
  /*  void _handleVisibilityDetector(VisibilityInfo info) async {
    if (info.visibleFraction <= 0.7) {
      if (widget.pageIndex == widget.currentPageIndex && !widget.isPaused) {
        if (controller != null) {
          await controller?.pause();

          print(
              'pausing video ${widget.url} visibility :${info.visibleFraction}');
        }
      }
    } else {
      await controller?.play();
      print('playing video ${widget.url} visibility :${info.visibleFraction}');
    }
  } */
}
