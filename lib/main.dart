// Import all necessary packages
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
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final cameras = await availableCameras();
  tz.initializeTimeZones();
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
      },
    );
  }
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
    Map<Permission, PermissionStatus> statuses = await [
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
      _speech.listen(onResult: (result) {
        setState(() => _text = result.recognizedWords);
      });
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(_text, style: const TextStyle(fontSize: 18)),
            ),
            FloatingActionButton(
              onPressed: _isListening ? _stopListening : _startListening,
              child: Icon(_isListening ? Icons.mic_off : Icons.mic),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/emergency'),
              child: const Text('Emergency Mode'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/signToAudio'),
              child: const Text('Sign to Text & Audio'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/learningMode'),
              child: const Text('Learning Mode'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/therapy'),
              child: const Text('Therapy & Speech Training'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/settings'),
              child: const Text('Settings'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/doctorSupport'),
              child: const Text('Doctor Support'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/socialPlatform'),
              child: const Text('Social Platform'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/medicalHistory'),
              child: const Text('Medical History'),
            ),
          ],
        ),
      ),
    );
  }
}

// For brevity, detailed implementations for each screen (EmergencyModeScreen, SignToTextAudioScreen, etc.) can be added below or in separate files if needed.
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';

class EmergencyModeScreen extends StatelessWidget {
  const EmergencyModeScreen({super.key});

  Future<void> _sendEmergencyAlert() async {
    try {
      // Get the user's location
      final position = await Geolocator.getCurrentPosition();
      final location = "Lat: ${position.latitude}, Long: ${position.longitude}";
      // Create SMS and Call URIs
      final smsUri = Uri.parse("sms:112?body=Emergency! My location: $location");
      final callUri = Uri.parse("tel://112");

      // Try launching the SMS app first, fall back to call if unavailable
      if (await canLaunchUrl(smsUri)) {
        await launchUrl(smsUri);
      } else {
        await launchUrl(callUri);
      }
    } catch (e) {
      print("Error sending emergency alert: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Emergency Mode')),
      body: Center(
        child: ElevatedButton(
          onPressed: _sendEmergencyAlert,
          child: const Text('Send Emergency Alert'),
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:flutter_tts/flutter_tts.dart';

class SignToTextAudioScreen extends StatefulWidget {
  final List<CameraDescription> cameras;

  const SignToTextAudioScreen({super.key, required this.cameras});

  @override
  _SignToTextAudioScreenState createState() => _SignToTextAudioScreenState();
}

class _SignToTextAudioScreenState extends State<SignToTextAudioScreen> {
  late CameraController _cameraController;
  bool _isCameraInitialized = false;
  bool _isLoading = false;
  String _detectedSign = "Perform a gesture to detect";
  final FlutterTts _tts = FlutterTts();
  late Interpreter _interpreter;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
    _loadModel();
  }

  Future<void> _initializeCamera() async {
    try {
      _cameraController = CameraController(widget.cameras[0], ResolutionPreset.medium);
      await _cameraController.initialize();
      if (!mounted) return;
      setState(() => _isCameraInitialized = true);
    } catch (e) {
      print("Failed to initialize camera: $e");
    }
  }

  Future<void> _loadModel() async {
    try {
      _interpreter = await Interpreter.fromAsset("model.tflite");
    } catch (e) {
      print("Failed to load model: $e");
    }
  }

  Future<void> _processSign() async {
    if (!_isCameraInitialized || _isLoading) return;

    setState(() => _isLoading = true);
    try {
      final image = await _cameraController.takePicture();
      // Run inference on the image (Add preprocessing and inference logic here)
      setState(() => _detectedSign = "Detected Sign: [Inference Result]");
    } catch (e) {
      print("Error processing sign: $e");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _speakText() async {
    await _tts.speak(_detectedSign);
  }

  @override
  void dispose() {
    _cameraController.dispose();
    _interpreter.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Sign to Text & Audio")),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (_isCameraInitialized)
            SizedBox(
              height: 200,
              child: CameraPreview(_cameraController),
            ),
          const SizedBox(height: 20),
          Text(_detectedSign, style: const TextStyle(fontSize: 18)),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _processSign,
            child: _isLoading ? const CircularProgressIndicator() : const Text("Detect Sign"),
          ),
          ElevatedButton(
            onPressed: _speakText,
            child: const Text("Speak Detected Sign"),
          ),
        ],
      ),
    );
  }
}
import 'package:flutter/material.dart';

class LearningModeScreen extends StatelessWidget {
  const LearningModeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Learning Mode")),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Card(
            child: ListTile(
              title: const Text("Lesson 1: Introduction to Sign Language"),
              subtitle: const Text("Learn the basics of sign language gestures."),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text("Lesson 1 not implemented yet!"),
                ));
              },
            ),
          ),
          Card(
            child: ListTile(
              title: const Text("Lesson 2: Greetings & Common Phrases"),
              subtitle: const Text("Master essential communication phrases."),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text("Lesson 2 not implemented yet!"),
                ));
              },
            ),
          ),
          Card(
            child: ListTile(
              title: const Text("Lesson 3: Everyday Objects"),
              subtitle: const Text("Learn how to sign common everyday items."),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text("Lesson 3 not implemented yet!"),
                ));
              },
            ),
          ),
        ],
      ),
    );
  }
}
import 'package:flutter/material.dart';

