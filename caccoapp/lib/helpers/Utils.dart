import 'package:CaccoApp/helpers/LoginService.dart';
import 'package:flutter/material.dart';

import '../utility/AppColors.dart';
import '../utility/Navigation.dart';
import '../view/pages/UserDetailsPage.dart';

class Utils{
  static GlobalKey<NavigatorState> mainListNav = GlobalKey();
  static GlobalKey<NavigatorState> mainAppNav = GlobalKey();

  static AppBar getAppbar(BuildContext context){
    return AppBar(
      backgroundColor: AppColors.mainBrown,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Expanded(
            flex: 1,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.asset(
                'assets/sample-poop.png',
                height: 150.0,
                width: 45.0,
              ),
            ),
          ),
          const SizedBox(width: 25,),
          const Expanded(
            flex: 3,
            child: Text('CaccoApp', style: TextStyle(fontFamily: 'Matemasie')),
          ),
          const SizedBox(width: 100,),
          Expanded(
              flex: 1,
              child: IconButton(
                icon: const Icon(Icons.person_rounded),
                iconSize: 24,
                onPressed: (){
                  Navigation.navigate(context, UserDetailsPage(
                      userId: LoginService.loggedInUserModel!.id!,
                      username: LoginService.loggedInUserModel!.username!
                  ));
                },
              )
          )
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
    if(gender == 'Male'){
      return 'Maschio';
    }else if(gender == 'Female'){
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