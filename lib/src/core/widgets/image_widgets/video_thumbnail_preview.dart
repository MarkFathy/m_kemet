import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:m_kemet/src/config/res/color_manager.dart';
import 'package:video_player/video_player.dart';

class VideoThumbnailPreview extends StatefulWidget {
  final String? thumbnailUrl;
  final String videoUrl;
  final BoxFit fit;

  const VideoThumbnailPreview({
    super.key,
    this.thumbnailUrl,
    required this.videoUrl,
    this.fit = BoxFit.cover,
  });

  @override
  State<VideoThumbnailPreview> createState() => _VideoThumbnailPreviewState();
}

class _VideoThumbnailPreviewState extends State<VideoThumbnailPreview> {
  VideoPlayerController? _controller;
  bool _isInitialized = false;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _initThumbnail();
  }

  @override
  void didUpdateWidget(covariant VideoThumbnailPreview oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.videoUrl != widget.videoUrl ||
        oldWidget.thumbnailUrl != widget.thumbnailUrl) {
      _controller?.dispose();
      _controller = null;
      _isInitialized = false;
      _hasError = false;
      _initThumbnail();
    }
  }

  void _initThumbnail() {
    // 1. If explicit thumbnail is provided, no need to initialize video controller
    if (widget.thumbnailUrl != null && widget.thumbnailUrl!.trim().isNotEmpty) {
      return;
    }

    // 2. Otherwise, load the first frame of the video
    final cleanUrl = widget.videoUrl.trim();
    if (cleanUrl.isEmpty) return;

    try {
      final uri = Uri.tryParse(cleanUrl);
      if (uri == null) {
        _hasError = true;
        return;
      }

      _controller = VideoPlayerController.networkUrl(uri)
        ..initialize().then((_) {
          if (!mounted) return;
          _controller?.setVolume(0.0);
          _controller?.pause();
          setState(() {
            _isInitialized = true;
          });
        }).catchError((_) {
          if (!mounted) return;
          setState(() {
            _hasError = true;
          });
        });
    } catch (_) {
      _hasError = true;
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Case 1: Explicit thumbnail image available
    if (widget.thumbnailUrl != null && widget.thumbnailUrl!.trim().isNotEmpty) {
      return CachedNetworkImage(
        imageUrl: widget.thumbnailUrl!.trim(),
        fit: widget.fit,
        color: Colors.black.withValues(alpha: 0.35),
        colorBlendMode: BlendMode.darken,
        placeholder: (context, url) => Container(color: AppColors.midnightNavy),
        errorWidget: (context, url, error) => _buildFallback(),
      );
    }

    // Case 2: Video first frame loaded
    if (_isInitialized && _controller != null) {
      final size = _controller!.value.size;
      final width = size.width > 0 ? size.width : 16.0;
      final height = size.height > 0 ? size.height : 9.0;

      return Stack(
        fit: StackFit.expand,
        children: [
          FittedBox(
            fit: widget.fit,
            clipBehavior: Clip.hardEdge,
            child: SizedBox(
              width: width,
              height: height,
              child: VideoPlayer(_controller!),
            ),
          ),
          Container(
            color: Colors.black.withValues(alpha: 0.35),
          ),
        ],
      );
    }

    // Case 3: Error or empty video url
    if (_hasError || widget.videoUrl.trim().isEmpty) {
      return _buildFallback();
    }

    // Case 4: Loading first frame placeholder
    return Container(
      color: AppColors.midnightNavy,
      child: Center(
        child: Icon(
          Icons.play_circle_outline_rounded,
          size: 44.sp,
          color: AppColors.whiteColor.withValues(alpha: 0.25),
        ),
      ),
    );
  }

  Widget _buildFallback() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.midnightNavy,
            AppColors.darkNavy,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Center(
        child: Icon(
          Icons.video_library_rounded,
          size: 54.sp,
          color: AppColors.whiteColor.withValues(alpha: 0.12),
        ),
      ),
    );
  }
}
