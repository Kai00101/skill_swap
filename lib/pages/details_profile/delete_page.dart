import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:skill_swap/pages/welcome_page.dart';

class DeletePage extends StatefulWidget {
  const DeletePage({super.key});

  @override
  State<DeletePage> createState() => _DeletePageState();
}

class _DeletePageState extends State<DeletePage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passController = TextEditingController();

  bool showPass = false;

  String? emailError;
  String? passError;

  Future<void> deleteAccount() async {
    setState(() {
      emailError = null;
      passError = null;
    });

    final email = emailController.text.trim();
    final pass = passController.text.trim();

    bool hasError = false;


    if (email.isEmpty) {
      emailError = "Введите email";
      hasError = true;
    } else if (!email.contains("@") || !email.contains(".")) {
      emailError = "Некорректный email";
      hasError = true;
    }


    if (pass.isEmpty) {
      passError = "Введите пароль";
      hasError = true;
    }

    if (hasError) {
      setState(() {});
      return;
    }

    try {

      AuthCredential credential = EmailAuthProvider.credential(
        email: email,
        password: pass,
      );

      await FirebaseAuth.instance.currentUser!
          .reauthenticateWithCredential(credential);


      await FirebaseAuth.instance.currentUser!.delete();


      await FirebaseAuth.instance.signOut();


      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            "Аккаунт успешно удалён!",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 2),
        ),
      );

      await Future.delayed(const Duration(seconds: 2));

      if (!mounted) return;

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const WelcomePage()),
            (_) => false,
      );

    } on FirebaseAuthException catch (e) {
      if (e.code == "wrong-password") {
        passError = "Неверный пароль";
      } else if (e.code == "user-mismatch") {
        emailError = "Этот email не принадлежит текущему пользователю";
      } else if (e.code == "invalid-credential") {
        passError = "Неверный пароль";
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
        title: const Text("Delete Account"),
        leading: const BackButton(),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(17),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Введите email и текущий пароль чтобы удалить аккаунт.",
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

            // PASSWORD
            const Text("Password"),
            const SizedBox(height: 10),
            TextField(
              controller: passController,
              obscureText: !showPass,
              decoration: deco(
                hint: "Password",
                icon: Icons.lock_outline,
                error: passError,
                suffix: GestureDetector(
                  onTap: () => setState(() => showPass = !showPass),
                  child: Icon(
                      showPass ? Icons.visibility : Icons.visibility_off),
                ),
              ),
            ),

            const SizedBox(height: 35),

            Center(
              child: ElevatedButton(
                onPressed: deleteAccount,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(380, 50),
                  backgroundColor: Colors.redAccent,
                ),
                child: const Text(
                  "Delete Account",
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
