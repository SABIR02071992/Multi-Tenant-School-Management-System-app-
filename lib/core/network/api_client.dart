/// Api_client.dart
class ApiClient {

  ApiClient._();  // Private constructor to prevent creating an object

  // 🌐 Base URLs
  static const String emulatorBaseUrl = "http://10.0.2.2:5000";
  static const String mobileBaseUrl = "http://192.168.29.217:5000";

  // 🚀 Changes active URL based on environment
  static const String baseUrl = mobileBaseUrl;

  // ⏱️ Timeouts
  static const int connectTimeoutInSeconds = 15;
  static const int receiveTimeoutInSeconds = 15;

  // 📝 Endpoints
  static const String login = '/api/v1/auth/login';
  static const String userAdminLogin = '/api/v1/super-admin/login';
  static const String onboardSchool = '/api/v1/school/setup';
  static const String getAllSchool = '/api/v1/school/list';
  static const String createSchoolCollegeAdmin = '/api/v1/create-school-admin';
  static const String settings = '/api/v1/settings';
  static const String getAllUsersForSuperAdmin = '/api/v1/super-admin/users';
  // Dashboard
  static const String dashboardHome = '/api/v1/dashboard/home';
  static const String dashboardPeople = '/api/v1/master/people';
  static const String dashboardAcademics = '/api/v1/master/academics';
  static const String dashboardSettings = '/api/v1/master/settings';
  static const String createStudent = '/api/v1/student/create';
  static const String createClasses = '/api/v1/class/create';
  static const String getClasses = '/api/v1/class/all';
  static const String getStudents = '/api/v1/student/all';


}
