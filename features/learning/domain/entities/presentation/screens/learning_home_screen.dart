import 'package:flutter/material.dart';
import '../widgets/lesson_card.dart';
import '../../domain/entities/lesson.dart';

class LearningHomeScreen extends StatelessWidget {
  const LearningHomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Learning Mode')),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.75,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: _getLessons().length,
        itemBuilder: (context, index) {
          return LessonCard(lesson: _getLessons()[index]);
        },
      ),
    );
  }

  List<Lesson> _getLessons() {
    return [
      Lesson(
        id: '1',
        title: 'Basic Signs',
        description: 'Learn basic everyday signs',
        category: LessonCategory.signLanguage,
        difficulty: LessonDifficulty.beginner,
        prerequisites: [],
        objectives: ['Learn 10 basic signs'],
        exercises: [],
        estimatedDuration: const Duration(minutes: 15),
        totalPoints: 100,
      ),
      // Add more lessons here
    ];
  }
}
