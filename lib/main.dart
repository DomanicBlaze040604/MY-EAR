// ignore_for_file: avoid_print, duplicate_ignore, unnecessary_import, unused_local_variable, unused_field

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:permission_handler/permission_handler.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:camera/camera.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vibration/vibration.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:local_auth/local_auth.dart';
import 'package:fl_chart/fl_chart.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox('medicalHistory');
  final cameras = await availableCameras();
  runApp(MyEarApp(cameras: cameras));
}

class MyEarApp extends StatelessWidget {
  final List<CameraDescription> cameras;

  const MyEarApp({super.key, required this.cameras});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'My Ear App',
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: '/',
      routes: {
        '/': (context) => HomeScreen(cameras: cameras),
        '/emergency': (context) => const EmergencyModeScreen(),
        '/signToAudio': (context) => SignToTextAudioScreen(cameras: cameras),
        '/learningMode': (context) => const LearningModeScreen(),
        '/therapy': (context) => const TherapyScreen(),
        '/settings': (context) => const SettingsScreen(),
        '/doctorSupport': (context) => const DoctorSupportScreen(),
        '/socialPlatform': (context) => const SocialPlatformScreen(),
        '/medicalHistory': (context) => const MedicalHistoryScreen(),
        '/analytics': (context) => const AnalyticsDashboardScreen(),
        '/biometricAuth': (context) => const BiometricAuthScreen(),
      },
    );
  }
}

class SignToTextAudioScreen {
}

class SignToTextAudioScreen {
}

class SocialPlatformScreen {
  const SocialPlatformScreen();
}

class HomeScreen extends StatefulWidget {
  final List<CameraDescription> cameras;

  const HomeScreen({super.key, required this.cameras});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late stt.SpeechToText _speech;
  bool _isListening = false;
  String _text = "Tap the mic and speak";
  FlutterTts flutterTts = FlutterTts();

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
    _requestPermissions();
  }

  void _requestPermissions() async {
    Map<Permission, PermissionStatus> statuses =
        await [
          Permission.microphone,
          Permission.location,
          Permission.camera,
        ].request();

    if (statuses.any((status) => status.value.isDenied)) {
      openAppSettings();
    }
  }

  void _startListening() async {
    bool available = await _speech.initialize();
    if (available) {
      setState(() => _isListening = true);
      _speech.listen(
        onResult: (result) {
          setState(() => _text = result.recognizedWords);
        },
      );
    }
  }

  void _stopListening() {
    setState(() => _isListening = false);
    _speech.stop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Ear App')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 100,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 5,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Icons const CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.blue,
                          child: Icon(Icons.emergency, color: Colors.white),
                        ),
                        const SizedBox(height: 5),
                        Text(index == 0 ? "Emergency" : "Feature ${index + 1}"),
                      ],
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  _buildFeatureCard(
                    title: "Sign to Text & Audio",
                    subtitle: "Translate sign language to text and audio.",
                    onTap: () => Navigator.pushNamed(context, '/signToAudio'),
                  ),
                  _buildFeatureCard(
                    title: "Learning Mode",
                    subtitle: "Interactive lessons for sign language.",
                    onTap: () => Navigator.pushNamed(context, '/learningMode'),
                  ),
                  _buildFeatureCard(
                    title: "Therapy & Speech Training",
                    subtitle: "Improve speech and communication skills.",
                    onTap: () => Navigator.pushNamed(context, '/therapy'),
                  ),
                  _buildFeatureCard(
                    title: "Emergency Mode",
                    subtitle: "Send SOS alerts with live location.",
                    onTap: () => Navigator.pushNamed(context, '/emergency'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _isListening ? _stopListening : _startListening,
        child: Icon(_isListening ? Icons.mic_off : Icons.mic),
      ),
    );
  }

  Widget _buildFeatureCard({
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: ListTile(
        title: Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(subtitle),
        onTap: onTap,
      ),
    );
  }
}

extension on Map<Permission, PermissionStatus> {
  bool any(Function(dynamic status) param0) {}
}

