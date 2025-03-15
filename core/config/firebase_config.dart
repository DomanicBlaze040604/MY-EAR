import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseConfig {
  static Future<void> initialize() async {
    await Firebase.initializeApp();
  }

  static FirebaseAuth get auth => FirebaseAuth.instance;
  static FirebaseFirestore get firestore => FirebaseFirestore.instance;
  static FirebaseStorage get storage => FirebaseStorage.instance;

  // Collection references
  static CollectionReference get users => firestore.collection('users');

  static CollectionReference get medicalRecords =>
      firestore.collection('medical_records');

  static CollectionReference get lessons => firestore.collection('lessons');

  static CollectionReference get speechSessions =>
      firestore.collection('speech_sessions');

  static CollectionReference get doctors => firestore.collection('doctors');

  // Storage references
  static Reference get medicaldocuments =>
      storage.ref().child('medical_documents');

  static Reference get lessonContent => storage.ref().child('lesson_content');

  static Reference get userAvatars => storage.ref().child('user_avatars');
}
