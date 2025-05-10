import 'dart:developer';

import 'package:camera/camera.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:gemini_lens/data/model/gemini_model.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class GeminiClient {
  GeminiClient._singleton();
  static final GeminiClient _instance = GeminiClient._singleton();
  // Factory constructor to return the same instance
  factory GeminiClient() {
    return _instance;
  }

  final model = GenerativeModel(
    model: 'gemini-1.5-flash',
    apiKey: dotenv.env['GEMINI_API_KEY']!,
  );

  // Gemini functionalities
  // Function to process image and query
  //and return the result
  Future<GeminiModel> anaylyzeImage({
    required XFile imageFile,
    required String query,
  }) async {
    final imageBytes = await imageFile.readAsBytes();
    final content = [
      Content.multi(
        [
          TextPart(query),
          DataPart('image/jpeg', imageBytes), // Change mime type if not JPEG
        ],
      )
    ];
    final response = await model.generateContent(content);
    log('response here ==> ${response.text}');
    return GeminiModel(
      responseText: response.text ?? '',
    );
  }
}