// EmergencyModeScreen
class EmergencyModeScreen extends StatefulWidget {
  const EmergencyModeScreen({super.key});

  @override
  _EmergencyModeScreenState createState() => _EmergencyModeScreenState();
}

class _EmergencyModeScreenState extends State<EmergencyModeScreen> {
  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    _initializeNotifications();
    _requestPermissions();
  }

  void _initializeNotifications() {
    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    const initializationSettings = InitializationSettings(
      android: androidSettings,
    );
    _notificationsPlugin.initialize(initializationSettings);
  }

  Future<void> _showNotification(String message) async {
    const androidDetails = AndroidNotificationDetails(
      'emergency_channel',
      'Emergency Alerts',
      importance: Importance.high,
      priority: Priority.high,
    );
    const notificationDetails = NotificationDetails(android: androidDetails);
    await _notificationsPlugin.show(
      0,
      'Emergency Alert',
      message,
      notificationDetails,
    );
  }

  Future<void> _requestPermissions() async {
    Map<Permission, PermissionStatus> statuses =
        await [Permission.location, Permission.sms].request();

    if (statuses.any((status) => status.value.isDenied)) {
      openAppSettings();
    }
  }

  Future<void> _sendEmergencyAlert() async {
    try {
      final position = await Geolocator.getCurrentPosition();
      final location = "Lat: ${position.latitude}, Long: ${position.longitude}";
      final smsUri = Uri.parse(
        "sms:112?body=Emergency! My location: $location",
      );

      if (await canLaunchUrl(smsUri)) {
        await launchUrl(smsUri);
        _showNotification("Emergency SMS sent successfully.");
      } else {
        _showNotification("Failed to send emergency SMS.");
      }
    } catch (e) {
      _showNotification("Error: Unable to retrieve location.");
    }
  }

  void _simulateFallDetection() {
    Vibration.vibrate(duration: 1000);
    _showNotification("Fall detected! Sending emergency alert...");
    _sendEmergencyAlert();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Enhanced Emergency Mode')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _sendEmergencyAlert,
              child: const Text('Send Emergency Alert'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _simulateFallDetection,
              child: const Text('Simulate Fall Detection'),
            ),
          ],
        ),
      ),
    );
  }
}

// ignore_for_file: avoid_print, duplicate_ignore, unnecessary_import, unused_local_variable, unused_field

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:permission_handler/permission_handler.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:camera/camera.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vibration/vibration.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:local_auth/local_auth.dart';
import 'package:fl_chart/fl_chart.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox('medicalHistory');
  final cameras = await availableCameras();
  runApp(MyEarApp(cameras: cameras));
}

class MyEarApp extends StatelessWidget {
  final List<CameraDescription> cameras;

  const MyEarApp({super.key, required this.cameras});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'My Ear App',
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: '/',
      routes: {
        '/': (context) => HomeScreen(cameras: cameras),
        '/emergency': (context) => const EmergencyModeScreen(),
        '/signToAudio': (context) => SignToTextAudioScreen(cameras: cameras),
        '/learningMode': (context) => const LearningModeScreen(),
        '/therapy': (context) => const TherapyScreen(),
        '/settings': (context) => const SettingsScreen(),
        '/doctorSupport': (context) => const DoctorSupportScreen(),
        '/socialPlatform': (context) => const SocialPlatformScreen(),
        '/medicalHistory': (context) => const MedicalHistoryScreen(),
        '/analytics': (context) => const AnalyticsDashboardScreen(),
        '/biometricAuth': (context) => const BiometricAuthScreen(),
      },
    );
  }
}

class SocialPlatformScreen {
  const SocialPlatformScreen();
}

class HomeScreen extends StatefulWidget {
  final List<CameraDescription> cameras;

