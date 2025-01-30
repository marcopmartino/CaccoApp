import 'package:cloud_firestore/cloud_firestore.dart';

class Group{
    late final String? id;
    late final String admin;
    late final String? name;
    late int? memberCounter;
    late final String creationDate;

    Group({
        this.id,
        required this.admin,
        required this.name,
        this.memberCounter = 0,
        required this.creationDate
    });

    Map<String, dynamic> toMap(){
        return{
            'admin': admin,
            'name': name,
            'memberCounter': memberCounter,
            'creationDate': creationDate
        };
    }

    Group.fromMap(Map<String, dynamic> groupMap):
            id = groupMap['id'],
            admin = groupMap['admin'],
            name = groupMap['name'],
            memberCounter = groupMap['description'],
            creationDate = groupMap['creationDate'];

    Group.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> doc):
            id = doc.id,
            admin = doc.data()!['admin'],
            name = doc.data()!['name'],
            memberCounter = doc.data()!['memberCounter'],
            creationDate = doc.data()!['creationDate'];

    String? getId(){
        return id;
    }

    String getCreationDate(){
        return creationDate;
    }
}