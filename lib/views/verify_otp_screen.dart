import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:lilac/colors/button_color.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class VerifyOtpScreen extends StatefulWidget {
  final String phoneNumber;
  final String? otp;

  const VerifyOtpScreen({Key? key, required this.phoneNumber, this.otp})
      : super(key: key);

  @override
  State<VerifyOtpScreen> createState() => _VerifyOtpScreenState();
}

class _VerifyOtpScreenState extends State<VerifyOtpScreen> {
  late TextEditingController otpController;
  late VoidCallback _otpListener;
  String otpCode = "";

  @override
  void initState() {
    super.initState();
    otpController = TextEditingController(text: widget.otp ?? "");
    otpCode = widget.otp ?? "";

    _otpListener = () {
      if (!mounted) return;
      setState(() {
        otpCode = otpController.text;
      });
    };

    otpController.addListener(_otpListener);
  }

  Future<Map<String, dynamic>?> verifyOtp(String phone, String otp) async {
    const String url =
        'https://test.myfliqapp.com/api/v1/auth/registration-otp-codes/actions/phone/verify-otp';

    int? otpCode;
    try {
      otpCode = int.parse(otp);
    } catch (e) {
      print("Invalid OTP format: must be a number.");
      return {"success": false};
    }

    final body = {
      "data": {
        "type": "registration_otp_codes",
        "attributes": {
          "phone": phone,
          "otp": otpCode,
          "device_meta": {
            "type": "web",
            "name": "Flutter App",
            "os": "Android",
            "browser": "Flutter WebView",
            "browser_version": "1.0.0",
            "user_agent": "flutter_user_agent",
            "screen_resolution": "1080x1920",
            "language": "en"
          }
        }
      }
    };

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
        body: json.encode(body),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        print("OTP Verified: $jsonResponse");

        return {
          "success": jsonResponse['status'] == true,
          "token": jsonResponse['data']?['attributes']?['token'], // may be null
        };
      } else {
        print("OTP verification failed: ${response.body}");
        return {"success": false};
      }
    } catch (e) {
      print("Exception during OTP verification: $e");
      return null;
    }
  }

  @override
  void dispose() {
    otpController.removeListener(_otpListener);
    otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: const BackButton(color: Colors.black),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const Text(
              "Enter your verification code",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  widget.phoneNumber,
                  style: const TextStyle(fontSize: 16, color: Colors.black54),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Text(
                    "Edit",
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 16,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),
            PinCodeTextField(
              appContext: context,
              controller: otpController,
              length: 6,
              onChanged: (_) {},
              keyboardType: TextInputType.number,
              pinTheme: PinTheme(
                shape: PinCodeFieldShape.box,
                borderRadius: BorderRadius.circular(12),
                fieldHeight: 50,
                fieldWidth: 50,
                activeFillColor: Colors.white,
                inactiveFillColor: Colors.white,
                selectedFillColor: Colors.white,
                inactiveColor: Colors.grey.shade300,
                selectedColor: AppColors.pink,
                activeColor: AppColors.pink,
              ),
              enableActiveFill: true,
            ),
            const SizedBox(height: 10),
            const Text(
              "Didn't get anything? No worries, let's try again.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.black54),
            ),
            TextButton(
              onPressed: () {
                // Optional: Implement resend OTP
              },
              child: const Text(
                "Resend",
                style: TextStyle(fontSize: 16, color: Colors.blue),
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: otpCode.length == 6
                    ? () async {
                        final response =
                            await verifyOtp(widget.phoneNumber, otpCode);
                        if (response != null && response['success'] == true) {
                          final prefs =
                              await SharedPreferences.getInstance();
                          await prefs.setString(
                              'auth_token', response['token'] ?? '');

                          if (!mounted) return;
                          Navigator.pushReplacementNamed(context, '/chatList');
                        } else {
                          if (!mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text(
                                    'Invalid OTP or verification failed')),
                          );
                        }
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.pink,
                  disabledBackgroundColor: AppColors.pink.withAlpha(102),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40),
                  ),
                ),
                child: const Text(
                  "Verify",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
