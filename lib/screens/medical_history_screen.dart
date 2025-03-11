import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class MedicalHistoryScreen extends StatelessWidget {
  const MedicalHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Medical History')),
      body: FutureBuilder(
        future: Hive.openBox('medicalHistory'),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            var box = Hive.box('medicalHistory');
            return ListView.builder(
              itemCount: box.length,
              itemBuilder: (context, index) {
                var record = box.getAt(index);
                return ListTile(
                  title: Text(record['title']),
                  subtitle: Text(record['date']),
                );
              },
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
