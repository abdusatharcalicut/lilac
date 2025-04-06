import 'package:flutter/material.dart';
import 'package:lilac/colors/button_color.dart';
import 'package:lilac/views/phone_number.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/images/splash.png',
            fit: BoxFit.cover,
          ),
          // ignore: deprecated_member_use
          Container(color: Colors.black.withOpacity(0.3)),
          Align(
            alignment: Alignment.topCenter,
            child: SafeArea(
              child: Column(
                children: [
                  const SizedBox(height: 30),
                  Image.asset(
                    'assets/images/love-logo.png',
                    width: 50,
                    height: 50,
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Connect. Meet. Love.',
                    style: TextStyle(
                      fontSize: 25,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'With Fliq Dating',
                    style: TextStyle(
                      fontSize: 25,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 1,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 60.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: ElevatedButton(
                      onPressed: () {
                        // Handle Google Sign-In
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.googleButton,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/images/google_logo.png',
                            height: 24,
                            width: 24,
                          ),
                          const SizedBox(width: 12),
                          const Text(
                            'Sign in with Google',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildButton(
                    context,
                    icon: Icons.facebook,
                    text: "Sign in with Facebook",
                    color: AppColors.facebookButton,
                    textColor: Colors.white,
                    onPressed: () {
                    },
                  ),
                  const SizedBox(height: 12),
                  _buildButton(
                    context,
                    icon: Icons.phone,
                    text: "Sign in with phone number",
                    color: AppColors.pink,
                    textColor: Colors.white,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const EnterPhoneScreen()),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButton(
    BuildContext context, {
    required IconData icon,
    required String text,
    required Color color,
    required Color textColor,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.8,
      child: ElevatedButton.icon(
        icon: Icon(icon, color: textColor),
        label: Text(
          text,
          style: TextStyle(color: textColor, fontSize: 16),
        ),
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
      ),
    );
  }
}
