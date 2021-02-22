import 'package:shared_preferences/shared_preferences.dart';

class preferencesUtil{
  static final preferencesUtil _instance =preferencesUtil._internal();
  factory preferencesUtil(){
    return _instance;
  }
  preferencesUtil._internal();
  SharedPreferences _prefs;
  initPrefs()async{
    this._prefs=await SharedPreferences.getInstance();
  }

  get businessName{
    return _prefs.getString('name') ?? '';
  }
  set businessName(String name){
    _prefs.setString('name', name);
  }
   get businessDescription{
    return _prefs.getString('description') ?? '';
  }
  set businessDescription(String desc){
    _prefs.setString('description', desc);
  }
  
   get adoptionName{
    return _prefs.getString('name') ?? '';
  }
  set adoptionName(String name){
    _prefs.setString('name', name);
  }
   get adoptionDescription{
    return _prefs.getString('description') ?? '';
  }
  set adoptionDescription(String desc){
    _prefs.setString('description', desc);
  }
}