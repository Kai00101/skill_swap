import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:skill_swap/pages/auth/sign_in_page.dart'; // <-- не забудь путь

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController oldPassController = TextEditingController();
  final TextEditingController newPassController = TextEditingController();
  final TextEditingController confirmController = TextEditingController();

  bool showOld = false;
  bool showNew = false;
  bool showConfirm = false;

  String? emailError;
  String? oldError;
  String? newError;
  String? confirmError;

  Future<void> changePassword() async {
    setState(() {
      emailError = null;
      oldError = null;
      newError = null;
      confirmError = null;
    });

    final email = emailController.text.trim();
    final oldPass = oldPassController.text.trim();
    final newPass = newPassController.text.trim();
    final confirmPass = confirmController.text.trim();

    bool hasError = false;


    if (email.isEmpty) {
      emailError = "Введите email";
      hasError = true;
    } else if (!email.contains("@") || !email.contains(".")) {
      emailError = "Некорректный email";
      hasError = true;
    }


    if (oldPass.isEmpty) {
      oldError = "Введите текущий пароль";
      hasError = true;
    }


    if (newPass.isEmpty) {
      newError = "Введите новый пароль";
      hasError = true;
    } else if (newPass.length < 6) {
      newError = "Пароль минимум 6 символов";
      hasError = true;
    }


    if (confirmPass.isEmpty) {
      confirmError = "Повторите новый пароль";
      hasError = true;
    } else if (newPass != confirmPass) {
      confirmError = "Пароли не совпадают";
      hasError = true;
    }

    if (hasError) {
      setState(() {});
      return;
    }

    try {

      AuthCredential credential = EmailAuthProvider.credential(
        email: email,
        password: oldPass,
      );

      await FirebaseAuth.instance.currentUser!
          .reauthenticateWithCredential(credential);


      await FirebaseAuth.instance.currentUser!.updatePassword(newPass);


      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            "Пароль успешно изменён!",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 2),
        ),
      );


      await Future.delayed(const Duration(seconds: 2));

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const SignInPage()),
      );

    } on FirebaseAuthException catch (e) {
      if (e.code == "wrong-password") {
        oldError = "Неверный текущий пароль";
      } else if (e.code == "user-mismatch") {
        emailError = "Этот email не принадлежит текущему пользователю";
      } else if (e.code == "invalid-credential") {
        oldError = "Неверный пароль";
      } else {
        emailError = e.message;
      }
      setState(() {});
    }
  }

  InputDecoration deco({
    required String hint,
    String? error,
    Widget? suffix,
    IconData? icon,
  }) {
    return InputDecoration(
      hintText: hint,
      errorText: error,
      prefixIcon: Icon(icon),
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
      appBar: AppBar(
        title: const Text("Change Password"),
        leading: const BackButton(),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(17),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Введите данные, чтобы изменить пароль.",
              style: TextStyle(fontSize: 15, color: Colors.grey),
            ),

            const SizedBox(height: 30),

            const Text("Email"),
            const SizedBox(height: 10),
            TextField(
              controller: emailController,
              decoration: deco(
                hint: "Email",
                icon: Icons.email_outlined,
                error: emailError,
              ),
            ),

            const SizedBox(height: 25),

            const Text("Current Password"),
            const SizedBox(height: 10),
            TextField(
              controller: oldPassController,
              obscureText: !showOld,
              decoration: deco(
                hint: "Current Password",
                icon: Icons.lock_outline,
                error: oldError,
                suffix: GestureDetector(
                  onTap: () => setState(() => showOld = !showOld),
                  child: Icon(showOld ? Icons.visibility : Icons.visibility_off),
                ),
              ),
            ),

            const SizedBox(height: 25),

            const Text("New Password"),
            const SizedBox(height: 10),
            TextField(
              controller: newPassController,
              obscureText: !showNew,
              decoration: deco(
                hint: "New Password",
                icon: Icons.lock_outline,
                error: newError,
                suffix: GestureDetector(
                  onTap: () => setState(() => showNew = !showNew),
                  child: Icon(showNew ? Icons.visibility : Icons.visibility_off),
                ),
              ),
            ),

            const SizedBox(height: 25),

            const Text("Confirm Password"),
            const SizedBox(height: 10),
            TextField(
              controller: confirmController,
              obscureText: !showConfirm,
              decoration: deco(
                hint: "Confirm Password",
                icon: Icons.lock_outline,
                error: confirmError,
                suffix: GestureDetector(
                  onTap: () => setState(() => showConfirm = !showConfirm),
                  child: Icon(showConfirm ? Icons.visibility : Icons.visibility_off),
                ),
              ),
            ),

            const SizedBox(height: 30),

            Center(
              child: ElevatedButton(
                onPressed: changePassword,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(380, 50),
                  backgroundColor: Colors.deepPurpleAccent,
                ),
                child: const Text(
                  "Change Password",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
