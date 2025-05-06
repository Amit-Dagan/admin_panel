import 'package:admin_panel/common/widgets/appbar.dart';
import 'package:admin_panel/domain/usecase/chat/send_message.dart';
import 'package:admin_panel/presentation/chat/cubit/chat_cubit.dart';
import 'package:admin_panel/presentation/chat/cubit/chat_state.dart';
import 'package:admin_panel/common/cubit/system_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:admin_panel/domain/entities/chat.dart';
import 'package:admin_panel/domain/entities/user.dart';
import 'package:admin_panel/service_locator.dart'; // if you use getIt

class ChatPage extends StatelessWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Assume SystemCubit is provided above (e.g. in main.dart)
    final systemCubit = context.read<SystemCubit>();
    final userId = systemCubit.state.userId!;

    return BlocProvider(
      create: (_) {
        // get your SendMessage use‐case however you like
        return ChatCubit()..init(userId);
      },
      child: const _ChatView(),
    );
  }
}

class _ChatView extends StatefulWidget {
  const _ChatView();

  @override
  State<_ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<_ChatView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BasicAppbar(),
      body: SafeArea(
        child: Column(
          children: [
            // Messages list
            Expanded(
              child: BlocBuilder<ChatCubit, ChatState>(
                builder: (context, state) {
                  final history = state.chat?.history ?? [];
                  return ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: history.length,
                    itemBuilder: (_, i) => _ChatBubble(message: history[i]),
                  );
                },
              ),
            ),

            // Loading indicator
            BlocSelector<ChatCubit, ChatState, bool>(
              selector: (s) => s.isLoading,
              builder:
                  (_, isLoading) =>
                      isLoading
                          ? const LinearProgressIndicator()
                          : const SizedBox.shrink(),
            ),

            // Input field
            const _ChatInput(),
          ],
        ),
      ),
    );
  }
}

class _ChatBubble extends StatelessWidget {
  final Message message;
  const _ChatBubble({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isUser = message.role == Role.user;
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isUser ? Colors.blue.shade100 : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(message.content, style: const TextStyle(fontSize: 16)),
      ),
    );
  }
}

class _ChatInput extends StatefulWidget {
  const _ChatInput({Key? key}) : super(key: key);
  @override
  State<_ChatInput> createState() => _ChatInputState();
}

class _ChatInputState extends State<_ChatInput> {
  final _controller = TextEditingController();

  void _onSend() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    context.read<ChatCubit>().send(text);
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
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
