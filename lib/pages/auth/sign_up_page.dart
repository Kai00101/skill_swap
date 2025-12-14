import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:skill_swap/pages/auth/sign_in_page.dart';
import 'package:skill_swap/pages/person_page_info.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  bool isPasswordVisible = false;
  bool isPasswordVisible2 = false;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmController = TextEditingController();

  String? emailError;
  String? passwordError;
  String? confirmError;

  Future<void> register() async {
    setState(() {
      emailError = null;
      passwordError = null;
      confirmError = null;
    });

    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final confirm = confirmController.text.trim();

    bool hasError = false;

    // EMAIL
    if (email.isEmpty) {
      emailError = "Введите email";
      hasError = true;
    } else if (!email.contains("@") || !email.contains(".")) {
      emailError = "Некорректный email";
      hasError = true;
    }

    // PASSWORD
    if (password.isEmpty) {
      passwordError = "Введите пароль";
      hasError = true;
    } else if (password.length < 6) {
      passwordError = "Минимум 6 символов";
      hasError = true;
    }

    // CONFIRM
    if (confirm.isEmpty) {
      confirmError = "Повторите пароль";
      hasError = true;
    } else if (password != confirm) {
      confirmError = "Пароли не совпадают";
      hasError = true;
    }

    if (hasError) {
      setState(() {});
      return;
    }

    try {

      final cred = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );


      await FirebaseFirestore.instance
          .collection("users")
          .doc(cred.user!.uid)
          .set({
        "name": "",
        "city": "",
        "canTeach": [],
        "wantsToLearn": [],
        "skipped": [],
        "blocked":[],
        "email": email,
        "createdAt": FieldValue.serverTimestamp(),
      });


      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const ProfileFormPage()),
      );

    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? "Ошибка регистрации")),
      );
    }
  }

  InputDecoration inputDecoration({
    required String hint,
    String? error,
    Widget? prefixIcon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      errorText: error,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide(
          color: error != null ? Colors.red : Colors.deepPurple,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide(
          color: error != null ? Colors.red : Colors.grey,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: const Text("Create Account"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Enjoy the various best courses we have, choose the category according to your wishes.",
              style: TextStyle(fontSize: 15, color: Colors.grey),
            ),

            const SizedBox(height: 35),


            const Text("Email"),
            const SizedBox(height: 12),
            TextField(
              controller: emailController,
              decoration: inputDecoration(
                hint: "Email",
                error: emailError,
                prefixIcon: const Icon(Icons.email_outlined),
              ),
            ),

            const SizedBox(height: 30),


            const Text("New Password"),
            const SizedBox(height: 12),
            TextField(
              controller: passwordController,
              obscureText: !isPasswordVisible,
              decoration: inputDecoration(
                hint: "New Password",
                error: passwordError,
                prefixIcon: const Icon(Icons.lock_outline),
                suffixIcon: GestureDetector(
                  onTap: () =>
                      setState(() => isPasswordVisible = !isPasswordVisible),
                  child: Icon(
                    isPasswordVisible
                        ? Icons.visibility
                        : Icons.visibility_off,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),


            const Text("Confirm Password"),
            const SizedBox(height: 12),
            TextField(
              controller: confirmController,
              obscureText: !isPasswordVisible2,
              decoration: inputDecoration(
                hint: "Confirm Password",
                error: confirmError,
                prefixIcon: const Icon(Icons.lock_outline),
                suffixIcon: GestureDetector(
                  onTap: () => setState(
                          () => isPasswordVisible2 = !isPasswordVisible2),
                  child: Icon(
                    isPasswordVisible2
                        ? Icons.visibility
                        : Icons.visibility_off,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 50),

            Center(
              child: ElevatedButton(
                onPressed: register,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(340, 50),
                  backgroundColor: Colors.deepPurpleAccent,
                ),
                child: const Text(
                  "Create Account",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Already have an account?"),
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const SignInPage()),
                    );
                  },
                  child: const Text(
                    "Sign In",
                    style: TextStyle(color: Colors.deepPurple),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
