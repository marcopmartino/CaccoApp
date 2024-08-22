import 'package:cloud_firestore/cloud_firestore.dart';

import '../utility/Extensions.dart';

class UsersNetwork{
  static CollectionReference get _usersReference =>
      FirebaseFirestore.instance.collection('users');

  static Stream<QuerySnapshot<Object?>> getUsersList() {
    return DeviceInfo.getQueryStream((userOrDeviceId) =>
        _usersReference.snapshots());
  }

  static Stream<DocumentSnapshot<Object?>> getUserDetails(String userId) {
    return _usersReference.doc(userId).snapshots();
  }
}