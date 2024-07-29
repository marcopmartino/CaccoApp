import 'package:cloud_firestore/cloud_firestore.dart';

class LoggedUser{
  late final String? id;
  final String? username;
  final String? email;
  final String? gender;

  LoggedUser({
    this.id,
    required this.username,
    required this.email,
    required this.gender,
  });

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

}