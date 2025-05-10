import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:gemini_lens/core/utils/app_dependencies.dart';
import 'package:gemini_lens/core/utils/routes.dart';
import 'package:gemini_lens/presentation/gemini_result_screen.dart/gemini_result_screen.dart';
import 'package:gemini_lens/presentation/gemini_result_screen.dart/gemini_result_screen_args.dart';
import 'package:gemini_lens/presentation/home_screen/home_screen.dart';
import 'package:gemini_lens/presentation/home_screen/provider/gemini_notifier_provider.dart';
import 'package:google_fonts/google_fonts.dart';

void main() async {
  await dotenv.load(fileName: '.env');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        textTheme: GoogleFonts.poppinsTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.homeScreen,
      onGenerateRoute: _registerCupertinoRoutes,
    );
  }

  Route<dynamic>? _registerCupertinoRoutes(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.homeScreen:
        return CupertinoPageRoute(
          builder: (context) {
            // Create singleton of dependencies
            final dependencies = AppDependencies();
            return GeminiNotifierProvider(
              geminiNotifier: dependencies.geminiNotifier,
              child: const HomeScreen(),
            );
          },
          settings: settings,
        );
      case AppRoutes.geminiResultScreen:
        return CupertinoPageRoute(
          builder: (context) {
            GeminiResultScreenArgs args = ModalRoute.of(context)!
                .settings
                .arguments as GeminiResultScreenArgs;

            return GeminiResultScreen(
              imageFile: args.imageFile,
              description: args.description,
            );
          },
          settings: settings,
        );
    }
    return null;
  }
}
