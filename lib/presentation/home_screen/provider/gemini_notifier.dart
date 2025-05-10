import 'dart:developer';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:gemini_lens/domain/entities/gemini_entity.dart';
import 'package:gemini_lens/domain/usecase/gemini_anayze_image_use_case.dart';

class GeminiNotifier extends ChangeNotifier {
  final GeminiAnalyzeImageUseCase _geminiAnalyzeImageUseCase;
  bool _isProcessing = false;
  bool _error = false;
  // AnalysisResult? _result;
  GeminiEntity? _result;

  bool get isProcessing => _isProcessing;
  bool get error => _error;
  GeminiEntity? get result => _result;

  GeminiNotifier({
    required GeminiAnalyzeImageUseCase geminiAnalyzeImageUseCase,
  }) : _geminiAnalyzeImageUseCase = geminiAnalyzeImageUseCase;

  Future<void> analyzeImage({
    required XFile imageFile,
    required String query,
  }) async {
    try {
      _isProcessing = true;
      notifyListeners();
      _result = await _geminiAnalyzeImageUseCase.call(
        GeminiAnalyzeImageParams(
          imageFile: imageFile,
          query: query,
        ),
      );
      _isProcessing = false;
      notifyListeners();
    } catch (e) {
      _error = true;
      log('in herer hte erroe ==> $e');
      notifyListeners();
    }
  }
}
