import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/chat_model.dart';

class ChatController {
  Future<List<ChatUser>> fetchChatList(String token) async {
    const url = 'https://test.myfliqapp.com/api/v1/chat/chat-messages/queries/contact-users';

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print('Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}'); // Add this for debugging

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        if (data.containsKey('data') && data['data'] is List) {
          final userList = data['data'] as List;
          return userList.map((user) => ChatUser.fromJson(user)).toList();
        } else {
          print('Unexpected data format');
          return [];
        }
      } else {
        print('Error: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Exception: $e');
      return [];
    }
  }
}
