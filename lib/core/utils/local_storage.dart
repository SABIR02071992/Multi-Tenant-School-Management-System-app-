import 'package:get_storage/get_storage.dart';

class LocalStorageService {
  final _box = GetStorage();

  // --- Token Operations ---

  // Save token
  void saveToken(String token) {
    _box.write('auth_token', token);
  }

  // Read token (returns null if it does not exist)
  String? getToken() {
    return _box.read<String>('auth_token');
  }
  void saveUser(String user){
    _box.write('user_name', user);
  }
  String? getUser(){
    return _box.read<String>('user_name');
  }
  // Save user role
  void saveRole(String role){
    _box.write('user_role', role);
  }

  String? getRole(){
    return _box.read<String>('user_role');
  }

  void saveDomain(String domain){
    _box.write('school_domain', domain);
  }
  String? getDomain(){
    return _box.read<String>('school_domain');
  }

  // --- Boolean Operations ---

  // Save boolean status
  void setLoginStatus(bool isLoggedIn) {
    _box.write('is_logged_in', isLoggedIn);
  }

  // Read boolean status (defaults to false if null)
  bool getLoginStatus() {
    return _box.read<bool>('is_logged_in') ?? false;
  }

  // --- Clear Data (Useful for Logout) ---

  void logout() {
    _box.remove('auth_token');
    _box.remove('is_logged_in');
    _box.remove('user_role');
  }
}
