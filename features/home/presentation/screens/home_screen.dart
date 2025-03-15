import 'package:flutter/material.dart';
import '../../../../core/navigation/app_bottom_navigation.dart';
import '../../../../core/navigation/app_drawer.dart';
import '../../../../core/widgets/voice_command_button.dart';
import '../../../../core/constants/color_constants.dart';
import '../../../../core/widgets/custom_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomeContent(),
    const Center(child: Text('Speech Features')),
    const Center(child: Text('Sign Language Features')),
    const Center(child: Text('Emergency Mode')),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'My Ear',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.accessibility_new),
            onPressed: () {
              // Show accessibility options
              // This will be implemented later
            },
            semanticsLabel: 'Accessibility Options',
          ),
        ],
      ),
      drawer: AppDrawer(
        userName: 'User Name', // Will be replaced with actual user data
        userEmail: 'user@example.com',
      ),
      body: _screens[_currentIndex],
      bottomNavigationBar: AppBottomNavigation(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() => _currentIndex = index);
        },
      ),
      floatingActionButton: VoiceCommandButton(
        onCommandReceived: (command) {
          // Handle voice command
          _handleVoiceCommand(command);
        },
        buttonLabel: 'Activate Voice Command',
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  void _handleVoiceCommand(String command) {
    // Voice command handling logic will be implemented later
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Voice command received: $command')),
    );
  }
}

class HomeContent extends StatelessWidget {
  const HomeContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildWelcomeCard(),
          const SizedBox(height: 20),
          _buildQuickActions(),
          const SizedBox(height: 20),
          _buildRecentActivities(),
        ],
      ),
    );
  }

  Widget _buildWelcomeCard() {
    return CustomCard(
      color: ColorConstants.primary,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            'Welcome to My Ear',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Your personal assistant for better communication',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Quick Actions',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          children: [
            _buildActionCard(
              'Speech to Text',
              Icons.record_voice_over,
              '/speech-to-text',
            ),
            _buildActionCard(
              'Sign Language',
              Icons.sign_language,
              '/sign-to-text',
            ),
            _buildActionCard(
              'Emergency',
              Icons.emergency,
              '/emergency',
            ),
            _buildActionCard(
              'Medical Support',
              Icons.medical_services,
              '/medical',
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionCard(String title, IconData icon, String route) {
    return CustomCard(
      onTap: () {
        // Navigation will be implemented later
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 32, color: ColorConstants.primary),
          const SizedBox(height: 8),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentActivities() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Recent Activities',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        CustomCard(
          child: ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 3,
            itemBuilder: (context, index) {
              return ListTile(
                leading: const CircleAvatar(
                  backgroundColor: ColorConstants.primary,
                  child: Icon(Icons.history, color: Colors.white),
                ),
                title: Text('Activity ${index + 1}'),
                subtitle: Text('Description for activity ${index + 1}'),
                trailing: const Icon(Icons.chevron_right),
              );
            },
          ),
        ),
      ],
    );
  }
}
