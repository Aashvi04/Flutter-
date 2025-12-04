import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  final List<Map<String, String>> profiles;

  const ProfilePage({super.key, required this.profiles});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profiles"),
        backgroundColor: Colors.pink.shade400,
      ),
      body: profiles.isEmpty
          ? const Center(child: Text("No profiles available"))
          : ListView.builder(
        itemCount: profiles.length,
        itemBuilder: (context, index) {
          final profile = profiles[index];
          return Card(
            child: ListTile(
              leading: const CircleAvatar(
                backgroundColor: Colors.pink,
                child: Icon(Icons.person, color: Colors.white),
              ),
              title: Text(profile["name"] ?? ""),
              subtitle: Text("${profile["email"] ?? ""}\n${profile["phone"] ?? ""}"),
              isThreeLine: true,
            ),
          );
        },
      ),
    );
  }
}