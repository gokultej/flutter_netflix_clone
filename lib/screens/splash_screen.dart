import 'dart:async';
import 'package:flutter/material.dart';
import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _loadingController;
  late Timer _timer;
  String displayedText = "";

  final String fullText = "Netflix";

  @override
  void initState() {
    super.initState();

    // Initialize the loading animation controller
    _loadingController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();

    // Start the timer for the loading animation
    _timer = Timer(const Duration(seconds: 3), () {
      _loadingController.stop(); // Stop the loading animation after 3 seconds
      _startTextAnimation(); // Start text animation
    });
  }

  void _startTextAnimation() {
    int charIndex = 0;

    // Periodic timer to reveal text character by character
    Timer.periodic(const Duration(milliseconds: 200), (timer) {
      if (charIndex < fullText.length) {
        setState(() {
          displayedText += fullText[charIndex];
          charIndex++;
        });
      } else {
        timer.cancel();
        _navigateToHome(); // Navigate to HomeScreen after text animation
      }
    });
  }

  void _navigateToHome() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
          builder: (context) => const HomeScreen()), // Navigate to HomeScreen
    );
  }

  @override
  void dispose() {
    _loadingController.dispose(); // Clean up animation controller
    _timer.cancel(); // Cancel the timer
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (displayedText.isEmpty) // Show the loading spinner initially
              const SizedBox(
                width: 60,
                height: 60,
                child: CircularProgressIndicator(
                  strokeWidth: 4.0,
                  color: Colors.red,
                ),
              ),
            const SizedBox(height: 20),
            // Show the animated text after loading spinner
            Text(
              displayedText,
              style: const TextStyle(
                color: Colors.red,
                fontSize: 40,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
                fontFamily: 'SharpSans', // Custom font
              ),
            ),
          ],
        ),
      ),
    );
  }
}
