import 'dart:io';
import 'dart:math';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:jtech_pomelo/base/base_widget.dart';
import 'package:jtech_pomelo/util/picker/file_info.dart';
import 'package:jtech_pomelo/widget/future_builder.dart';
import 'package:jtech_pomelo/widget/video_player/custom_controls.dart';
import 'package:video_player/video_player.dart';

/*
* 播放器组件
* @author JTech JH
* @Time 2022/3/31 15:38
*/
class JVideoPlayer extends BaseStatefulWidget {
  //播放器控制器
  final ChewieController controller;

  //视频组件容器尺寸
  final Size? size;

  //背景色
  final Color backgroundColor;

  //对齐方式
  final Alignment align;

  //是否自动播放
  final bool autoPlay;

  JVideoPlayer({
    Key? key,
    required VideoPlayerController controller,
    this.size,
    Duration? startAt,
    bool? looping,
    bool? showControls,
    bool? showControlsOnInitialize,
    bool? fullScreenByDefault,
    bool? allowedScreenSleep,
    bool? allowFullScreen,
    bool? allowMuting,
    bool? allowPlaybackSpeedChanging,
    bool? showOptions,
    Color? backgroundColor,
    Alignment? align,
    bool? autoPlay,
  })  : controller = ChewieController(
          videoPlayerController: controller,
          startAt: startAt,
          looping: looping ?? false,
          fullScreenByDefault: fullScreenByDefault ?? false,
          showControls: showControls ?? true,
          showControlsOnInitialize: showControlsOnInitialize ?? true,
          allowedScreenSleep: allowedScreenSleep ?? true,
          allowFullScreen: allowFullScreen ?? true,
          allowMuting: allowMuting ?? true,
          allowPlaybackSpeedChanging: allowPlaybackSpeedChanging ?? true,
          showOptions: showOptions ?? false,
          customControls: const CustomControls(),
        ),
        backgroundColor = backgroundColor ?? Colors.grey,
        align = align ?? Alignment.center,
        autoPlay = autoPlay ?? false,
        super(key: key);

  //从JFile中加载视频
  JVideoPlayer.jFile({
    Key? key,
    required JFile file,
    //基础参数
    bool? autoPlay,
    Duration? startAt,
    bool? looping,
    bool? showControls,
    bool? showControlsOnInitialize,
    bool? fullScreenByDefault,
    bool? allowedScreenSleep,
    bool? allowFullScreen,
    bool? allowMuting,
    bool? allowPlaybackSpeedChanging,
    bool? showOptions,
    Size? size,
    Color? backgroundColor,
    Alignment? align,
  }) : this(
          key: key,
          controller: file.isNetFile
              ? VideoPlayerController.network(file.uri)
              : VideoPlayerController.file(file.file!),
          autoPlay: autoPlay,
          startAt: startAt,
          looping: looping,
          showControls: showControls,
          showControlsOnInitialize: showControlsOnInitialize,
          fullScreenByDefault: fullScreenByDefault,
          allowedScreenSleep: allowedScreenSleep,
          allowFullScreen: allowFullScreen,
          allowMuting: allowMuting,
          allowPlaybackSpeedChanging: allowPlaybackSpeedChanging,
          showOptions: showOptions,
          size: size,
          backgroundColor: backgroundColor ?? Colors.grey,
          align: align ?? Alignment.center,
        );

  //加载本地视频
  JVideoPlayer.file({
    Key? key,
    required File file,
    //基础参数
    bool? autoPlay,
    Duration? startAt,
    bool? looping,
    bool? showControls,
    bool? showControlsOnInitialize,
    bool? fullScreenByDefault,
    bool? allowedScreenSleep,
    bool? allowFullScreen,
    bool? allowMuting,
    bool? allowPlaybackSpeedChanging,
    bool? showOptions,
    Size? size,
    Color? backgroundColor,
    Alignment? align,
  }) : this(
          key: key,
          controller: VideoPlayerController.file(file),
          autoPlay: autoPlay,
          startAt: startAt,
          looping: looping,
          showControls: showControls,
          showControlsOnInitialize: showControlsOnInitialize,
          fullScreenByDefault: fullScreenByDefault,
          allowedScreenSleep: allowedScreenSleep,
          allowFullScreen: allowFullScreen,
          allowMuting: allowMuting,
          allowPlaybackSpeedChanging: allowPlaybackSpeedChanging,
          showOptions: showOptions,
          size: size,
          backgroundColor: backgroundColor ?? Colors.grey,
          align: align ?? Alignment.center,
        );

