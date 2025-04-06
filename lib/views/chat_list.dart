import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../controllers/chat_controller.dart';
import '../../models/chat_model.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({super.key});

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  final ChatController _controller = ChatController();
  final TextEditingController _searchController = TextEditingController();

  Future<List<ChatUser>>? _chatUsers;

  @override
  void initState() {
    super.initState();
    _loadChatUsers();
    _loadTokenAndFetchChats();
  }

  void _loadTokenAndFetchChats() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    if (token == null) {
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/login');
      }
      return;
    }

    setState(() {
      _chatUsers = _controller.fetchChatList(token);
    });
  }
Future<void> _loadChatUsers() async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('auth_token');

  if (token != null) {
    setState(() {
      _chatUsers = _controller.fetchChatList(token);
    });
  } else {
    if (mounted) {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }
}

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> stories = [
      {'name': 'Christina', 'image': 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR9kXpUb0gdSaunNvDzt_QrSoowuEyMAdZ95Q&s'},
      {'name': 'Patricia', 'image': 'https://media.istockphoto.com/id/1151159008/photo/close-up-photo-beautiful-amazing-she-her-lady-hold-arm-hand-index-finger-mouth-lips-ask-stop.jpg?s=612x612&w=0&k=20&c=lIRXtf1IIiqYly-vAQsursDFUA_ak3RykG6HxhoBZ5M='},
      {'name': 'Celestine', 'image': 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTIFmaA3_5j9MLsYO4UfZf9d4xP0pu08JY65A&s'},
      {'name': 'Celestine', 'image': 'https://img.freepik.com/free-photo/woman-couch-home-coronavirus-quarantine_53876-146785.jpg'},
      {'name': 'Elizabeth', 'image': 'https://live.staticflickr.com/887/42060748055_4ebd15c224_c.jpg'},
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
        title: const Text('Messages', style: TextStyle(color: Colors.black)),
      ),
      body: Column(
        children: [
          // Stories Section
          SizedBox(
            height: 100,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: stories.length,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (context, index) {
                final story = stories[index];
                return Column(
                  children: [
                    CircleAvatar(
                      radius: 28,
                      backgroundImage: NetworkImage(story['image']!),
                    ),
                    const SizedBox(height: 4),
                    Text(story['name']!, style: const TextStyle(fontSize: 12)),
                  ],
                );
              },
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search',
                prefixIcon: const Icon(Icons.search),
                contentPadding: const EdgeInsets.all(12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
                fillColor: Colors.grey[200],
                filled: true,
              ),
            ),
          ),
          
          Expanded(
            child: FutureBuilder<List<ChatUser>>(
              future: _chatUsers,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return const Center(child: Text('Failed to load chat list'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No chats found'));
                }

                final chats = snapshot.data!;
                return ListView.separated(
                  itemCount: chats.length,
                  separatorBuilder: (_, __) => const Divider(indent: 70),
                  itemBuilder: (context, index) {
                    final chat = chats[index];
                    return ListTile(
                      leading: const CircleAvatar(
                        radius: 28,
                        backgroundImage: NetworkImage('https://svgsilh.com/svg/296989.svg'),
                      ),
                      title: Text(chat.name),
                      subtitle: Text(chat.lastMessage),
                      trailing: const Text('Now', style: TextStyle(fontSize: 12, color: Colors.grey)),
                      onTap: () {
                        // Navigate to chat screen
                      },
                    );
                  },
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
