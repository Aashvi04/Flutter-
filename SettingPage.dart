import 'package:flutter/material.dart';
import 'package:project/HomePage.dart';
import 'ProfilePage.dart';
import 'SignupPage.dart';
import 'LoginPage.dart';
import 'main.dart'; // import MyApp for theme toggle

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool isDark = MyApp.themeNotifier.value == ThemeMode.dark;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
        backgroundColor: Colors.pink.shade400,
      ),
      body: ListView(
        children: [
          const SizedBox(height: 10),

          _buildSectionTitle("Profile"),
          ListTile(
            leading: const Icon(Icons.person, color: Colors.pink),
            title: const Text("Edit Profile"),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ProfileFormPage()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.photo_camera, color: Colors.pink),
            title: const Text("Change Photo"),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ChangePhotoPage()),
              );
            },
          ),

          const Divider(),

          _buildSectionTitle("Account"),
          ListTile(
            leading: const Icon(Icons.lock, color: Colors.orange),
            title: const Text("Change Password"),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ChangePasswordPage()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.notifications, color: Colors.blue),
            title: const Text("Notifications"),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const NotificationsPage()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.privacy_tip, color: Colors.green),
            title: const Text("Privacy Settings"),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const PrivacyPage()),
              );
            },
          ),

          const Divider(),

          _buildSectionTitle("App"),
          ListTile(
            leading: const Icon(Icons.language, color: Colors.purple),
            title: const Text("Language"),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const LanguagePage()),
              );
            },
          ),
          SwitchListTile(
            secondary: const Icon(Icons.dark_mode, color: Colors.indigo),
            title: const Text("Dark Mode"),
            value: isDark,
            onChanged: (val) {
              setState(() => isDark = val);
              MyApp.themeNotifier.value =
              val ? ThemeMode.dark : ThemeMode.light;
            },
          ),

          const Divider(),

          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text("Logout"),
            onTap: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => LoginPage()),
                    (route) => false,
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.black54,
        ),
      ),
    );
  }
}

/// 🔹 Language Selection Page
class LanguagePage extends StatelessWidget {
  const LanguagePage({super.key});

  final List<String> languages = const [
    "English",
    "Gujarati",
    "Hindi",
    "Spanish",
    "French",
    "Urdu",
    "German",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Select Language"),
        backgroundColor: Colors.pink.shade400,
      ),
      body: ListView.builder(
        itemCount: languages.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: const Icon(Icons.language, color: Colors.purple),
            title: Text(languages[index]),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Selected: ${languages[index]}")),
              );
              Navigator.pop(context);
            },
          );
        },
      ),
    );
  }
}

/// 🔹 Dummy pages for other settings
class ChangePhotoPage extends StatelessWidget {
  const ChangePhotoPage({super.key});
  @override
  Widget build(BuildContext context) => _placeholder("Change Photo Page");
}

class ChangePasswordPage extends StatelessWidget {
  const ChangePasswordPage({super.key});
  @override
  Widget build(BuildContext context) => _placeholder("Change Password Page");
}

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});
  @override
  Widget build(BuildContext context) => _placeholder("Notifications Page");
}

class PrivacyPage extends StatelessWidget {
  const PrivacyPage({super.key});
  @override
  Widget build(BuildContext context) => _placeholder("Privacy Page");
}

/// 🔹 Helper placeholder widget
Widget _placeholder(String title) {
  return Scaffold(
    appBar: AppBar(title: Text(title), backgroundColor: Colors.pink.shade400),
    body: Center(child: Text(title, style: const TextStyle(fontSize: 20))),
  );
}