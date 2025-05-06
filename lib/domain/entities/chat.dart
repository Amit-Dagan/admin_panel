// domain/entities/message.dart
enum Role { system, user, assistant, bot }

class Message {
  final Role role;
  final String content;
  Message({required this.role, required this.content});
}

// domain/entities/chat_entity.dart
class ChatEntity {
  final String userId;
  final List<Message> history;
  ChatEntity({required this.userId, List<Message>? history})
    : history = List.unmodifiable(history ?? []);

  ChatEntity append(Message m) =>
      ChatEntity(userId: userId, history: [...history, m]);
}
