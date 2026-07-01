/*Base URL and APIs end poids declare here*/
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
  //static const String createSchoolCollegeAdmin = '/api/v1/school/college';
  static const String createSchoolCollegeAdmin = '/api/v1/create-school-admin';

}
