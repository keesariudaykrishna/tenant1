import 'package:shared_preferences/shared_preferences.dart';

class SessionController {
  // Create a static instance of SessionController using the private constructor.
  static final SessionController _sessionController =
      SessionController._internal();

  // Nullable userId that holds the user's ID.
  String? userId;

  // Factory constructor that returns the same instance of SessionController every time.
  factory SessionController() {
    return _sessionController;
  }

  // Private internal constructor to prevent external instantiation.
  SessionController._internal();
}

class UserPreference {
  // Save the userRole in SharedPreferences
  Future<bool> saveUserRole(String userRole) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    sp.setString('userRole', userRole); // Save the userRole
    return true;
  }

  // Get the userRole from SharedPreferences
  Future<String?> getUserRole() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    return sp.getString('userRole'); // Retrieve the userRole
  }

  // Remove the userRole from SharedPreferences
  Future<bool> removeUserRole() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    sp.remove('userRole'); // Remove the userRole
    return true;
  }
}
