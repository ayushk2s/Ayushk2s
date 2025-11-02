import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class BackgroundLoopVideo extends StatefulWidget {
  final String videoPath;

  const BackgroundLoopVideo({super.key, required this.videoPath});

  @override
  State<BackgroundLoopVideo> createState() => _BackgroundLoopVideoState();
}

class _BackgroundLoopVideoState extends State<BackgroundLoopVideo> with WidgetsBindingObserver {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    _controller = VideoPlayerController.asset(widget.videoPath)
      ..setLooping(true)
      ..initialize().then((_) {
        if (mounted) _controller.play();
        setState(() {});
      });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (!mounted) return;
    if (state == AppLifecycleState.paused) {
      _controller.pause();
    } else if (state == AppLifecycleState.resumed) {
      _controller.play();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_controller.value.isInitialized) {
      return const SizedBox.shrink();
    }

    return Positioned.fill(
      child: FittedBox(
        fit: BoxFit.cover,
        child: SizedBox(
          width: _controller.value.size.width,
          height: _controller.value.size.height,
          child: VideoPlayer(_controller),
        ),
      ),
    );
  }
}
