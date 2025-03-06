import 'package:cloud_firestore/cloud_firestore.dart';

class LoggedUser{

  String? id;
  String? username;
  String? email;
  String? gender;
  List<String>? groups;
  int? currentMonthPoops;
  int? lastMonthPoops;

  static final LoggedUser _instance = LoggedUser._internal();

  LoggedUser._internal();

  factory LoggedUser({
    String? id,
    String? username,
    String? email,
    String? gender,
    List<String>? groups,
    int? currentMonthPoops,
    int? lastMonthPoops,
  }){
    _instance.id = id;
    _instance.username = username;
    _instance.email = email;
    _instance.gender = gender;
    _instance.groups = groups;
    _instance.currentMonthPoops = currentMonthPoops;
    _instance.lastMonthPoops = lastMonthPoops;
    return _instance;
  }

  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'email': email,
      'gender': gender,
      'groups': groups,
      'currentMonthPoops': currentMonthPoops,
      'lastMonthPoops': lastMonthPoops,
    };
  }

  LoggedUser.fromMap(Map<String, dynamic> profileMap) :
    id = profileMap['id'],
    username = profileMap['username'],
    email = profileMap['email'],
    groups = profileMap['groups'],
    currentMonthPoops = profileMap['currentMonthPoops'],
    lastMonthPoops = profileMap['lastMonthPoops'],
    gender = profileMap['gender'];


  LoggedUser.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> doc):
    id = doc.id,
    username = doc.data()!['username'],
    email = doc.data()!['email'],
    groups = doc.data()!['groups'],
    currentMonthPoops = doc.data()!['currentMonthPoops'],
    lastMonthPoops = doc.data()!['lastMonthPoops'],
    gender = doc.data()!['gender'];

  String? getId(){
    return id;
  }

  String? getUsername(){
    return username;
  }

  void logOut(){
    id = "";
    username = "";
    email = "";
    gender= "";
    lastMonthPoops = 0;
    currentMonthPoops = 0;
    groups = [];
  }
}