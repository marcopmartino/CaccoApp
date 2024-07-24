import 'package:custom_signin_buttons/button_builder.dart';
import 'package:custom_signin_buttons/button_list.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../helpers/FirebaseAuthHelper.dart';
import '../utility/AppColors.dart';
import '../utility/CaccoTxt.dart';
import '../utility/Validator.dart';
import '../widgets/CustomDecoration.dart';
import 'HomePage.dart';

class LoginPage extends StatefulWidget{
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>{
  final _formKey = GlobalKey<FormState>();

  final _emailTextController = TextEditingController();
  final _passwTextController = TextEditingController();

  bool _isProcessing = false;

  final _focusEmail = FocusNode();
  final _focusPassw = FocusNode();

  Future<void> _showAlertDialog(String error) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context){
        return AlertDialog(
          title: const Text('Errore'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(error),
              ],
            )
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Ok'),
              onPressed: (){
                Navigator.of(context).pop();
              },
            )
          ],
        );
      }
    );
  }

  @override
  Widget build(BuildContext context){
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(title: const Text("Login")),
      body: SingleChildScrollView(
        child: Container(
          height: size.height - 80,
          decoration: const BoxDecoration(
            color: Colors.white,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const SizedBox(height: 70),
                Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.asset(
                      'assets/exemple-poop.png',
                      height: 150.0,
                      width: 150.0,
                    ),
                  ),
                ), //Logo
                const SizedBox(height: 70),
                Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 25.0,
                              right: 25.0,
                              top: 60,
                              bottom: 15
                          ),
                          child: TextFormField(
                              controller: _emailTextController,
                              validator: (value) =>
                                  Validator.validateEmail(email: value),
                              style: const TextStyle(color: Colors.white),
                              decoration: CustomDecoration.loginInputDecoration('Email')
                          ),
                        ), //Email
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 25.0, right: 25.0, top: 15, bottom: 40
                          ),
                          child: TextFormField(
                            controller: _passwTextController,
                            validator: (value) =>
                              Validator.validatePassword(password: value),
                            style: const TextStyle(color: Colors.white),
                            obscureText: true,
                            decoration: CustomDecoration.loginInputDecoration('Password'),
                          )
                        )
                      ],
                    )), //Email&Password
                _isProcessing
                  ? const CircularProgressIndicator():
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          height: 50,
                          width: 100,
                          decoration: BoxDecoration(
                            color: AppColors.problemShit,
                            borderRadius: BorderRadius.circular(30)),
                          child: CustomSignInButton(
                            text: "Accedi",
                            textSize: 18,
                            width: 50,
                            borderRadius: 30,
                            buttonColor: Colors.blue,
                            textColor: Colors.white,
                            customIcon: Icons.login,
                            useGradient: true,
                            setGradient: const LinearGradient(
                                colors: [
                                  AppColors.problemShit, AppColors.softShit],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter
                            ),
                            onPressed: () async {
                              _focusEmail.unfocus();
                              _focusPassw.unfocus();

                              if(_formKey.currentState!.validate()){
                                setState((){
                                  _isProcessing = true;
                                });

                                Object? user =
                                await FirebaseAuthHelper.signInUsingEmailPassword(
                                    email: _emailTextController.text,
                                    password: _passwTextController.text
                                );

                                setState(() {
                                  _isProcessing = false;
                                });

                                print(user);
                                if(user != null && user is User){
                                  if(context.mounted){
                                    Navigator.pushAndRemoveUntil(context,
                                        MaterialPageRoute(
                                            builder: (_) => const HomePage()
                                        ),
                                            (Route route) => false);
                                  }
                                }else{
                                  _showAlertDialog(user as String);
                                }

                              }
                            },
                          ),
                        ),
                        const SizedBox(height: 25),
                        InkWell(
                            onTap: (){
                              if(context.mounted) {
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => const LoginPage()
                                    ));
                              }
                            },
                            child: const Text(
                              CaccoTxt.signUpTxt,
                              style: TextStyle(
                                  color: AppColors.heavyShit,
                                  fontSize: 18.0,
                                  decoration: TextDecoration.underline
                              ),
                            )
                        ), //Signup email button
                      ],
                    )
                ],

          ),
        )
      )
    );
  }
}