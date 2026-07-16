import '../../domain/entities/student_entity.dart';

class StudentModel extends StudentEntity {
  const StudentModel({
    super.id,
    required super.admissionNo,
    super.rollNo,
    required super.firstName,
    super.lastName,
    super.gender,
    super.dob,
    super.mobile,
    super.email,
    super.fatherName,
    super.motherName,
    required super.className,
    required super.section,
    super.address,
    super.photo,
  });

  factory StudentModel.fromJson(Map<String, dynamic> json) {
    return StudentModel(
      id: json["id"],
      admissionNo: json["admission_no"] ?? "",
      rollNo: json["roll_no"],
      firstName: json["first_name"] ?? "",
      lastName: json["last_name"],
      gender: json["gender"],
      dob: json["dob"],
      mobile: json["mobile"],
      email: json["email"],
      fatherName: json["father_name"],
      motherName: json["mother_name"],
      className: json["class_name"] ?? "",
      section: json["section"] ?? "",
      address: json["address"],
      photo: json["photo"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "admission_no": admissionNo,
      "first_name": firstName,
      "last_name": lastName,
      "gender": gender,
      "dob": dob,
      "mobile": mobile,
      "email": email,
      "father_name": fatherName,
      "mother_name": motherName,
      "class_name": className,
      "section": section,
      "address": address,
      "photo": photo,
    };
  }

  factory StudentModel.fromEntity(StudentEntity entity) {
    return StudentModel(
      id: entity.id,
      admissionNo: entity.admissionNo,
      rollNo: entity.rollNo,
      firstName: entity.firstName,
      lastName: entity.lastName,
      gender: entity.gender,
      dob: entity.dob,
      mobile: entity.mobile,
      email: entity.email,
      fatherName: entity.fatherName,
      motherName: entity.motherName,
      className: entity.className,
      section: entity.section,
      address: entity.address,
      photo: entity.photo,
    );
  }
}