import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'screens/emergency_mode_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/doctor_support_screen.dart';
import 'screens/social_platform_screen.dart';
import 'screens/medical_history_screen.dart';
import 'screens/analytics_dashboard_screen.dart';
import 'screens/biometric_auth_screen.dart';
import 'screens/speech_therapy_screen.dart';
import 'screens/speech_to_text_screen.dart';
import 'screens/text_to_speech_screen.dart';
import 'screens/sign_to_speech_screen.dart';
import 'screens/sign_to_text_screen.dart';
import 'screens/lectures_screen.dart';
import 'screens/games_screen.dart';
import 'screens/information_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox('medicalHistory');
  final cameras = await availableCameras();
  runApp(MyEarApp(cameras: cameras));
}

class MyEarApp extends StatefulWidget {
  final List<CameraDescription> cameras;

  const MyEarApp({super.key, required this.cameras});

  @override
  State<MyEarApp> createState() => _MyEarAppState();
}

class _MyEarAppState extends State<MyEarApp> {
  ThemeData _themeData = ThemeData(
    primarySwatch: Colors.blue,
    brightness: Brightness.light,
    visualDensity: VisualDensity.adaptivePlatformDensity,
  );
  bool _isDarkMode = false;

  @override
  void initState() {
    super.initState();
    _loadThemePreference();
  }

  Future<void> _loadThemePreference() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isDarkMode = prefs.getBool('isDarkMode') ?? false;
      _updateTheme();
    });
  }

  void _updateTheme() {
    setState(() {
      _themeData = ThemeData(
        primarySwatch: Colors.blue,
        brightness: _isDarkMode ? Brightness.dark : Brightness.light,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'My Ear App',
      theme: _themeData,
      initialRoute: '/',
      routes: {
        '/': (context) => HomeScreen(cameras: widget.cameras),
        '/emergency': (context) => const EmergencyModeScreen(),
        '/settings':
            (context) => SettingsScreen(
              onThemeChanged: (isDark) {
                setState(() {
                  _isDarkMode = isDark;
                  _updateTheme();
                });
              },
            ),
        '/doctorSupport': (context) => const DoctorSupportScreen(),
        '/socialPlatform': (context) => const SocialPlatformScreen(),
        '/medicalHistory': (context) => const MedicalHistoryScreen(),
        '/analytics': (context) => const AnalyticsDashboardScreen(),
        '/biometricAuth': (context) => const BiometricAuthScreen(),
        '/speechTherapy': (context) => const SpeechTherapyScreen(),
        '/speechToText': (context) => const SpeechToTextScreen(),
        '/textToSpeech': (context) => const TextToSpeechScreen(),
        '/signToSpeech': (context) => const SignToSpeechScreen(),
        '/signToText': (context) => const SignToTextScreen(),
        '/lectures': (context) => const LecturesScreen(),
        '/games': (context) => const GamesScreen(),
        '/information': (context) => const InformationScreen(),
      },
    );
  }
}

class SpeechToTextScreen {
  const SpeechToTextScreen();
}

class HomeScreen extends StatelessWidget {
  final List<CameraDescription> cameras;

  const HomeScreen({super.key, required this.cameras});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Ear App')),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/emergency');
                },
                child: const Text('Emergency Mode'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/settings');
                },
                child: const Text('Settings'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/doctorSupport');
                },
                child: const Text('Doctor Support'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/socialPlatform');
                },
                child: const Text('Social Platform'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/medicalHistory');
                },
                child: const Text('Medical History'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/analytics');
                },
                child: const Text('Analytics Dashboard'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/biometricAuth');
                },
                child: const Text('Biometric Authentication'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/speechTherapy');
                },
                child: const Text('Speech Therapy'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/speechToText');
                },
                child: const Text('Speech to Text'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/textToSpeech');
                },
                child: const Text('Text to Speech'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/signToSpeech');
                },
                child: const Text('Sign to Speech'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/signToText');
                },
                child: const Text('Sign to Text'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/lectures');
                },
                child: const Text('Lectures'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/games');
                },
                child: const Text('Games'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/information');
                },
                child: const Text('About Deafness & App Benefits'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
