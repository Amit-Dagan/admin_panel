import 'package:admin_panel/domain/entities/chat.dart';
import 'package:admin_panel/presentation/chat/cubit/chat_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatBubble extends StatelessWidget {
  final Message message;
  const ChatBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isUser = message.role == Role.user;
    // User messages in primary color, assistant in surface variant
    final bgColor =
        isUser ? theme.colorScheme.primary : theme.colorScheme.surfaceVariant;
    final textColor =
        isUser
            ? theme.colorScheme.onPrimary
            : theme.colorScheme.onSurfaceVariant;
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          message.content,
          style: TextStyle(fontSize: 16, color: textColor),
        ),
      ),
    );
  }
}

class ChatInput extends StatefulWidget {
  const ChatInput({super.key});
  @override
  State<ChatInput> createState() => _ChatInputState();
}

class _ChatInputState extends State<ChatInput> {
  final _controller = TextEditingController();

  void _onSend() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    context.read<ChatCubit>().send(text);
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              onSubmitted: (_) => _onSend(),
              decoration: InputDecoration(
                hintText: 'Type a message…',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          IconButton(icon: const Icon(Icons.send), onPressed: _onSend),
        ],
      ),
    );
  }
}
