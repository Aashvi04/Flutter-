import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'LoginPage.dart';
import 'HomePage.dart';
import 'auth_service.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _hobbiesController = TextEditingController();

  String? _gender;

  // Date Picker
  Future<void> _selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1970),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null) {
      setState(() {
        _dobController.text =
        "${pickedDate.day.toString().padLeft(2, '0')}/"
            "${pickedDate.month.toString().padLeft(2, '0')}/"
            "${pickedDate.year}";
      });
    }
  }

  Future<void> _saveUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("name", _nameController.text.trim());
    await prefs.setString("email", _emailController.text.trim());
    await prefs.setString("phone", _phoneController.text.trim());
    await prefs.setString("password", _passwordController.text.trim());
    await prefs.setString("dob", _dobController.text.trim());
    await prefs.setString("hobbies", _hobbiesController.text.trim());
    await prefs.setString("gender", _gender ?? "");
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      if (_gender == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please select your gender")),
        );
        return;
      }

      await _saveUser();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Signup Successful 🎉 Welcome ${_nameController.text}")),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => LoginPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink.shade50,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(25.0),
          child: ConstrainedBox(
            constraints: const BoxConstraints(minWidth: 300, maxWidth: 450),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.white, Colors.pink.shade100, Colors.white],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.pink.withOpacity(0.2),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Image.asset(
                      'assets/images/image.png',
                      width: 150,
                      height: 80,
                      fit: BoxFit.fill,
                    ),
                    const SizedBox(height: 25),

                    // Name
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: "Full Name",
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.person),
                      ),
                      validator: (v) => v!.isEmpty ? "Please enter your name" : null,
                    ),
                    const SizedBox(height: 12),

                    // Email
                    TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                        labelText: "Email",
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.email),
                      ),
                      validator: (v) {
                        if (v!.isEmpty) return "Please enter your email";
                        final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                        if (!emailRegex.hasMatch(v)) return "Enter valid email";
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),

                    // Phone
                    TextFormField(
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(
                        labelText: "Phone Number",
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.phone),
                      ),
                      validator: (v) => v!.isEmpty ? "Please enter phone number" : null,
                    ),
                    const SizedBox(height: 12),

                    // Password
                    TextFormField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: "Password",
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.lock),
                      ),
                      validator: (v) {
                        if (v == null || v.length < 6) return "Password min 6 characters";
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),

                    // Confirm Password
                    TextFormField(
                      controller: _confirmPasswordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: "Confirm Password",
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.lock_outline),
                      ),
                      validator: (v) {
                        if (v != _passwordController.text) return "Passwords do not match";
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),

                    // Gender
                    const Text("Gender:", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400)),
                    Row(
                      children: [
                        Expanded(
                          child: RadioListTile<String>(
                            title: const Text("Male"),
                            value: "Male",
                            groupValue: _gender,
                            onChanged: (v) => setState(() => _gender = v),
                          ),
                        ),
                        Expanded(
                          child: RadioListTile<String>(
                            title: const Text("Female"),
                            value: "Female",
                            groupValue: _gender,
                            onChanged: (v) => setState(() => _gender = v),
                          ),
                        ),
                        Expanded(
                          child: RadioListTile<String>(
                            title: const Text("Other"),
                            value: "Other",
                            groupValue: _gender,
                            onChanged: (v) => setState(() => _gender = v),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // DOB
                    TextFormField(
                      controller: _dobController,
                      readOnly: true,
                      decoration: InputDecoration(
                        labelText: "Date of Birth",
                        border: const OutlineInputBorder(),
                        prefixIcon: const Icon(Icons.calendar_today),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.date_range),
                          onPressed: () => _selectDate(context),
                        ),
                      ),
                      validator: (v) => v!.isEmpty ? "Please select DOB" : null,
                    ),
                    const SizedBox(height: 12),

                    // Hobbies
                    TextFormField(
                      controller: _hobbiesController,
                      maxLines: 1,
                      decoration: const InputDecoration(
                        labelText: "Hobbies",
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.interests),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Signup Button
                    ElevatedButton(
                      onPressed: () async {
                        // ✅ Static signup → directly logged in
                        await AuthService.saveLogin();
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (_) => DashboardPage()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.pink.shade400,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Text(
                        "Signup",
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Login redirect
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Already have an account?"),
                        TextButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (_) => LoginPage()),
                            );
                          },
                          child: const Text("Login", style: TextStyle(color: Colors.pink)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}