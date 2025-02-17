import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../utility/Extensions.dart';

class GroupsNetwork{
  static final CollectionReference _groups = FirebaseFirestore.instance.collection('groups');

  static Future<void> addMember(String groupId, String memberId) async{
    await _groups.doc(groupId).update(
        {'members': FieldValue.arrayUnion([memberId])});
    await _groups.doc(groupId).update(
        {'membersCounter': FieldValue.increment(1)});
  }

  static Future<void> removeMember(String groupId, String memberId) async{
    await _groups.doc(groupId).update(
        {'members': FieldValue.arrayRemove([memberId])});
    await _groups.doc(groupId).update(
        {'membersCounter': FieldValue.increment(-1)});
  }

  static Future<String> createGroup(Map<String, dynamic> group) async {
    DocumentReference doc = await _groups.add(group);
    addMember(doc.id, FirebaseAuth.instance.currentUser!.uid.toString());
    return doc.id;
  }

  static Stream<QuerySnapshot<Object?>> getGroupsList() {
    return DeviceInfo.getQueryStream((userOrDeviceId) =>
        _groups.snapshots());
  }

  static Stream<DocumentSnapshot<Object?>> getGroupDetails(String groupId) {
    return _groups.doc(groupId).snapshots();
  }

}