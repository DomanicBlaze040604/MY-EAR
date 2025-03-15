import 'package:flutter/foundation.dart';
import '../analytics/analytics_service.dart';
import 'custom_exceptions.dart';

class ErrorHandler {
  final AnalyticsService _analytics;

  ErrorHandler(this._analytics);

  Future<T> handleError<T>(Future<T> Function() action, String context) async {
    try {
      return await action();
    } on NetworkException catch (e) {
      await _logError('network_error', e.toString(), context);
      throw AppException(
        'Network Error',
        'Please check your internet connection and try again.',
      );
    } on AuthenticationException catch (e) {
      await _logError('auth_error', e.toString(), context);
      throw AppException(
        'Authentication Error',
        'Please sign in again to continue.',
      );
    } on DatabaseException catch (e) {
      await _logError('database_error', e.toString(), context);
      throw AppException(
        'Storage Error',
        'Unable to access local storage. Please restart the app.',
      );
    } on ValidationException catch (e) {
      await _logError('validation_error', e.toString(), context);
      throw AppException('Validation Error', e.toString());
    } catch (e, stackTrace) {
      await _logError('unexpected_error', e.toString(), context, stackTrace);
      throw AppException(
        'Unexpected Error',
        'An unexpected error occurred. Please try again later.',
      );
    }
  }

  Future<void> _logError(
    String type,
    String message,
    String context, [
    StackTrace? stackTrace,
  ]) async {
    // Log to analytics
    await _analytics.logErrorOccurred(type, message);

    // Debug logging
    if (kDebugMode) {
      print('Error[$type] in $context: $message');
      if (stackTrace != null) {
        print(stackTrace);
      }
    }
  }
}

class AppException implements Exception {
  final String title;
  final String message;

  AppException(this.title, this.message);

  @override
  String toString() => '$title: $message';
}
