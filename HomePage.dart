import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'LoginPage.dart';
import 'SignupPage.dart';
import 'ProfilePage.dart';
import 'SettingPage.dart';

/// 🔹 Dashboard Page with BottomNav & Drawer
class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _selectedIndex = 0;
  final List<Map<String, String>> likedProfiles = [];
  final List<Map<String, String>> profiles = [];

  void _onBottomNavTap(int index) {
    setState(() => _selectedIndex = index);
    final List<Map<String, String>> likedProfiles = [];

    switch (index) {
      case 0:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => DashboardPage(),
          ),
        );
        break; // Home
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ProfilePage(profiles: profiles),
          ),
        );
        break;
      case 2:
        Navigator.push<Map<String, String>>(
          context,
          MaterialPageRoute(
            builder: (_) => ProfileFormPage(),
          ),
        ).then((newProfile) {
          if (newProfile != null) {
            setState(() {
              newProfile["id"] ??=
                  DateTime.now().millisecondsSinceEpoch.toString();
              profiles.add(newProfile);
            });
          }
        });
        break;
      case 3:
        break; 
      case 4:
        Navigator.push(
            context, MaterialPageRoute(builder: (_) => const SettingsPage()));
        break;
    }
  }

  void addToMatches(String name, String details) {
    setState(() {
      final existing = likedProfiles.indexWhere((p) => p["name"] == name);
      if (existing >= 0) {
        likedProfiles.removeAt(existing);
      } else {
        likedProfiles.add({"name": name, "details": details});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dashboard"),
        backgroundColor: Colors.pink.shade400,
      ),
      drawer: _buildDrawer(context),
      body: DashboardHome(
        likedProfiles: likedProfiles,
        onLikeProfile: addToMatches,
        profiles: profiles,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onBottomNavTap,
        selectedItemColor: Colors.pink.shade400,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
          BottomNavigationBarItem(icon: Icon(Icons.person_add), label: "Add User"),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: "Matches"),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Settings"),
        ],
      ),
    );
  }

  Drawer _buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const UserAccountsDrawerHeader(
            accountName: Text("Aashvi Vadaliya"),
            accountEmail: Text("aashvivadalia4@gmail.com"),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.person, size: 40, color: Colors.pink),
            ),
            decoration: BoxDecoration(color: Colors.pinkAccent),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text("Dashboard"),
            onTap: () => Navigator.pop(context),
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text("Profile"),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ProfilePage(profiles: profiles),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text("Settings"),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsPage()));
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text("Logout"),
            onTap: () {
              Navigator.pop(context);
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
}

/// 🔹 Dashboard Home with Search + Stats + CRUD
class DashboardHome extends StatefulWidget {
  final List<Map<String, String>> likedProfiles;
  final Function(String, String) onLikeProfile;
  final List<Map<String, String>> profiles;

  const DashboardHome({
    super.key,
    required this.likedProfiles,
    required this.onLikeProfile,
    required this.profiles,
  });

  @override
  State<DashboardHome> createState() => _DashboardHomeState();
}

class _DashboardHomeState extends State<DashboardHome> {
  final TextEditingController _searchController = TextEditingController();
  String searchQuery = "";

  final List<Map<String, String>> profile = [
    {"name": "Karan Mehta", "details": "Sent you a request"}
  ];

  final List<Map<String, String>> requests = [
    {"name": "Karan Mehta", "details": "Sent you a request"},
    {"name": "Sneha Kapoor", "details": "Wants to connect"},
  ];

  final List<Map<String, String>> chats = [
    {"name": "Amit Joshi", "details": "Hey, how are you?"},
    {"name": "Pooja Rani", "details": "Let's meet tomorrow!"},
  ];

  final List<Map<String, String>> visits = [
    {"name": "Arjun Singh", "details": "Visited your profile"},
    {"name": "Simran Kaur", "details": "Checked your profile"},
  ];

