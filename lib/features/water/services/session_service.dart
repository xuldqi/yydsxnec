import '../models/user.dart';
import 'database_service.dart';
import 'storage_service.dart';

class SessionService {
  SessionService._();

  static final DatabaseService _databaseService = DatabaseService();
  static final StorageService _storageService = StorageService();

  static Future<String?> getCurrentUserId() async {
    await _storageService.init();
    return _storageService.getCurrentUserId();
  }

  static Future<User?> getCurrentUser() async {
    final userId = await getCurrentUserId();
    if (userId == null) return null;
    return _databaseService.getUser(userId);
  }

  static Future<User> ensureLocalUser({String? displayName}) async {
    final existingUserId = await getCurrentUserId();
    if (existingUserId != null) {
      final existingUser = await _databaseService.getUser(existingUserId);
      if (existingUser != null) return existingUser;
    }

    final now = DateTime.now();
    final userId = 'guest_${now.millisecondsSinceEpoch}';
    final user = User(
      id: userId,
      name: displayName ?? '小鹿用户',
      preferences: UserPreferences(),
      createdAt: now,
      updatedAt: now,
    );

    await _databaseService.insertUser(user);
    await _databaseService.insertUserPreferences(userId, user.preferences);
    await _storageService.setCurrentUserId(userId);
    await _storageService.setLoginType('guest');

    return user;
  }

  static Future<User> loginAsGuest({String? displayName}) {
    return ensureLocalUser(displayName: displayName);
  }

  static Future<void> logout() async {
    await _storageService.clearCurrentUserId();
  }
}
