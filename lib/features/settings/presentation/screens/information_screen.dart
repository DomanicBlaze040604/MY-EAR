import 'package:flutter/material.dart';

class InformationScreen extends StatelessWidget {
  const InformationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('About Deafness & App Benefits')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Understanding Deafness',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 10),
            const Text(
              'Deafness, or hearing loss, is the partial or complete inability to hear sound in one or both ears. '
              'It can be caused by a variety of factors including aging, exposure to loud noises, infections, and genetic factors. '
              'There are different levels of hearing loss, ranging from mild to profound.',
            ),
            const SizedBox(height: 20),
            Text(
              'Treatment Options',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 10),
            const Text(
              'Treatment for deafness depends on the cause and severity of the hearing loss. Some common treatment options include:',
            ),
            const SizedBox(height: 10),
            const Text(
              '1. Hearing Aids: Devices that amplify sound to help those with hearing loss hear better.',
            ),
            const Text(
              '2. Cochlear Implants: Surgically implanted devices that provide a sense of sound to individuals who are profoundly deaf or severely hard of hearing.',
            ),
            const Text(
              '3. Medications or Surgery: For hearing loss caused by infections or other medical conditions.',
            ),
            const Text(
              '4. Assistive Listening Devices: Devices that help individuals hear in specific situations, such as using a phone or watching TV.',
            ),
            const SizedBox(height: 20),
            Text(
              'How Our App Helps',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 10),
            const Text(
              'Our app, My Ear, is designed to support individuals with hearing impairments through various features:',
            ),
            const SizedBox(height: 10),
            const Text(
              '1. Speech to Text: Converts spoken words into text to help users understand conversations in real-time.',
            ),
            const Text(
              '2. Text to Speech: Converts text into spoken words, allowing users to communicate more easily.',
            ),
            const Text(
              '3. Emergency Mode: Sends SOS alerts with the user\'s location in case of emergencies.',
            ),
            const Text(
              '4. Doctor Support: Facilitates video calls with doctors and allows users to upload medical reports.',
            ),
            const Text(
              '5. Social Platform: Connects users with friends and community support groups.',
            ),
            const Text(
              '6. Medical History: Allows users to store and manage their medical history and records.',
            ),
            const Text(
              '7. Analytics Dashboard: Provides insights into the user\'s health and app usage.',
            ),
            const Text(
              '8. Biometric Authentication: Ensures secure access to the app using biometric authentication.',
            ),
            const Text(
              '9. Speech Therapy: Offers personalized training and AI-powered guidance to improve speech abilities.',
            ),
            const Text(
              '10. Sign to Speech & Sign to Text: Translates sign language into speech or text, making communication easier for users who use sign language.',
            ),
            const SizedBox(height: 20),
            const Text(
              'By leveraging these features, our app aims to enhance the quality of life for individuals with hearing impairments, making communication and daily activities more accessible and manageable.',
            ),
          ],
        ),
      ),
    );
  }
}
