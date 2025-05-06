import 'package:admin_panel/domain/entities/chat_config.dart';
import 'package:admin_panel/domain/repositories/chat/chat_config_repository.dart';
import 'package:admin_panel/service_locator.dart';

/// Use-case to retrieve the current ChatGPT configuration.
class GetChatConfigUseCase {
  /// Returns the saved [ChatConfig].
  Future<ChatConfig> call() async {
    return await sl<ChatConfigRepository>().getChatConfig();
  }
}