  final List<Map<String, String>> info = [
    {"name": "App Update", "details": "New version available"},
    {"name": "Tips", "details": "Complete your profile for better matches"},
  ];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        searchQuery = _searchController.text.toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void editProfile(Map<String, String> profile) {
    Navigator.push<Map<String, String>>(
      context,
      MaterialPageRoute(builder: (_) => ProfileFormPage(user: profile)),
    ).then((updatedProfile) {
      if (updatedProfile != null) {
        setState(() {
          int index = widget.profiles.indexWhere((p) => p["id"] == profile["id"]);
          widget.profiles[index] = updatedProfile;
        });
      }
    });
  }

  void deleteProfile(Map<String, String> profile) {
    setState(() {
      widget.profiles.remove(profile);
      widget.likedProfiles.removeWhere((p) => p["id"] == profile["id"]);
    });
  }

  bool isLiked(Map<String, String> profile) {
    return widget.likedProfiles.any((p) => p["id"] == profile["id"]);
  }

  void toggleLike(Map<String, String> profile) {
    setState(() {
      if (isLiked(profile)) {
        widget.likedProfiles.removeWhere((p) => p["id"] == profile["id"]);
      } else {
        widget.likedProfiles.add(profile);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final filteredProfiles = widget.profiles.where((p) {
      return p["name"]!.toLowerCase().contains(searchQuery);
    }).toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Welcome, Aashvi 👋",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),

          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: "Search Matches",
              prefixIcon: const Icon(Icons.search, color: Colors.pink),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
            ),
          ),
          const SizedBox(height: 20),

          // 🔹 Stats Cards
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStatCard(context, "Matches", Icons.favorite, Colors.pink,
                  MatchesPage(likedProfiles: widget.likedProfiles)),
              _buildStatCard(context, "Requests", Icons.mail, Colors.orange,
                  RequestsPage(requests: requests)),
              _buildStatCard(context, "Chats", Icons.chat, Colors.green,
                  ChatsPage(chats: chats)),
            ],
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildStatCard(context, "Info", Icons.info, Colors.blue,
                  InfoPage(info: info)),
              _buildStatCard(context, "Visits", Icons.visibility, Colors.purple,
                  VisitsPage(visits: visits)),
            ],
          ),
          const SizedBox(height: 20),

          // 🔹 Users List with CRUD
          if (filteredProfiles.isNotEmpty) ...[
            const Text("Users",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            for (var profile in filteredProfiles)
              Card(
                margin: const EdgeInsets.symmetric(vertical: 8),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 35,
                        backgroundColor: Colors.pink.shade200,
                        backgroundImage: (profile["imagePath"] != null &&
                            profile["imagePath"]!.isNotEmpty)
                            ? FileImage(File(profile["imagePath"]!))
                            : null,
                        child: (profile["imagePath"] == null ||
                            profile["imagePath"]!.isEmpty)
                            ? const Icon(Icons.person,
                            size: 40, color: Colors.white)
                            : null,
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(profile["name"] ?? "",
                                style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold)),
                            Text(profile["email"] ?? ""),
                            Text(profile["phone"] ?? ""),
                            Text("Country: ${profile["country"] ?? ""}"),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(
                              isLiked(profile)
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: Colors.pink,
                            ),
                            onPressed: () => toggleLike(profile),
                          ),
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.green),
                            onPressed: () => editProfile(profile),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => deleteProfile(profile),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
          ] else if (widget.profiles.isEmpty)
            const Center(child: Text("No users added yet")),
        ],
      ),
    );
  }

  Widget _buildStatCard(BuildContext context, String title, IconData icon,
      Color color, Widget page) {
    return Expanded(
      child: GestureDetector(
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => page)),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Column(
              children: [
                Icon(icon, color: color, size: 30),
                const SizedBox(height: 8),
                Text(title,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// 🔹 Profile Form Page for Add/Edit
class ProfileFormPage extends StatefulWidget {
  final Map<String, String>? user;

  const ProfileFormPage({super.key, this.user});

  @override
  State<ProfileFormPage> createState() => _ProfileFormPageState();
}

class _ProfileFormPageState extends State<ProfileFormPage> {
  final _formKey = GlobalKey<FormState>();
  File? _profileImage;
  final ImagePicker _picker = ImagePicker();

  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController phoneController;
  late TextEditingController dobController;
  late TextEditingController hobbiesController;

  String? selectedGender;
  String? selectedCountry;
  String? selectedMaritalStatus;
  String? selectedOccupation;

  final List<String> countries = ["India", "USA", "UK", "Canada", "Australia"];
  final List<String> maritalStatuses = ["Single", "Married", "Divorced"];
  final List<String> occupations = [
    "IT",
    "Doctor",
    "Engineer",
    "Teacher",
    "Business",
    "Student",
    "Other"
  ];

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.user?["name"]);
    emailController = TextEditingController(text: widget.user?["email"]);
    phoneController = TextEditingController(text: widget.user?["phone"]);
    dobController = TextEditingController(text: widget.user?["dob"]);
    hobbiesController = TextEditingController(text: widget.user?["hobbies"]);

    selectedGender = widget.user?["gender"];
    selectedCountry = widget.user?["country"];
    selectedMaritalStatus = widget.user?["maritalStatus"];
    selectedOccupation = widget.user?["occupation"];
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    dobController.dispose();
    hobbiesController.dispose();
    super.dispose();
  }

  /// 🔹 Save profile
  void saveProfile() {
    if (_formKey.currentState!.validate()) {
      if (selectedGender == null ||
          selectedCountry == null ||
          selectedMaritalStatus == null ||
          selectedOccupation == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please fill all required fields")),
        );
        return;
      }

      final profile = {
        "id": widget.user?["id"] ?? DateTime.now().millisecondsSinceEpoch.toString(),
        "name": nameController.text.trim(),
        "email": emailController.text.trim(),
        "phone": phoneController.text.trim(),
        "dob": dobController.text.trim(),
        "gender": selectedGender!,
        "country": selectedCountry!,
        "maritalStatus": selectedMaritalStatus!,
        "occupation": selectedOccupation!,
        "hobbies": hobbiesController.text.trim(),
        "imagePath": _profileImage?.path ?? widget.user?["imagePath"] ?? "",
      };
      Navigator.pop(context, profile);
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    }
  }

  /// 🔹 Date Picker
  Future<void> _pickDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() {
        dobController.text =
        "${picked.day.toString().padLeft(2, '0')}/"
            "${picked.month.toString().padLeft(2, '0')}/"
            "${picked.year}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.user == null ? "Add User" : "Edit User"),
        backgroundColor: Colors.pink.shade400,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// 🔹 Profile Photo
              const Text("Profile Photo",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              Center(
                child: GestureDetector(
                  onTap: _pickImage,
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.pink.shade100,
                    backgroundImage: _profileImage != null
                        ? FileImage(_profileImage!)
                        : (widget.user?["imagePath"]?.isNotEmpty ?? false)
                        ? FileImage(File(widget.user!["imagePath"]!))
                        : null,
                    child: _profileImage == null &&
                        (widget.user?["imagePath"]?.isEmpty ?? true)
                        ? const Icon(Icons.camera_alt,
                        size: 40, color: Colors.white)
                        : null,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              _buildTextField(nameController, "Name", (v) {
                if (v!.isEmpty) return "Name is required";
                if (v.length < 3) return "At least 3 characters";
                return null;
              }),
              _buildTextField(emailController, "Email", (v) {
                if (v!.isEmpty) return "Email is required";
                if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(v)) {
                  return "Enter valid email";
                }
                return null;
              }),
              _buildTextField(phoneController, "Phone", (v) {
                if (v!.isEmpty) return "Phone is required";
                if (!RegExp(r'^[0-9]{10}$').hasMatch(v)) {
                  return "Phone must be 10 digits";
                }
                return null;
              }),

              /// 🔹 DOB with Date Picker
              TextFormField(
                controller: dobController,
                readOnly: true,
                decoration: const InputDecoration(labelText: "Date of Birth"),
                onTap: _pickDate,
                validator: (v) => v!.isEmpty ? "DOB is required" : null,
              ),
              const SizedBox(height: 16),

              /// 🔹 Gender with Radio Buttons
              const Text("Gender", style: TextStyle(fontWeight: FontWeight.bold)),
              Row(
                children: [
                  Radio<String>(
                    value: "Male",
                    groupValue: selectedGender,
                    onChanged: (val) => setState(() => selectedGender = val),
                  ),
                  const Text("Male"),
                  Radio<String>(
                    value: "Female",
                    groupValue: selectedGender,
                    onChanged: (val) => setState(() => selectedGender = val),
                  ),
                  const Text("Female"),
                  Radio<String>(
                    value: "Other",
                    groupValue: selectedGender,
                    onChanged: (val) => setState(() => selectedGender = val),
                  ),
                  const Text("Other"),
                ],
              ),
              const SizedBox(height: 16),

              /// 🔹 Country Dropdown
              DropdownButtonFormField<String>(
                value: selectedCountry,
                decoration: const InputDecoration(labelText: "Country"),
                items: countries.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                onChanged: (val) => setState(() => selectedCountry = val),
                validator: (v) => v == null ? "Country is required" : null,
              ),
              const SizedBox(height: 16),

              /// 🔹 Marital Status Dropdown
              DropdownButtonFormField<String>(
                value: selectedMaritalStatus,
                decoration: const InputDecoration(labelText: "Marital Status"),
                items: maritalStatuses.map((m) => DropdownMenuItem(value: m, child: Text(m))).toList(),
                onChanged: (val) => setState(() => selectedMaritalStatus = val),
                validator: (v) => v == null ? "Marital Status is required" : null,
              ),
              const SizedBox(height: 16),

              /// 🔹 Occupation Dropdown
              DropdownButtonFormField<String>(
                value: selectedOccupation,
                decoration: const InputDecoration(labelText: "Occupation"),
                items: occupations.map((o) => DropdownMenuItem(value: o, child: Text(o))).toList(),
                onChanged: (val) => setState(() => selectedOccupation = val),
                validator: (v) => v == null ? "Occupation is required" : null,
              ),
              const SizedBox(height: 16),

              _buildTextField(hobbiesController, "Hobbies", (v) {
                if (v!.isEmpty) return "Hobbies required";
                return null;
              }),

              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: saveProfile,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.pink.shade400),
                child: Text(widget.user == null ? "Add User" : "Update User"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label,
      String? Function(String?) validator) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(labelText: label),
        validator: validator,
      ),
    );
  }
}

