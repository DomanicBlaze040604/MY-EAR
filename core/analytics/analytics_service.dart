import 'package:firebase_analytics/firebase_analytics.dart';

class AnalyticsService {
  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  Future<void> logFeatureUsage(String featureName) async {
    await _analytics.logEvent(
      name: 'feature_usage',
      parameters: {
        'feature_name': featureName,
        'timestamp': DateTime.now().toIso8601String(),
      },
    );
  }

  Future<void> logAppointmentBooked(
    String doctorId,
    AppointmentType type,
  ) async {
    await _analytics.logEvent(
      name: 'appointment_booked',
      parameters: {
        'doctor_id': doctorId,
        'appointment_type': type.toString(),
        'timestamp': DateTime.now().toIso8601String(),
      },
    );
  }

  Future<void> logLessonCompleted(String lessonId, double score) async {
    await _analytics.logEvent(
      name: 'lesson_completed',
      parameters: {
        'lesson_id': lessonId,
        'score': score,
        'timestamp': DateTime.now().toIso8601String(),
      },
    );
  }

  Future<void> logErrorOccurred(String errorCode, String errorMessage) async {
    await _analytics.logEvent(
      name: 'error_occurred',
      parameters: {
        'error_code': errorCode,
        'error_message': errorMessage,
        'timestamp': DateTime.now().toIso8601String(),
      },
    );
  }

  Future<void> logUserEngagement(String activityType, Duration duration) async {
    await _analytics.logEvent(
      name: 'user_engagement',
      parameters: {
        'activity_type': activityType,
        'duration_seconds': duration.inSeconds,
        'timestamp': DateTime.now().toIso8601String(),
      },
    );
  }

  Future<void> setUserProperties({
    required String userId,
    required String userType,
    String? language,
    String? region,
  }) async {
    await _analytics.setUserId(id: userId);
    await _analytics.setUserProperty(name: 'user_type', value: userType);
    if (language != null) {
      await _analytics.setUserProperty(name: 'language', value: language);
    }
    if (region != null) {
      await _analytics.setUserProperty(name: 'region', value: region);
    }
  }
}
