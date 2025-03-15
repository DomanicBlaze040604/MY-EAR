import 'package:equatable/equatable.dart';

class LearningProgress extends Equatable {
  final String userId;
  final String moduleId;
  final int completedLessons;
  final int totalLessons;
  final double progressPercentage;
  final DateTime lastAccessed;
  final Map<String, double> skillScores;

  const LearningProgress({
    required this.userId,
    required this.moduleId,
    required this.completedLessons,
    required this.totalLessons,
    required this.progressPercentage,
    required this.lastAccessed,
    required this.skillScores,
  });

  @override
  List<Object> get props => [
    userId,
    moduleId,
    completedLessons,
    totalLessons,
    progressPercentage,
    lastAccessed,
    skillScores,
  ];

  factory LearningProgress.fromJson(Map<String, dynamic> json) {
    return LearningProgress(
      userId: json['userId'],
      moduleId: json['moduleId'],
      completedLessons: json['completedLessons'],
      totalLessons: json['totalLessons'],
      progressPercentage: json['progressPercentage'],
      lastAccessed: DateTime.parse(json['lastAccessed']),
      skillScores: Map<String, double>.from(json['skillScores']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'moduleId': moduleId,
      'completedLessons': completedLessons,
      'totalLessons': totalLessons,
      'progressPercentage': progressPercentage,
      'lastAccessed': lastAccessed.toIso8601String(),
      'skillScores': skillScores,
    };
  }
}
