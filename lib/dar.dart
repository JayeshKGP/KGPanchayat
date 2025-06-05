import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class Dar extends StatefulWidget {
  const Dar({Key? key}) : super(key: key);

  @override
  State<Dar> createState() => _DarState();
}

class _DarState extends State<Dar> {
  late VideoPlayerController _controller;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
        onPressed: () {
      setState(() {
        _controller.value.isPlaying
            ? _controller.pause()
            : _controller.play();
      });
    },
          child: Icon(
            _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
          ),
        ),
      body: SingleChildScrollView(child: Column(children: [
        Center(
          child: _controller.value.isInitialized
              ? AspectRatio(
            aspectRatio: _controller.value.aspectRatio,
            child: VideoPlayer(_controller),
          )
              : Container(),
        ),
      ],),),
    );
  }

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(Uri.parse(
        'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4'))
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
      });
  }
}
