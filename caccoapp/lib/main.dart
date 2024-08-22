import 'package:CaccoApp/helpers/LoginService.dart';
import 'package:CaccoApp/view/pages/HomePage.dart';
import 'package:CaccoApp/view/pages/LoginPage.dart';
import 'package:CaccoApp/view/pages/SignupPage.dart';
import 'package:CaccoApp/view/pages/SplashPage.dart';
import 'package:CaccoApp/view/pages/WelcomePage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:CaccoApp/utility/AppColors.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'firebase_options.dart';
import 'helpers/Utils.dart';

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final SharedPreferences prefs = await SharedPreferences.getInstance();
  var isLoggedIn = (prefs.getBool('isLoggedIn') == null) ? false : prefs.getBool('isLoggedIn');

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
            primarySwatch: AppColors.getMaterialColor(AppColors.softBrown),
            useMaterial3: false
          ),
          home: isLoggedIn! ? const HomePage() : const WelcomePage(),
          routes: {
            //'/': (context) => SplashPage(duration: 3, goToPage: '/homepage'),
            '/homepage': (context) => const HomePage(),
            '/welcomepage': (context) => const WelcomePage(),
            '/loginpage': (context) => const LoginPage(),
            '/signuppage': (context) => const SignupPage(),
          }
      )
    )
  );
}