import 'package:shared_preferences/shared_preferences.dart';
Future<String> getUserName() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('stringValue') ?? '';
}
