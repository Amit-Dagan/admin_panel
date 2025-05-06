import 'package:admin_panel/domain/entities/chat_config.dart';
import 'package:admin_panel/domain/repositories/chat/chat_config_repository.dart';
import 'package:admin_panel/service_locator.dart';

/// Use-case to save the ChatGPT configuration.
class SetChatConfigUseCase {
  /// Persists the given [config].
  Future<void> call(ChatConfig config) async {
    await sl<ChatConfigRepository>().setChatConfig(config);
  }
}