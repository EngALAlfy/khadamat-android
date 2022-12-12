import 'package:ez_localization/ez_localization.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleProvider extends ChangeNotifier {
  bool isLocaleLoaded = false;
  bool isSettingsLocaleLoaded = false;
  Locale locale;
  Locale settingsLocale;

  getLocale(context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var lang = prefs.getString('lang');
    print(lang);
    print(EzLocalization.of(context));
    if (lang != null) {
      locale = new Locale(lang, '');
    } else {
      if (EzLocalization.of(context) != null) {
        locale = EzLocalization.of(context).locale;
        print(locale);
      } else {
        locale = null;
      }
    }

    isLocaleLoaded = true;

    notifyListeners();
  }

  getSettingsLocale(context) async {
    isSettingsLocaleLoaded = false;
    settingsLocale = null;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var lang = prefs.getString('lang');
    if (lang != null) {
      settingsLocale = new Locale(lang, '');
    } else {
      if (EzLocalization.of(context) != null) {
        settingsLocale = EzLocalization.of(context).locale;
        print(settingsLocale);
      } else {
        settingsLocale = null;
      }
    }

    isSettingsLocaleLoaded = true;

    notifyListeners();
  }

  setLocale(context, lang) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('lang', lang);

    EzLocalizationBuilder.of(context).changeLocale(Locale(lang));

    getLocale(context);
  }
}