  const HomeScreen({super.key, required this.cameras});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late stt.SpeechToText _speech;
  bool _isListening = false;
  String _text = "Tap the mic and speak";
  FlutterTts flutterTts = FlutterTts();

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
    _requestPermissions();
  }

  void _requestPermissions() async {
    Map<Permission, PermissionStatus> statuses =
        await [
          Permission.microphone,
          Permission.location,
          Permission.camera,
        ].request();

    if (statuses.any((status) => status.value.isDenied)) {
      openAppSettings();
    }
  }

  void _startListening() async {
    bool available = await _speech.initialize();
    if (available) {
      setState(() => _isListening = true);
      _speech.listen(
        onResult: (result) {
          setState(() => _text = result.recognizedWords);
        },
      );
    }
  }

  void _stopListening() {
    setState(() => _isListening = false);
    _speech.stop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Ear App')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 100,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 5,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Icons const CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.blue,
                          child: Icon(Icons.emergency, color: Colors.white),
                        ),
                        const SizedBox(height: 5),
                        Text(index == 0 ? "Emergency" : "Feature ${index + 1}"),
                      ],
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  _buildFeatureCard(
                    title: "Sign to Text & Audio",
                    subtitle: "Translate sign language to text and audio.",
                    onTap: () => Navigator.pushNamed(context, '/signToAudio'),
                  ),
                  _buildFeatureCard(
                    title: "Learning Mode",
                    subtitle: "Interactive lessons for sign language.",
                    onTap: () => Navigator.pushNamed(context, '/learningMode'),
                  ),
                  _buildFeatureCard(
                    title: "Therapy & Speech Training",
                    subtitle: "Improve speech and communication skills.",
                    onTap: () => Navigator.pushNamed(context, '/therapy'),
                  ),
                  _buildFeatureCard(
                    title: "Emergency Mode",
                    subtitle: "Send SOS alerts with live location.",
                    onTap: () => Navigator.pushNamed(context, '/emergency'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _isListening ? _stopListening : _startListening,
        child: Icon(_isListening ? Icons.mic_off : Icons.mic),
      ),
    );
  }

  Widget _buildFeatureCard({
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: ListTile(
        title: Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(subtitle),
        onTap: onTap,
      ),
    );
  }
}

extension on Map<Permission, PermissionStatus> {
  bool any(Function(dynamic status) param0) {}
}

// EmergencyModeScreen
class EmergencyModeScreen extends StatefulWidget {
  const EmergencyModeScreen({super.key});

  @override
  _EmergencyModeScreenState createState() => _EmergencyModeScreenState();
}

class _EmergencyModeScreenState extends State<EmergencyModeScreen> {
  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    _initializeNotifications();
    _requestPermissions();
  }

  void _initializeNotifications() {
    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    const initializationSettings = InitializationSettings(
      android: androidSettings,
    );
    _notificationsPlugin.initialize(initializationSettings);
  }

  Future<void> _showNotification(String message) async {
    const androidDetails = AndroidNotificationDetails(
      'emergency_channel',
      'Emergency Alerts',
      importance: Importance.high,
      priority: Priority.high,
    );
    const notificationDetails = NotificationDetails(android: androidDetails);
    await _notificationsPlugin.show(
      0,
      'Emergency Alert',
      message,
      notificationDetails,
    );
  }

  Future<void> _requestPermissions() async {
    Map<Permission, PermissionStatus> statuses =
        await [Permission.location, Permission.sms].request();

    if (statuses.any((status) => status.value.isDenied)) {
      openAppSettings();
    }
  }

  Future<void> _sendEmergencyAlert() async {
    try {
      final position = await Geolocator.getCurrentPosition();
      final location = "Lat: ${position.latitude}, Long: ${position.longitude}";
      final smsUri = Uri.parse(
        "sms:112?body=Emergency! My location: $location",
      );

      if (await canLaunchUrl(smsUri)) {
        await launchUrl(smsUri);
        _showNotification("Emergency SMS sent successfully.");
      } else {
        _showNotification("Failed to send emergency SMS.");
      }
    } catch (e) {
      _showNotification("Error: Unable to retrieve location.");
    }
  }

  void _simulateFallDetection() {
    Vibration.vibrate(duration: 1000);
    _showNotification("Fall detected! Sending emergency alert...");
    _sendEmergencyAlert();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Enhanced Emergency Mode')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _sendEmergencyAlert,
              child: const Text('Send Emergency Alert'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _simulateFallDetection,
              child: const Text('Simulate Fall Detection'),
            ),
          ],
        ),
      ),
    );
  }
}
      floatingActionButton: FloatingActionButton(
        onPressed = () {
          _addRecord("2025-04-10", "Offline Record Example");
        },
        child = const Icon(Icons.add),
      ),
    );
  }
}

