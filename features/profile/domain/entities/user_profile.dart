import 'package:equatable/equatable.dart';

class UserProfile extends Equatable {
  final String id;
  final String username;
  final String? email;
  final String? avatarUrl;
  final List<String> preferredLanguages;
  final Map<String, bool> accessibilitySettings;
  final DateTime createdAt;
  final DateTime lastUpdated;

  const UserProfile({
    required this.id,
    required this.username,
    this.email,
    this.avatarUrl,
    required this.preferredLanguages,
    required this.accessibilitySettings,
    required this.createdAt,
    required this.lastUpdated,
  });

  @override
  List<Object?> get props => [
    id,
    username,
    email,
    avatarUrl,
    preferredLanguages,
    accessibilitySettings,
    createdAt,
    lastUpdated,
  ];

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'],
      username: json['username'],
      email: json['email'],
      avatarUrl: json['avatarUrl'],
      preferredLanguages: List<String>.from(json['preferredLanguages']),
      accessibilitySettings: Map<String, bool>.from(
        json['accessibilitySettings'],
      ),
      createdAt: DateTime.parse(json['createdAt']),
      lastUpdated: DateTime.parse(json['lastUpdated']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'avatarUrl': avatarUrl,
      'preferredLanguages': preferredLanguages,
      'accessibilitySettings': accessibilitySettings,
      'createdAt': createdAt.toIso8601String(),
      'lastUpdated': lastUpdated.toIso8601String(),
    };
  }
}
