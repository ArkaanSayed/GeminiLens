import 'package:flutter/material.dart';
import 'package:gemini_lens/presentation/home_screen/provider/gemini_notifier.dart';

class GeminiNotifierProvider extends InheritedWidget {
  final GeminiNotifier geminiNotifier;

  const GeminiNotifierProvider({
    super.key,
    required this.geminiNotifier,
    required super.child,
  });

  static GeminiNotifier of(BuildContext context) {
    final provider =
        context.dependOnInheritedWidgetOfExactType<GeminiNotifierProvider>();

    if (provider == null) {
      throw 'No GeminiProvider found in context';
    }

    return provider.geminiNotifier;
  }

  @override
  bool updateShouldNotify(GeminiNotifierProvider oldWidget) {
    return geminiNotifier != oldWidget.geminiNotifier;
  }
}
