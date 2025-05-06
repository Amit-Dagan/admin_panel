// data/datasources/chat_remote_data_source.dart
import 'package:admin_panel/domain/entities/chat.dart';
import 'package:dart_openai/dart_openai.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

// A pure data-source that only knows about the SDK and returns a Message:
abstract class ChatService {
  Future<Message> send(List<Message> history);
}

class ChatServiceImpl implements ChatService {
  ChatRemoteDataSource() {
    // ❗️Don’t hard-code your key in source!
    
  }

  @override
  Future<Message> send(List<Message> history) async {
    OpenAI.apiKey = dotenv.env['OPENAI_APY_KEY'] ?? '';
    print(history[history.length - 1].content);
    // map domain → SDK model
    final sdkHistory =
        history
            .map(
              (m) => OpenAIChatCompletionChoiceMessageModel(
                role: OpenAIChatMessageRole.values.byName(m.role.name),
                content: [
                  OpenAIChatCompletionChoiceMessageContentItemModel.text(
                    m.content,
                  ),
                ],
              ),
            )
            .toList();

    final chat = await OpenAI.instance.chat.create(
      model: "gpt-4o",
      messages: sdkHistory,
    );
    
    // extract assistant reply
    final sdkReply = chat.choices.first.message;
    print("RAW CONTENT ITEMS: ${sdkReply.content}");
    if (sdkReply.haveContent) {
      for (var item in sdkReply.content!) {
        print(
          "  • type = ${item.type}, "
          "text = ${item.text}, "
          "imageUrl = ${item.imageUrl}, "
        );
      }
    }
    final text = sdkReply.content!.map((c) => c.text).join().trim();  
    print(text);
    return Message(role: Role.assistant, content: text);
  }

  Future<String> _loadApiKeyFromSecureStorage() async {
    // e.g. return await SecureStorage().read(key: 'openai_api_key');
    throw UnimplementedError();
  }
}
