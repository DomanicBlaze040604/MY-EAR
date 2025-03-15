class NetworkException implements Exception {
  final String message;
  final int? statusCode;

  NetworkException(this.message, [this.statusCode]);

  @override
  String toString() =>
      'NetworkException: $message${statusCode != null ? ' (Status Code: $statusCode)' : ''}';
}

class AuthenticationException implements Exception {
  final String message;

  AuthenticationException(this.message);

  @override
  String toString() => 'AuthenticationException: $message';
}

class DatabaseException implements Exception {
  final String message;
  final String? operation;

  DatabaseException(this.message, [this.operation]);

  @override
  String toString() =>
      'DatabaseException: $message${operation != null ? ' (Operation: $operation)' : ''}';
}

class ValidationException implements Exception {
  final String message;
  final Map<String, String>? errors;

  ValidationException(this.message, [this.errors]);

  @override
  String toString() {
    if (errors != null && errors!.isNotEmpty) {
      final errorMessages = errors!.entries
          .map((e) => '${e.key}: ${e.value}')
          .join(', ');
      return 'ValidationException: $message ($errorMessages)';
    }
    return 'ValidationException: $message';
  }
}

class OfflineException implements Exception {
  final String message;
  final String? action;

  OfflineException(this.message, [this.action]);

  @override
  String toString() =>
      'OfflineException: $message${action != null ? ' (Action: $action)' : ''}';
}

class PermissionException implements Exception {
  final String message;
  final String permission;

  PermissionException(this.message, this.permission);

  @override
  String toString() =>
      'PermissionException: $message (Permission: $permission)';
}

class ResourceNotFoundException implements Exception {
  final String message;
  final String resourceType;
  final String? resourceId;

  ResourceNotFoundException(this.message, this.resourceType, [this.resourceId]);

  @override
  String toString() =>
      'ResourceNotFoundException: $message (Type: $resourceType${resourceId != null ? ', ID: $resourceId' : ''})';
}
