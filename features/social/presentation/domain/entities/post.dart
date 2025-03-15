import 'package:equatable/equatable.dart';

class Post extends Equatable {
  final String id;
  final String userId;
  final String userName;
  final String content;
  final List<String> mediaUrls;
  final List<String> tags;
  final int likes;
  final int comments;
  final DateTime createdAt;
  final PostType type;
  final bool isAccessibilityFriendly;

  const Post({
    required this.id,
    required this.userId,
    required this.userName,
    required this.content,
    this.mediaUrls = const [],
    this.tags = const [],
    this.likes = 0,
    this.comments = 0,
    required this.createdAt,
    required this.type,
    this.isAccessibilityFriendly = true,
  });

  @override
  List<Object> get props => [
    id,
    userId,
    userName,
    content,
    mediaUrls,
    tags,
    likes,
    comments,
    createdAt,
    type,
    isAccessibilityFriendly,
  ];

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'],
      userId: json['userId'],
      userName: json['userName'],
      content: json['content'],
      mediaUrls: List<String>.from(json['mediaUrls'] ?? []),
      tags: List<String>.from(json['tags'] ?? []),
      likes: json['likes'] ?? 0,
      comments: json['comments'] ?? 0,
      createdAt: DateTime.parse(json['createdAt']),
      type: PostType.values.firstWhere(
        (e) => e.toString() == 'PostType.${json['type']}',
        orElse: () => PostType.general,
      ),
      isAccessibilityFriendly: json['isAccessibilityFriendly'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'userName': userName,
      'content': content,
      'mediaUrls': mediaUrls,
      'tags': tags,
      'likes': likes,
      'comments': comments,
      'createdAt': createdAt.toIso8601String(),
      'type': type.toString().split('.').last,
      'isAccessibilityFriendly': isAccessibilityFriendly,
    };
  }
}

enum PostType { general, question, experience, tip, event, resource }
