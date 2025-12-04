import 'package:flutter/material.dart';
import 'package:project/HomePage.dart';
import 'ProfilePage.dart';

class StaticCrudPage extends StatefulWidget {
  @override
  _StaticCrudPageState createState() => _StaticCrudPageState();
}

class _StaticCrudPageState extends State<StaticCrudPage> {
  final nameController = TextEditingController();
  final ageController = TextEditingController();
  final emailController = TextEditingController();
  String gender = "Male";

  List<Map<String, String>> users = []; // ✅ Keep everything String for consistency

  // CREATE
  void _addUser() {
    setState(() {
      users.add({
        "id": DateTime.now().millisecondsSinceEpoch.toString(),
        "name": nameController.text,
        "age": ageController.text,
        "gender": gender,
        "email": emailController.text,
      });
    });
    _clearControllers();
  }

  // UPDATE
  void _updateUser(Map<String, String> updatedUser) {
    final index = users.indexWhere((u) => u["id"] == updatedUser["id"]);
    if (index != -1) {
      setState(() {
        users[index] = updatedUser;
      });
    }
  }

  // DELETE
  void _deleteUser(String id) {
    setState(() {
      users.removeWhere((u) => u["id"] == id);
    });
  }

  void _clearControllers() {
    nameController.clear();
    ageController.clear();
    emailController.clear();
    gender = "Male";
  }

  // Show dialog for adding user
  void _showAddUserDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Add New User"),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: "Name")),
              TextField(
                  controller: ageController,
                  decoration: const InputDecoration(labelText: "Age")),
              TextField(
                  controller: emailController,
                  decoration: const InputDecoration(labelText: "Email")),
              DropdownButton<String>(
                value: gender,
                onChanged: (val) => setState(() => gender = val!),
                items: ["Male", "Female"]
                    .map((g) => DropdownMenuItem(value: g, child: Text(g)))
                    .toList(),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _clearControllers();
            },
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              _addUser();
              Navigator.pop(context);
            },
            child: const Text("Add"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Static CRUD - Matrimony"),
        backgroundColor: Colors.pink,
      ),

      // List of users
      body: users.isEmpty
          ? const Center(child: Text("No users added yet."))
          : ListView.builder(
        itemCount: users.length,
        itemBuilder: (context, index) {
          final u = users[index];
          return ListTile(
            title: Text("${u["name"]} (${u["age"]})"),
            subtitle: Text("${u["email"]} - ${u["gender"]}"),
            onTap: () async {
              final updatedUser = await Navigator.push<Map<String, String>>(
                context,
                MaterialPageRoute(
                  builder: (_) => ProfileFormPage(user: u),
                ),
              );
              if (updatedUser != null) {
                _updateUser(updatedUser);
              }
            },
            trailing: IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () => _deleteUser(u["id"]!),
            ),
          );
        },
      ),

      // Floating Add Button in Bottom Navigation
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.pink,
        child: const Icon(Icons.add),
        onPressed: _showAddUserDialog,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 6,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(icon: const Icon(Icons.home), onPressed: () {}),
            IconButton(icon: const Icon(Icons.person), onPressed: () {}),
          ],
        ),
      ),
    );
  }
}