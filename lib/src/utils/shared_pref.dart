import 'package:shared_preferences/shared_preferences.dart';

void updateSaved(_saved) async {
  Future<SharedPreferences> prefs = SharedPreferences.getInstance();
  prefs.then((pref) async {
    await pref.setStringList('saved', _saved.toList());
  });
}

void updateTimestamp(_timestamp) async {
  Future<SharedPreferences> prefs = SharedPreferences.getInstance();
  prefs.then((pref) async {
    await pref.setString('timestamp', _timestamp.toString());
  });
}