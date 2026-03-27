library;

import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/message_entity.dart';
import '../../domain/usecases/send_message_usecase.dart';
import 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  final SendMessageUseCase _sendMessage;
  final String patientId;

  ChatCubit({
    required SendMessageUseCase sendMessage,
    required this.patientId,
  })  : _sendMessage = sendMessage,
        super(ChatLoaded(messages: [
          MessageEntity(
            id: '0',
            role: MessageRole.assistant,
            content: 'أهلاً! أنا مساعدك الصحي. كيف أقدر أساعدك اليوم؟',
            createdAt: DateTime.now(),
          ),
        ]));

  Future<void> sendMessage(String text) async {
    if (text.isEmpty) return;
    final currentState = state;
    if (currentState is! ChatLoaded) return;

    final userMsg = MessageEntity(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      role: MessageRole.user,
      content: text,
      createdAt: DateTime.now(),
    );

    emit(currentState.copyWith(
        messages: [...currentState.messages, userMsg], isSending: true));

    final result = await _sendMessage(
        SendMessageParams(patientId: patientId, message: text));

    result.fold(
      (failure) {
        final errorMsg = MessageEntity(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          role: MessageRole.assistant,
          content: 'عذراً، حدث خطأ. حاول مرة أخرى.',
          createdAt: DateTime.now(),
        );
        final s = state;
        if (s is! ChatLoaded) return;
        emit(s.copyWith(
            messages: [...s.messages, errorMsg], isSending: false));
      },
      (response) {
        final assistantMsg = MessageEntity(
          id: (DateTime.now().millisecondsSinceEpoch + 1).toString(),
          role: MessageRole.assistant,
          content: response,
          createdAt: DateTime.now(),
        );
        final s = state;
        if (s is! ChatLoaded) return;
        emit(s.copyWith(
            messages: [...s.messages, assistantMsg],
            isSending: false));
      },
    );
  }

  void reset() {
    emit(ChatLoaded(messages: [
      MessageEntity(
        id: '0',
        role: MessageRole.assistant,
        content: 'أهلاً! أنا مساعدك الصحي. كيف أقدر أساعدك اليوم؟',
        createdAt: DateTime.now(),
      ),
    ]));
  }
}