  //加载网络视频
  JVideoPlayer.net({
    Key? key,
    required String url,
    Map<String, String> headers = const {},
    //基础参数
    bool? autoPlay,
    Duration? startAt,
    bool? looping,
    bool? showControls,
    bool? showControlsOnInitialize,
    bool? fullScreenByDefault,
    bool? allowedScreenSleep,
    bool? allowFullScreen,
    bool? allowMuting,
    bool? allowPlaybackSpeedChanging,
    bool? showOptions,
    Size? size,
    Color? backgroundColor,
    Alignment? align,
  }) : this(
          key: key,
          controller: VideoPlayerController.network(url, httpHeaders: headers),
          autoPlay: autoPlay,
          startAt: startAt,
          looping: looping,
          showControls: showControls,
          showControlsOnInitialize: showControlsOnInitialize,
          fullScreenByDefault: fullScreenByDefault,
          allowedScreenSleep: allowedScreenSleep,
          allowFullScreen: allowFullScreen,
          allowMuting: allowMuting,
          allowPlaybackSpeedChanging: allowPlaybackSpeedChanging,
          showOptions: showOptions,
          size: size,
          backgroundColor: backgroundColor ?? Colors.grey,
          align: align ?? Alignment.center,
        );

  //加载asset视频
  JVideoPlayer.asset({
    Key? key,
    required String path,
    String? package,
    //基础参数
    bool? autoPlay,
    Duration? startAt,
    bool? looping,
    bool? showControls,
    bool? showControlsOnInitialize,
    bool? fullScreenByDefault,
    bool? allowedScreenSleep,
    bool? allowFullScreen,
    bool? allowMuting,
    bool? allowPlaybackSpeedChanging,
    bool? showOptions,
    Size? size,
    Color? backgroundColor,
    Alignment? align,
  }) : this(
          key: key,
          controller: VideoPlayerController.asset(path, package: package),
          autoPlay: autoPlay,
          startAt: startAt,
          looping: looping,
          showControls: showControls,
          showControlsOnInitialize: showControlsOnInitialize,
          fullScreenByDefault: fullScreenByDefault,
          allowedScreenSleep: allowedScreenSleep,
          allowFullScreen: allowFullScreen,
          allowMuting: allowMuting,
          allowPlaybackSpeedChanging: allowPlaybackSpeedChanging,
          showOptions: showOptions,
          size: size,
          backgroundColor: backgroundColor ?? Colors.grey,
          align: align ?? Alignment.center,
        );

  @override
  State<StatefulWidget> createState() => JVideoPlayerState();
}

/*
* 播放器组件-状态
* @author JTech JH
* @Time 2022/3/31 15:40
*/
class JVideoPlayerState extends BaseState<JVideoPlayer> {
  @override
  Widget build(BuildContext context) {
    return JFutureBuilder<bool>(
      future: () async {
        await playerController.initialize();
        if (widget.autoPlay) widget.controller.play();
        return playerController.value.isInitialized;
      },
      builder: (_, snap) {
        return SizedBox.fromSize(
          size: widget.size ?? _getVideoSize(context, videoValue.size),
          child: Container(
            color: widget.backgroundColor,
            alignment: widget.align,
            child: Chewie(controller: widget.controller),
          ),
        );
      },
    );
  }

  //获取当前视频播放器参数
  VideoPlayerValue get videoValue => playerController.value;

  //获取视频播放器控制器
  VideoPlayerController get playerController =>
      widget.controller.videoPlayerController;

  //进入全屏
  void enterFullScreen() => widget.controller.enterFullScreen();

  //退出全屏
  void exitFullScreen() => widget.controller.exitFullScreen();

  //切换全屏状态
  void toggleFullScreen() => widget.controller.toggleFullScreen();

  //切换暂停状态
  void togglePause() => widget.controller.togglePause();

  //播放
  Future<void> play() => widget.controller.play();

  //设置循环模式
  Future<void> setLooping(bool looping) =>
      widget.controller.setLooping(looping);

  //暂停
  Future<void> pause() => widget.controller.pause();

  //滑动到指定位置
  Future<void> seekTo(Duration moment) => widget.controller.seekTo(moment);

  //设置音量
  Future<void> setVolume(double volume) => widget.controller.setVolume(volume);

  //设置字幕
  void setSubtitle(List<Subtitle> newSubtitle) =>
      widget.controller.setSubtitle(newSubtitle);

  //计算视频实际展示尺寸
  Size _getVideoSize(BuildContext context, Size videoSize) {
    var limitSize = widget.size ?? MediaQuery.of(context).size;
    var wRatio = limitSize.width / videoSize.width;
    var hRatio = limitSize.height / videoSize.height;
    var ratio = min(wRatio, hRatio);
    return Size(
      ratio == wRatio ? limitSize.width : videoSize.width * ratio,
      ratio == hRatio ? limitSize.height : videoSize.height * ratio,
    );
  }

  @override
  void dispose() {
    //销毁控制器
    widget.controller.dispose();
    playerController.dispose();
    super.dispose();
  }
}
