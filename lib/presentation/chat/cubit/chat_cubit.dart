import 'package:admin_panel/domain/entities/chat.dart';
import 'package:admin_panel/domain/entities/user.dart';
import 'package:admin_panel/domain/repositories/chat/chat.dart';
import 'package:admin_panel/domain/usecase/chat/send_message.dart';
import 'package:admin_panel/presentation/chat/cubit/chat_state.dart';
import 'package:admin_panel/service_locator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Manages sending user input to GPT and updating state with responses.
class ChatCubit extends Cubit<ChatState> {
  ChatCubit() : super(ChatState());

  /// Sends [text] as a user message, awaits GPT response, and updates the state.
  Future<void> send(String text) async {
    // 1️⃣ Add user message
    final userMsg = Message(content: text, role: Role.user);
    emit(
      state.copyWith(
        chat: state.chat?.append(userMsg),
        isLoading: true,
        error: null,
      ),
    );
    try {
      // 2️⃣ Request GPT reply
      final reply = await sl<ChatRepository>().sendMessage(state.chat!);

      // 3️⃣ Update state: add bot message and turn off loading
      emit(state.copyWith(chat: reply, isLoading: false));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  init(String userId) {
    emit(state.copyWith(chat: ChatEntity(userId: userId)));
  }
}
