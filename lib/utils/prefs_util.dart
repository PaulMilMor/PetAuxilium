import 'package:shared_preferences/shared_preferences.dart';

class preferencesUtil {
  static final preferencesUtil _instance = preferencesUtil._internal();
  factory preferencesUtil() {
    return _instance;
  }
  preferencesUtil._internal();
  SharedPreferences _prefs;
  initPrefs() async {
    this._prefs = await SharedPreferences.getInstance();
  }

  get businessName {
    return _prefs.getString('name') ?? '';
  }

  set businessName(String name) {
    _prefs.setString('name', name);
  }

  get businessDescription {
    return _prefs.getString('description') ?? '';
  }

  set businessDescription(String desc) {
    _prefs.setString('description', desc);
  }

  get userName {
    return _prefs.getString('userName') ?? null;
  }

  set userName(String userName) {
    _prefs.setString('userName', userName);
  }

  get userID {
    return _prefs.getString('userID') ?? ' ';
  }

  set userID(String userID) {
    _prefs.setString('userID', userID);
  }

  get userImg {
    return _prefs.getString('userImg') ?? ' ';
  }

  set userImg(String userImg) {
    _prefs.setString('userImg', userImg);
  }

  get userEmail {
    return _prefs.getString('userEmail') ?? ' ';
  }

  set userEmail(String userEmail) {
    _prefs.setString('userEmail', userEmail);
  }

  get adoptionName {
    return _prefs.getString('aname') ?? '';
  }

  set adoptionName(String name) {
    _prefs.setString('aname', name);
  }

  get adoptionDescription {
    return _prefs.getString('pdescription') ?? '';
  }

  set adoptionDescription(String desc) {
    _prefs.setString('pdescription', desc);
  }

  get adoptionCategory {
    return _prefs.getString('pcategory') ?? 'Adopción';
  }

  set adoptionCategory(String desc) {
    _prefs.setString('pcategory', desc);
  }

  get selectedIndex {
    return _prefs.getInt('selectedIndex') ?? 0;
    
  }

  set selectedIndex(int selectedIndex) {
    _prefs.setInt('selectedIndex', selectedIndex);
  }
  get keeperDescription {
    return _prefs.getString('kdescription') ?? '';
  }

  set keeperDescription(String desc) {
    _prefs.setString('kdescription', desc);
  }

  get keeperCategory {
    return _prefs.getString('kcategory') ?? 'ENTRENAMIENTO';
  }

  set keeperCategory(String desc) {
    _prefs.setString('kcategory', desc);
  }
  get keeperPricing {
    return _prefs.getString('kpricing') ?? '';
  }

  set keeperPricing(String desc) {
    _prefs.setString('kpricing', desc);
  }

  get follows{
    return _prefs.getStringList('follows');
  }
  set follows(List follows){
    _prefs.setStringList('follows', follows);
  }
}
