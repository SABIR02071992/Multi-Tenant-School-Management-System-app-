// lib/features/auth/data/models/user_model.dart
import '../../domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  UserModel({
    required super.id,
    required super.name,
    required super.email,
    required super.role,
    required super.schoolId,
  });

  // Flask API से आने वाले JSON को मॉडल में बदलना
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'].toString(),
      name: json['name'],
      email: json['email'],
      role: json['role'],
      schoolId: json['school_id'].toString(),
    );
  }
}
