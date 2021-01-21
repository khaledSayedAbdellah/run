import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppLanguage extends ChangeNotifier{
  Locale _appLocale = Locale("ar");
  String _appLanguage = "ar";

  // return the appLocale, if not supported make "en" by default
  Locale get appLocale {
    fetchLocale();
    return _appLocale;
  }
  String get appLanguage => _appLanguage ?? "ar";

  fetchLocale() async{
    var prefs = await SharedPreferences.getInstance();
    if (prefs.getString('language_code') == null){
      _appLocale = Locale('ar');
      return null;
    }

    _appLocale = Locale(prefs.getString('language_code'));
    _appLanguage = prefs.getString('language_code');
    //print('Current Language is ' + _appLocale.languageCode);
    
    notifyListeners();
  }

  void changeLanguage(Locale type) async{
    var prefs = await SharedPreferences.getInstance();

    if (type == Locale('ar')){
      _appLocale = Locale('ar');
      _appLanguage = "ar";
      prefs.setString('language_code', 'ar');
      prefs.setString('countryCode', '');
    }else{
      _appLocale = Locale('en');
      _appLanguage = "en";
      prefs.setString('language_code', 'en');
      prefs.setString('countryCode', 'US');
    }
    print('Language Changed To ' + prefs.getString('language_code'));

    notifyListeners();
  }
}