import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:gemini_lens/core/utils/routes.dart';
import 'package:gemini_lens/presentation/gemini_result_screen.dart/gemini_result_screen_args.dart';
import 'package:gemini_lens/presentation/home_screen/provider/gemini_notifier.dart';
import 'package:gemini_lens/presentation/home_screen/provider/gemini_notifier_provider.dart';

class CameraWidget extends StatefulWidget {
  final CameraController controller;
  const CameraWidget({super.key, required this.controller});

  @override
  State<CameraWidget> createState() => _CameraWidgetState();
}

class _CameraWidgetState extends State<CameraWidget>
    with TickerProviderStateMixin {
  final double _minAvailableZoom = 1.0;
  final double _maxAvailableZoom = 10.0;
  double _currentScale = 1.0;
  double _baseScale = 1.0;
  int _pointers = 0;
  double width = 600;
  double height = 600;
  bool _isImageCaptured = false;
  String query = 'Describe this image';

  // Editing controler
  final TextEditingController _queryTextController = TextEditingController();

  XFile? imageFile;

  // All animations
  late AnimationController _controller;
  late AnimationController _slideController;
  late AnimationController _cameraAnimateController;
  late Animation<double> _sizeAnimation;
  late Animation<double> _marginAnimation;
  late Animation<double> _sizeAnimationCamera;
  late Animation<double> _marginAnimationCamera;
  late Animation<double> _translateAnimation;
  late Animation<double> _opacityAnimation;
  late Animation<Offset> _textFiledSlideAnimation;
  late Animation<Offset> _captureButtonSlideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );

    _cameraAnimateController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 700),
    );

    _slideController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );

    _sizeAnimation = Tween<double>(begin: 600, end: 450).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOut,
      ),
    );

    _sizeAnimationCamera = Tween<double>(begin: 450, end: 600).animate(
      CurvedAnimation(
        parent: _cameraAnimateController,
        curve: Curves.easeOut,
      ),
    );

    _marginAnimation = Tween<double>(begin: 10, end: 50).animate(
      CurvedAnimation(
        parent: _cameraAnimateController,
        curve: Curves.easeOut,
      ),
    );

    _marginAnimationCamera = Tween<double>(begin: 50, end: 10).animate(
      CurvedAnimation(
        parent: _cameraAnimateController,
        curve: Curves.easeOut,
      ),
    );

    _translateAnimation = Tween<double>(begin: -20, end: 90).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOut,
      ),
    );

    _opacityAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.5, 1.0, curve: Curves.easeOut),
      ),
    );

    _captureButtonSlideAnimation = Tween<Offset>(
      begin: Offset(0, 0),
      end: Offset(250, 0),
    ).animate(
      CurvedAnimation(
        parent: _slideController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeInOut),
      ),
    );

    _textFiledSlideAnimation = Tween<Offset>(
      begin: Offset(0, 100),
      end: Offset(0, -50),
    ).animate(
      CurvedAnimation(
        parent: _slideController,
        curve: const Interval(0.5, 1.0, curve: Curves.bounceOut),
      ),
    );

    _controller.addStatusListener((AnimationStatus status) {
      if (status == AnimationStatus.completed) {
        _slideController
          ..reset()
          ..forward();
      }
    });
    _cameraAnimateController.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    _cameraAnimateController.dispose();
    _queryTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final GeminiNotifier geminiNotifier = GeminiNotifierProvider.of(context);
    return Stack(
      children: [
        _isImageCaptured
            ? AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return Opacity(
                    opacity: _opacityAnimation.value,
                    child: Transform.translate(
                      offset: Offset(
                        0,
                        _translateAnimation.value,
                      ),
                      child: Hero(
                        tag: imageFile!.path,
                        child: Container(
                          width: _sizeAnimation.value,
                          height: _sizeAnimation.value,
                          margin: EdgeInsets.only(
                            left: _marginAnimation.value,
                            right: _marginAnimation.value,
                          ),
                          padding: EdgeInsets.all(
                            20.0,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20.0),
                            color: Color(
                              0xff8AAAE5,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.3),
                                blurRadius: 10,
                                spreadRadius: 2,
                                offset: Offset(0, 4),
                              )
                            ],
                          ),
                          child: SizedBox(
                            width: 200.0,
                            height: 200.0,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10.0),
                              child: Image.file(
                                File(
                                  imageFile!.path,
                                ),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              )
            : AnimatedBuilder(
                animation: _cameraAnimateController,
                builder: (context, child) {
                  return Container(
                    width: _sizeAnimationCamera.value,
                    height: _sizeAnimationCamera.value,
                    margin: EdgeInsets.only(
                      left: _marginAnimationCamera.value,
                      right: _marginAnimationCamera.value,
                    ),
                    child: Listener(
                      onPointerDown: (_) => _pointers++,
                      onPointerUp: (_) => _pointers--,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20.0),
                        child: CameraPreview(
                          widget.controller,
                          child: LayoutBuilder(
                            builder: (BuildContext context,
                                BoxConstraints constraints) {
                              return GestureDetector(
                                behavior: HitTestBehavior.opaque,
                                onScaleStart: _handleScaleStart,
                                onScaleUpdate: _handleScaleUpdate,
                                onTapDown: (TapDownDetails details) =>
                                    onViewFinderTap(details, constraints),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  );
                }),
        AnimatedBuilder(
            animation: _slideController,
            builder: (context, child) {
              return Align(
                alignment: Alignment.bottomCenter,
                child: Transform.translate(
                  offset: _captureButtonSlideAnimation.value,
                  child: Container(
                    margin: const EdgeInsets.only(
                      bottom: 50.0,
                    ),
                    child: ElevatedButton(
                      onPressed: () {
                        onTakePictureButtonPressed();
                      },
                      style: ElevatedButton.styleFrom(
                        shape: CircleBorder(),
                        backgroundColor: Color(
                          0xff8AAAE5,
                        ),
                        minimumSize: Size(100, 100), // Diameter
                      ),
                      child: Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            width: 1.0,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }),
        if (_isImageCaptured)
          ListenableBuilder(
              listenable: geminiNotifier,
              builder: (context, _) {
                return AnimatedBuilder(
                    animation: _slideController,
                    builder: (context, child) {
                      return Align(
                        alignment: Alignment.bottomCenter,
                        child: Transform.translate(
                          offset: _textFiledSlideAnimation.value,
                          child: Container(
                            margin: const EdgeInsets.only(
                              bottom: 50.0,
                              left: 12.0,
                              right: 12.0,
                            ),
                            child: TextField(
                              controller: _queryTextController,
                              maxLines: null,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white70,
                                hintText: 'Ask about the Image',
                                hintStyle: TextStyle(color: Colors.black),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                  borderSide: BorderSide.none,
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 25,
                                  vertical: 20,
                                ),
                                prefixIcon: IconButton(
                                  onPressed: () {
                                    _slideController.reverse();
                                    _cameraAnimateController
                                      ..reset()
                                      ..forward();
                                    setState(() {
                                      _isImageCaptured = false;
                                      imageFile = null;
                                    });
                                  },
                                  icon: Icon(
                                    Icons.camera_alt,
                                    color: Colors.blueGrey,
                                  ),
                                ),
                                suffixIcon: IconButton(
                                  onPressed: geminiNotifier.isProcessing
                                      ? null
                                      : () async {
                                          final navigator =
                                              Navigator.of(context);
                                          query = _queryTextController.text;
                                          await geminiNotifier.analyzeImage(
                                            imageFile: imageFile!,
                                            query: query,
                                          );

                                          if (geminiNotifier.result != null) {
                                            navigator.pushNamed(
                                              AppRoutes.geminiResultScreen,
                                              arguments: GeminiResultScreenArgs(
                                                imageFile: imageFile,
                                                description: geminiNotifier
                                                    .result!.responseText,
                                              ),
                                            );
                                          }
                                        },
                                  icon: geminiNotifier.isProcessing
                                      ? const CircularProgressIndicator
                                          .adaptive()
                                      : Icon(
                                          Icons.arrow_forward,
                                          color: Colors.blueAccent,
                                        ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    });
              }),
      ],
    );
  }

  void onTakePictureButtonPressed() {
    takePicture().then((XFile? file) {
      if (mounted) {
        setState(
          () {
            _isImageCaptured = true;
            imageFile = file;
            // Future.delayed(Duration(milliseconds: 90), () {
            // _controller
            //   ..reset()
            //   ..forward();
            // });
            _controller
              ..reset()
              ..forward();
          },
        );
        if (file != null) {}
      }
    });
  }

  Future<XFile?> takePicture() async {
    if (widget.controller.value.isTakingPicture) {
      // A capture is already pending, do nothing.
      return null;
    }

    try {
      final XFile file = await widget.controller.takePicture();
      return file;
    } on CameraException catch (_) {
      return null;
    }
  }

  void onViewFinderTap(TapDownDetails details, BoxConstraints constraints) {
    final CameraController cameraController = widget.controller;

    final Offset offset = Offset(
      details.localPosition.dx / constraints.maxWidth,
      details.localPosition.dy / constraints.maxHeight,
    );
    cameraController.setExposurePoint(offset);
    cameraController.setFocusPoint(offset);
  }

  void _handleScaleStart(ScaleStartDetails details) {
    _baseScale = _currentScale;
  }

  Future<void> _handleScaleUpdate(ScaleUpdateDetails details) async {
    // When there are not exactly two fingers on screen don't scale
    if (_pointers != 2) {
      return;
    }

    _currentScale = (_baseScale * details.scale).clamp(
      _minAvailableZoom,
      _maxAvailableZoom,
    );
    debugPrint('the zoom level here ==> $_currentScale');

    await widget.controller.setZoomLevel(_currentScale);
  }
}
