import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

// ============ ADJUST VIDEO SIZE HERE ============
const double VIDEO_MIN_HEIGHT = 1000;
const double VIDEO_MIN_WIDTH = 500;
// ===============================================

class VideoPlayerWidget extends StatefulWidget {
  final String videoPath;

  const VideoPlayerWidget({
    super.key,
    required this.videoPath,
  });

  @override
  State<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController _controller;
  bool _hasError = false;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  void _initializeVideo() {
    try {
      _controller = VideoPlayerController.asset(widget.videoPath);
      
      _controller.initialize().then((_) {
        if (mounted) {
          setState(() {});
        }
      }).catchError((error) {
        if (mounted) {
          setState(() {
            _hasError = true;
            _errorMessage = 'Failed to load video: $error';
          });
        }
        print('Video Error: $error');
      });
    } catch (e) {
      setState(() {
        _hasError = true;
        _errorMessage = 'Error initializing video: $e';
      });
      print('Initialization Error: $e');
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_hasError) {
      return Container(
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error,
                color: Colors.red[300],
                size: 40,
              ),
              const SizedBox(height: 12),
              Text(
                'Video Error',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.red[600],
                ),
              ),
              const SizedBox(height: 4),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  _errorMessage,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.red[400],
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (!_controller.value.isInitialized) {
      return Container(
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Stack(
      alignment: Alignment.center,
      children: [
        // Video player - larger display
        Container(
          constraints: BoxConstraints(
            minHeight: VIDEO_MIN_HEIGHT,
            minWidth: VIDEO_MIN_WIDTH,
          ),
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(12),
          ),
          clipBehavior: Clip.hardEdge,
          child: AspectRatio(
            aspectRatio: _controller.value.aspectRatio,
            child: VideoPlayer(_controller),
          ),
        ),
        
        // Play button overlay (if not playing)
        if (!_controller.value.isPlaying)
          GestureDetector(
            onTap: () {
              setState(() {
                _controller.play();
              });
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.4),
                shape: BoxShape.circle,
              ),
              padding: const EdgeInsets.all(16),
              child: const Icon(
                Icons.play_arrow,
                color: Colors.white,
                size: 50,
              ),
            ),
          ),
        
        // Pause button overlay (if playing)
        if (_controller.value.isPlaying)
          GestureDetector(
            onTap: () {
              setState(() {
                _controller.pause();
              });
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.4),
                shape: BoxShape.circle,
              ),
              padding: const EdgeInsets.all(16),
              child: const Icon(
                Icons.pause,
                color: Colors.white,
                size: 50,
              ),
            ),
          ),
      ],
    );
  }
}