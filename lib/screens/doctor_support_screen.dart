import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:file_picker/file_picker.dart';

class DoctorSupportScreen extends StatelessWidget {
  const DoctorSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Doctor Support')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _videoCallWithDoctor,
              child: const Text('Video Call with Doctor'),
            ),
            ElevatedButton(
              onPressed: _uploadMedicalReports,
              child: const Text('Upload Medical Reports'),
            ),
          ],
        ),
      ),
    );
  }

  void _videoCallWithDoctor() async {
    const url = 'your-video-call-url'; // Replace with actual video call URL
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void _uploadMedicalReports() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx', 'jpg', 'png'],
    );
    if (result != null) {
      PlatformFile file = result.files.first;
      // Handle file upload (e.g., send to server)
      print('File picked: ${file.name}');
    } else {
      // User canceled the picker
    }
  }
}
