import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthController {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  /// Saves the token securely
  Future<void> saveToken(String token) async {
    try {
      await _storage.write(key: 'token', value: token);
      print("Token saved: $token");
    } catch (e) {
      print("Error saving token: $e");
    }
  }

  /// Retrieves the token securely
  Future<String?> getToken() async {
    try {
      return await _storage.read(key: 'token');
    } catch (e) {
      print("Error reading token: $e");
      return null;
    }
  }
}
