import 'package:equatable/equatable.dart';

class Lesson extends Equatable {
  final String id;
  final String title;
  final String description;
  final LessonCategory category;
  final LessonDifficulty difficulty;
  final List<String> prerequisites;
  final List<String> objectives;
  final List<Exercise> exercises;
  final Duration estimatedDuration;
  final int totalPoints;
  final bool isCompleted;
  final double progressPercentage;

  const Lesson({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.difficulty,
    required this.prerequisites,
    required this.objectives,
    required this.exercises,
    required this.estimatedDuration,
    required this.totalPoints,
    this.isCompleted = false,
    this.progressPercentage = 0.0,
  });

  @override
  List<Object> get props => [
    id,
    title,
    description,
    category,
    difficulty,
    prerequisites,
    objectives,
    exercises,
    estimatedDuration,
    totalPoints,
    isCompleted,
    progressPercentage,
  ];

  factory Lesson.fromJson(Map<String, dynamic> json) {
    return Lesson(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      category: LessonCategory.values.firstWhere(
        (e) => e.toString() == 'LessonCategory.${json['category']}',
      ),
      difficulty: LessonDifficulty.values.firstWhere(
        (e) => e.toString() == 'LessonDifficulty.${json['difficulty']}',
      ),
      prerequisites: List<String>.from(json['prerequisites']),
      objectives: List<String>.from(json['objectives']),
      exercises:
          (json['exercises'] as List).map((e) => Exercise.fromJson(e)).toList(),
      estimatedDuration: Duration(minutes: json['estimatedDuration']),
      totalPoints: json['totalPoints'],
      isCompleted: json['isCompleted'] ?? false,
      progressPercentage: json['progressPercentage'] ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'category': category.toString().split('.').last,
      'difficulty': difficulty.toString().split('.').last,
      'prerequisites': prerequisites,
      'objectives': objectives,
      'exercises': exercises.map((e) => e.toJson()).toList(),
      'estimatedDuration': estimatedDuration.inMinutes,
      'totalPoints': totalPoints,
      'isCompleted': isCompleted,
      'progressPercentage': progressPercentage,
    };
  }
}

enum LessonCategory { signLanguage, speechTherapy, communication, lipreading }

enum LessonDifficulty { beginner, intermediate, advanced, expert }

class Exercise {
  final String id;
  final String title;
  final String description;
  final ExerciseType type;
  final Map<String, dynamic> content;
  final int points;
  final bool isCompleted;

  Exercise({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.content,
    required this.points,
    this.isCompleted = false,
  });

  factory Exercise.fromJson(Map<String, dynamic> json) {
    return Exercise(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      type: ExerciseType.values.firstWhere(
        (e) => e.toString() == 'ExerciseType.${json['type']}',
      ),
      content: json['content'],
      points: json['points'],
      isCompleted: json['isCompleted'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'type': type.toString().split('.').last,
      'content': content,
      'points': points,
      'isCompleted': isCompleted,
    };
  }
}

enum ExerciseType {
  signRecognition,
  pronunciation,
  quiz,
  interactive,
  practice,
}