/// 🔹 Reusable Pages for Stats
class MatchesPage extends StatelessWidget {
  final List<Map<String, String>> likedProfiles;
  const MatchesPage({super.key, required this.likedProfiles});

  @override
  Widget build(BuildContext context) => _buildListPage(context, "Your Matches", likedProfiles);
}

class RequestsPage extends StatelessWidget {
  final List<Map<String, String>> requests;
  const RequestsPage({super.key, required this.requests});

  @override
  Widget build(BuildContext context) => _buildListPage(context, "Your Requests", requests);
}

class ChatsPage extends StatelessWidget {
  final List<Map<String, String>> chats;
  const ChatsPage({super.key, required this.chats});

  @override
  Widget build(BuildContext context) => _buildListPage(context, "Chats", chats);
}

class VisitsPage extends StatelessWidget {
  final List<Map<String, String>> visits;
  const VisitsPage({super.key, required this.visits});

  @override
  Widget build(BuildContext context) => _buildListPage(context, "Visits", visits);
}

class InfoPage extends StatelessWidget {
  final List<Map<String, String>> info;
  const InfoPage({super.key, required this.info});

  @override
  Widget build(BuildContext context) => _buildListPage(context, "Info", info);
}

Widget _buildListPage(BuildContext context, String title, List<Map<String, String>> items) {
  return Scaffold(
    appBar: AppBar(title: Text(title), backgroundColor: Colors.pink.shade400),
    body: items.isEmpty
        ? const Center(child: Text("No data available"))
        : ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return Card(
          margin: const EdgeInsets.all(8),
          child: ListTile(
            leading: const CircleAvatar(
              backgroundColor: Colors.pink,
              child: Icon(Icons.person, color: Colors.white),
            ),
            title: Text(item["name"] ?? ""),
            subtitle: Text(item["details"] ?? ""),
          ),
        );
      },
    ),
  );
}