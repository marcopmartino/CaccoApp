import 'dart:async';

import 'package:CaccoApp/network/UsersNetwork.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/Group.dart';
import '../utility/Extensions.dart';

class GroupsNetwork{
  static final CollectionReference _groups = FirebaseFirestore.instance.collection('groups');

  static Future<void> addMember(String groupId, String memberId) async{
    await _groups.doc(groupId).update(
        {'members': FieldValue.arrayUnion([memberId])});
    UsersNetwork.addGroup(memberId, groupId);
    await _groups.doc(groupId).update(
        {'membersCounter': FieldValue.increment(1)});
  }

  static Future<void> removeMember(String groupId, String memberId) async{
    await _groups.doc(groupId).update(
        {'members': FieldValue.arrayRemove([memberId])});
    UsersNetwork.removeGroup(memberId, groupId);
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

  static Future<DocumentSnapshot<Object?>> getGroupDetails(String groupId) {
    return _groups.doc(groupId).get();
  }

  static Stream<DocumentSnapshot<Object?>> getGroupDetailsStream(String groupId) {
    return _groups.doc(groupId).snapshots();
  }

  static Future<DocumentSnapshot<Object?>> getGroupDetailsRemove(String groupId) async {
    return await _groups.doc(groupId).get();
  }

  //Aggiorna un gruppo
  static Future<void> updateGroup(Group group) async{
   await _groups.doc(group.id).update(group.toMap());
  }

  //Elimina un gruppo
  static Future<void> deleteGroup(String groupId) async{
    await _groups.doc(groupId).delete();
  }

  //TODO: da testare
  static Future<void> changeGroupsAdmin(String userId) async {
    var groups = await _groups.where('admin', isEqualTo: userId).get();
    for(var element in groups.docs){
      var adminChanged = false;
      for(var user in element['members']){
        if(user != userId){
          _groups.doc(element.id).update({'admin': user});
          adminChanged = true;
        }
        if(adminChanged) break;
      }
    }
  }

  //TODO: da testare
  static Future<void> exitFromAllGroups(String userId) async {
    var groups = await _groups.where('members', arrayContains: userId).get();
    for(var element in groups.docs){
      await removeMember(element.id, userId);
    }
  }

}