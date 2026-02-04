import 'package:shared_preferences/shared_preferences.dart';

class UserLocalStorage {
  static const _keyUid = 'uid';
  static const _keyEmail = 'email';
  static const _keyName = 'name';
  static const _keyCoins = 'coins';
  static const _keyOnboarding = 'onboarding_done';

  Future<void> saveUser({
    required String uid,
    required String email,
    required String name,
    int coins = 0,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyUid, uid);
    await prefs.setString(_keyEmail, email);
    await prefs.setString(_keyName, name);
    await prefs.setInt(_keyCoins, coins);
  }

  Future<String?> get uid async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyUid);
  }

  Future<String?> get email async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyEmail);
  }

  Future<String?> get name async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyName);
  }

  Future<int> get coins async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_keyCoins) ?? 0;
  }

  Future<bool> get onboardingDone async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyOnboarding) ?? false;
  }

  Future<void> setOnboardingDone(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyOnboarding, value);
  }

  Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
