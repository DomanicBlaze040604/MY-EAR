import 'package:flutter/material.dart';

// Import all screens
import '../features/analytics/presentation/screens/analytics_dashboard_screen.dart';
import '../features/authentication/presentation/screens/biometric_auth_screen.dart';
import '../features/emergency/presentation/screens/emergency_mode_screen.dart';
import '../features/gamification/presentation/screens/games_screen.dart';
import '../features/gamification/presentation/screens/lectures_screen.dart';
import '../features/medical/presentation/screens/doctor_support_screen.dart';
import '../features/medical/presentation/screens/medical_history_screen.dart';
import '../features/settings/presentation/screens/information_screen.dart';
import '../features/settings/presentation/screens/settings_screen.dart';
import '../features/sign_language/presentation/screens/sign_to_speech_screen.dart';
import '../features/sign_language/presentation/screens/sign_to_text_audio_screen.dart';
import '../features/social/presentation/screens/social_platform_screen.dart';
import '../features/speech/presentation/screens/speech_therapy_screen.dart';
import '../features/speech/presentation/screens/speech_to_text_screen.dart';
import '../features/speech/presentation/screens/text_to_speech_screen.dart';

class AppRoutes {
  static const String home = '/';
  static const String analytics = '/analytics';
  static const String auth = '/auth';
  static const String emergency = '/emergency';
  static const String games = '/games';
  static const String lectures = '/lectures';
  static const String doctorSupport = '/doctor-support';
  static const String medicalHistory = '/medical-history';
  static const String settings = '/settings';
  static const String information = '/information';
  static const String signToSpeech = '/sign-to-speech';
  static const String signToTextAudio = '/sign-to-text-audio';
  static const String social = '/social';
  static const String speechTherapy = '/speech-therapy';
  static const String speechToText = '/speech-to-text';
  static const String textToSpeech = '/text-to-speech';
}

class AppRouter {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.analytics:
        return MaterialPageRoute(
            builder: (_) => const AnalyticsDashboardScreen());
      case AppRoutes.auth:
        return MaterialPageRoute(builder: (_) => const BiometricAuthScreen());
      case AppRoutes.emergency:
        return MaterialPageRoute(builder: (_) => const EmergencyModeScreen());
      case AppRoutes.games:
        return MaterialPageRoute(builder: (_) => const GamesScreen());
      case AppRoutes.lectures:
        return MaterialPageRoute(builder: (_) => const LecturesScreen());
      case AppRoutes.doctorSupport:
        return MaterialPageRoute(builder: (_) => const DoctorSupportScreen());
      case AppRoutes.medicalHistory:
        return MaterialPageRoute(builder: (_) => const MedicalHistoryScreen());
      case AppRoutes.settings:
        return MaterialPageRoute(builder: (_) => const SettingsScreen());
      case AppRoutes.information:
        return MaterialPageRoute(builder: (_) => const InformationScreen());
      case AppRoutes.signToSpeech:
        return MaterialPageRoute(builder: (_) => const SignToSpeechScreen());
      case AppRoutes.signToTextAudio:
        return MaterialPageRoute(builder: (_) => const SignToTextAudioScreen());
      case AppRoutes.social:
        return MaterialPageRoute(builder: (_) => const SocialPlatformScreen());
      case AppRoutes.speechTherapy:
        return MaterialPageRoute(builder: (_) => const SpeechTherapyScreen());
      case AppRoutes.speechToText:
        return MaterialPageRoute(builder: (_) => const SpeechToTextScreen());
      case AppRoutes.textToSpeech:
        return MaterialPageRoute(builder: (_) => const TextToSpeechScreen());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('Route ${settings.name} not found!'),
            ),
          ),
        );
    }
  }
}
