import 'package:CaccoApp/widgets/CustomButton.dart';
import 'package:custom_signin_buttons/button_builder.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../helpers/LoginService.dart';
import '../utility/AppColors.dart';
import '../utility/CaccoTxt.dart';
import '../utility/Navigation.dart';
import '../utility/Validator.dart';
import '../widgets/CustomDecoration.dart';
import 'HomePage.dart';
import 'SignupPage.dart';

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
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text(CaccoTxt.loginAppbar),
      ),
      body: SingleChildScrollView(
        child: Container(
          width: size.width,
          height: size.height,
          decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                  'assets/exemple-poop.png',
                ),
                fit: BoxFit.cover,
                opacity: 0.3,
              )
          ),
          child: Stack(
            children: <Widget>[
              Center(
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
                      children: [
                        CustomElevatedIconButton(
                            height: 50,
                            width: 150,
                            onPressed: () async {
                              _focusEmail.unfocus();
                              _focusPassw.unfocus();

                              if(_formKey.currentState!.validate()){
                                setState((){
                                  _isProcessing = true;
                                });

                                Object? user =
                                await LoginService.signInUsingEmailPassword(
                                    email: _emailTextController.text,
                                    password: _passwTextController.text
                                );

                                setState(() {
                                  _isProcessing = false;
                                });
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
                            icon: const Icon(Icons.login),
                            label: const Text(
                              "Accedi",
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                              ),
                            ),
                            borderRadius: BorderRadius.circular(25.0)
                        ),
                        const SizedBox(height: 25),
                        InkWell(
                            onTap: (){
                              Navigation.navigate(context, const SignupPage());
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
            ],
          )
        )
      )
    );
  }
}