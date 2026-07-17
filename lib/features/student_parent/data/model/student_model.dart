import '../../domain/entities/student_entity.dart';

class StudentModel extends StudentEntity {
  StudentModel({
    required super.id,
    required super.admissionNo,
    required super.firstName,
    required super.lastName,
    super.gender,
    super.dob,
    super.mobile,
    super.email,
    super.fatherName,
    super.motherName,
    super.rollNo,
    super.section,
    super.className,
    super.photo,
    super.status,
    super.address,
  });

  /// Entity -> Model
  factory StudentModel.fromEntity(StudentEntity entity) {
    return StudentModel(
      id: entity.id,
      admissionNo: entity.admissionNo,
      firstName: entity.firstName,
      lastName: entity.lastName,
      gender: entity.gender,
      dob: entity.dob,
      mobile: entity.mobile,
      email: entity.email,
      fatherName: entity.fatherName,
      motherName: entity.motherName,
      rollNo: entity.rollNo,
      section: entity.section,
      className: entity.className,
      photo: entity.photo,
      status: entity.status,
      address: entity.address,
    );
  }

  /// JSON -> Model
  factory StudentModel.fromJson(Map<String, dynamic> json) {
    return StudentModel(
      id: json['id'],
      admissionNo: json['admission_no'] ?? '',
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      gender: json['gender'],
      dob: json['dob'],
      mobile: json['mobile'],
      email: json['email'],
      fatherName: json['father_name'],
      motherName: json['mother_name'],
      rollNo: json['roll_no'],
      section: json['section'],
      className: json['class_name'],
      photo: json['photo'],
      status: json['status'],
      address: json['address'],
    );
  }

  /// Model -> JSON
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "admission_no": admissionNo,
      "first_name": firstName,
      "last_name": lastName,
      "gender": gender,
      "dob": dob,
      "mobile": mobile,
      "email": email,
      "father_name": fatherName,
      "mother_name": motherName,
      "roll_no": rollNo,
      "section": section,
      "class_name": className,
      "photo": photo,
      "status": status,
      "address": address,
    };
  }
}