// AnalyticsDashboardScreen
class AnalyticsDashboardScreen extends StatelessWidget {
  const AnalyticsDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Analytics & Gamification")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Your Progress",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(show: true),
                  titlesData: FlTitlesData(show: true),
                  borderData: FlBorderData(show: true),
                  lineBarsData: [
                    LineChartBarData(
                      isCurved: true,
                      spots: const [
                        FlSpot(0, 1),
                        FlSpot(1, 2.5),
                        FlSpot(2, 2),
                        FlSpot(3, 4),
                        FlSpot(4, 3.5),
                      ],
                      color: [Colors.blue],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              "Your Achievements",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView(
                children: [
                  _buildAchievementCard(
                    title: "Badge: Beginner",
                    description: "Complete your first lesson!",
                    isUnlocked: true,
                  ),
                  _buildAchievementCard(
                    title: "Badge: Consistent Learner",
                    description: "Complete lessons 5 days in a row.",
                    isUnlocked: false,
                  ),
                  _buildAchievementCard(
                    title: "Badge: Master Communicator",
                    description: "Finish all lessons and activities.",
                    isUnlocked: false,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAchievementCard({
    required String title,
    required String description,
    required bool isUnlocked,
  }) {
    return Card(
      color: isUnlocked ? Colors.green[50] : Colors.grey[200],
      child: ListTile(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(description),
        trailing: Icon(
          isUnlocked ? Icons.emoji_events : Icons.lock,
          color: isUnlocked ? Colors.green : Colors.grey,
        ),
      ),
    );
  }
}

// BiometricAuthScreen
class BiometricAuthScreen extends StatefulWidget {
  const BiometricAuthScreen({super.key});

  @override
  _BiometricAuthScreenState createState() => _BiometricAuthScreenState();
}

class _BiometricAuthScreenState extends State<BiometricAuthScreen> {
  final LocalAuthentication auth = LocalAuthentication();
  bool _canCheckBiometrics = false;
  String _authorized = "Not Authorized";

  @override
  void initState() {
    super.initState();
    _checkBiometrics();
  }

  Future<void> _checkBiometrics() async {
    bool canCheckBiometrics;
    try {
      canCheckBiometrics = await auth.canCheckBiometrics;
    } catch (e) {
      canCheckBiometrics = false;
    }
    setState(() {
      _canCheckBiometrics = canCheckBiometrics;
    });
  }

  Future<void> _authenticate() async {
    bool authenticated = false;
    try {
      authenticated = await auth.authenticate(
        localizedReason: "Please authenticate to access the app",
        options: const AuthenticationOptions(biometricOnly: true),
      );
    } catch (e) {
      if (kDebugMode) {
        print("Error using biometric authentication: $e");
      }
    }
    setState(() {
      _authorized = authenticated ? "Authorized" : "Not Authorized";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Biometric Authentication")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Biometric Support: $_canCheckBiometrics"),
            const SizedBox(height: 16),
            Text("Status: $_authorized"),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _authenticate,
              child: const Text("Authenticate"),
            ),
          ],
        ),
      ),
    );
  }
}

// SettingsScreen
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _isDarkMode = false;
  bool _isVibrationEnabled = true;
  bool _isNotificationsEnabled = true;
  bool _isSpeechToTextEnabled = true;
  bool _isTextToSpeechEnabled = true;
  bool _isBiometricAuthEnabled = false;
  String _selectedLanguage = 'English';
  String _selectedTheme = 'Blue';

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isDarkMode = prefs.getBool('isDarkMode') ?? false;
      _isVibrationEnabled = prefs.getBool('isVibrationEnabled') ?? true;
      _isNotificationsEnabled = prefs.getBool('isNotificationsEnabled') ?? true;
      _isSpeechToTextEnabled = prefs.getBool('isSpeechToTextEnabled') ?? true;
      _isTextToSpeechEnabled = prefs.getBool('isTextToSpeechEnabled') ?? true;
      _isBiometricAuthEnabled =
          prefs.getBool('isBiometricAuthEnabled') ?? false;
      _selectedLanguage = prefs.getString('selectedLanguage') ?? 'English';
      _selectedTheme = prefs.getString('selectedTheme') ?? 'Blue';
    });
  }

  Future<void> _savePreference(String key, dynamic value) async {
    final prefs = await SharedPreferences.getInstance();
    if (value is bool) {
      await prefs.setBool(key, value);
    } else if (value is String) {
      await prefs.setString(key, value);
    }
  }

  void _showLanguagePicker(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Select Language'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text('English'),
                onTap: () => _updateLanguage('English'),
              ),
              ListTile(
                title: const Text('Hindi'),
                onTap: () => _updateLanguage('Hindi'),
              ),
              ListTile(
                title: const Text('Spanish'),
                onTap: () => _updateLanguage('Spanish'),
              ),
            ],
          ),
        );
      },
    );
  }

  void _updateLanguage(String language) {
    setState(() => _selectedLanguage = language);
    _savePreference('selectedLanguage', language);
    Navigator.pop(context); // Close the dialog
  }

  void _showThemePicker(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Select Theme'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text('Blue'),
                onTap: () => _updateTheme('Blue'),
              ),
              ListTile(
                title: const Text('Green'),
                onTap: () => _updateTheme('Green'),
              ),
              ListTile(
                title: const Text('Red'),
                onTap: () => _updateTheme('Red'),
              ),
            ],
          ),
        );
      },
    );
  }

  void _updateTheme(String theme) {
    setState(() => _selectedTheme = theme);
    _savePreference('selectedTheme', theme);
    Navigator.pop(context); // Close the dialog
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Settings")),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          SwitchListTile(
            title: const Text('Dark Mode'),
            value: _isDarkMode,
            onChanged: (value) {
              setState(() => _isDarkMode = value);
              _savePreference('isDarkMode', value);
            },
          ),
          SwitchListTile(
            title: const Text('Enable Vibration'),
            value: _isVibrationEnabled,
            onChanged: (value) {
              setState(() => _isVibrationEnabled = value);
              _savePreference('isVibrationEnabled', value);
            },
          ),
          SwitchListTile(
            title: const Text('Enable Notifications'),
            value: _isNotificationsEnabled,
            onChanged: (value) {
              setState(() => _isNotificationsEnabled = value);
              _savePreference('isNotificationsEnabled', value);
            },
          ),
          SwitchListTile(
            title: const Text('Enable Speech-to-Text'),
            value: _isSpeechToTextEnabled,
            onChanged: (value) {
              setState(() => _isSpeechToTextEnabled = value);
              _savePreference('isSpeechToTextEnabled', value);
            },
          ),
          SwitchListTile(
            title: const Text('Enable Text-to-Speech'),
            value: _isTextToSpeechEnabled,
            onChanged: (value) {
              setState(() => _isTextToSpeechEnabled = value);
              _savePreference('isTextToSpeechEnabled', value);
            },
          ),
          SwitchListTile(
            title: const Text('Enable Biometric Authentication'),
            value: _isBiometricAuthEnabled,
            onChanged: (value) {
              setState(() => _isBiometricAuthEnabled = value);
              _savePreference('isBiometricAuthEnabled', value);
            },
          ),
          ListTile(
            title: const Text('Language'),
            subtitle: Text(_selectedLanguage),
            onTap: () => _showLanguagePicker(context),
          ),
          ListTile(
            title: const Text('Theme'),
            subtitle: Text(_selectedTheme),
            onTap: () => _showThemePicker(context),
          ),
        ],
      ),
    );
  }
}
import 'package:tflite_flutter/tflite_flutter.dart';

Future<void> loadModel() async {
  try {
    final interpreter = await Interpreter.fromAsset('assets/your_model.tflite');
    print("Model Loaded Successfully!");
  } catch (e) {
    print("Error loading model: $e");
  }
}