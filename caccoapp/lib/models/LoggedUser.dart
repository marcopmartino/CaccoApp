import 'package:cloud_firestore/cloud_firestore.dart';

class LoggedUser{

  String? id;
  String? username;
  String? email;
  String? gender;

  static final LoggedUser _instance = LoggedUser._internal();

  LoggedUser._internal();

  factory LoggedUser({
    String? id,
    String? username,
    String? email,
    String? gender,
  }){
    _instance.id = id;
    _instance.username = username;
    _instance.email = email;
    _instance.gender = gender;
    return _instance;
  }

  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'email': email,
      'gender': gender,
    };
  }

  LoggedUser.fromMap(Map<String, dynamic> profileMap) :
        id = profileMap['id'],
        username = profileMap['username'],
        email = profileMap['email'],
        gender = profileMap['gender'];


  LoggedUser.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> doc):
        id = doc.id,
        username = doc.data()!['username'],
        email = doc.data()!['email'],
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
  }
}