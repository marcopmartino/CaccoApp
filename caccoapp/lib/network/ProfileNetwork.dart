import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/LoggedUser.dart';
import '../utility/Extensions.dart';

class ProfileNetwork{
  static final DocumentReference _user = FirebaseFirestore.instance.collection('users')
      .doc(FirebaseAuth.instance.currentUser!.uid);

  static createUserIfNotExists(String? userId) async {
    DocumentReference userReference = FirebaseFirestore.instance.collection('users').doc(userId);
    await userReference.get().then((document) async => {
      if (!document.exists) {
        await userReference.set({})
      }
    });
  }

  static createDeviceUserIfNotExists() async {
    createUserIfNotExists(await DeviceInfo.deviceId);
  }

  static Future<void> checkIfExist(User user, String gender) async {
    var document = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
    if(!document.exists){
      await addUser(
          username: user.displayName!,
          email: user.email!,
          gender: gender
      );
    }
  }

  static Future<Object?> addUser({
    required String username,
    required String email,
    required String gender}) async {

    final LoggedUser user = LoggedUser(
        username: username,
        email: email,
        gender: gender
    );

    _user.set(user.toMap()).catchError((e){
      return e;
    });

    return null;
  }

  static Stream<DocumentSnapshot<Object?>> getCurrentUserInfo() {
    return _user.snapshots();
  }

  static Stream<DocumentSnapshot<Object?>> getUserInfo(String userId) {
    return FirebaseFirestore.instance.collection('users')
        .doc(userId).snapshots();
  }

  static Future<DocumentSnapshot<Object?>> getUserInfoOnce(String userId) {
    return FirebaseFirestore.instance.collection('users')
        .doc(userId).get();
  }

  static void updateProfile(LoggedUser user){
    _user.update(user.toMap());
  }
}