class TherapyScreen extends StatelessWidget {
  const TherapyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Therapy & Speech Training")),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Card(
            child: ListTile(
              title: const Text("Exercise 1: Pronunciation Practice"),
              subtitle: const Text("Improve speech clarity with guided exercises."),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text("Exercise 1 not implemented yet!"),
                ));
              },
            ),
          ),
          Card(
            child: ListTile(
              title: const Text("Exercise 2: Vocabulary Building"),
              subtitle: const Text("Learn new words and how to pronounce them."),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text("Exercise 2 not implemented yet!"),
                ));
              },
            ),
          ),
          Card(
            child: ListTile(
              title: const Text("Exercise 3: Sentence Practice"),
              subtitle: const Text("Build your confidence with sentences."),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text("Exercise 3 not implemented yet!"),
                ));
              },
            ),
          ),
        ],
      ),
    );
  }
}
import 'package:flutter/material.dart';

class DoctorSupportScreen extends StatelessWidget {
  const DoctorSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Doctor Support")),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          ListTile(
            title: const Text("Schedule a Video Consultation"),
            subtitle: const Text("Book an appointment with an audiologist."),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text("Video consultation feature coming soon!"),
              ));
            },
          ),
          ListTile(
            title: const Text("Upload Medical Reports"),
            subtitle: const Text("Securely share your reports with doctors."),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text("Medical report upload feature coming soon!"),
              ));
            },
          ),
        ],
      ),
    );
  }
}
import 'package:flutter/material.dart';

class MedicalHistoryScreen extends StatelessWidget {
  const MedicalHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Medical History")),
      body: Center(
        child: const Text("Medical history and records will be displayed here."),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _isDarkMode = false;
  bool _isVibrationEnabled = true;
  bool _isNotificationsEnabled = true;
  String _selectedLanguage = 'English';

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
      _selectedLanguage = prefs.getString('selectedLanguage') ?? 'English';
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
          ListTile(
            title: const Text('Language'),
            subtitle: Text(_selectedLanguage),
            onTap: () => _showLanguagePicker(context),
          ),
        ],
      ),
    );
  }
}
import 'package:flutter/material.dart';

