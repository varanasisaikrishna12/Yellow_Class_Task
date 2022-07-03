import 'dart:developer';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:hls_player/model/video.dart';

import 'package:video_player/video_player.dart';

import '../styles/styles.dart';
import '../utils/duration.dart';

class VideoTile extends StatefulWidget {
  final Video video;

  const VideoTile(this.video, {Key? key}) : super(key: key);

  @override
  State<VideoTile> createState() => VideoTileState();
}

class VideoTileState extends State<VideoTile> {
  late Video video;

  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;
  late VideoPlayerValue _latestValue;

  double progressBar1 = 0;
  double progressBar2 = 0;
  double progressBar3 = 0;
  int maxAnimationHeight = 10;
  double animationBarHeight = 5;

  @override
  void initState() {
    super.initState();
    video = widget.video;

    _controller = VideoPlayerController.network(video.videoUrl,
        videoPlayerOptions: VideoPlayerOptions())
      ..setVolume(0);

    _initializeVideoPlayerFuture = _controller.initialize();

    _controller.addListener(_updateState);

    _updateState();
    log(video.videoUrl);
  }

  void playvideo() {
    _controller.play();

    isVisible = true;
    if (mounted) {
      setState(() {});
    }
  }

  void stopvideo() {
    _controller.pause();
    isVisible = false;
    if (mounted) {
      setState(() {});
    }
  }

  void _updateState() {
    if (!mounted) return;

    progressBar1 = math.Random().nextDouble() * maxAnimationHeight;
    progressBar2 = math.Random().nextDouble() * maxAnimationHeight;
    progressBar3 = math.Random().nextDouble() * maxAnimationHeight;

    _latestValue = _controller.value;

    setState(() {});
  }

  @override
  void dispose() {
    // Ensuring disposing of the VideoPlayerController to free up resources.
    _controller.dispose();
    super.dispose();
  }

  bool isVisible = false;

  Widget _wTile() {
    return ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.grey[300],
          backgroundImage: const NetworkImage("https://i.pravatar.cc/300"),
        ),
        title: Text(
          video.title,
          style: Styles.TxtStyle(
            fontstyle: 'Roboto',
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: Text(
          "${video.totalViews} Views",
          style: Styles.TxtStyle(
            fontstyle: 'Roboto',
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        trailing: const Icon(Icons.more_vert));
  }

  @override
  Widget build(BuildContext context) {
    var hei = MediaQuery.of(context).size.height;
    return SizedBox(
      height: hei / 3 + 50,
      child: FutureBuilder(
          future: _initializeVideoPlayerFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return Column(
                children: <Widget>[
                  Expanded(
                    child: isVisible
                        ? Stack(
                            children: [
                              VideoPlayer(
                                _controller,
                              ),
                              Positioned(
                                  bottom: 10,
                                  right: 10,
                                  child: Row(
                                    children: [
                                      _buildAudioWave(),
                                      const SizedBox(width: 10),
                                      _buildPosition()
                                    ],
                                  ))
                            ],
                          )
                        : Image.network(video.coverPicture, fit: BoxFit.fill),
                  ),
                  _wTile(),
                  const SizedBox(height: 10)
                ],
              );
            } else {
              // If the VideoPlayerController is still initializing, show a
              // loading spinner and thumbnail url
              return Stack(
                children: [
                  Positioned.fill(
                    child: Column(
                      children: [
                        Expanded(
                          child: Image.network(
                            video.coverPicture,
                            fit: BoxFit.cover,
                          ),
                        ),
                        _wTile(),
                        const SizedBox(height: 10)
                      ],
                    ),
                  ),
                  const Center(
                    child: CircularProgressIndicator(color: Colors.white),
                  ),
                ],
              );
            }
          }),
    );
  }

  Widget _wAnimationBar(double height) {
    return AnimatedContainer(
      margin: const EdgeInsets.symmetric(horizontal: 1),
      duration: const Duration(milliseconds: 500),
      height: height,
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(1),
            topRight: Radius.circular(1),
          ),
          color: Colors.white),
      width: animationBarHeight,
    );
  }

  Widget _buildAudioWave() {
    return SizedBox(
      height: double.tryParse(maxAnimationHeight.toString()),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          _wAnimationBar(progressBar1),
          _wAnimationBar(progressBar2),
          _wAnimationBar(progressBar3),
        ],
      ),
    );
  }

  Widget _buildPosition() {
    final position = _latestValue.position;
    final duration = _latestValue.duration;

    final durationDiff = duration - position;

    return Container(
      decoration: const BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.all(Radius.circular(5))),
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
      child: RichText(
        text: TextSpan(
          //     text: '${formatDuration(position)} ',
          children: <InlineSpan>[
            TextSpan(
              text: formatDuration(durationDiff),
              style: TextStyle(
                fontSize: 10,
                color: Colors.white.withOpacity(.75),
                fontWeight: FontWeight.normal,
              ),
            )
          ],
          style: const TextStyle(
            fontSize: 10,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }


}
