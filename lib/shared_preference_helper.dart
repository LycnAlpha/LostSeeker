import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceHelper {
  static Future<bool> saveUserID(String userID) async {
    SharedPreferences sh = await SharedPreferences.getInstance();
    return await sh.setString('USER_ID', userID);
  }

  static Future<String> getUserID() async {
    SharedPreferences sh = await SharedPreferences.getInstance();
    return sh.getString('USER_ID') ?? '';
  }
}
