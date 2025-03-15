import 'package:flutter/material.dart';

class NavigationItem {
  final String label;
  final String route;
  final IconData icon;
  final String semanticsLabel;

  const NavigationItem({
    required this.label,
    required this.route,
    required this.icon,
    required this.semanticsLabel,
  });
}

class NavigationItems {
  static const List<NavigationItem> bottomNavItems = [
    NavigationItem(
      label: 'Home',
      route: '/',
      icon: Icons.home,
      semanticsLabel: 'Home Screen',
    ),
    NavigationItem(
      label: 'Speech',
      route: '/speech',
      icon: Icons.mic,
      semanticsLabel: 'Speech Features',
    ),
    NavigationItem(
      label: 'Sign',
      route: '/sign',
      icon: Icons.sign_language,
      semanticsLabel: 'Sign Language Features',
    ),
    NavigationItem(
      label: 'Emergency',
      route: '/emergency',
      icon: Icons.emergency,
      semanticsLabel: 'Emergency Mode',
    ),
  ];

  static const List<NavigationItem> drawerItems = [
    NavigationItem(
      label: 'Profile',
      route: '/profile',
      icon: Icons.person,
      semanticsLabel: 'User Profile',
    ),
    NavigationItem(
      label: 'Medical History',
      route: '/medical-history',
      icon: Icons.medical_information,
      semanticsLabel: 'Medical History Records',
    ),
    NavigationItem(
      label: 'Doctor Support',
      route: '/doctor-support',
      icon: Icons.health_and_safety,
      semanticsLabel: 'Doctor Support Features',
    ),
    NavigationItem(
      label: 'Games',
      route: '/games',
      icon: Icons.games,
      semanticsLabel: 'Educational Games',
    ),
    NavigationItem(
      label: 'Lectures',
      route: '/lectures',
      icon: Icons.school,
      semanticsLabel: 'Educational Lectures',
    ),
    NavigationItem(
      label: 'Social',
      route: '/social',
      icon: Icons.people,
      semanticsLabel: 'Social Platform',
    ),
    NavigationItem(
      label: 'Analytics',
      route: '/analytics',
      icon: Icons.analytics,
      semanticsLabel: 'Usage Analytics',
    ),
    NavigationItem(
      label: 'Settings',
      route: '/settings',
      icon: Icons.settings,
      semanticsLabel: 'App Settings',
    ),
  ];
}
