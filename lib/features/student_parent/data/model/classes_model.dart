
import '../../domain/entities/classes_entity.dart';

class ClassModel extends ClassEntity {
  const ClassModel({
    super.id,
    required super.className,
    super.description,
    super.status,
    super.createdBy,
    super.createdAt,
    super.updatedAt,
  });

  factory ClassModel.fromJson(Map<String, dynamic> json) {
    return ClassModel(
      id: json["id"],
      className: json["class_name"] ?? "",
      description: json["description"],
      status: json["status"],
      createdBy: json["created_by"],
      createdAt: json["created_at"] != null
          ? DateTime.parse(json["created_at"])
          : null,
      updatedAt: json["updated_at"] != null
          ? DateTime.parse(json["updated_at"])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "class_name": className,
      "description": description,
      "status": status,
      "created_by": createdBy,
      "created_at": createdAt?.toIso8601String(),
      "updated_at": updatedAt?.toIso8601String(),
    };
  }

  factory ClassModel.fromEntity(ClassEntity entity) {
    return ClassModel(
      id: entity.id,
      className: entity.className,
      description: entity.description,
      status: entity.status,
      createdBy: entity.createdBy,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }
}