import 'package:admin_panel/domain/entities/chat.dart';
import 'package:admin_panel/domain/repositories/chat/chat.dart';
import 'package:admin_panel/service_locator.dart';

class SendMessageUseCase {
  /// Sends [input] and returns the assistant's response text.
  Future<ChatEntity> call(ChatEntity chat) async {
    return await sl<ChatRepository>().sendMessage(chat);
  }
}
