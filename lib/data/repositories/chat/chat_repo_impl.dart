
import 'package:admin_panel/data/sources/chat/chat_service.dart';
import 'package:admin_panel/domain/entities/chat.dart';
import 'package:admin_panel/domain/repositories/chat/chat.dart';
import 'package:admin_panel/service_locator.dart';

class ChatRepositoryImpl implements ChatRepository {

  @override
  Future<ChatEntity> sendMessage(ChatEntity chat) async {
    // chat.history already includes the user's latest message
    // Request GPT reply based on current history
    final assistantMsg = await sl<ChatService>().send(chat.history);
    // Return new entity with assistant message appended
    return chat.append(assistantMsg);
  }
  

}
