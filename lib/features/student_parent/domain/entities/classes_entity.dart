class ClassEntity {
  final int? id;
  final String className;
  final String? description;
  final String? status;
  final int? createdBy;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const ClassEntity({
    this.id,
    required this.className,
    this.description,
    this.status,
    this.createdBy,
    this.createdAt,
    this.updatedAt,
  });
}