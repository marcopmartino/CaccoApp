import 'package:CaccoApp/network/ProfileNetwork.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/LoggedUser.dart';

class LoginService extends ChangeNotifier{
  LoggedUser? _userModel;
  LoggedUser? get loggedInUserModel => _userModel;

  GoogleSignIn googleSignIn = GoogleSignIn(
      scopes: [
        'profile',
        'email',
        "https://www.googleapis.com/auth/user.gender.read",
        "https://www.googleapis.com/auth/userinfo.email"
      ]);

  Future<bool> signInWithGoogle() async {

    // Trigger the authentication flow

    final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

    if (googleUser == null){
      return false;
    }

    // Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

    // Create a new credential
    final GoogleAuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    ) as GoogleAuthCredential;

    // Once signed in, return the UserCredential
    UserCredential userCreds = await FirebaseAuth.instance.signInWithCredential(credential);

    final gender = await getGender();
    _userModel = LoggedUser(
      username: userCreds.user!.displayName,
      email: userCreds.user!.email,
      id: userCreds.user!.uid,
      gender: gender
    );
    ProfileNetwork.checkIfExist(userCreds.user!, gender);
    notifyListeners();

    return true;
  }

  Future<String> getGender() async{
    final headers = await googleSignIn.currentUser!.authHeaders;
    final r = await http.get(Uri.parse("https://people.googleapis.com/v1/people/me?personFields=genders&key="),
      headers: {
      "Authorization": headers["Authorization"]!,
      }
    );
    final response = json.decode(r.body);
    return response["genders"][0]["formattedValue"];
  }

  Future<void> googleSignOut() async{
    await GoogleSignIn().signOut();
    _userModel = null;
  }

  static Future<User?> registerUsingEmailPassword({
    required String name,
    required String email,
    required String password,
  }) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;

    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      user = userCredential.user;
      await user!.updateDisplayName(name);
      await user.reload();
      user = auth.currentUser;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }

    return user;
  }


  static Future<Object?> signInUsingEmailPassword({
    required String email,
    required String password,
  }) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;

    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      user = userCredential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return ('Utente non trovato.');
      } else if (e.code == 'wrong-password') {
        return ('Password inserita errata.');
      }
    }

    return user;
  }

  static Future<Object?> signUpUsingEmailPassword({
    required String email,
    required String password,
  }) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;

    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      user = userCredential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'account-exists-with-different-credential') {
        return ('Email già in uso.');
      } else if (e.code == 'email-already-in-use'){
        return ('Email già in uso.');
      }
    }

    return user;
  }

  bool isUserLoggedIn(){
    return _userModel != null;
  }
}