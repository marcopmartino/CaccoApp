import 'package:cloud_firestore/cloud_firestore.dart';

import '../utility/Extensions.dart';

class UsersNetwork{
  static CollectionReference get _usersReference =>
      FirebaseFirestore.instance.collection('users');

  static Stream<QuerySnapshot<Object?>> getUsersList() {
    return DeviceInfo.getQueryStream((userOrDeviceId) =>
        _usersReference.snapshots());
  }

  static Future<DocumentSnapshot<Object?>> getUserDetails(String? userId) {
    return _usersReference.doc(userId).get();
  }

  static Future<dynamic> getUserGroupsList(String userId) async {
    Map<String, dynamic>? data;
    await _usersReference.doc(userId).get().then((DocumentSnapshot userData) {
      data = userData.data() as Map<String, dynamic>;
    });

    return data?['groups'];
  }

  static Stream<DocumentSnapshot<Object?>> getUserGroupsListStream() {
    return DeviceInfo.getDocumentStream((userOrDeviceId) =>
        _usersReference.doc(userOrDeviceId).snapshots());
  }

  static getGroupMembersList(String groupId) {
    return _usersReference.where('groups', arrayContains: groupId).snapshots();
  }

  static Stream<DocumentSnapshot<Object?>> getCurrentUserDetails() {
    return DeviceInfo.getDocumentStream((userOrDeviceId) =>
        _usersReference.doc(userOrDeviceId).snapshots());
  }

  static void addGroup(String uid, String id) async {
    await   _usersReference.doc(uid).update(
        {'groups': FieldValue.arrayUnion([id])});
  }

  static Future<void> removeGroup(String memberId, String groupId) async {
    await FirebaseFirestore.instance.collection('users').doc(memberId).update(
        {'groups': FieldValue.arrayRemove([groupId])});
  }
}