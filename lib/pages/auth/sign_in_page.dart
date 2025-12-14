import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:skill_swap/pages/reset_page.dart';
import 'package:skill_swap/pages/auth/sign_up_page.dart';
import '../../widgets/widget_tree.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  bool isPasswordVisible = false;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  String? emailError;
  String? passwordError;

  Future<void> login() async {
    setState(() {
      emailError = null;
      passwordError = null;
    });

    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    bool hasError = false;


    if (email.isEmpty) {
      emailError = "Введите email";
      hasError = true;
    } else if (!email.contains("@") || !email.contains(".")) {
      emailError = "Некорректный email";
      hasError = true;
    }


    if (password.isEmpty) {
      passwordError = "Введите пароль";
      hasError = true;
    }

    if (hasError) {
      setState(() {});
      return;
    }

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const WidgetTree()),
      );

    } on FirebaseAuthException catch (e) {

      if (e.code == "wrong-password") {
        setState(() {
          passwordError = "Неверный пароль";
        });
      }

      else if (e.code == "user-not-found") {
        setState(() {
          emailError = "Пользователь не найден";
        });
      }

      else {
        setState(() {
          emailError = e.message;
        });
      }
    }
  }

  InputDecoration decoration(String hint, {String? error, Widget? suffix}) {
    return InputDecoration(
      hintText: hint,
      errorText: error,
      prefixIcon: Icon(
        hint == "Email" ? Icons.email_outlined : Icons.lock_outline,
      ),
      suffixIcon: suffix,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide(
          color: error != null ? Colors.red : Colors.deepPurple,
          width: 2,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide(
          color: error != null ? Colors.red : Colors.grey,
          width: 1.5,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Sign In")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Hello, welcome back!"),
            const SizedBox(height: 20),


            const Text("Email"),
            const SizedBox(height: 8),
            TextField(
              controller: emailController,
              decoration: decoration("Email", error: emailError),
            ),

            const SizedBox(height: 35),


            const Text("Password"),
            const SizedBox(height: 12),
            TextField(
              controller: passwordController,
              obscureText: !isPasswordVisible,
              decoration: decoration(
                "Password",
                error: passwordError,
                suffix: GestureDetector(
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

            Align(
              alignment: Alignment.bottomRight,
              child: TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const ChangePasswordPage()),
                  );
                },
                child: const Text(
                  "Forgot password?",
                  style: TextStyle(color: Colors.grey, fontSize: 15),
                ),
              ),
            ),

            const SizedBox(height: 20),


            Center(
              child: ElevatedButton(
                onPressed: login,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(340, 50),
                  backgroundColor: Colors.deepPurpleAccent,
                ),
                child: const Text(
                  "Login",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
            ),

            const SizedBox(height: 10),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Didn’t have an account?"),
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const SignUpPage()),
                    );
                  },
                  child: const Text(
                    "Sign Up",
                    style: TextStyle(color: Colors.deepPurple),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
