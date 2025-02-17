import 'package:cloud_firestore/cloud_firestore.dart';

import '../utility/Extensions.dart';

class UsersNetwork{
  static CollectionReference get _usersReference =>
      FirebaseFirestore.instance.collection('users');

  static Stream<QuerySnapshot<Object?>> getUsersList() {
    return DeviceInfo.getQueryStream((userOrDeviceId) =>
        _usersReference.snapshots());
  }

  static Future<DocumentSnapshot<Object?>> getUserDetails(String userId) {
    return _usersReference.doc(userId).get();
  }

  static Future<dynamic> getUserGroupsList(String userId) async {
    Map<String, dynamic>? data;
    await _usersReference.doc(userId).get().then((DocumentSnapshot userData) {
      data = userData.data() as Map<String, dynamic>;
    });

    return data?['groups'];
  }

  static getGroupMembersList(String groupId) {
    return _usersReference.where('groups', arrayContains: groupId).snapshots();
  }

  static Stream<DocumentSnapshot<Object?>> getCurrentUserDetails() {
    return DeviceInfo.getDocumentStream((userOrDeviceId) =>
        _usersReference.doc(userOrDeviceId).snapshots());
  }
}