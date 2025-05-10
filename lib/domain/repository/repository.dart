import 'package:camera/camera.dart';
import 'package:gemini_lens/domain/entities/gemini_entity.dart';

abstract class Repository {
  Future<GeminiEntity> anaylyzeImage({
    required XFile imageFile,
    required String query,
  });
}
