// File: settingsScreen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:testnow/screens/profilescreen.dart';

import '../wedgets/themProvider.dart';
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool receiveAppUpdates = true;
  bool receiveNewsletter = true;

  Widget _buildIconBox(IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(icon, color: Colors.white),
    );
  }

  Widget _buildSettingTile(
      {required IconData icon,
        required String title,
        required VoidCallback onTap,
        required Color color}) {
    return ListTile(
      leading: _buildIconBox(icon, color),
      title: Text(title),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }

  Widget _buildToggleTile(
      {required IconData icon,
        required String title,
        required bool value,
        required ValueChanged<bool> onChanged,
        required Color color}) {
    return SwitchListTile(
      secondary: _buildIconBox(icon, color),
      title: Text(title),
      value: value,
      onChanged: onChanged,
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Log Out"),
        content: const Text("Are you sure you want to log out?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context), // Replace with actual logout logic
            child: const Text("Log Out"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
      ),
      body: ListView(
        children: [
          _buildSettingTile(
            icon: Icons.person,
            title: 'Account Details',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfileScreen()),
              );
            },
            color: Colors.blue,
          ),
          _buildToggleTile(
            icon: Icons.nightlight_round,
            title: 'Dark Mode',
            value: themeProvider.isDarkMode,
            onChanged: (_) => themeProvider.toggleTheme(),
            color: Colors.purple,
          ),
          _buildToggleTile(
            icon: Icons.update,
            title: 'Receive App Updates',
            value: receiveAppUpdates,
            onChanged: (value) {
              setState(() {
                receiveAppUpdates = value;
              });
            },
            color: Colors.green,
          ),
          _buildToggleTile(
            icon: Icons.email,
            title: 'Receive Newsletter',
            value: receiveNewsletter,
            onChanged: (value) {
              setState(() {
                receiveNewsletter = value;
              });
            },
            color: Colors.orange,
          ),
          _buildSettingTile(
            icon: Icons.logout,
            title: 'Log Out',
            onTap: _showLogoutDialog,
            color: Colors.red,
          ),
        ],
      ),
    );
  }
}
