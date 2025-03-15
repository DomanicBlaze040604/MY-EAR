import '../entities/speech_record.dart';

abstract class SpeechRepository {
  Future<List<SpeechRecord>> getRecords();
  Future<void> saveRecord(SpeechRecord record);
  Future<void> deleteRecord(String id);
  Future<void> clearRecords();
  Future<List<String>> getAvailableLanguages();
}
