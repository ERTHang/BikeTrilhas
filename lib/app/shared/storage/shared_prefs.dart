import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class SharedPrefs {
  read(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return json.decode(prefs.getString(key));
  }

  save(String key, value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(key, json.encode(value));
  }

  remove(String key) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(key);
  }

  update(String key, value) async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey(key)) {
      prefs.remove(key);
    }
    prefs.setString(key, json.encode(value));
  }

  //Verificar se a key existe na memória
  haveKey(key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(key);
  }
}
