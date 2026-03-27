library;

import 'package:equatable/equatable.dart';

enum MessageRole { user, assistant }

class MessageEntity extends Equatable {
  final String id;
  final MessageRole role;
  final String content;
  final DateTime createdAt;

  const MessageEntity({
    required this.id,
    required this.role,
    required this.content,
    required this.createdAt,
  });

  bool get isUser => role == MessageRole.user;

  @override
  List<Object> get props => [id, role, content, createdAt];
}
