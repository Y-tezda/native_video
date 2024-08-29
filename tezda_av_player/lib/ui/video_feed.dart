import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:tezda_av_player/services/video/native_video_player_controller.dart';
import 'package:tezda_av_player/services/video/ios_native_video_player_view.dart';
import 'package:tezda_av_player/services/video/video_source.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:preload_page_view/preload_page_view.dart';

class VideoScrollScreen extends StatefulWidget {
  const VideoScrollScreen({super.key});

  @override
  State<VideoScrollScreen> createState() => _VideoScrollScreenState();
}

class _VideoScrollScreenState extends State<VideoScrollScreen> {
  List<String> videoSources = [
    "https://test-streams.mux.dev/x36xhzz/x36xhzz.m3u8",
    "https://flipfit-cdn.akamaized.net/flip_hls/661f570aab9d840019942b80-473e0b/video_h1.m3u8",
    "https://flipfit-cdn.akamaized.net/flip_hls/662aae7a42cd740019b91dec-3e114f/video_h1.m3u8",
    "https://flipfit-cdn.akamaized.net/flip_hls/663e5a1542cd740019b97dfa-ccf0e6/video_h1.m3u8",
    "https://flipfit-cdn.akamaized.net/flip_hls/663d1244f22a010019f3ec12-f3c958/video_h1.m3u8",
    "https://flipfit-cdn.akamaized.net/flip_hls/664ce52bd6fcda001911a88c-8f1c4d/video_h1.m3u8",
    "https://flipfit-cdn.akamaized.net/flip_hls/664d87dfe8e47500199ee49e-dbd56b/video_h1.m3u8",
    "https://flipfit-cdn.akamaized.net/flip_hls/6656423247ffe600199e8363-15125d/video_h1.m3u8",
    "https://media.tezda.co/v/f3a5d646f77e6bbfddfa087487aac4e9/master.m3u8",
    "https://media.tezda.co/v/fe4562abf3067fd868b2c1f321bff4ee/master.m3u8",
    "https://media.tezda.co/v/54a4c82a399a6038ee636361dc99222c/master.m3u8",
    "https://media.tezda.co/v/da13367a9a834e9582afea3ad148dd2b/master.m3u8",
    "https://media.tezda.co/v/2049f9d22fa46aa6f5e2ce521da45e8f/master.m3u8",
  ];
  final PreloadPageController _pageController =
      PreloadPageController(initialPage: 0, keepPage: true);
  @override
  Widget build(BuildContext context) {
    return PreloadPageView.builder(
      onPageChanged: (value) {
        print(value);
      },
      preloadPagesCount: 3,
      physics: const AlwaysScrollableScrollPhysics(),
      controller: _pageController,
      scrollDirection: Axis.vertical,
      itemBuilder: (context, index) {
        return IosNativeVideoPlayerView(
          key: Key((index + 1).toString()),
          url: videoSources[index],
        );
      },
      itemCount: videoSources.length,
    );
  }
}
