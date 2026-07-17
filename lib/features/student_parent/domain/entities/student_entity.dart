class StudentEntity {
  final int? id;
  final String admissionNo;
  final String firstName;
  final String lastName;
  final String? gender;
  final String? dob;
  final String? mobile;
  final String? email;
  final String? fatherName;
  final String? motherName;
  final String? rollNo;
  final String? section;
  final String? className;
  final String? photo;
  final String? status;
  final String? address;

  StudentEntity({
    this.id,
    required this.admissionNo,
    required this.firstName,
    required this.lastName,
    this.gender,
    this.dob,
    this.mobile,
    this.email,
    this.fatherName,
    this.motherName,
    this.rollNo,
    this.section,
    this.className,
    this.photo,
    this.status,
    this.address,
  });

  String get fullName => "$firstName $lastName";
}