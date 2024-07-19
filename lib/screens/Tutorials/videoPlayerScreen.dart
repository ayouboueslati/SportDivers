import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

class VideoPlayerScreen extends StatelessWidget {
  final ChewieController chewieController;

  VideoPlayerScreen({required this.chewieController});

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
          chewieController.videoPlayerController.value.isPlaying
              ? chewieController.videoPlayerController.pause()
              : chewieController.videoPlayerController.play();
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
