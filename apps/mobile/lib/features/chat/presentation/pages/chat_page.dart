library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../app/theme.dart';
import '../../../../core/responsive_scaffold.dart';
import '../../../../main.dart';
import '../../../../widgets/error_state.dart';
import '../../../../widgets/typing_indicator.dart';
import '../../domain/entities/message_entity.dart';
import '../cubit/chat_cubit.dart';
import '../cubit/chat_state.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final _textController = TextEditingController();
  final _scrollController = ScrollController();

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
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

  void _send([String? text]) {
    final message = text ?? _textController.text.trim();
    if (message.isEmpty) return;
    _textController.clear();
    setState(() {});
    context.read<ChatCubit>().sendMessage(message);
    _scrollToBottom();
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final quickQuestions = [
      (text: l.chat_q1, icon: Icons.monitor_heart_outlined),
      (text: l.chat_q2, icon: Icons.medication_outlined),
      (text: l.chat_q3, icon: Icons.schedule_outlined),
      (text: l.chat_q4, icon: Icons.medical_services_outlined),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(l.chat_title),
            const SizedBox(width: AppSpacing.sm),
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.smart_toy_rounded,
                  size: 20, color: AppColors.primary),
            ),
          ],
        ),
        leading: const BackButton(),
      ),
      body: BlocConsumer<ChatCubit, ChatState>(
        listener: (context, state) {
          if (state is ChatLoaded) _scrollToBottom();
        },
        builder: (context, state) {
          if (state is ChatError) {
            return ErrorStateWidget(
              message: l.chat_errorLoad,
              detail: l.chat_errorDetail,
              icon: Icons.chat_bubble_outline_rounded,
              onRetry: () => context.read<ChatCubit>().reset(),
            );
          }

          if (state is! ChatLoaded) {
            return const Center(child: CircularProgressIndicator());
          }

          final messages = state.messages;
          final isSending = state.isSending;

          return ResponsiveCenter(
            maxWidth: 800,
            child: Column(
              children: [
                // AI Guardrails disclaimer (App Store §5, §1.4.1)
                Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                    vertical: AppSpacing.sm,
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.warning.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColors.warning.withValues(alpha: 0.25),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          l.chat_aiDisclaimer,
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                            height: 1.5,
                          ),
                          textAlign: TextAlign.right,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                      vertical: AppSpacing.sm,
                    ),
                    itemCount: messages.length + (isSending ? 1 : 0),
                    itemBuilder: (context, i) {
                      if (i == messages.length && isSending) {
                        return const Padding(
                          padding: EdgeInsets.only(bottom: 12),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TypingIndicator(),
                              SizedBox(width: 48),
                            ],
                          ),
                        );
                      }
                      return _MessageBubble(message: messages[i]);
                    },
                  ),
                ),
                if (messages.length <= 1)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      alignment: WrapAlignment.end,
                      children: quickQuestions
                          .map((q) => ActionChip(
                                avatar: Icon(q.icon,
                                    size: 16, color: AppColors.primary),
                                label: Text(q.text,
                                    style: const TextStyle(
                                        fontSize: 13,
                                        color: AppColors.primary)),
                                backgroundColor: AppColors.primaryLight,
                                onPressed: () => _send(q.text),
                                shape: const StadiumBorder(),
                                side: BorderSide.none,
                              ))
                          .toList(),
                    ),
                  ),
                _ChatInputBar(
                  controller: _textController,
                  onSend: _send,
                  onChanged: () => setState(() {}),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  final MessageEntity message;
  const _MessageBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    final isUser = message.isUser;
    final time =
        '${message.createdAt.hour.toString().padLeft(2, '0')}:${message.createdAt.minute.toString().padLeft(2, '0')}';

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment:
            isUser ? CrossAxisAlignment.start : CrossAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment:
                isUser ? MainAxisAlignment.start : MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (!isUser) const SizedBox(width: 48),
              Flexible(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md, vertical: 12),
                  decoration: BoxDecoration(
                    color: isUser ? AppColors.primary : AppColors.surface,
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(18),
                      topRight: const Radius.circular(18),
                      bottomLeft: Radius.circular(isUser ? 4 : 18),
                      bottomRight: Radius.circular(isUser ? 18 : 4),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.06),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Text(
                    message.content,
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      fontSize: 16,
                      height: 1.6,
                      color:
                          isUser ? Colors.white : AppColors.textPrimary,
                    ),
                  ),
                ),
              ),
              if (isUser) const SizedBox(width: 48),
            ],
          ),
          const SizedBox(height: 4),
          Padding(
            padding: EdgeInsets.only(
                right: isUser ? 0 : 8, left: isUser ? 8 : 0),
            child: Text(time,
                style: const TextStyle(
                    fontSize: 11, color: AppColors.textMuted)),
          ),
        ],
      ),
    );
  }
}

class _ChatInputBar extends StatelessWidget {
  final TextEditingController controller;
  final void Function([String?]) onSend;
  final VoidCallback onChanged;

  const _ChatInputBar({
    required this.controller,
    required this.onSend,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final hasText = controller.text.trim().isNotEmpty;
    final l = context.l10n;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 44,
              height: 44,
              child: IconButton.filled(
                onPressed: hasText ? onSend : null,
                icon: const Icon(Icons.arrow_upward_rounded, size: 22),
                style: IconButton.styleFrom(
                  backgroundColor:
                      hasText ? AppColors.primary : AppColors.shimmerBase,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: TextField(
                controller: controller,
                textAlign: TextAlign.right,
                maxLines: null,
                textInputAction: TextInputAction.send,
                onSubmitted: (_) => onSend(),
                onChanged: (_) => onChanged(),
                style: const TextStyle(fontSize: 16),
                decoration: InputDecoration(
                  hintText: l.chat_inputHint,
                  hintStyle:
                      const TextStyle(color: AppColors.textMuted),
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 18, vertical: 12),
                  isDense: true,
                  filled: true,
                  fillColor: AppColors.surfaceContainerLow,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide:
                        const BorderSide(color: AppColors.primary),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
