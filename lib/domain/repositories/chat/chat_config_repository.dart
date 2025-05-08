import 'package:admin_panel/domain/entities/chat_config.dart';

/// Repository interface for persisting and retrieving chat configuration.
abstract class ChatConfigRepository {
  /// Retrieves the current chat configuration (e.g. model selection).
  Future<ChatConfig> getChatConfig();

  /// Saves the provided chat configuration.
  Future<void> setChatConfig(ChatConfig config);

}
