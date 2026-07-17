class SchoolCollegeAdminEntity {
  final String fullName;
  final String email;
  final String phone;
  final String schoolDomain;
  final String role;

  const SchoolCollegeAdminEntity({
    required this.fullName,
    required this.email,
    required this.phone,
    required this.schoolDomain,
    this.role = 'School Admin'
  });
}
