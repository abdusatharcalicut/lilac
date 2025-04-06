import 'package:flutter/material.dart';
import 'package:lilac/views/phone_number.dart';
import 'package:lilac/views/splash.dart';
import 'package:lilac/views/verify_otp_screen.dart';
import 'package:lilac/views/chat_list.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Lilac',
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/login': (context) => const EnterPhoneScreen(),
        '/chatList': (context) => const ChatListScreen(),
      },
      onGenerateRoute: (settings) {
  if (settings.name == '/verifyOtp') {
    final args = settings.arguments;
    if (args is Map<String, dynamic> && args.containsKey('phoneNumber')) {
      return MaterialPageRoute(
        builder: (_) => VerifyOtpScreen(
          phoneNumber: args['phoneNumber'],
          otp: args['otp'],
        ),
      );
    } else {
      return MaterialPageRoute(
        builder: (_) => const EnterPhoneScreen(),
      );
    }
  }
  return null;
},

    );
  }
}
