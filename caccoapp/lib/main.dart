import 'package:CaccoApp/helpers/LoginService.dart';
import 'package:CaccoApp/pages/HomePage.dart';
import 'package:CaccoApp/pages/LoginPage.dart';
import 'package:CaccoApp/pages/SignupPage.dart';
import 'package:CaccoApp/pages/SplashPage.dart';
import 'package:CaccoApp/pages/WelcomePage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:CaccoApp/utility/AppColors.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';
import 'helpers/Utils.dart';

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

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
              primarySwatch: AppColors.getMaterialColor(Colors.brown)
          ),
          initialRoute: '/welcomepage',
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