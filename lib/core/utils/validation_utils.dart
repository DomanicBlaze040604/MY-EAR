class ValidationUtils {
  // Email validation
  static bool isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  // Password validation (minimum 8 characters, at least one letter and one number)
  static bool isValidPassword(String password) {
    return RegExp(r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$').hasMatch(password);
  }

  // Phone number validation
  static bool isValidPhone(String phone) {
    return RegExp(r'^\+?[\d-]{10,}$').hasMatch(phone);
  }

  // Username validation (3-16 characters, letters, numbers, and underscores only)
  static bool isValidUsername(String username) {
    return RegExp(r'^[a-zA-Z0-9_]{3,16}$').hasMatch(username);
  }

  // Check if string is empty or null
  static bool isEmpty(String? text) {
    return text == null || text.trim().isEmpty;
  }
}
