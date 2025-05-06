import 'package:admin_panel/data/sources/chat/chat_config_service.dart';
import 'package:admin_panel/domain/entities/chat_config.dart';
import 'package:admin_panel/domain/repositories/chat/chat_config_repository.dart';

/// Repository implementation that delegates to [ChatConfigService].
class ChatConfigRepositoryImpl implements ChatConfigRepository {
  final ChatConfigService service;

  ChatConfigRepositoryImpl(this.service);

  @override
  Future<ChatConfig> getChatConfig() {
    return service.getChatConfig();
  }

  @override
  Future<void> setChatConfig(ChatConfig config) {
    return service.setChatConfig(config);
  }
}