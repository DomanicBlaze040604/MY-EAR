import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SocialPlatformScreen extends StatefulWidget {
  const SocialPlatformScreen({super.key});

  @override
  _SocialPlatformScreenState createState() => _SocialPlatformScreenState();
}

class _SocialPlatformScreenState extends State<SocialPlatformScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Social Platform')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _addFriend,
              child: const Text('Add Friend'),
            ),
            ElevatedButton(
              onPressed: _createGroup,
              child: const Text('Create Group'),
            ),
            ElevatedButton(
              onPressed: _privateChat,
              child: const Text('Private Chat'),
            ),
            ElevatedButton(
              onPressed: _sharePost,
              child: const Text('Share Post'),
            ),
            ElevatedButton(
              onPressed: _connectWithCommunity,
              child: const Text('Connect with Community'),
            ),
            ElevatedButton(
              onPressed: _shareExperiences,
              child: const Text('Share Experiences'),
            ),
          ],
        ),
      ),
    );
  }

  void _addFriend() {
    // Implement add friend feature
  }

  void _createGroup() {
    // Implement create group feature
  }

  void _privateChat() {
    // Implement private chat feature
  }

  void _sharePost() {
    // Implement share post feature
  }

  void _connectWithCommunity() async {
    const url = 'your-community-url'; // Replace with actual community URL
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void _shareExperiences() async {
    const url =
        'your-share-experience-url'; // Replace with actual share experience URL
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
