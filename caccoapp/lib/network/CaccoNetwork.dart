import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../utility/Extensions.dart';
import '../models/Cacco.dart';
import 'ProfileNetwork.dart';

class CaccoNetwork{

  static CollectionReference get _caccos =>
      FirebaseFirestore.instance.collection('caccos');

  static Stream<QuerySnapshot<Object?>> getCurrentUserCaccos() {
    return DeviceInfo.getQueryStream((userOrDeviceId) =>
        _caccos.doc(userOrDeviceId).collection('userCaccos').snapshots()
    );
  }

  static Stream<QuerySnapshot<Object?>> getUserCaccos(userId){
    return _caccos.doc(userId).collection('userCaccos').snapshots();
  }

  static Future<QuerySnapshot<Object?>> getCurrentUserCaccosOnce() async {
    return _caccos.doc(FirebaseAuth.instance.currentUser!.uid).collection('userCaccos').get();
  }

  static Stream<DocumentSnapshot<Object?>> getCaccoById(String caccoId, String? userId ) {
    return _caccos.doc(userId).collection('userCaccos').doc(caccoId).snapshots();
  }

  static Stream<DocumentSnapshot<Object?>> getCaccosInfo(String? userId){
    if(userId == null){
      return DeviceInfo.getDocumentStream((userOrDeviceId) =>
          _caccos.doc(userOrDeviceId).snapshots()
      );
    }else{
      return _caccos.doc(userId).snapshots();
    }
  }

  static Future<String> addCacco(Map<String, dynamic> cacco) async {
    DocumentReference doc = await  _caccos.doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('userCaccos').add(cacco);
    increaseCaccoCounter();
    return doc.id;
  }

  static void increaseCaccoCounter() async {
    await _caccos.doc(FirebaseAuth.instance.currentUser!.uid)
        .update({'currentMonthPoops': FieldValue.increment(1)});
    ProfileNetwork.increaseCaccoCounter();
  }

  static Future<void> updateCacco(Cacco cacco) async {
    await _caccos.doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('userCaccos').doc(cacco.id).update(cacco.toMap());
  }

  static Future<void> deleteCacco(String caccoId) async {
    await _caccos.doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('userCaccos').doc(caccoId).delete();
    ProfileNetwork.decreaseCaccoCounter();
    decreaseCaccoCounter();
  }

  static void decreaseCaccoCounter() async {
    await _caccos.doc(FirebaseAuth.instance.currentUser!.uid)
        .update({'currentMonthPoops': FieldValue.increment(-1)});
  }

  static getLastCacco() async{
    return await _caccos.doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('userCaccos').orderBy('timeStamp', descending: true)
        .limit(1).get();
  }

  static removeUserCaccos(String userId) async{
    await _caccos.doc(FirebaseAuth.instance.currentUser!.uid).delete();
  }

  static Stream<DocumentSnapshot<Object?>> getCaccoDetails(String caccoId){
    return _caccos.doc(FirebaseAuth.instance.currentUser!.uid).collection('userCaccos')
            .doc(caccoId).snapshots();
  }
}