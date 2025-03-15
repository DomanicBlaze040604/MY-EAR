import 'package:equatable/equatable.dart';

class ChatMessage extends Equatable {
  final String id;
  final String senderId;
  final String receiverId;
  final String content;
  final DateTime timestamp;
  final MessageType type;
  final MessageStatus status;
  final Map<String, dynamic>? metadata;
  final String? attachmentUrl;
  final String? replyToMessageId;

  const ChatMessage({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.content,
    required this.timestamp,
    required this.type,
    required this.status,
    this.metadata,
    this.attachmentUrl,
    this.replyToMessageId,
  });

  @override
  List<Object?> get props => [
    id,
    senderId,
    receiverId,
    content,
    timestamp,
    type,
    status,
    metadata,
    attachmentUrl,
    replyToMessageId,
  ];

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['id'],
      senderId: json['senderId'],
      receiverId: json['receiverId'],
      content: json['content'],
      timestamp: DateTime.parse(json['timestamp']),
      type: MessageType.values.firstWhere(
        (e) => e.toString() == 'MessageType.${json['type']}',
      ),
      status: MessageStatus.values.firstWhere(
        (e) => e.toString() == 'MessageStatus.${json['status']}',
      ),
      metadata: json['metadata'],
      attachmentUrl: json['attachmentUrl'],
      replyToMessageId: json['replyToMessageId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'senderId': senderId,
      'receiverId': receiverId,
      'content': content,
      'timestamp': timestamp.toIso8601String(),
      'type': type.toString().split('.').last,
      'status': status.toString().split('.').last,
      'metadata': metadata,
      'attachmentUrl': attachmentUrl,
      'replyToMessageId': replyToMessageId,
    };
  }
}

enum MessageType { text, image, video, audio, document, location }

enum MessageStatus { sending, sent, delivered, read, failed }
