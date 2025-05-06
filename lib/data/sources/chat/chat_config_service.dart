import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:admin_panel/domain/entities/chat_config.dart';

/// Data-source for storing/retrieving chat configuration in Firestore.
abstract class ChatConfigService {
  /// Fetches the current chat configuration.
  Future<ChatConfig> getChatConfig();

  /// Saves the provided chat configuration.
  Future<void> setChatConfig(ChatConfig config);
}

/// Firestore-based implementation of [ChatConfigService].
class FirebaseChatConfigService implements ChatConfigService {
  final CollectionReference _collection =
      FirebaseFirestore.instance.collection('settings');
  final String _docId = 'chat_config';

  @override
  Future<ChatConfig> getChatConfig() async {
    final doc = await _collection.doc(_docId).get();
    if (doc.exists) {
      final data = doc.data() as Map<String, dynamic>;
      final model = data['model'] as String? ?? 'gpt-3.5-turbo';
      return ChatConfig(model: model);
    } else {
      // Initialize with a default model if none exists
      const defaultConfig = ChatConfig(model: 'gpt-3.5-turbo');
      await setChatConfig(defaultConfig);
      return defaultConfig;
    }
  }

  @override
  Future<void> setChatConfig(ChatConfig config) async {
    await _collection.doc(_docId).set({'model': config.model});
  }
}