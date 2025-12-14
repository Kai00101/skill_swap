import 'package:flutter/material.dart';
import 'package:skill_swap/pages/loading.dart';
import 'package:skill_swap/pages/welcome_page.dart';
import 'package:skill_swap/widgets/widget_tree.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const SkillSwap());
}


class SkillSwap extends StatefulWidget {
  const SkillSwap({super.key});


  static _SkillSwapState of(BuildContext context) {
    return context.findAncestorStateOfType<_SkillSwapState>()!;
  }

  @override
  State<SkillSwap> createState() => _SkillSwapState();
}

class _SkillSwapState extends State<SkillSwap> {
  ThemeMode _themeMode = ThemeMode.light;


  void toggleTheme() {
    setState(() {
      _themeMode =
      _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    });
  }


  void setThemeMode(ThemeMode mode) {
    setState(() {
      _themeMode = mode;
    });
  }


  ThemeData get _lightTheme => ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: const Color(0xFFF8F2FF),
    primaryColor: Colors.deepPurpleAccent,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      foregroundColor: Colors.black,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.deepPurpleAccent,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    ),
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.deepPurpleAccent,
      brightness: Brightness.light,
    ),
  );




  ThemeData get _darkTheme => ThemeData(
    brightness: Brightness.dark,

    scaffoldBackgroundColor: const Color(0xFF1C1B29),

    cardColor: const Color(0xFF2B2938),

    primaryColor: const Color(0xFF9B6DFF),

    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF1C1B29),
      elevation: 0,
      foregroundColor: Colors.white,
    ),

    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.white,),
      bodyMedium: TextStyle(color: Colors.white),
      bodySmall: TextStyle(color: Colors.white70),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFF9B6DFF),
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFF2B2938),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide.none,
      ),
      hintStyle: const TextStyle(color: Colors.white38),
    ),

    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFF9B6DFF),
      brightness: Brightness.dark,
    ),
  );


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,


      theme: _lightTheme,
      darkTheme: _darkTheme,
      themeMode: _themeMode,

      initialRoute: '/',
      routes: {
        '/':  (context) => const LoadingPage(),
        '/2': (context) => const WelcomePage(),
        '/3': (context) => const WidgetTree(),
      },
    );
  }
}
