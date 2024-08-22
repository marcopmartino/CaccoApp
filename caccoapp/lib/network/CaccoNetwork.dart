import 'package:CaccoApp/network/ProfileNetwork.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../utility/Extensions.dart';
import '../models/Cacco.dart';

class CaccoNetwork{

  static Future<CollectionReference<Object?>> get _caccos async =>
      FirebaseFirestore.instance.collection('users')
          .doc(await DeviceInfo.getCurrentUserIdOrDeviceId()).collection('caccos');

  static Stream<QuerySnapshot<Object?>> getCurrentUserCaccos() {
    return DeviceInfo.getQueryStream((userOrDeviceId) =>
        FirebaseFirestore.instance.collection('users')
            .doc(userOrDeviceId).collection('caccos').snapshots()
    );
  }

  static Future<QuerySnapshot<Object?>> getCurrentUserCaccosOnce() async {
    var id = await DeviceInfo.getCurrentUserIdOrDeviceId();
    return FirebaseFirestore.instance.collection('users')
        .doc(id).collection('caccos').get();
  }

  static Stream<DocumentSnapshot<Object?>> getCaccoById(String caccoId) {
    return DeviceInfo.getDocumentStream((userOrDeviceId) =>
        FirebaseFirestore.instance.collection('users')
            .doc(userOrDeviceId).collection('caccos').doc(caccoId).snapshots()
    );
  }

  static Future<String> addCacco(Map<String, dynamic> cacco) async {
    DocumentReference doc = await (await _caccos).add(cacco);
    ProfileNetwork.addCacco();
    return doc.id;
  }

  static void updateCacco(Cacco cacco) async {
    await (await _caccos).doc(cacco.id).update(cacco.toMap());
  }

  static void deleteCacco(String caccoId) async {
    await (await _caccos).doc(caccoId).delete();
  }
}