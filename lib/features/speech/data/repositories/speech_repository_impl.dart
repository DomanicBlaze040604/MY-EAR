import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart'; // Fix this line
import '../../domain/entities/speech_record.dart';
import '../../domain/repositories/speech_repository.dart';

// Rest of the file remains the same

class SpeechRepositoryImpl implements SpeechRepository {
  final SharedPreferences _prefs;
  static const String _recordsKey = 'speech_records';

  SpeechRepositoryImpl(this._prefs);

  @override
  Future<List<SpeechRecord>> getRecords() async {
    final String? recordsJson = _prefs.getString(_recordsKey);
    if (recordsJson == null) return [];

    final List<dynamic> decoded = json.decode(recordsJson);
    return decoded.map((json) => _recordFromJson(json)).toList();
  }

  @override
  Future<void> saveRecord(SpeechRecord record) async {
    final List<SpeechRecord> records = await getRecords();
    records.insert(0, record);
    final String encoded = json.encode(
      records.map((r) => _recordToJson(r)).toList(),
    );
    await _prefs.setString(_recordsKey, encoded);
  }

  @override
  Future<void> deleteRecord(String id) async {
    final List<SpeechRecord> records = await getRecords();
    records.removeWhere((record) => record.id == id);
    final String encoded = json.encode(
      records.map((r) => _recordToJson(r)).toList(),
    );
    await _prefs.setString(_recordsKey, encoded);
  }

  @override
  Future<void> clearRecords() async {
    await _prefs.remove(_recordsKey);
  }

  @override
  Future<List<String>> getAvailableLanguages() async {
    return ['en-US', 'es-ES', 'fr-FR', 'de-DE'];
  }

  Map<String, dynamic> _recordToJson(SpeechRecord record) {
    return {
      'id': record.id,
      'text': record.text,
      'timestamp': record.timestamp.toIso8601String(),
      'confidence': record.confidence,
      'language': record.language,
    };
  }

  SpeechRecord _recordFromJson(Map<String, dynamic> json) {
    return SpeechRecord(
      id: json['id'],
      text: json['text'],
      timestamp: DateTime.parse(json['timestamp']),
      confidence: json['confidence'],
      language: json['language'],
    );
  }
}
