class SchoolEntity {
  final String id;
  final String schoolName;
  final String adminEmail;
  final String domain;
  final String schemaName; // 🟢 Naya variable joda gaya hai
  final String logoPath;
  final String planSetup;
  final String status;
  final String? message;

  SchoolEntity({
    required this.id,
    required this.schoolName,
    required this.adminEmail,
    required this.domain,
    required this.schemaName, // 🟢 Required banaya gaya
    required this.logoPath,
    required this.planSetup,
    required this.status,
    this.message,
  });
}
