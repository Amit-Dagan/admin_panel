import 'package:admin_panel/domain/entities/chat_config.dart';
import 'package:admin_panel/domain/repositories/chat/chat.dart';
import 'package:admin_panel/domain/repositories/chat/chat_config_repository.dart';
import 'package:admin_panel/service_locator.dart';

class getChatModelsUseCase {
  /// Persists the given [config].
  Future<List<String>> call() async {
    final configs = await sl<ChatRepository>().getChatModels();
    return configs;
  }
}
