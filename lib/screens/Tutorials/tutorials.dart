import 'package:flutter/material.dart';
import 'package:footballproject/screens/Tutorials/videoPlayerScreen.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'package:provider/provider.dart';
import '../../Provider/VideosProvider/videoProvider.dart';

class VideoApp extends StatefulWidget {
  static const String id = 'Video_screen';

  const VideoApp({Key? key}) : super(key: key);

  @override
  _VideoAppState createState() => _VideoAppState();
}

class _VideoAppState extends State<VideoApp> {
  List<VideoPlayerController> _videoControllers = [];
  List<ChewieController> _chewieControllers = [];
  List<bool> _isInitialized = [];
  String? _error;
  int? _playingIndex; // Index of the currently playing video

  @override
  void initState() {
    super.initState();
    _fetchAndInitializeVideos();
  }

  Future<void> _fetchAndInitializeVideos() async {
    final videoProvider = Provider.of<VideoProvider>(context, listen: false);
    try {
      await videoProvider.fetchVideos();

      if (videoProvider.videos.isEmpty) {
        setState(() {
          _error = 'No videos found';
        });
        return;
      }

      // Clear previous controllers to avoid potential issues
      _videoControllers.clear();
      _chewieControllers.clear();
      _isInitialized.clear();

      for (var video in videoProvider.videos) {
        VideoPlayerController videoController =
            VideoPlayerController.network(video.fileUrl);
        ChewieController chewieController = ChewieController(
          videoPlayerController: videoController,
          autoInitialize: true,
          autoPlay: false,
          showControls: true, // Enable controls for debugging
        );

        _videoControllers.add(videoController);
        _chewieControllers.add(chewieController);
        _isInitialized.add(false);

        videoController.addListener(() {
          if (videoController.value.isInitialized &&
              !_isInitialized[_videoControllers.indexOf(videoController)]) {
            setState(() {
              _isInitialized[_videoControllers.indexOf(videoController)] = true;
            });
          }
        });

        try {
          await videoController.initialize();
        } catch (e) {
          setState(() {
            _error = "Video Player Initialization Error: $e";
          });
        }
      }

      setState(() {});
    } catch (e) {
      setState(() {
        _error = "Error fetching and initializing videos: $e";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Video Demo',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Video Player'),
        ),
        body: _error != null
            ? Center(child: Text(_error!))
            : _videoControllers.isEmpty
                ? Center(child: CircularProgressIndicator())
                : PageView.builder(
                    scrollDirection: Axis.vertical, // Scroll vertically
                    itemCount: _videoControllers.length,
                    onPageChanged: (index) {
                      // Pause previous video
                      if (_playingIndex != null &&
                          _playingIndex! < _chewieControllers.length) {
                        _chewieControllers[_playingIndex!].pause();
                      }

                      // Play the new video
                      _playingIndex = index;
                      _chewieControllers[index].play();
                    },
                    itemBuilder: (context, index) {
                      return _isInitialized[index]
                          ? AspectRatio(
                              aspectRatio:
                                  _videoControllers[index].value.aspectRatio,
                              child: Chewie(
                                controller: _chewieControllers[index],
                              ),
                            )
                          : Center(child: CircularProgressIndicator());
                    },
                  ),
      ),
    );
  }

  @override
  void dispose() {
    for (var controller in _videoControllers) {
      controller.dispose();
    }
    for (var controller in _chewieControllers) {
      controller.dispose();
    }
    super.dispose();
  }
}
