import 'package:admin_panel/common/widgets/appbar.dart';
import 'package:admin_panel/domain/usecase/chat/send_message.dart';
import 'package:admin_panel/presentation/chat/cubit/chat_cubit.dart';
import 'package:admin_panel/presentation/chat/cubit/chat_state.dart';
import 'package:admin_panel/common/cubit/system_cubit.dart';
import 'package:admin_panel/presentation/chat/widgets/chat_bubble.dart';
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
    final userId = systemCubit.state.userId ?? '';

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
      drawer: Drawer(child: ListView(children: appBarActions(context))),

      body: SafeArea(
        child: Container(
          color: Theme.of(context).cardColor,

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
                          child: ChatBubble(message: message),
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
              const ChatInput(),
            ],
          ),
        ),
      ),
    );
  }
}
