import 'package:CaccoApp/helpers/LoginService.dart';
import 'package:CaccoApp/view/pages/HomePage.dart';
import 'package:CaccoApp/view/pages/LoginPage.dart';
import 'package:CaccoApp/view/pages/SignupPage.dart';
import 'package:CaccoApp/view/pages/WelcomePage.dart';
import 'package:CaccoApp/view/pages/homeTabs/GroupsTab.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:CaccoApp/utility/AppColors.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'firebase_options.dart';
import 'helpers/Utils.dart';

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();

  if (Firebase.apps.isEmpty){
      await Firebase.initializeApp(
          name: "CaccoApp",
          options: DefaultFirebaseOptions.currentPlatform,
      );
  }


  final SharedPreferences prefs = await SharedPreferences.getInstance();

  final bool isLoggedIn = (prefs.getBool('isLoggedIn') == null) ? false : prefs.getBool('isLoggedIn')!;

  runApp(
      MultiProvider(
          providers: [
            ChangeNotifierProvider(
              create: (_) => LoginService(),
            )
          ],
          child: MaterialApp(
              navigatorKey: Utils.mainAppNav,
              title: 'CaccoApp',
              theme: ThemeData(
                  fontFamily: 'Roboto',
                  primarySwatch: AppColors.getMaterialColor(AppColors.softBrown),
                  useMaterial3: true
              ),
              home: isLoggedIn ? const HomePage() : const WelcomePage(),
              routes: {
                WelcomePage.route: (context) => const WelcomePage(),
                LoginPage.route: (context) => const LoginPage(),
                SignupPage.route: (context) => const SignupPage(),
                HomePage.route: (context) => const HomePage(),
                GroupsTab.route: (context) => const HomePage(index: 1,),
                //'/searchuserspage': (context) => const SearchBar(),
              }
          )
      )
  );
}

class MyKeys{
  static final first = GlobalKey(debugLabel: 'Home');
  static final third = GlobalKey(debugLabel: 'Groups');

  static List<GlobalKey> getKeys() => [first, third];
}