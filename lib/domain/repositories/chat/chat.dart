import 'package:admin_panel/domain/entities/chat.dart';
import 'package:admin_panel/domain/entities/chat_config.dart';

abstract class ChatRepository {
  /// Sends [userInput] plus context to GPT and returns the assistant’s reply.
  Future<ChatEntity> sendMessage(ChatEntity history);

  Future<List<String>> getChatModels();

}
