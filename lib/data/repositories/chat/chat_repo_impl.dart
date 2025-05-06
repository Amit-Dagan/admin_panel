
import 'package:admin_panel/data/sources/chat/chat_service.dart';
import 'package:admin_panel/domain/entities/chat.dart';
import 'package:admin_panel/domain/repositories/chat/chat.dart';
import 'package:admin_panel/service_locator.dart';

class ChatRepositoryImpl implements ChatRepository {

  @override
  Future<ChatEntity> sendMessage(ChatEntity chat) async {
    // 1️⃣ append user turn
    final withUser = chat.append(
      Message(
        role: Role.user,
        content: /* user input */ chat.history.last.content,
      ),
    );
    // 2️⃣ ask GPT
    final assistantMsg = await sl<ChatService>().send(withUser.history);
    // 3️⃣ return new entity with assistant appended
    return withUser.append(assistantMsg);
  }
  

}
