import 'package:cloud_firestore/cloud_firestore.dart';

class Group{
    late final String? id;
    late final String adminId;
    late final String adminName;
    late final String? name;
    late int? memberCounter;
    late final String creationDate;

    Group({
        this.id,
        required this.adminId,
        required this.adminName,
        required this.name,
        this.memberCounter = 0,
        required this.creationDate
    });

    Map<String, dynamic> toMap(){
        return{
            'admin': adminId,
            'adminName': adminName,
            'name': name,
            'memberCounter': memberCounter,
            'creationDate': creationDate
        };
    }

    Group.fromMap(Map<String, dynamic> groupMap):
            id = groupMap['id'],
            adminId = groupMap['adminId'],
            adminName = groupMap['adminName'],
            name = groupMap['name'],
            memberCounter = groupMap['description'],
            creationDate = groupMap['creationDate'];

    Group.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> doc):
            id = doc.id,
            adminId = doc.data()!['adminId'],
            adminName = doc.data()!['adminName'],
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