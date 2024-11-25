import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class GroupsNetwork{
  static final CollectionReference _groups = FirebaseFirestore.instance.collection('groups');

  static void joinGroup(String groupId, bool owner) async {
    owner ?
      await _groups.doc(groupId).collection('members').doc(FirebaseAuth.instance.currentUser!.uid).set({"role": 'owner'}):
      await _groups.doc(groupId).collection('members').doc(FirebaseAuth.instance.currentUser!.uid).set({"role": 'member'});
    increaseGroupMemberCounter(groupId);
  }

  static void increaseGroupMemberCounter(String groupId) async {
    await _groups.doc(groupId).update({'memberCounter': FieldValue.increment(1)});
  }

  static Future<void> exitGroup(String groupId) async {
    await _groups.doc(groupId).collection('member').doc(FirebaseAuth.instance.currentUser!.uid).delete();
    decreaseGroupMemberCounter(groupId);
  }

  static Future<void> removeMember(String groupId, String memberId) async{
    await _groups.doc(groupId).collection('member').doc(memberId).delete();
    decreaseGroupMemberCounter(groupId);
  }

  static void decreaseGroupMemberCounter(String groupId) async {
    await _groups.doc(groupId).update({'memberCounter': FieldValue.increment(-1)});;
  }

  static Future<String> createGroup(Map<String, dynamic> group) async {
    DocumentReference doc = await _groups.add(group);
    doc.set({'memberCounter': 0});
    increaseGroupMemberCounter(doc.id);
    return doc.id;
  }
}