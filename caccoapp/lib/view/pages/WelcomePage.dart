import 'package:custom_signin_buttons/button_builder.dart';
import 'package:custom_signin_buttons/button_data.dart';
import 'package:custom_signin_buttons/button_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'package:CaccoApp/view/pages/HomePage.dart';
import 'package:CaccoApp/view/pages/SignupPage.dart';
import 'package:CaccoApp/utility/AppColors.dart';
import 'package:CaccoApp/utility/CaccoTxt.dart';
import 'package:CaccoApp/helpers/LoginService.dart';
import 'package:CaccoApp/utility/Navigation.dart';
import 'LoginPage.dart';

class WelcomePage extends StatefulWidget{
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage>{

  Future<void> _showAlertDialog(String error) async{
    return showDialog<void>(
        context: context,
        barrierDismissible: false, //user must tap button!
        builder: (BuildContext context){
          return AlertDialog(
            title: const Text('Errore'),
            content: Text(error),
            actions: <Widget>[
              TextButton(
                child: const Text("Ok"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        }
    );
  }

  @override
  Widget build(BuildContext context){
    LoginService loginService = Provider.of<LoginService>(context, listen: false);

    return Scaffold(
        body: Stack(
          children: [
            Positioned.fill(
                child: Opacity(
                  opacity: 0.3,
                  child: Image.asset(
                      'assets/exemple-poop.png',
                      fit: BoxFit.cover),
                )
            ),
            Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: Image.asset(
                          'assets/exemple-poop.png',
                          height: 150.0,
                          width: 150.0,
                        ),
                      ),
                    ),
                    const SizedBox(height: 50),
                    const Text(
                        CaccoTxt.welcomeTxt1,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 40,
                            fontWeight: FontWeight.bold
                        )
                    ),
                    const SizedBox(height: 40),
                    const Text(
                        CaccoTxt.welcomeTxt2,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 18
                        )
                    ),
                    const SizedBox(height: 40),
                    CustomSignInButton(
                        text: "Accedi con Email",
                        borderRadius: 25,
                        useGradient: true,
                        setGradient: const LinearGradient(
                            colors: [Colors.cyan, Colors.indigo]
                        ),
                        width: 300,
                        textSize: 18,
                        customIcon: Icons.mail_rounded,
                        iconColor: Colors.white,
                        textColor: Colors.white,
                        splashColor: Colors.transparent,
                        onPressed: (){
                          Navigation.navigate(context, const LoginPage());
                        }
                    ), //Email login button
                    const SizedBox(height: 20),
                    SignInButton(
                      button: Button.Google,
                      width: 300,
                      borderRadius: 25,
                      textSize: 18,
                      text: CaccoTxt.googleLogin,
                      onPressed: ()  async {
                        try {
                          bool success = await loginService.signInWithGoogle();

                          if (success) {
                            if (context.mounted) {
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => const HomePage()
                                  ),
                                      (Route route) => false);
                            }
                          } else {
                            _showAlertDialog("Errore login!");
                          }
                        } on PlatformException{
                          print('PlatformExpection');
                        }
                      },
                      splashColor: Colors.transparent,
                    ), //Google login button
                    const SizedBox(height: 20),
                    InkWell(
                        onTap: (){
                          Navigation.navigate(context, const SignupPage());
                        },
                        child: const Text(
                          CaccoTxt.signUpTxt,
                          style: TextStyle(
                              color: AppColors.mainBrown,
                              fontSize: 18.0,
                              decoration: TextDecoration.underline
                          ),
                        )
                    ), //Signup email button
                  ],
                )
            )
          ],
        )
    );
  }
}