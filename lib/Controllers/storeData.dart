import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import 'package:test_apk/Models/Character.dart';
import 'package:test_apk/constant.dart';
class LocalData{

    static SharedPreferences? sharedPreferences;
    static void loadSharedPreferencesAndData() async {
    sharedPreferences = await SharedPreferences.getInstance();
    loadData();
    }
   static void loadData() {
    
    List<String>? listString =
        sharedPreferences!.getStringList("Favorite");
    if (listString != null) {
      listFavorite =
          listString.map((item) => ResultsCharacter.fromJson(json.decode(item))).toList();
      
    }
  }
   static void saveData() {
    List<String> stringList =
        listFavorite.map((item) => json.encode(item.toJson())).toList();
    sharedPreferences!.setStringList("Favorite", stringList);
  }

 static void clearData() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  await  prefs.remove('Favorite');
}
}