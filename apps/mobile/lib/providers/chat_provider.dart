import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/message.dart';
import '../services/api_service.dart';
import 'auth_provider.dart';

class ChatNotifier extends AsyncNotifier<List<ChatMessage>> {
  @override
  Future<List<ChatMessage>> build() async {
    return [
      ChatMessage(
        id: '0',
        role: MessageRole.assistant,
        content: 'أهلاً! أنا مساعدك الصحي. كيف أقدر أساعدك اليوم؟',
        createdAt: DateTime.now(),
      ),
    ];
  }

  Future<void> sendMessage(String text) async {
    final messages = state.requireValue;
    final userMsg = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      role: MessageRole.user,
      content: text,
      createdAt: DateTime.now(),
    );

    state = AsyncData([...messages, userMsg]);

    try {
      final patientId = await ref.read(currentPatientIdProvider.future);
      final api = ref.read(apiServiceProvider);
      final response = await api.sendChatMessage(patientId, text);

      final assistantMsg = ChatMessage(
        id: (DateTime.now().millisecondsSinceEpoch + 1).toString(),
        role: MessageRole.assistant,
        content: response,
        createdAt: DateTime.now(),
      );
      state = AsyncData([...state.requireValue, assistantMsg]);
    } catch (e) {
      final errorMsg = ChatMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        role: MessageRole.assistant,
        content: 'عذراً، حدث خطأ. حاول مرة أخرى.',
        createdAt: DateTime.now(),
      );
      state = AsyncData([...state.requireValue, errorMsg]);
    }
  }
}

final chatProvider = AsyncNotifierProvider<ChatNotifier, List<ChatMessage>>(
  ChatNotifier.new,
);
