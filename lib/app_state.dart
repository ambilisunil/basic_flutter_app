import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyAppState extends ChangeNotifier {
  var current = "ambili";
  var b = 0;

  void getNext() {
    var h = WordPair.random();
    current = h.toString();
    notifyListeners();
  }

  var favorites = <String>[];

  void toggleFavorite() {
    if (favorites.contains(current)) {
      favorites.remove(current);
    } else {
      favorites.add(current);
    }
    notifyListeners();
  }

  void localStorageSet(key, value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);

    notifyListeners();
  }

  void localStorageRemove(key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(key);

    notifyListeners();
  }

  Future<String> localStorageRead(String key) {
    return SharedPreferences.getInstance().then((prefs) {
      String value = prefs.getString(key) ?? "";
      print("value: $value");
      return value;
    });
  }
}
