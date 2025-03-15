// TODO Implement this library.
import 'package:equatable/equatable.dart';

class Friend extends Equatable {
  final String id;
  final String userId;
  final String friendId;
  final String friendUsername;
  final String? friendAvatar;
  final FriendshipStatus status;
  final DateTime createdAt;
  final DateTime? lastInteractionAt;
  final bool isFavorite;

  const Friend({
    required this.id,
    required this.userId,
    required this.friendId,
    required this.friendUsername,
    this.friendAvatar,
    required this.status,
    required this.createdAt,
    this.lastInteractionAt,
    this.isFavorite = false,
  });

  @override
  List<Object?> get props => [
    id,
    userId,
    friendId,
    friendUsername,
    friendAvatar,
    status,
    createdAt,
    lastInteractionAt,
    isFavorite,
  ];

  factory Friend.fromJson(Map<String, dynamic> json) {
    return Friend(
      id: json['id'],
      userId: json['userId'],
      friendId: json['friendId'],
      friendUsername: json['friendUsername'],
      friendAvatar: json['friendAvatar'],
      status: FriendshipStatus.values.firstWhere(
        (e) => e.toString() == 'FriendshipStatus.${json['status']}',
      ),
      createdAt: DateTime.parse(json['createdAt']),
      lastInteractionAt:
          json['lastInteractionAt'] != null
              ? DateTime.parse(json['lastInteractionAt'])
              : null,
      isFavorite: json['isFavorite'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'friendId': friendId,
      'friendUsername': friendUsername,
      'friendAvatar': friendAvatar,
      'status': status.toString().split('.').last,
      'createdAt': createdAt.toIso8601String(),
      'lastInteractionAt': lastInteractionAt?.toIso8601String(),
      'isFavorite': isFavorite,
    };
  }
}

enum FriendshipStatus { pending, accepted, blocked, declined }
