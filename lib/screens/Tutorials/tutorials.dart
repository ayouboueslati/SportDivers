import 'package:flutter/material.dart';
import 'package:footballproject/screens/Tutorials/videoPlayerScreen.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

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

  @override
  void initState() {
    super.initState();
    _initializeVideoPlayers();
  }

  Future<void> _initializeVideoPlayers() async {
    List<String> videoPaths = [
      'assets/video.mp4',
      'assets/video.mp4',
      'assets/video.mp4',
      'assets/video.mp4',
      'assets/video.mp4',
    ];

    for (String path in videoPaths) {
      VideoPlayerController videoController = VideoPlayerController.asset(path);
      ChewieController chewieController = ChewieController(
        videoPlayerController: videoController,
        autoInitialize: true,
        autoPlay: false,
        showControls: true,
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
        print("Video Player Initialization Error: $e");
      }
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Video Demo',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Video Player'),
        ),
        body: _videoControllers.isEmpty
            ? Center(child: CircularProgressIndicator())
            : ListView.builder(
                itemCount: _videoControllers.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => VideoPlayerScreen(
                            chewieController: _chewieControllers[index],
                          ),
                        ),
                      );
                    },
                    child: _isInitialized[index]
                        ? AspectRatio(
                            aspectRatio:
                                _videoControllers[index].value.aspectRatio,
                            child:
                                Chewie(controller: _chewieControllers[index]),
                          )
                        : Center(child: CircularProgressIndicator()),
                  );
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
