import 'package:admin_panel/domain/entities/chat.dart';

/// Holds the list of messages, loading state, and optional error.
class ChatState {
  final ChatEntity? chat;
  final bool isLoading;
  final String? error;

  ChatState({this.chat, this.isLoading = false, this.error});

  ChatState copyWith({
    ChatEntity? chat,
    bool? isLoading,
    String? error,
  }) {
    return ChatState(
      chat: chat ?? this.chat,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }

  factory ChatState.initial( ) => ChatState(chat: null);
}
