import 'package:gemini_lens/data/client/gemini_client.dart';
import 'package:gemini_lens/data/repository/repository_imp.dart';
import 'package:gemini_lens/domain/repository/repository.dart';
import 'package:gemini_lens/domain/usecase/gemini_anayze_image_use_case.dart';
import 'package:gemini_lens/presentation/home_screen/provider/gemini_notifier.dart';

class AppDependencies {
  static final AppDependencies _instance = AppDependencies._internal();

  factory AppDependencies() => _instance;

  AppDependencies._internal() {
    _initDependencies();
  }

  late final GeminiClient geminiClient;
  late final Repository repository;
  late final GeminiAnalyzeImageUseCase geminiAnalyzeImageUseCase;
  late final GeminiNotifier geminiNotifier;

  void _initDependencies() {
    geminiClient = GeminiClient();
    repository = RepositoryImpl(geminiClient: geminiClient);
    geminiAnalyzeImageUseCase = GeminiAnalyzeImageUseCase(repository);
    geminiNotifier =
        GeminiNotifier(geminiAnalyzeImageUseCase: geminiAnalyzeImageUseCase);
  }
}
