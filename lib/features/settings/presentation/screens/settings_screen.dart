import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends StatefulWidget {
  final Function(bool) onThemeChanged;

  const SettingsScreen({super.key, required this.onThemeChanged});

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _isDarkMode = false;
  bool _isHighContrast = false;
  double _fontSize = 16.0;

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isDarkMode = prefs.getBool('isDarkMode') ?? false;
      _isHighContrast = prefs.getBool('isHighContrast') ?? false;
      _fontSize = prefs.getDouble('fontSize') ?? 16.0;
    });
  }

  Future<void> _savePreferences() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('isDarkMode', _isDarkMode);
    prefs.setBool('isHighContrast', _isHighContrast);
    prefs.setDouble('fontSize', _fontSize);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text('Dark Mode'),
            value: _isDarkMode,
            onChanged: (val) {
              setState(() {
                _isDarkMode = val;
                widget.onThemeChanged(val);
              });
              _savePreferences();
            },
          ),
          SwitchListTile(
            title: const Text('High Contrast Mode'),
            value: _isHighContrast,
            onChanged: (val) {
              setState(() {
                _isHighContrast = val;
              });
              _savePreferences();
            },
          ),
          ListTile(
            title: const Text('Font Size'),
            subtitle: Slider(
              min: 12.0,
              max: 24.0,
              value: _fontSize,
              onChanged: (val) {
                setState(() {
                  _fontSize = val;
                });
                _savePreferences();
              },
            ),
          ),
        ],
      ),
    );
  }
}
