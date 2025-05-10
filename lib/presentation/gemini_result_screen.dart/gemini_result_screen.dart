import 'dart:async';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' show Vector3;

class GeminiResultScreen extends StatefulWidget {
  final XFile? imageFile;
  final String description;
  const GeminiResultScreen({
    super.key,
    required this.imageFile,
    required this.description,
  });

  @override
  State<GeminiResultScreen> createState() => _GeminiResultScreenState();
}

class _GeminiResultScreenState extends State<GeminiResultScreen> {
  String displayedText = '';
  int currentIndex = 0;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _startTypingAnimation();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _startTypingAnimation() {
    _timer = Timer.periodic(const Duration(milliseconds: 16), (timer) {
      if (currentIndex < widget.description.length) {
        setState(() {
          displayedText = widget.description.substring(0, currentIndex + 1);
          currentIndex++;
        });
      } else {
        timer.cancel();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 350.0,
            automaticallyImplyLeading: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Transform(
                alignment: Alignment.center,
                transform: Matrix4.identity()
                  ..scale(0.7)
                  ..translate(
                    Vector3(
                      0,
                      40,
                      0,
                    ),
                  )
                  ..rotateZ(-220.0),
                child: Hero(
                  tag: widget.imageFile!.path,
                  flightShuttleBuilder: (
                    flightContext,
                    animation,
                    flightDirection,
                    fromHeroContext,
                    toHeroContext,
                  ) {
                    switch (flightDirection) {
                      case HeroFlightDirection.push:
                        return Material(
                          color: Colors.transparent,
                          child: ScaleTransition(
                            scale: animation.drive(
                              Tween<double>(
                                begin: 0.2,
                                end: 0.7,
                              ).chain(
                                CurveTween(
                                  curve: Curves.easeInToLinear,
                                ),
                              ),
                            ),
                            child: Transform(
                              alignment: Alignment.center,
                              transform: Matrix4.identity()..rotateZ(-220.0),
                              child: toHeroContext.widget,
                            ),
                          ),
                        );

                      case HeroFlightDirection.pop:
                        return toHeroContext.widget;
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.all(20.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.0),
                      color: const Color(0xff8AAAE5),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withAlpha(76),
                          blurRadius: 10,
                          spreadRadius: 2,
                          offset: const Offset(0, 4),
                        )
                      ],
                    ),
                    child: SizedBox(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                        child: Image.file(
                          File(widget.imageFile!.path),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          SliverFillRemaining(
            hasScrollBody: true,
            child: Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Analysis Results',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          // height: 1.5,
                        ),
                        children: _buildAnimatedTextSpans(displayedText),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<TextSpan> _buildAnimatedTextSpans(String text) {
    final List<TextSpan> spans = [];
    final lines = text.split('\n');

    for (final line in lines) {
      if (line.startsWith('* **')) {
        // Format bullet points with bold titles
        final parts = line.split('**');
        if (parts.length > 2) {
          spans.add(
            TextSpan(
              text: '• ',
              style: const TextStyle(
                color: Color(0xff8AAAE5),
                fontSize: 20,
              ),
            ),
          );
          spans.add(
            TextSpan(
              text: parts[1],
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xff8AAAE5),
              ),
            ),
          );
          spans.add(
            TextSpan(
              text: parts[2],
              style: const TextStyle(color: Colors.black87),
            ),
          );
        } else {
          spans.add(
            TextSpan(text: line),
          );
        }
      } else if (line.trim().isEmpty) {
        // Add spacing between paragraphs
        // spans.add(const TextSpan(text: '\n'));
      } else {
        // Regular text
        spans.add(
          TextSpan(text: line),
        );
      }
      spans.add(const TextSpan(text: '\n'));
    }

    // Add blinking cursor at the end
    if (currentIndex < widget.description.length) {
      spans.add(const TextSpan(
        text: '|',
        style: TextStyle(
          color: Color(0xff8AAAE5),
          fontWeight: FontWeight.bold,
        ),
      ));
    }

    return spans;
  }
}
