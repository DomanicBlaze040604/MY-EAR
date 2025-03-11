import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';

class EmergencyModeScreen extends StatefulWidget {
  const EmergencyModeScreen({super.key});

  @override
  _EmergencyModeScreenState createState() => _EmergencyModeScreenState();
}

class _EmergencyModeScreenState extends State<EmergencyModeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Emergency Mode'),
        backgroundColor: Colors.red,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _sendSOS,
              child: const Text('Send SOS Alert'),
              style: ElevatedButton.styleFrom(
                primary: Colors.red,
                padding: const EdgeInsets.symmetric(
                  horizontal: 50,
                  vertical: 20,
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _makeEmergencyCall,
              child: const Text('Call Emergency'),
              style: ElevatedButton.styleFrom(
                primary: Colors.red,
                padding: const EdgeInsets.symmetric(
                  horizontal: 50,
                  vertical: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _sendSOS() async {
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    String message =
        'SOS! I need help. My location is: https://maps.google.com/?q=${position.latitude},${position.longitude}';
    String url = 'sms:1234567890?body=$message';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not send SOS';
    }
  }

  Future<void> _makeEmergencyCall() async {
    String url = 'tel:1234567890';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not make emergency call';
    }
  }
}
