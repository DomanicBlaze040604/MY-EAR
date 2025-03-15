import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class EmergencyModeScreen extends StatelessWidget {
  const EmergencyModeScreen({Key? key}) : super(key: key);

  Future<void> _makeEmergencyCall(String number) async {
    final Uri url = Uri.parse('tel:$number');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Emergency Mode'),
        backgroundColor: Colors.red,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildEmergencyButton(
            'Call Emergency Services',
            Icons.emergency,
            Colors.red,
            () => _makeEmergencyCall('911'),
          ),
          _buildEmergencyButton(
            'Medical Information',
            Icons.medical_services,
            Colors.blue,
            () {},
          ),
          _buildEmergencyButton(
            'Emergency Contacts',
            Icons.contacts,
            Colors.green,
            () {},
          ),
        ],
      ),
    );
  }

  Widget _buildEmergencyButton(
    String title,
    IconData icon,
    Color color,
    VoidCallback onPressed,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 32.0),
            const SizedBox(width: 16.0),
            Text(title, style: const TextStyle(fontSize: 18.0)),
          ],
        ),
      ),
    );
  }
}
