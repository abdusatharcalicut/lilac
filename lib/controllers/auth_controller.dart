import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_service.dart';

class AuthController {
  Future<void> sendOtp({
    required String phoneNumber,
    required BuildContext context,
  }) async {
    try {
      final response = await ApiService.sendOtp(phoneNumber);

      if (response.statusCode == 200) {
        Navigator.pushNamed(
  context,
  '/verifyOtp',
  arguments: {
    'phoneNumber': phoneNumber,
  },
);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Failed to send OTP")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Something went wrong")),
      );
    }
  }

  Future<void> verifyOtp({
    required String phoneNumber,
    required String otp,
    required BuildContext context,
  }) async {
    try {
      final response = await ApiService.verifyOtp(phoneNumber, otp);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final token = data['data']['access_token'];
        
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('auth_token', token);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Verification Successful")),
        );
        Navigator.pushReplacementNamed(context, '/chatList');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Invalid OTP")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Something went wrong")),
      );
    }
  }
}
