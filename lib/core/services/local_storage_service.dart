import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/user_progress_model.dart';

class LocalStorageService {
  static const String _keyProgress = 'tahfizh_user_progress';

  static Future<UserProgressModel> loadProgress() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? jsonString = prefs.getString(_keyProgress);
      if (jsonString != null && jsonString.isNotEmpty) {
        final Map<String, dynamic> decoded = jsonDecode(jsonString);
        return UserProgressModel.fromJson(decoded);
      }
    } catch (e) {
      // Fallback on error
    }
    return const UserProgressModel();
  }

  static Future<bool> saveProgress(UserProgressModel progress) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String jsonString = jsonEncode(progress.toJson());
      return await prefs.setString(_keyProgress, jsonString);
    } catch (e) {
      return false;
    }
  }

  static Future<bool> clearData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return await prefs.remove(_keyProgress);
    } catch (e) {
      return false;
    }
  }
}
