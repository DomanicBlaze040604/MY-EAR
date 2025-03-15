import 'package:flutter/material.dart';
import 'navigation_items.dart';
import '../constants/color_constants.dart';

class AppBottomNavigation extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const AppBottomNavigation({
    Key? key,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: onTap,
        type: BottomNavigationBarType.fixed,
        backgroundColor: ColorConstants.surface,
        selectedItemColor: ColorConstants.primary,
        unselectedItemColor: ColorConstants.textSecondary,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
        items: NavigationItems.bottomNavItems.map((item) {
          return BottomNavigationBarItem(
            icon: Semantics(
              label: item.semanticsLabel,
              child: Icon(item.icon),
            ),
            label: item.label,
          );
        }).toList(),
      ),
    );
  }
}