class SocialPlatformScreen extends StatelessWidget {
  const SocialPlatformScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Social Platform")),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildPostCard(
            username: "Alice",
            content: "Learning sign language is so empowering! 😊",
            likes: 12,
            comments: 4,
          ),
          _buildPostCard(
            username: "Bob",
            content: "Anyone tried the Therapy Mode? It's amazing! 💪",
            likes: 8,
            comments: 2,
          ),
          _buildPostCard(
            username: "Charlie",
            content: "Looking for resources to learn advanced signs! 📚",
            likes: 20,
            comments: 5,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Post creation feature coming soon!")),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildPostCard({
    required String username,
    required String content,
    required int likes,
    required int comments,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("@$username", style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(content),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.thumb_up, size: 16),
                    const SizedBox(width: 4),
                    Text("$likes likes"),
                  ],
                ),
                Row(
                  children: [
                    const Icon(Icons.comment, size: 16),
                    const SizedBox(width: 4),
                    Text("$comments comments"),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:vibration/vibration.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';

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
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const initializationSettings = InitializationSettings(android: androidSettings);
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
    Map<Permission, PermissionStatus> statuses = await [
      Permission.location,
      Permission.sms,
    ].request();

    if (statuses.any((status) => status.value.isDenied)) {
      openAppSettings();
    }
  }

  Future<void> _sendEmergencyAlert() async {
    try {
      final position = await Geolocator.getCurrentPosition();
      final location = "Lat: ${position.latitude}, Long: ${position.longitude}";
      final smsUri = Uri.parse("sms:112?body=Emergency! My location: $location");

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
import 'package:flutter/material.dart';

class MedicalHistoryScreen extends StatefulWidget {
  const MedicalHistoryScreen({super.key});

  @override
  _MedicalHistoryScreenState createState() => _MedicalHistoryScreenState();
}

class _MedicalHistoryScreenState extends State<MedicalHistoryScreen> {
  final List<Map<String, String>> _medicalRecords = [
    {"date": "2025-03-01", "description": "Routine Checkup"},
    {"date": "2025-02-15", "description": "Prescribed Hearing Aid"},
    {"date": "2025-01-20", "description": "Follow-up Consultation"},
  ];

  Future<void> _addRecord() async {
    final descriptionController = TextEditingController();
    final dateController = TextEditingController();

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Add Medical Record"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: dateController,
                decoration: const InputDecoration(labelText: "Date (YYYY-MM-DD)"),
              ),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(labelText: "Description"),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _medicalRecords.add({
                    "date": dateController.text,
                    "description": descriptionController.text,
                  });
                });
                Navigator.pop(context);
              },
              child: const Text("Save"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Medical History")),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: _medicalRecords.length,
        itemBuilder: (context, index) {
          final record = _medicalRecords[index];
          return Card(
            child: ListTile(
              title: Text(record["description"]!),
              subtitle: Text(record["date"]!),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text("Viewing record for ${record["description"]!}"),
                ));
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addRecord,
        child: const Icon(Icons.add),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

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
                      colors: [Colors.blue],
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
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class SpeechToTextScreen extends StatefulWidget {
  const SpeechToTextScreen({super.key});

  @override
  _SpeechToTextScreenState createState() => _SpeechToTextScreenState();
}

class _SpeechToTextScreenState extends State<SpeechToTextScreen> {
  late stt.SpeechToText _speech;
  bool _isListening = false;
  String _transcribedText = "Press the button and start speaking";

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
  }

  void _startListening() async {
    bool available = await _speech.initialize();
    if (available) {
      setState(() => _isListening = true);
      _speech.listen(onResult: (result) {
        setState(() {
          _transcribedText = result.recognizedWords;
        });
      });
    } else {
      setState(() {
        _transcribedText = "Speech recognition not available on this device.";
      });
    }
  }

  void _stopListening() {
    setState(() {
      _isListening = false;
      _speech.stop();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Speech to Text")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _transcribedText,
              style: const TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            FloatingActionButton(
              onPressed: _isListening ? _stopListening : _startListening,
              child: Icon(_isListening ? Icons.mic_off : Icons.mic),
            ),
          ],
        ),
      ),
    );
  }
}
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  runApp(MyEarApp());
}
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class MedicalHistoryScreen extends StatefulWidget {
  const MedicalHistoryScreen({super.key});

  @override
  _MedicalHistoryScreenState createState() => _MedicalHistoryScreenState();
}

class _MedicalHistoryScreenState extends State<MedicalHistoryScreen> {
  late Box medicalHistoryBox;

  @override
  void initState() {
    super.initState();
    medicalHistoryBox = Hive.box('medicalHistory');
  }

  Future<void> _addRecord(String date, String description) async {
    await medicalHistoryBox.add({'date': date, 'description': description});
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Medical History (Offline)")),
      body: ListView.builder(
        itemCount: medicalHistoryBox.length,
        itemBuilder: (context, index) {
          final record = medicalHistoryBox.getAt(index) as Map;
          return Card(
            child: ListTile(
              title: Text(record['description']),
              subtitle: Text(record['date']),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _addRecord("2025-04-10", "Offline Record Example");
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';

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
        options: const AuthenticationOptions(
          biometricOnly: true,
        ),
      );
    } catch (e) {
      print("Error using biometric authentication: $e");
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
