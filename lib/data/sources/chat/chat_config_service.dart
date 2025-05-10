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
      final model = data['model'] as String?;
      final tempRaw = data['temperature'];
      double? temperature;
      if (tempRaw is num) {
        temperature = tempRaw.toDouble();
      }
      final systemPrompt = data['systemPrompt'] as String?;
      final pdfContent = data['pdfContent'] as String?;
      return ChatConfig(
        model: model,
        temperature: temperature,
        systemPrompt: systemPrompt,
        pdfContent: pdfContent,
      );
    } else {
      // No configuration set yet
      return const ChatConfig();
    }
  }

  @override
  Future<void> setChatConfig(ChatConfig config) async {
    final data = <String, dynamic>{};
    if (config.model != null) {
      data['model'] = config.model;
    }
    if (config.temperature != null) {
      data['temperature'] = config.temperature;
    }
    if (config.systemPrompt != null) {
      data['systemPrompt'] = config.systemPrompt;
    }
    if (config.pdfContent != null) {
      data['pdfContent'] = config.pdfContent;
    }
    if (data.isEmpty) return;
    await _collection.doc(_docId).set(data, SetOptions(merge: true));
  }
}