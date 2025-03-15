import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/entities/sign_detection.dart';

class StorageService {
  final SharedPreferences _prefs;
  static const String _detectionsKey = 'sign_detections';
  static const int _maxStoredDetections = 100;

  StorageService(this._prefs);

  Future<List<SignDetection>> getDetections() async {
    final String? json = _prefs.getString(_detectionsKey);
    if (json == null) return [];

    try {
      final List<dynamic> decoded = jsonDecode(json);
      return decoded.map((item) => SignDetection.fromJson(item)).toList();
    } catch (e) {
      print('Error loading detections: $e');
      return [];
    }
  }

  Future<void> saveDetection(SignDetection detection) async {
    final detections = await getDetections();
    detections.insert(0, detection);

    if (detections.length > _maxStoredDetections) {
      detections.removeRange(_maxStoredDetections, detections.length);
    }

    await _prefs.setString(
      _detectionsKey,
      jsonEncode(detections.map((d) => d.toJson()).toList()),
    );
  }

  Future<void> clearDetections() async {
    await _prefs.remove(_detectionsKey);
  }
}
