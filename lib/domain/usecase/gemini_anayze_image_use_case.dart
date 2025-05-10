import 'package:camera/camera.dart';
import 'package:gemini_lens/domain/entities/gemini_entity.dart';
import 'package:gemini_lens/domain/repository/repository.dart';
import 'package:gemini_lens/domain/usecase/usecase.dart';

class GeminiAnalyzeImageUseCase
    extends UseCase<GeminiEntity, GeminiAnalyzeImageParams> {
  final Repository _repository;
  GeminiAnalyzeImageUseCase(this._repository);
  @override
  Future<GeminiEntity> call(GeminiAnalyzeImageParams params) async {
    return await _repository.anaylyzeImage(
      imageFile: params.imageFile,
      query: params.query,
    );
  }
}

class GeminiAnalyzeImageParams {
  final XFile imageFile;
  final String query;

  GeminiAnalyzeImageParams({
    required this.imageFile,
    required this.query,
  });
}
