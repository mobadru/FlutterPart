import 'package:flutter/material.dart';
import '../services/api_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool loading = false;

  // =========================
  // EMAIL VALIDATION
  // =========================
  String? validateEmail(String email) {
    if (email.isEmpty) {
      return "Email is required.";
    }

    final emailRegex = RegExp(
      r'^[a-zA-Z0-9.!#$%&’*+/=?^_`{|}~-]+@'
      r'[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)+$',
    );

    if (!emailRegex.hasMatch(email)) {
      return "Please enter a valid email address.";
    }

    return null;
  }

  // =========================
  // PASSWORD VALIDATION
  // =========================
  String? validatePassword(String password, String username) {
    // Django MinimumLengthValidator
    if (password.length < 8) {
      return "Password must be at least 8 characters.";
    }

    // Django NumericPasswordValidator
    if (RegExp(r'^\d+$').hasMatch(password)) {
      return "Password cannot be entirely numeric.";
    }

    // Django UserAttributeSimilarityValidator
    if (username.isNotEmpty &&
        password.toLowerCase().contains(username.toLowerCase())) {
      return "Password is too similar to your username.";
    }

    // Common passwords
    const commonPasswords = [
      "password",
      "12345678",
      "123456789",
      "password123",
      "qwerty",
      "qwerty123",
      "admin123",
      "1234567890",
      "letmein",
      "welcome",
    ];

    if (commonPasswords.contains(password.toLowerCase())) {
      return "This password is too common.";
    }

    return null;
  }

  // =========================
  // REGISTER
  // =========================
  Future<void> register() async {
    final username = usernameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    // =========================
    // USERNAME VALIDATION
    // =========================
    if (username.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Username is required.",
          ),
        ),
      );

      return;
    }

    // =========================
    // EMAIL VALIDATION
    // =========================
    final emailError = validateEmail(email);

    if (emailError != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(emailError),
        ),
      );

      return;
    }

    // =========================
    // PASSWORD VALIDATION
    // =========================
    final passwordError = validatePassword(
      password,
      username,
    );

    if (passwordError != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(passwordError),
        ),
      );

      return;
    }

    setState(() {
      loading = true;
    });

    try {
      await ApiService.registerPatient(
        username,
        email,
        password,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Account created successfully",
          ),
        ),
      );

      Navigator.pop(context);
    } catch (error) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            error.toString(),
          ),
        ),
      );
    }

    if (!mounted) return;

    setState(() {
      loading = false;
    });
  }

  @override
  void dispose() {
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Patient Registration",
        ),
        backgroundColor: const Color(0xff0A66FF),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          children: [
            // =========================
            // USERNAME
            // =========================
            TextField(
              controller: usernameController,

              decoration: const InputDecoration(
                labelText: "Username",
                prefixIcon: Icon(Icons.person),
              ),
            ),

            // =========================
            // EMAIL
            // =========================
            TextField(
              controller: emailController,

              keyboardType: TextInputType.emailAddress,

              decoration: const InputDecoration(
                labelText: "Email",
                prefixIcon: Icon(Icons.email),
              ),
            ),

            // Email information
            const Align(
              alignment: Alignment.centerLeft,

              child: Padding(
                padding: EdgeInsets.only(
                  top: 8,
                ),

                child: Text(
                  "Enter a valid email address, for example: example@gmail.com",
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
              ),
            ),

            // =========================
            // PASSWORD
            // =========================
            TextField(
              controller: passwordController,

              obscureText: true,

              decoration: const InputDecoration(
                labelText: "Password",
                prefixIcon: Icon(Icons.lock),
              ),
            ),

            // Password information
            const Align(
              alignment: Alignment.centerLeft,

              child: Padding(
                padding: EdgeInsets.only(
                  top: 8,
                ),

                child: Text(
                  "Password must be at least 8 characters and not be common or entirely numeric.",
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),

            // =========================
            // REGISTER BUTTON
            // =========================
            SizedBox(
              width: double.infinity,
              height: 50,

              child: ElevatedButton(
                onPressed: loading ? null : register,

                child: loading
                    ? const CircularProgressIndicator()
                    : const Text(
                        "REGISTER",
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}