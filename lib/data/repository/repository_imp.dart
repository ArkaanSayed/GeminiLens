import 'package:camera/camera.dart';
import 'package:gemini_lens/data/client/gemini_client.dart';
import 'package:gemini_lens/domain/entities/gemini_entity.dart';
import 'package:gemini_lens/domain/repository/repository.dart';

class RepositoryImpl extends Repository {
  final GeminiClient geminiClient;

  RepositoryImpl({
    required this.geminiClient,
  });

  @override
  Future<GeminiEntity> anaylyzeImage({
    required XFile imageFile,
    required String query,
  }) async {
    try {
      final response =
          await geminiClient.anaylyzeImage(imageFile: imageFile, query: query);
      return GeminiEntity(responseText: response.responseText);
    } catch (e) {
      throw Exception(e);
    }
  }
}
