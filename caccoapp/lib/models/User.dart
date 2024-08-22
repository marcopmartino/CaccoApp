import 'package:cloud_firestore/cloud_firestore.dart';

class User{
  late final String? id;
  final String? username;
  final String? email;
  final String? gender;
  final int? currentMonthPoop;
  final int? lastMonthPoop;

  User({
    this.id,
    required this.username,
    required this.email,
    required this.gender,
    this.currentMonthPoop = 0,
    this.lastMonthPoop = 0,
  });

  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'email': email,
      'gender': gender,
      'currentMonthPoop': currentMonthPoop,
      'lastMonthPoop': lastMonthPoop,
    };
  }

  User.fromMap(Map<String, dynamic> profileMap) :
    id = profileMap['id'],
    username = profileMap['username'],
    email = profileMap['email'],
    gender = profileMap['gender'],
    currentMonthPoop = profileMap['currentMonthPoop'],
    lastMonthPoop = profileMap['lastMonthPoop'];


  User.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> doc):
    id = doc.id,
    username = doc.data()!['username'],
    email = doc.data()!['email'],
    gender = doc.data()!['gender'],
    currentMonthPoop = doc.data()!['currentMonthPoop'],
    lastMonthPoop = doc.data()!['lastMonthPoop'];

  String? getId(){
    return id;
  }

}