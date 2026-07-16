// lib/features/auth/domain/entities/user_entity.dart
class UserEntity {
  final String id;
  final String name;
  final String email;
  final String role;     // Super Admin, School Admin, Teacher, Student
  final String schoolId; // मल्टी-टेनेंट के लिए जरूरी आईडी
  final String? schoolName;
  final String? status;
  UserEntity({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.schoolId,
    this.schoolName,
    this.status,
  });
}
