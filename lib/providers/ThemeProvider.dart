import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  bool isDark = false;
  bool isDarkLoaded = false;

  getIsDark() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    isDark = prefs.getBool('isDark') ?? false;
    isDarkLoaded = true;
    notifyListeners();
  }

  toggleDark() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    isDark = prefs.getBool("isDark") ?? false;
    await prefs.setBool("isDark" , !isDark);
    getIsDark();
  }

  setDark(dark) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool("isDark" , dark);
    getIsDark();
  }
}
