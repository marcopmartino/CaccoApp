import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FollowerNetwork{
  static final DocumentReference _currentUserFollowing = FirebaseFirestore.instance.collection('follow')
      .doc(FirebaseAuth.instance.currentUser!.uid);

  static void addFollowing(String followedId) async {
    DocumentReference doc = await _currentUserFollowing.collection('userFollowing').add({"followedId": followedId});
    increaseFollowingAndFollowerCounter(followedId);
  }

  static void increaseFollowingAndFollowerCounter(String followedId) async {
    await _currentUserFollowing.update({'following': FieldValue.increment(1)});
    await FirebaseFirestore.instance.collection('follow')
        .doc(followedId).update({'follower': FieldValue.increment(1)});
  }

  static Future<void> removeFollowing(String followedId) async {
    final doc = await _currentUserFollowing.collection('userFollowing').where('followedId', isEqualTo: followedId).limit(1).get();
    await _currentUserFollowing.collection('userFollowing').doc(doc.docs[0].id).delete();
    decreaseFollowingAndFollowedCounter(followedId);
  }

  static void decreaseFollowingAndFollowedCounter(String followedId) async {
    await _currentUserFollowing.update({'following': FieldValue.increment(-1)});
    await FirebaseFirestore.instance.collection('follow')
        .doc(followedId).update({'follower': FieldValue.increment(-1)});
  }

  static Stream<DocumentSnapshot<Object?>> getFollowInfo(String userId){
    return FirebaseFirestore.instance.collection('follow')
        .doc(userId).snapshots();
  }

  static Future<bool> checkFollow(String followedId) async {
    final doc = await _currentUserFollowing.collection('userFollowing').where('followedId', isEqualTo: followedId).limit(1).get();

    if(doc.docs[0]['followedId'] == followedId){
      return true;
    }

    return false;
  }
}