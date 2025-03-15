import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/offline_queue_item.dart';

class AppDatabase {
  static const String _databaseName = 'my_ear.db';
  static const int _databaseVersion = 1;

  static Database? _database;

  static Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  static Future<Database> _initDatabase() async {
    final path = join(await getDatabasesPath(), _databaseName);
    return openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  static Future<void> _onCreate(Database db, int version) async {
    // Medical Records table
    await db.execute('''
      CREATE TABLE medical_records (
        id TEXT PRIMARY KEY,
        user_id TEXT NOT NULL,
        doctor_id TEXT NOT NULL,
        date TEXT NOT NULL,
        diagnosis TEXT NOT NULL,
        symptoms TEXT NOT NULL,
        prescriptions TEXT NOT NULL,
        notes TEXT,
        is_synced INTEGER DEFAULT 0,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL
      )
    ''');

    // Chat Messages table
    await db.execute('''
      CREATE TABLE chat_messages (
        id TEXT PRIMARY KEY,
        sender_id TEXT NOT NULL,
        receiver_id TEXT NOT NULL,
        content TEXT NOT NULL,
        timestamp TEXT NOT NULL,
        type TEXT NOT NULL,
        status TEXT NOT NULL,
        metadata TEXT,
        attachment_url TEXT,
        reply_to_message_id TEXT,
        is_synced INTEGER DEFAULT 0
      )
    ''');

    // Offline Queue table
    await db.execute('''
      CREATE TABLE offline_queue (
        id TEXT PRIMARY KEY,
        action TEXT NOT NULL,
        data TEXT NOT NULL,
        timestamp TEXT NOT NULL,
        retry_count INTEGER DEFAULT 0,
        status TEXT NOT NULL
      )
    ''');

    // Lessons Progress table
    await db.execute('''
      CREATE TABLE lessons_progress (
        lesson_id TEXT NOT NULL,
        user_id TEXT NOT NULL,
        progress REAL NOT NULL,
        last_position INTEGER NOT NULL,
        completed_exercises TEXT NOT NULL,
        updated_at TEXT NOT NULL,
        is_synced INTEGER DEFAULT 0,
        PRIMARY KEY (lesson_id, user_id)
      )
    ''');
  }

  static Future<void> _onUpgrade(
    Database db,
    int oldVersion,
    int newVersion,
  ) async {
    // Handle database upgrades here
  }

  // Medical Records Operations
  Future<void> saveMedicalRecord(Map<String, dynamic> record) async {
    final db = await database;
    await db.insert(
      'medical_records',
      record,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, dynamic>>> getUnsyncedMedicalRecords() async {
    final db = await database;
    return db.query('medical_records', where: 'is_synced = ?', whereArgs: [0]);
  }

  // Chat Messages Operations
  Future<void> saveChatMessage(Map<String, dynamic> message) async {
    final db = await database;
    await db.insert(
      'chat_messages',
      message,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, dynamic>>> getUnsyncedMessages() async {
    final db = await database;
    return db.query('chat_messages', where: 'is_synced = ?', whereArgs: [0]);
  }

  // Offline Queue Operations
  Future<void> addToOfflineQueue(OfflineQueueItem item) async {
    final db = await database;
    await db.insert(
      'offline_queue',
      item.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<OfflineQueueItem>> getPendingOfflineActions() async {
    final db = await database;
    final results = await db.query(
      'offline_queue',
      where: 'status = ?',
      whereArgs: ['pending'],
    );
    return results.map((json) => OfflineQueueItem.fromJson(json)).toList();
  }

  // Lessons Progress Operations
  Future<void> saveLessonProgress(Map<String, dynamic> progress) async {
    final db = await database;
    await db.insert(
      'lessons_progress',
      progress,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<Map<String, dynamic>?> getLessonProgress(
    String lessonId,
    String userId,
  ) async {
    final db = await database;
    final results = await db.query(
      'lessons_progress',
      where: 'lesson_id = ? AND user_id = ?',
      whereArgs: [lessonId, userId],
      limit: 1,
    );
    return results.isNotEmpty ? results.first : null;
  }
}
