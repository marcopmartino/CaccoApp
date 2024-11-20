import 'package:cloud_firestore/cloud_firestore.dart';

import '../utility/Extensions.dart';
import '../models/Cacco.dart';

class CaccoNetwork{

  static Future<DocumentReference<Object?>> get _caccos async =>
      FirebaseFirestore.instance.collection('caccos')
          .doc(await DeviceInfo.getCurrentUserIdOrDeviceId());

  static Stream<QuerySnapshot<Object?>> getCurrentUserCaccos() {
    return DeviceInfo.getQueryStream((userOrDeviceId) =>
        FirebaseFirestore.instance.collection('caccos')
            .doc(userOrDeviceId).collection('userCaccos').snapshots()
    );
  }

  static Stream<QuerySnapshot<Object?>> getUserCaccos(userId){
    return FirebaseFirestore.instance.collection('caccos')
        .doc(userId).collection('userCaccos').snapshots();
  }

  static Future<QuerySnapshot<Object?>> getCurrentUserCaccosOnce() async {
    var id = await DeviceInfo.getCurrentUserIdOrDeviceId();
    return FirebaseFirestore.instance.collection('caccos')
        .doc(id).collection('userCaccos').get();
  }

  static Stream<DocumentSnapshot<Object?>> getCaccoById(String caccoId, String? userId) {
    if(userId == null){
      return DeviceInfo.getDocumentStream((userOrDeviceId) =>
          FirebaseFirestore.instance.collection('caccos')
              .doc(userOrDeviceId).collection('caccos').doc(caccoId).snapshots()
      );
    }else{
      return FirebaseFirestore.instance.collection('caccos')
          .doc(userId).collection('userCaccos').doc(caccoId).snapshots();
    }
  }

  static Stream<DocumentSnapshot<Object?>> getCaccosInfo(String? userId){
    if(userId == null){
      return DeviceInfo.getDocumentStream((userOrDeviceId) =>
          FirebaseFirestore.instance.collection('caccos')
              .doc(userOrDeviceId).snapshots()
      );
    }else{
      return FirebaseFirestore.instance.collection('caccos')
          .doc(userId).snapshots();
    }
  }

  static Future<String> addCacco(Map<String, dynamic> cacco) async {
    DocumentReference doc = await (await _caccos).collection('userCaccos').add(cacco);
    increaseCaccoCounter();
    return doc.id;
  }

  static void increaseCaccoCounter() async {
    await (await _caccos).update({'currentMonthPoops': FieldValue.increment(1)});
  }

  static void updateCacco(Cacco cacco) async {
    await (await _caccos).collection('userCaccos').doc(cacco.id).update(cacco.toMap());
  }

  static void deleteCacco(String caccoId) async {
    await (await _caccos).collection('userCaccos').doc(caccoId).delete();
  }
}