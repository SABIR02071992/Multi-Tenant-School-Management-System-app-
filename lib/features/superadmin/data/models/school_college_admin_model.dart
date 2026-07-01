import '../../domain/entity/school_college_admin_entity.dart';

class SchoolCollegeAdminModel extends SchoolCollegeAdminEntity {
  const SchoolCollegeAdminModel({
    required super.fullName,
    required super.email,
    required super.phone,
    required super.schoolDomain,
    super.role,
  });

  // Entity se Model mein convert karne ke liye factory constructor
  factory SchoolCollegeAdminModel.fromEntity(SchoolCollegeAdminEntity entity) {
    return SchoolCollegeAdminModel(
      fullName: entity.fullName,
      email: entity.email,
      phone: entity.phone,
      schoolDomain: entity.schoolDomain,
      role: entity.role,
    );
  }

  // API Request Body (JSON) banane ke liye method
  Map<String, dynamic> toJson() {
    return {
      'full_name': fullName,
      'email': email,
      'phone': phone,
      'school_domain': schoolDomain,
      'role': role,
    };
  }
}
