import 'package:school_test/core/constants/api_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  // ── Token ──
  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(StorageKeys.token, token);
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(StorageKeys.token);
  }

  // ── Role ──
  static Future<void> saveRole(String role) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(StorageKeys.userRole, role);
  }

  static Future<String?> getRole() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(StorageKeys.userRole);
  }

  // ── User Data ──
  static Future<void> saveUserName(String name) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(StorageKeys.userData, name);
  }

  static Future<String?> getUserName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(StorageKeys.userData);
  }

  // ── Clear (Logout) ──
  static Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  // ── Check Login ──
  static Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null;
  }

  static Future<void> saveOriginalRole(String role) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(StorageKeys.originalRole, role);
  }

  static Future<String?> getOriginalRole() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(StorageKeys.originalRole);
  }
}
