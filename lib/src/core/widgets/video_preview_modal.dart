import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:m_kemet/generated/l10n.dart';
import 'package:m_kemet/src/config/res/color_manager.dart';
import 'package:m_kemet/src/config/res/font_manager.dart';
import 'package:m_kemet/src/config/res/text_style_extensions.dart';
import 'package:m_kemet/src/core/services/service_locator/service_locator.dart';
import 'package:m_kemet/src/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:video_player/video_player.dart';

class VideoPreviewModal extends StatefulWidget {
  final File? file;
  final String? videoUrl;
  final String? title;
  final VoidCallback? onChange;

  const VideoPreviewModal({
    super.key,
    this.file,
    this.videoUrl,
    this.title,
    this.onChange,
  });

  static Future<void> show(
    BuildContext context, {
    File? file,
    String? videoUrl,
    String? title,
    VoidCallback? onChange,
  }) {
    return showDialog(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.65),
      builder: (ctx) => VideoPreviewModal(
        file: file,
        videoUrl: videoUrl,
        title: title,
        onChange: onChange,
      ),
    );
  }

  @override
  State<VideoPreviewModal> createState() => _VideoPreviewModalState();
}

class _VideoPreviewModalState extends State<VideoPreviewModal>
    with SingleTickerProviderStateMixin {
  VideoPlayerController? _controller;
  bool _isInitialized = false;
  bool _hasError = false;
  bool _showControls = true;
  bool _isMuted = false;
  String? _seekFeedback;
  bool _isDragging = false;
  double _dragPositionMs = 0.0;

  @override
  void initState() {
    super.initState();
    _initVideo();
  }

  Future<void> _initVideo() async {
    try {
      if (widget.file != null && widget.file!.existsSync()) {
        _controller = VideoPlayerController.file(widget.file!);
      } else if (widget.videoUrl != null && widget.videoUrl!.isNotEmpty) {
        Map<String, String> headers = {};
        try {
          final token = await sl<AuthLocalDataSource>().getAccessToken();
          if (token != null && token.isNotEmpty) {
            headers['Authorization'] = 'Bearer $token';
          }
        } catch (_) {}
        _controller = VideoPlayerController.networkUrl(
          Uri.parse(widget.videoUrl!),
          httpHeaders: headers,
        );
      }

      if (_controller != null) {
        await _controller!.initialize();
        _controller!.addListener(_onControllerUpdate);
        if (mounted) {
          setState(() {
            _isInitialized = true;
          });
          _controller!.play();
        }
      } else {
        if (mounted) setState(() => _hasError = true);
      }
    } catch (_) {
      if (mounted) setState(() => _hasError = true);
    }
  }

  void _onControllerUpdate() {
    if (mounted && !_isDragging) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _controller?.removeListener(_onControllerUpdate);
    _controller?.dispose();
    super.dispose();
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  void _togglePlayPause() {
    if (_controller == null || !_isInitialized) return;
    setState(() {
      if (_controller!.value.isPlaying) {
        _controller!.pause();
      } else {
        if (_controller!.value.position >= _controller!.value.duration) {
          _controller!.seekTo(Duration.zero);
        }
        _controller!.play();
      }
    });
  }

  void _seekRelative(int seconds) {
    if (_controller == null || !_isInitialized) return;
    final current = _controller!.value.position;
    final total = _controller!.value.duration;
    final target = current + Duration(seconds: seconds);
    final clamped = target < Duration.zero
        ? Duration.zero
        : (target > total ? total : target);

    _controller!.seekTo(clamped);
    setState(() {
      _seekFeedback = seconds > 0 ? '+$seconds ث' : '$seconds ث';
    });

    Future.delayed(const Duration(milliseconds: 700), () {
      if (mounted) {
        setState(() {
          _seekFeedback = null;
        });
      }
    });
  }

  void _toggleMute() {
    if (_controller == null || !_isInitialized) return;
    setState(() {
      _isMuted = !_isMuted;
      _controller!.setVolume(_isMuted ? 0.0 : 1.0);
    });
  }

  @override
  Widget build(BuildContext context) {
    final titleText = widget.title ?? S.of(context).watchVideo;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 20.h),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24.r),
        child: Container(
          width: double.infinity,
          constraints: BoxConstraints(maxHeight: 0.75.sh),
          decoration: BoxDecoration(
            color: const Color(0xFF141D2B),
            borderRadius: BorderRadius.circular(24.r),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.12),
              width: 1,
            ),
          ),
          child: Column(
            children: [
              // ── Top Header ──────────────────────────────────────────
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E293B).withValues(alpha: 0.5),
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.white.withValues(alpha: 0.08),
                      width: 1,
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    InkWell(
                      onTap: () => Navigator.pop(context),
                      borderRadius: BorderRadius.circular(10.r),
                      child: Container(
                        padding: EdgeInsets.all(8.r),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        child: Icon(
                          Icons.close_rounded,
                          color: Colors.white,
                          size: 20.sp,
                        ),
                      ),
                    ),
                    SizedBox(width: 14.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            titleText,
                            style: getTextStyle().whiteColor.w700.s16,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            S.of(context).watchVideo,
                            style: getTextStyle().greyColor.w500.s12,
                          ),
                        ],
                      ),
                    ),
                    if (widget.onChange != null)
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                          widget.onChange!();
                        },
                        borderRadius: BorderRadius.circular(10.r),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 12.w, vertical: 6.h),
                          decoration: BoxDecoration(
                            color: AppColors.skyBlue.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(10.r),
                            border: Border.all(
                                color:
                                    AppColors.skyBlue.withValues(alpha: 0.3)),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.refresh_rounded,
                                  color: AppColors.skyBlue, size: 16.sp),
                              SizedBox(width: 4.w),
                              Text(
                                S.of(context).changeMedia,
                                style: getTextStyle()
                                    .w600
                                    .s13
                                    .copyWith(color: AppColors.skyBlue),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),

              // ── Player Viewport ─────────────────────────────────────
              Expanded(
                child: Container(
                  color: Colors.black,
                  child: _buildPlayerArea(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPlayerArea() {
    if (_hasError) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(24.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.error_outline_rounded,
                  color: AppColors.errorRed, size: 48.sp),
              SizedBox(height: 12.h),
              Text(
                S.of(context).cannotPlayVideo,
                style: getTextStyle().whiteColor.w600.s15,
              ),
            ],
          ),
        ),
      );
    }

    if (!_isInitialized || _controller == null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(color: AppColors.skyBlue),
            SizedBox(height: 14.h),
            Text(
              S.of(context).preparingVideoPlayer,
              style: getTextStyle().whiteColor.w500.s14,
            ),
          ],
        ),
      );
    }

    final isPlaying = _controller!.value.isPlaying;
    final position = _controller!.value.position;
    final duration = _controller!.value.duration;
    final isCompleted = position >= duration;

    final totalMs = duration.inMilliseconds.toDouble();
    final currentMs = _isDragging
        ? _dragPositionMs
        : position.inMilliseconds.toDouble().clamp(0.0, totalMs > 0 ? totalMs : 1.0);
    final displayPosition = _isDragging
        ? Duration(milliseconds: _dragPositionMs.toInt())
        : position;

    return GestureDetector(
      onTap: () {
        setState(() {
          _showControls = !_showControls;
        });
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Video Player
          Center(
            child: AspectRatio(
              aspectRatio: _controller!.value.aspectRatio,
              child: VideoPlayer(_controller!),
            ),
          ),

          // Double Tap Seeking zones (Invisible Left / Right detectors)
          Positioned.fill(
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onDoubleTap: () => _seekRelative(-5),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onDoubleTap: () => _seekRelative(5),
                  ),
                ),
              ],
            ),
          ),

          // Animated Seek Feedback Bubble (+5s / -5s)
          if (_seekFeedback != null)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.75),
                borderRadius: BorderRadius.circular(20.r),
                border: Border.all(
                    color: AppColors.skyBlue.withValues(alpha: 0.4)),
              ),
              child: Text(
                _seekFeedback!,
                style: getTextStyle().w700.s16.copyWith(color: AppColors.skyBlue),
              ),
            ),

          // Floating Center Controls: -5s | Play/Pause | +5s
          if (_showControls || !isPlaying)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 10.h),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.35),
                borderRadius: BorderRadius.circular(50.r),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.15),
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Rewind 5 seconds
                  InkWell(
                    onTap: () => _seekRelative(-5),
                    borderRadius: BorderRadius.circular(25.r),
                    child: Container(
                      width: 44.r,
                      height: 44.r,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.12),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.18),
                          width: 1,
                        ),
                      ),
                      child: Center(
                        child: Icon(
                          Icons.replay_5_rounded,
                          color: Colors.white,
                          size: 24.sp,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 18.w),

                  // Big Center Play/Pause/Replay
                  InkWell(
                    onTap: _togglePlayPause,
                    borderRadius: BorderRadius.circular(35.r),
                    child: Container(
                      width: 62.r,
                      height: 62.r,
                      decoration: BoxDecoration(
                        color: AppColors.skyBlue,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.skyBlue.withValues(alpha: 0.4),
                            blurRadius: 16,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Icon(
                          isCompleted
                              ? Icons.replay_rounded
                              : (isPlaying
                                  ? Icons.pause_rounded
                                  : Icons.play_arrow_rounded),
                          color: AppColors.midnightNavy,
                          size: 34.sp,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 18.w),

                  // Forward 5 seconds
                  InkWell(
                    onTap: () => _seekRelative(5),
                    borderRadius: BorderRadius.circular(25.r),
                    child: Container(
                      width: 44.r,
                      height: 44.r,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.12),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.18),
                          width: 1,
                        ),
                      ),
                      child: Center(
                        child: Icon(
                          Icons.forward_5_rounded,
                          color: Colors.white,
                          size: 24.sp,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

          // Bottom Bar (Progress Scrubber & Time)
          if (_showControls)
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                padding:
                    EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.65),
                    ],
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Progress Scrubber (Smooth Interactive Slider)
                    SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        trackHeight: 3.5.h,
                        trackShape: const RoundedRectSliderTrackShape(),
                        activeTrackColor: AppColors.skyBlue,
                        inactiveTrackColor: Colors.white.withValues(alpha: 0.24),
                        thumbColor: Colors.white,
                        thumbShape: RoundSliderThumbShape(
                          enabledThumbRadius: 6.5.r,
                          elevation: 3,
                          pressedElevation: 6,
                        ),
                        overlayColor: AppColors.skyBlue.withValues(alpha: 0.2),
                        overlayShape: RoundSliderOverlayShape(overlayRadius: 16.r),
                      ),
                      child: Slider(
                        min: 0.0,
                        max: totalMs > 0 ? totalMs : 1.0,
                        value: totalMs > 0 ? currentMs.clamp(0.0, totalMs) : 0.0,
                        onChangeStart: (val) {
                          setState(() {
                            _isDragging = true;
                            _dragPositionMs = val;
                          });
                        },
                        onChanged: (val) {
                          setState(() {
                            _dragPositionMs = val;
                          });
                        },
                        onChangeEnd: (val) {
                          _controller
                              ?.seekTo(Duration(milliseconds: val.toInt()))
                              .then((_) {
                            if (mounted) {
                              setState(() {
                                _isDragging = false;
                              });
                            }
                          });
                        },
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Elapsed / Total Duration (updates live as you drag)
                        Text(
                          '${_formatDuration(displayPosition)} / ${_formatDuration(duration)}',
                          style: getTextStyle().whiteColor.w600.s13,
                        ),

                        // Audio Mute Toggle
                        IconButton(
                          onPressed: _toggleMute,
                          icon: Icon(
                            _isMuted
                                ? Icons.volume_off_rounded
                                : Icons.volume_up_rounded,
                            color: Colors.white,
                            size: 22.sp,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
