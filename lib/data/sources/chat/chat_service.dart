// data/datasources/chat_remote_data_source.dart
import 'package:admin_panel/domain/entities/chat.dart';
import 'package:admin_panel/domain/entities/chat_config.dart';
import 'package:dart_openai/dart_openai.dart';
import 'package:admin_panel/domain/repositories/chat/chat_config_repository.dart';
import 'package:admin_panel/service_locator.dart';

/// A pure data-source that only knows about the SDK and returns a Message:
abstract class ChatService {
  Future<Message> send(List<Message> history);
  Future<List<String>> getModels();
}

class ChatServiceImpl implements ChatService {
  @override
  Future<Message> send(List<Message> history) async {
    // Optionally refresh available models
    await getModels();

    // Fetch saved chat configuration
    final config = await sl<ChatConfigRepository>().getChatConfig();

    // Build SDK history using ChoiceMessageModel
    final sdkHistory = <OpenAIChatCompletionChoiceMessageModel>[];
    if (config.systemPrompt != null) {
      sdkHistory.add(OpenAIChatCompletionChoiceMessageModel(
        role: OpenAIChatMessageRole.system,
        content: [
          OpenAIChatCompletionChoiceMessageContentItemModel.text(
            config.systemPrompt!,
          ),
        ],
      ));
    }
    if (config.pdfContent != null) {
      sdkHistory.add(OpenAIChatCompletionChoiceMessageModel(
        role: OpenAIChatMessageRole.system,
        content: [
          OpenAIChatCompletionChoiceMessageContentItemModel.text(
            config.pdfContent!,
          ),
        ],
      ));
    }

    // Map domain history into SDK ChoiceMessageModel
    sdkHistory.addAll(history.map((m) => OpenAIChatCompletionChoiceMessageModel(
          role: OpenAIChatMessageRole.values.byName(m.role.name),
          content: [
            OpenAIChatCompletionChoiceMessageContentItemModel.text(
              m.content,
            ),
          ],
        )));

    // Invoke chat completion with selected model
    final chat = await OpenAI.instance.chat.create(
      model: config.model ?? 'gpt-4',
      messages: sdkHistory,
      temperature: config.temperature ?? 1.0,
    );

    // Extract assistant reply
    final sdkReply = chat.choices.first.message;
    final text = sdkReply.content!
        .map((item) => item.text)
        .join()
        .trim();
    print(text);

    return Message(role: Role.assistant, content: text);
  }

  @override
  Future<List<String>> getModels() async {
    final all = await OpenAI.instance.model.list();
    final strings = all
        .map((m) => m.id)
        .where((id) => id.startsWith('gpt-'))
        .where((id) {
          final l = id.toLowerCase();
          return !l.contains('dall') &&
              !l.contains('audio') &&
              !l.contains('image') &&
              !l.contains('embedding') &&
              !l.contains('search') &&
              !l.contains('preview') &&
              !l.contains('tts') &&
              !l.contains('transcribe') &&
              !l.contains('moderation');
        })
        .toList();
    return strings;
  }

  Future<String> _loadApiKeyFromSecureStorage() async {
    // e.g. return await SecureStorage().read(key: 'openai_api_key');
    throw UnimplementedError();
  }
}