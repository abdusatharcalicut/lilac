class ChatUser {
  final String id;
  final String name;
  final String lastMessage;

  ChatUser({
    required this.id,
    required this.name,
    required this.lastMessage,
  });

  factory ChatUser.fromJson(Map<String, dynamic> json) {
  final attributes = json['attributes'] as Map<String, dynamic>? ?? {};
  return ChatUser(
    id: json['id']?.toString() ?? '',
    name: attributes['name'] ?? 'Unknown',
    lastMessage: attributes['last_message'] ?? '',
  );
}

}
