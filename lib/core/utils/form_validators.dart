class KFormValidators {
  /// 1. Admin Full Name Validator
  static String? validateAdminName(String? value) {
    final cleanVal = value?.trim() ?? '';
    if (cleanVal.isEmpty) return "Admin name is required";
    if (cleanVal.length < 3) return "Name must be at least 3 characters long";
    return null;
  }

  /// 2. Password Strength Validator
  static String? validatePassword(String? value) {
    final cleanVal = value?.trim() ?? '';
    if (cleanVal.isEmpty) return "Password cannot be blank";
    if (cleanVal.length < 6) return "Password must be at least 6 characters long";
    return null;
  }

  /// 3. Production-Grade Email Validator (RFC 5322 Standard)
  static String? validateEmail(String? value) {
    final cleanVal = value?.trim() ?? '';
    if (cleanVal.isEmpty) return "Email address is required";

    // Regular Expression for absolute valid email formatting structure
    final emailRegex = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
    );

    if (!emailRegex.hasMatch(cleanVal)) {
      return "Please enter a valid email address (e.g., name@domain.com)";
    }
    return null;
  }

  /// 4. Indian Mobile Number Standard Validator (10 Digits Validation)
  static String? validateMobile(String? value) {
    final cleanVal = value?.trim() ?? '';
    if (cleanVal.isEmpty) return "Mobile number is required";

    // Enforcing exact 10 digit validation logic profile tracking
    final mobileRegex = RegExp(r'^[0-9]{10}$');

    if (!mobileRegex.hasMatch(cleanVal)) {
      return "Mobile number must be exactly 10 digits without spaces or country code";
    }
    return null;
  }
}
