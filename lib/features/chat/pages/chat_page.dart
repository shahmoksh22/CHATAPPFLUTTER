import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../core/services/firestore_service.dart';
import '../../../core/models/message_model.dart';
import '../widgets/message_bubble.dart';
import '../../../shared/widgets/custom_text_field.dart';

class ChatPage extends StatefulWidget {
  final String userId;

  const ChatPage({super.key, required this.userId});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  /// Scrolls the chat list to the bottom.
  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  /// Sends the message currently in the text field to the chat partner.
  ///
  /// Clears the text field and scrolls to the bottom after sending.
  void _sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      await Provider.of<FirestoreService>(context, listen: false).sendMessage(
        widget.userId,
        _messageController.text,
      );
      _messageController.clear();
      _scrollToBottom();
    }
  }

  @override
  Widget build(BuildContext context) {
    final firestoreService = Provider.of<FirestoreService>(context);
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorScheme.primary, // Use primary color
        foregroundColor: colorScheme.onPrimary, // Use contrasting text color
        elevation: 0, // Remove shadow for a flatter look
        title: FutureBuilder<String>(
          future: firestoreService.getUserEmailById(widget.userId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Text('Loading...');
            }
            if (snapshot.hasError) {
              return const Text('Error');
            }
            if (!snapshot.hasData) {
              return const Text('User Not Found');
            }
            return Text(snapshot.data!, style: TextStyle(color: colorScheme.onPrimary));
          },
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: colorScheme.onPrimary),
           onPressed: () => GoRouter.of(context).pop(), // Use context.pop() to navigate back
        ),
      ),
      backgroundColor: colorScheme.surface, // Background color
      body: Column(
        children: [
          FutureBuilder<void>(
              future: firestoreService.updateLastReadMessage(widget.userId),
              builder: (context, snapshot) {
                return Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: colorScheme.surface,
                    ),
                    child: StreamBuilder<List<MessageModel>>(
                        stream: firestoreService.getMessages(widget.userId),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                                child: CircularProgressIndicator());
                          }
                          if (snapshot.hasError) {
                            return Center(
                                child: Text('Error: ${snapshot.error}'));
                          }
                          if (!snapshot.hasData || snapshot.data!.isEmpty) {
                            return const Center(child: Text('Say hello!'));
                          }

                          final messages = snapshot.data!;
                          // Scroll to bottom when new messages arrive or UI is built.
                          WidgetsBinding.instance
                              .addPostFrameCallback((_) => _scrollToBottom());

                          return ListView.builder(
                            controller: _scrollController,
                            itemCount: messages.length,
                            itemBuilder: (context, index) {
                              final message = messages[index];
                              final isCurrentUser = message.senderId ==
                                  firestoreService.getCurrentUserId();
                            return MessageBubble(
                              message: message.message,
                              isCurrentUser: isCurrentUser,
                            );
                          },
                        );
                      }),
                  ),
                );
              }),
          Container(
            decoration: BoxDecoration(
              color: colorScheme.surface,
              border: Border(top: BorderSide(color: colorScheme.outlineVariant, width: 0.5)),
            ),
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: CustomTextField(
                    controller: _messageController,
                    hintText: 'Enter message',
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send, color: colorScheme.primary),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}