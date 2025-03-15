import 'package:flutter/material.dart';
import 'navigation_items.dart';
import '../constants/color_constants.dart';
import '../widgets/high_contrast_text.dart';

class AppDrawer extends StatelessWidget {
  final String userName;
  final String? userEmail;
  final String? userImage;
  final VoidCallback? onProfileTap;

  const AppDrawer({
    Key? key,
    required this.userName,
    this.userEmail,
    this.userImage,
    this.onProfileTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          _buildDrawerHeader(),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                ...NavigationItems.drawerItems.map(
                  (item) => _buildDrawerItem(context, item),
                ),
                const Divider(),
                _buildAccessibilityButton(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerHeader() {
    return UserAccountsDrawerHeader(
      accountName: HighContrastText(
        userName,
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
      accountEmail: userEmail != null
          ? HighContrastText(
              userEmail!,
              fontSize: 14,
            )
          : null,
      currentAccountPicture: CircleAvatar(
        backgroundColor: ColorConstants.surface,
        backgroundImage: userImage != null ? NetworkImage(userImage!) : null,
        child: userImage == null
            ? Text(
                userName[0].toUpperCase(),
                style: const TextStyle(fontSize: 32),
              )
            : null,
      ),
      decoration: BoxDecoration(
        color: ColorConstants.primary,
      ),
    );
  }

  Widget _buildDrawerItem(BuildContext context, NavigationItem item) {
    return Semantics(
      button: true,
      label: item.semanticsLabel,
      child: ListTile(
        leading: Icon(item.icon),
        title: Text(item.label),
        onTap: () {
          Navigator.pop(context); // Close drawer
          Navigator.pushNamed(context, item.route);
        },
      ),
    );
  }

  Widget _buildAccessibilityButton(BuildContext context) {
    return Semantics(
      button: true,
      label: 'Quick Accessibility Options',
      child: ListTile(
        leading: const Icon(Icons.accessibility_new),
        title: const Text('Accessibility Options'),
        onTap: () {
          Navigator.pop(context);
          // Show accessibility options dialog or navigate to accessibility settings
        },
      ),
    );
  }
}
