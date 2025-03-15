import 'package:equatable/equatable.dart';

class Community extends Equatable {
  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final List<String> moderatorIds;
  final List<String> tags;
  final int memberCount;
  final bool isVerified;
  final DateTime createdAt;
  final CommunityType type;
  final List<AccessibilityFeature> accessibilityFeatures;

  const Community({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.moderatorIds,
    required this.tags,
    this.memberCount = 0,
    this.isVerified = false,
    required this.createdAt,
    required this.type,
    this.accessibilityFeatures = const [],
  });

  @override
  List<Object> get props => [
    id,
    name,
    description,
    imageUrl,
    moderatorIds,
    tags,
    memberCount,
    isVerified,
    createdAt,
    type,
    accessibilityFeatures,
  ];

  factory Community.fromJson(Map<String, dynamic> json) {
    return Community(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      imageUrl: json['imageUrl'],
      moderatorIds: List<String>.from(json['moderatorIds']),
      tags: List<String>.from(json['tags']),
      memberCount: json['memberCount'] ?? 0,
      isVerified: json['isVerified'] ?? false,
      createdAt: DateTime.parse(json['createdAt']),
      type: CommunityType.values.firstWhere(
        (e) => e.toString() == 'CommunityType.${json['type']}',
      ),
      accessibilityFeatures:
          (json['accessibilityFeatures'] as List)
              .map(
                (e) => AccessibilityFeature.values.firstWhere(
                  (f) => f.toString() == 'AccessibilityFeature.$e',
                ),
              )
              .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'imageUrl': imageUrl,
      'moderatorIds': moderatorIds,
      'tags': tags,
      'memberCount': memberCount,
      'isVerified': isVerified,
      'createdAt': createdAt.toIso8601String(),
      'type': type.toString().split('.').last,
      'accessibilityFeatures':
          accessibilityFeatures
              .map((e) => e.toString().split('.').last)
              .toList(),
    };
  }
}

enum CommunityType { general, support, education, events, resources }

enum AccessibilityFeature {
  signLanguage,
  audioDescription,
  closedCaptions,
  screenReader,
  highContrast,
  textToSpeech,
}
