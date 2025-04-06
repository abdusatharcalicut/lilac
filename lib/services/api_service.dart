import 'dart:convert';
import 'package:http/http.dart' as http;
import '../utils/constants.dart';

class ApiService {
  static Future<http.Response> sendOtp(String phoneNumber) async {
  final url = Uri.parse('$baseUrl/auth/registration-otp-codes/actions/phone/send-otp');

  final body = jsonEncode({
    "data": {
      "type": "registration_otp_codes",
      "attributes": {
        "phone": phoneNumber
      }
    }
  });

  final response = await http.post(
    url,
    headers: {
      'Content-Type': 'application/json',
    },
    body: body,
  );

  if (response.statusCode != 200 && response.statusCode != 201) {
    throw Exception("Failed to send OTP: ${response.body}");
  }

  return response;
}


  static Future<http.Response> verifyOtp(String phoneNumber, String otp) async {
  final url = Uri.parse('$baseUrl/auth/registration-otp-codes/actions/phone/verify-otp');

  int? otpCode;
  try {
    otpCode = int.parse(otp);
  } catch (e) {
    throw Exception("Invalid OTP format: must be a number.");
  }

  final body = jsonEncode({
    "data": {
      "type": "registration_otp_codes",
      "attributes": {
        "phone": phoneNumber,
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
  });

  return await http.post(
    url,
    headers: {
      'Content-Type': 'application/json',
    },
    body: body,
  );
}

}
