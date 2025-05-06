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

  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  final ScrollController _scrollController = ScrollController();
  final List<Message> _messages = [];
  Message? _lastMessage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BasicAppbar(),
      body: SafeArea(
        child: Column(
          children: [
            // Animated messages list
            Expanded(
              child: BlocListener<ChatCubit, ChatState>(
                listener: (context, state) {
                  final newHistory = state.chat?.history ?? [];
                  final oldLength = _messages.length;
                  final newLength = newHistory.length;
                  if (newLength > oldLength) {
                    for (int i = oldLength; i < newLength; i++) {
                      final msg = newHistory[i];
                      _messages.insert(i, msg);
                      _listKey.currentState?.insertItem(
                        i,
                        duration: const Duration(milliseconds: 300),
                      );
                    }
                    // scroll to bottom
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      if (_scrollController.hasClients) {
                        _scrollController.animateTo(
                          _scrollController.position.maxScrollExtent,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeOut,
                        );
                      }
                    });
                  }
                },
                child: AnimatedList(
                  key: _listKey,
                  controller: _scrollController,
                  initialItemCount: _messages.length,
                  padding: const EdgeInsets.all(12),
                  itemBuilder: (context, index, animation) {
                    final message = _messages[index];
                    final isUser = message.role == Role.user;
                    return SlideTransition(
                      position: animation.drive(
                        Tween<Offset>(
                          begin: isUser ? const Offset(1, 0) : const Offset(-1, 0),
                          end: Offset.zero,
                        ).chain(CurveTween(curve: Curves.easeOut)),
                      ),
                      child: FadeTransition(
                        opacity: animation.drive(
                          CurveTween(curve: Curves.easeIn),
                        ),
                        child: _ChatBubble(message: message),
                      ),
                    );
                  },
                ),
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
    final theme = Theme.of(context);
    final isUser = message.role == Role.user;
    // User messages in primary color, assistant in surface variant
    final bgColor = isUser
        ? theme.colorScheme.primary
        : theme.colorScheme.surfaceVariant;
    final textColor = isUser
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
