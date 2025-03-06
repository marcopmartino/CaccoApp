import 'package:CaccoApp/helpers/LoginService.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../network/GroupsNetwork.dart';
import '../utility/AppColors.dart';
import '../utility/Navigation.dart';
import '../view/pages/CurrentUserDetailsPage.dart';
import '../view/pages/HomePage.dart';
import '../view/pages/WelcomePage.dart';

class Utils{
  static GlobalKey<NavigatorState> mainListNav = GlobalKey();
  static GlobalKey<NavigatorState> mainAppNav = GlobalKey();

  static Widget appLogo(){
    return ClipRRect(
      borderRadius: BorderRadius.circular(8.0),
      child: Image.asset(
        'assets/sample-poop.png',
        height: 150.0,
        width: 45.0,
      ),
    );
  }

  static Widget appName(){
    return const Text('CaccoApp', style: TextStyle(fontFamily: 'Matemasie', color: Colors.white));
  }

  static Widget userProfile(){
    return IconButton(
      icon: const Icon(Icons.person_rounded, color: Colors.white,),
      iconSize: 24,
      onPressed: (){
        Navigation.navigateFromLeft(mainAppNav.currentContext!, CurrentUserDetailsPage(
            userId: LoginService.loggedInUserModel!.id!,
            username: LoginService.loggedInUserModel!.username!
        ));
      },
    );
  }

  static AppBar getAppbarHome(BuildContext context){
    return AppBar(
      backgroundColor: AppColors.mainBrown,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Expanded(
            flex: 1,
            child: appLogo(),
          ),
          const SizedBox(width: 25,),
          Expanded(
            flex: 3,
            child: appName(),
          ),
          const SizedBox(width: 100,),
          Expanded(
              flex: 1,
              child: userProfile()
          )
        ],
      ),
      centerTitle: true,
    );
  }

  static AppBar getAppbarGroups(BuildContext context, String title, String groupId){

    return AppBar(
      backgroundColor: AppColors.mainBrown,
      leading: IconButton(
        onPressed: (){
          Navigation.back(context);
        },
        icon: const Icon(Icons.arrow_back_outlined, color: Colors.white,),
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Expanded(
            flex: 1,
            child: appLogo()
          ),
          const SizedBox(width: 25,),
          Expanded(
            flex: 3,
            child: appName(),
          ),
          const SizedBox(width: 100,),
          Expanded(
            flex: 1,
            child: IconButton(
              icon: const Icon(Icons.exit_to_app, color: Colors.white),
              iconSize: 24,
              onPressed: (){
                GroupsNetwork.removeMember(groupId, FirebaseAuth.instance.currentUser!.uid);
                Navigation.navigateFromLeft(context, const HomePage());
              },
            )
          )
        ],
      ),
      centerTitle: true,
    );
  }

  static AppBar getAppbarInvite(BuildContext context, String title){
    return AppBar(
      backgroundColor: AppColors.mainBrown,
      leading: IconButton(
        onPressed: (){
          Navigation.back(context);
        },
        icon: const Icon(Icons.arrow_back_outlined, color: Colors.white,),
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Expanded(
            flex: 1,
            child: appLogo(),
          ),
          const SizedBox(width: 25,),
          Expanded(
            flex: 3,
            child: appName(),
          ),
        ],
      ),
      centerTitle: true,
    );
  }

  static AppBar getAppbarProfile(BuildContext context){
    return AppBar(
      backgroundColor: AppColors.mainBrown,
      leading: IconButton(
        onPressed: (){
          Navigation.back(context);
        },
        icon: const Icon(Icons.arrow_back_outlined, color: Colors.white,),
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Expanded(
            flex: 1,
            child: appLogo(),
          ),
          const SizedBox(width: 25,),
          const Expanded(
            flex: 3,
            child: Text(
              'Dettagli profilo',
              style: TextStyle(fontFamily: 'JosefinSans', color: Colors.white)),
          ),
          const SizedBox(width: 100,),
          Expanded(
            flex: 1,
            child: IconButton(
              icon: const Icon(Icons.exit_to_app, color: Colors.white,),
              iconSize: 24,
              onPressed: () async{
                LoginService.googleSignOut();
                Navigation.navigateFromLeft(context, const WelcomePage());
              },
            )
          )
        ],
      ),
      centerTitle: true,
    );
  }

  static AppBar getAppbarCacco(BuildContext context){
    return AppBar(
      backgroundColor: AppColors.mainBrown,
      leading: IconButton(
        onPressed: (){
          Navigation.back(context);
        },
        icon: const Icon(Icons.arrow_back_outlined, color: Colors.white,),
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Expanded(
            flex: 1,
            child: appLogo(),
          ),
          const SizedBox(width: 25,),
          const Expanded(
            flex: 3,
            child: Text(
              'Dettagli cacco',
              style: TextStyle(fontFamily: 'JosefinSans', color: Colors.white)),
          ),
          const SizedBox(width: 100,),
        ],
      ),
      centerTitle: true,
    );
  }

  static String deviceSuffix(BuildContext context){
    String deviceSuffix = '';
    TargetPlatform platform = Theme.of(context).platform;
    switch(platform){
      case TargetPlatform.android:
        deviceSuffix = '_android';
        break;
      case TargetPlatform.iOS:
        deviceSuffix = '_ios';
        break;
      default:
        deviceSuffix = '';
        break;
    }
    return deviceSuffix;
  }

  static String translateGender(String gender){
    if(gender == 'Male' || gender == 'male'){
      return 'Maschio';
    }else if(gender == 'Female' || gender == 'female'){
      return 'Femmina';
    }else{
      return 'Altro';
    }
  }

  static String getCurrentMonth(){
    List months = ['Gennaio', 'Febbraio', 'Marzo', 'Aprile', 'Maggio','Giugno',
      'Luglio','Agosto','Settembre','Ottobre','Novembre','Dicembre'];
    var now = DateTime.now();
    return months[now.month-1];
  }
}