// screens/super_admin_settings_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TeacherSettingsScreen extends ConsumerStatefulWidget {
  const TeacherSettingsScreen({super.key});

  @override
  ConsumerState<TeacherSettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<TeacherSettingsScreen> {
  bool notifications = true;
  bool darkMode = false;
  bool autoSave = true;
  bool biometric = false;
  String selectedLanguage = 'English';

  final List<Map<String, String>> languages = [
    {'code': 'en', 'name': 'English'},
    {'code': 'hi', 'name': 'Hindi'},
    {'code': 'te', 'name': 'Telugu'},
    {'code': 'ta', 'name': 'Tamil'},
    {'code': 'bn', 'name': 'Bengali'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Profile Section
          _buildProfileSection(),
          const SizedBox(height: 20),

          // Preferences
          _buildSectionTitle('Preferences'),
          _buildSettingsTile(
            icon: Icons.notifications,
            title: 'Push Notifications',
            subtitle: 'Receive notifications for attendance and updates',
            trailing: Switch(
              value: notifications,
              onChanged: (value) {
                setState(() {
                  notifications = value;
                });
              },
              activeColor: Colors.blue,
            ),
          ),
          _buildSettingsTile(
            icon: Icons.dark_mode,
            title: 'Dark Mode',
            subtitle: 'Enable dark theme',
            trailing: Switch(
              value: darkMode,
              onChanged: (value) {
                setState(() {
                  darkMode = value;
                });
              },
              activeColor: Colors.blue,
            ),
          ),
          _buildSettingsTile(
            icon: Icons.save,
            title: 'Auto Save',
            subtitle: 'Automatically save attendance',
            trailing: Switch(
              value: autoSave,
              onChanged: (value) {
                setState(() {
                  autoSave = value;
                });
              },
              activeColor: Colors.blue,
            ),
          ),
          _buildSettingsTile(
            icon: Icons.fingerprint,
            title: 'Biometric Login',
            subtitle: 'Use fingerprint to login',
            trailing: Switch(
              value: biometric,
              onChanged: (value) {
                setState(() {
                  biometric = value;
                });
              },
              activeColor: Colors.blue,
            ),
          ),

          const SizedBox(height: 20),

          // General Settings
          _buildSectionTitle('General'),
          _buildSettingsTile(
            icon: Icons.language,
            title: 'Language',
            subtitle: selectedLanguage,
            trailing: DropdownButton<String>(
              value: selectedLanguage,
              items: languages.map((lang) {
                return DropdownMenuItem<String>(
                  value: lang['name'],
                  child: Text(lang['name']!),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedLanguage = value!;
                });
              },
              underline: const SizedBox(),
            ),
          ),
          _buildSettingsTile(
            icon: Icons.data_usage,
            title: 'Data Usage',
            subtitle: 'Manage data usage settings',
            onTap: () {
              // TODO: Navigate to data usage
            },
          ),
          _buildSettingsTile(
            icon: Icons.cloud_sync,
            title: 'Sync Data',
            subtitle: 'Last synced: Today 10:30 AM',
            onTap: () {
              // TODO: Sync data
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Syncing data...')),
              );
            },
          ),

          const SizedBox(height: 20),

          // Support Section
          _buildSectionTitle('Support'),
          _buildSettingsTile(
            icon: Icons.help_outline,
            title: 'Help Center',
            subtitle: 'Get help and support',
            onTap: () {
              // TODO: Navigate to help center
            },
          ),
          _buildSettingsTile(
            icon: Icons.feedback,
            title: 'Send Feedback',
            subtitle: 'Help us improve',
            onTap: () {
              // TODO: Open feedback
            },
          ),
          _buildSettingsTile(
            icon: Icons.share,
            title: 'Share App',
            subtitle: 'Share with friends and colleagues',
            onTap: () {
              // TODO: Share app
            },
          ),
          _buildSettingsTile(
            icon: Icons.info_outline,
            title: 'About',
            subtitle: 'Version 1.0.0',
            onTap: () {
              // TODO: Show about dialog
              _showAboutDialog();
            },
          ),

          const SizedBox(height: 20),

          // Danger Zone
          _buildSectionTitle('Danger Zone', isDanger: true),
          _buildSettingsTile(
            icon: Icons.logout,
            title: 'Logout',
            subtitle: 'Sign out of your account',
            isDanger: true,
            onTap: () {
              _showLogoutDialog();
            },
          ),
          _buildSettingsTile(
            icon: Icons.delete_forever,
            title: 'Delete Account',
            subtitle: 'Permanently delete account and data',
            isDanger: true,
            onTap: () {
              _showDeleteAccountDialog();
            },
          ),

          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _buildProfileSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue.shade700, Colors.blue.shade400],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 35,
            backgroundColor: Colors.white,
            child: Icon(
              Icons.person,
              size: 40,
              color: Colors.blue,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'John Doe',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Teacher • Class 8 - A',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      Icons.email,
                      size: 14,
                      color: Colors.white.withOpacity(0.8),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'john.doe@school.com',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.white),
            onPressed: () {
              // TODO: Edit profile
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, {bool isDanger = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: isDanger ? Colors.red : Colors.blue,
        ),
      ),
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    required String subtitle,
    Widget? trailing,
    VoidCallback? onTap,
    bool isDanger = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isDanger ? Colors.red.withOpacity(0.1) : Colors.blue.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: isDanger ? Colors.red : Colors.blue,
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: isDanger ? Colors.red : Colors.black,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            color: isDanger ? Colors.red.shade400 : Colors.grey.shade600,
            fontSize: 12,
          ),
        ),
        trailing: trailing ?? (onTap != null ? const Icon(Icons.arrow_forward_ios, size: 16) : null),
        onTap: onTap,
      ),
    );
  }

  void _showAboutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('About App'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.school, size: 60, color: Colors.blue),
            const SizedBox(height: 16),
            const Text(
              'Attendance Management System',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Version 1.0.0',
              style: TextStyle(
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'A complete solution for managing school attendance',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Implement logout
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Logged out successfully')),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }

  void _showDeleteAccountDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Account'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.warning, color: Colors.red, size: 50),
            SizedBox(height: 16),
            Text(
              'This action cannot be undone. All your data will be permanently deleted.',
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Implement delete account
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Account deleted'),
                  backgroundColor: Colors.red,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}