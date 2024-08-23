import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';


/// Class that contains the attributes of a video file.
@JsonSerializable()
class VideoInfo {
  /// Height of the video frame, in pixels.
  final int height;

  /// Width of the video frame, in pixels.
  final int width;

  /// Duration of the video, in seconds.
  final int duration;

  /// Aspect ratio of the video frame, in pixels.
  double get aspectRatio => //
      height > 0 && width > 0 //
          ? width / height
          : 1;

  /// NOTE: For internal use only.
  @protected
  VideoInfo({
    required this.height,
    required this.width,
    required this.duration,
  });

  factory VideoInfo.fromJson(Map<String, dynamic> json) {
    return _$VideoInfoFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$VideoInfoToJson(this);
  }
}
VideoInfo _$VideoInfoFromJson(Map<String, dynamic> json) => VideoInfo(
      height: json['height'] as int,
      width: json['width'] as int,
      duration: json['duration'] as int,
    );

Map<String, dynamic> _$VideoInfoToJson(VideoInfo instance) => <String, dynamic>{
      'height': instance.height,
      'width': instance.width,
      'duration': instance.duration,
    };
