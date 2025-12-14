import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skill_swap/pages/welcome_page.dart';
import 'package:skill_swap/widgets/widget_tree.dart';

class LoadingPage extends StatefulWidget {
  const LoadingPage({super.key});

  @override
  State<LoadingPage> createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 700),
          pageBuilder: (_, animation, __) => const WelcomePage(),
         //pageBuilder: (_, animation, __) => const WidgetTree(),
          transitionsBuilder: (_, animation, __, child) {
            final fade = Tween(begin: 0.0, end: 1.0).animate(animation);
            final slide = Tween(
              begin: const Offset(0, 0.1),
              end: Offset.zero,
            ).animate(animation);

            return FadeTransition(
              opacity: fade,
              child: SlideTransition(
                position: slide,
                child: child,
              ),
            );
          },
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF23135E),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/im.png',
            fit: BoxFit.cover,
          ),
          const SizedBox(height: 0),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Skill',
                style: GoogleFonts.salsa(
                  fontSize: 45,
                  fontWeight: FontWeight.w400,
                  color: Colors.amber,
                ),
              ),
              Text(
                'Swap',
                style: GoogleFonts.salsa(
                  fontSize: 45,
                  fontWeight: FontWeight.w400,
                  color: Colors.white,
                ),
              )
            ],
          ),
          const SizedBox(height: 60),
        ],
      ),
    );
  }
}
