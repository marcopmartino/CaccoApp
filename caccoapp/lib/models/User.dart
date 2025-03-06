import 'package:cloud_firestore/cloud_firestore.dart';

class User{
  late final String? id;
  final String? username;
  final String? email;
  final String? gender;
  final int? currentMonthPoops;
  final int? lastMonthPoops;

  User({
    this.id,
    required this.username,
    required this.email,
    required this.gender,
    this.currentMonthPoops = 0,
    this.lastMonthPoops = 0
  });

  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'email': email,
      'gender': gender,
      'currentMonthPoops': currentMonthPoops,
      'lastMonthPoops': lastMonthPoops
    };
  }

  User.fromMap(Map<String, dynamic> profileMap) :
        id = profileMap['id'],
        username = profileMap['username'],
        email = profileMap['email'],
        gender = profileMap['gender'],
        currentMonthPoops = profileMap['currentMonthPoops'],
        lastMonthPoops = profileMap['lastMonthPoops'];


  User.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> doc):
        id = doc.id,
        username = doc.data()!['username'],
        email = doc.data()!['email'],
        gender = doc.data()!['gender'],
        currentMonthPoops = doc.data()!['currentMonthPoops'],
        lastMonthPoops = doc.data()!['lastMonthPoops'];

  String? getId(){
    return id;
  }

}