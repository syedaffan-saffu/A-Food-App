import 'package:flutter/material.dart';
import 'package:rajputfoods/utils/auth/apiutils.dart';
import 'package:rajputfoods/utils/sharedprefs/sharedprefs.dart';

class UserIdProvider extends ChangeNotifier {
  final SharedprefStoreUser prefs;
  UserIdProvider(this.prefs) {
    setuserlog();
  }
  String _id = "";
  bool _isloggedin = false;
  bool get isloggedin => _isloggedin;
  String get userid => _id;

  void setuserlog() async {
    final thisid = await prefs.getuserid();
    print("idprovider ${Encodedata.decodeid(thisid)}");
    if (thisid == "") {
      _isloggedin = false;
      notifyListeners();
    } else {
      _id = thisid;
      _isloggedin = true;
      notifyListeners();
    }
  }

  void logout() {
    _isloggedin = false;
    notifyListeners();
  }

  void setid(String newid) {
    _id = newid;
    notifyListeners();
  }
}

class ItemIndexProvider extends ChangeNotifier {
  int _index = 0;

  int get index => _index;

  void increase() {
    _index++;
    notifyListeners();
  }

  void changeindex(int newindex) {
    _index = newindex;
    notifyListeners();
  }
}

class TabIndexProvider extends ChangeNotifier {
  int _index = 0;

  int get index => _index;

  void changeindex(int newindex) {
    if (index == newindex) {
      notifyListeners();
    } else {
      _index = newindex;
      notifyListeners();
    }
  }
}

class LocationProvider extends ChangeNotifier {
  List<String> _data = [];

  List<String> get data => _data;

  void changedata(List<String> location) {
    _data = location;
    notifyListeners();
  }
}
