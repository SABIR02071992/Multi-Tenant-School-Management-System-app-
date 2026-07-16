class StudentEntity {
  final int? id;
  final String admissionNo;
  final String? rollNo;
  final String firstName;
  final String? lastName;
  final String? gender;
  final String? dob;
  final String? mobile;
  final String? email;
  final String? fatherName;
  final String? motherName;
  final String className;
  final String section;
  final String? address;
  final String? photo;

  const StudentEntity({
    this.id,
    required this.admissionNo,
    this.rollNo,
    required this.firstName,
    this.lastName,
    this.gender,
    this.dob,
    this.mobile,
    this.email,
    this.fatherName,
    this.motherName,
    required this.className,
    required this.section,
    this.address,
    this.photo,
  });
}