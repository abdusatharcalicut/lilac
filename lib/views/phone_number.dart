import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:lilac/colors/button_color.dart';
import 'package:lilac/controllers/auth_controller.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class EnterPhoneScreen extends StatefulWidget {
  const EnterPhoneScreen({super.key});

  @override
  State<EnterPhoneScreen> createState() => _EnterPhoneScreenState();
}

class _EnterPhoneScreenState extends State<EnterPhoneScreen> {
  final TextEditingController _phoneController = TextEditingController();
  bool isButtonEnabled = false;
  String fullPhoneNumber = '';

  void _checkPhone(String value) {
    setState(() {
      isButtonEnabled = value.length >= 10;
    });
  }

   @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  Future<bool> requestOtp(String phoneNumber) async {
    const String url =
        'https://test.myfliqapp.com/api/v1/auth/registration-otp-codes/actions/phone/send-otp';

    final body = {
      "data": {
        "type": "registration_otp_codes",
        "attributes": {"phone": phoneNumber}
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
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            const Center(
              child: Text(
                'Enter your phone\nnumber',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            const SizedBox(height: 30),
            IntlPhoneField(
              controller: _phoneController,
              initialCountryCode: 'IN',
              decoration: InputDecoration(
                labelText: 'Phone Number',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(),
                ),
              ),
              onChanged: (phone) {
                fullPhoneNumber = phone.completeNumber;
                _checkPhone(fullPhoneNumber);
              },
            ),
            const SizedBox(height: 10),
            const Text(
              'Fliq will send you a text with a verification code.',
              style: TextStyle(
                fontSize: 14,
                color: Colors.black54,
              ),
              textAlign: TextAlign.start,
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isButtonEnabled
    ? () async {
        AuthController().sendOtp(
          phoneNumber: fullPhoneNumber,
          context: context,
        );
      }
    : null,


                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.pink,
                  disabledBackgroundColor:
                      AppColors.pink.withAlpha((255 * 0.4).toInt()),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40),
                  ),
                ),
                child: const Text(
                  'Next',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
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
