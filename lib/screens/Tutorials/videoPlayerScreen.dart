import 'package:flutter/material.dart';
import 'package:chewie/chewie.dart';

class VideoPlayerScreen extends StatelessWidget {
  final ChewieController chewieController;

  const VideoPlayerScreen({Key? key, required this.chewieController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Video Player'),
      ),
      body: Center(
        child: AspectRatio(
          aspectRatio: chewieController.videoPlayerController.value.aspectRatio,
          child: Chewie(controller: chewieController),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (chewieController.videoPlayerController.value.isPlaying) {
            chewieController.videoPlayerController.pause();
          } else {
            chewieController.videoPlayerController.play();
          }
        },
        child: Icon(
          chewieController.videoPlayerController.value.isPlaying
              ? Icons.pause
              : Icons.play_arrow,
        ),
      ),
    );
  }
}
