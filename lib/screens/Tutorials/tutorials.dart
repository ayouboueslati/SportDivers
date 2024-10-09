import 'package:flutter/material.dart';
import 'package:sportdivers/screens/dailoz/dailoz_gloabelclass/dailoz_color.dart';
import 'package:sportdivers/screens/dailoz/dailoz_gloabelclass/dailoz_fontstyle.dart';
import 'package:video_player/video_player.dart';
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
          _error = 'Aucune vidéo trouvée';
        });
        return;
      }

      _videoControllers.clear();
      _isInitialized.clear();

      for (var video in videoProvider.videos) {
        VideoPlayerController videoController =
            VideoPlayerController.network(video.fileUrl);

        _videoControllers.add(videoController);
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
    final size = MediaQuery.of(context).size;
    final height = size.height;
    final width = size.width;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(10),
          child: InkWell(
            splashColor: DailozColor.transparent,
            highlightColor: DailozColor.transparent,
            onTap: () => Navigator.pop(context),
            child: Container(
              height: height / 20,
              width: height / 20,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: DailozColor.white,
                boxShadow: [
                  BoxShadow(
                      color: DailozColor.grey.withOpacity(0.3), blurRadius: 5)
                ],
              ),
              child: Padding(
                padding: EdgeInsets.only(left: width / 56),
                child: Icon(
                  Icons.arrow_back_ios,
                  size: 18,
                  color: DailozColor.black,
                ),
              ),
            ),
          ),
        ),
        title: Text(
          'Lecteur Vidéo',
          style: hsBold.copyWith(
            color: DailozColor.black,
            fontSize: 22,
          ),
        ),
        backgroundColor: DailozColor.white,
        elevation: 0,
      ),
        body: _error != null
            ? Center(child: Text(_error!))
            : _videoControllers.isEmpty
                ? Center(child: CircularProgressIndicator())
                : PageView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: _videoControllers.length,
                    onPageChanged: (index) {
                      if (_playingIndex != null &&
                          _playingIndex! < _videoControllers.length) {
                        _videoControllers[_playingIndex!].pause();
                      }

                      _playingIndex = index;
                      _videoControllers[index].play();
                    },
                    itemBuilder: (context, index) {
                      return _isInitialized[index]
                          ? AspectRatio(
                              aspectRatio:
                                  _videoControllers[index].value.aspectRatio,
                              child: VideoPlayer(_videoControllers[index]),
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
    super.dispose();
  }
}
