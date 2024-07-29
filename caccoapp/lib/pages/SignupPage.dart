import 'package:CaccoApp/network/ProfileNetwork.dart';
import 'package:CaccoApp/widgets/CustomButton.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../helpers/LoginService.dart';
import '../utility/AppColors.dart';
import '../utility/CaccoTxt.dart';
import '../utility/Navigation.dart';
import '../utility/Validator.dart';
import '../widgets/CustomDecoration.dart';
import 'HomePage.dart';
import 'LoginPage.dart';

enum Genders {male, female, other}

class SignupPage extends StatefulWidget{
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage>{
  final _formKey = GlobalKey<FormState>();

  Genders _genders = Genders.male;

  final _usernameController = TextEditingController();
  final _emailTextController = TextEditingController();
  final _passwTextController = TextEditingController();
  final _confirmPasswTextController = TextEditingController();

  bool _isProcessing = false;

  final _focusUsername = FocusNode();
  final _focusEmail = FocusNode();
  final _focusPassw = FocusNode();
  final _focusConfirmPassw = FocusNode();

  Future<void> _showAlertDialog(String error) async {
    return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context){
          return AlertDialog(
            title: Text(error),
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
          title: const Text(CaccoTxt.signupAppbar),
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
                                      top: 60.0,
                                      bottom: 15.0
                                    ),
                                    child: TextFormField(
                                      controller: _usernameController,
                                      validator: (value) =>
                                          Validator.validateUsername(username: value),
                                      style: const TextStyle(color: Colors.white),
                                      decoration: CustomDecoration.loginInputDecoration('Username'),
                                    ),
                                  ), //Username
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      left: 25.0,
                                      right: 25.0,
                                      top: 15.0,
                                      bottom: 15.0
                                    ),
                                    child: Row(
                                      children: <Widget>[
                                        const Text(
                                          CaccoTxt.genderLabel,
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 14.0
                                          ),
                                        ),
                                        RadioListTile<Genders>(
                                          title: const Text(
                                            CaccoTxt.maleTxt,
                                            style: TextStyle(color: Colors.white),
                                          ),
                                          value: Genders.male,
                                          groupValue: _genders,
                                          onChanged: (Genders? value) {
                                            _genders = value!;
                                          },
                                        ), //Male gender
                                        RadioListTile<Genders>(
                                          title: const Text(
                                            CaccoTxt.femaleTxt,
                                            style: TextStyle(color: Colors.white),
                                          ),
                                          value: Genders.female,
                                          groupValue: _genders,
                                          onChanged: ((Genders? value) {
                                            _genders = value!;
                                          }),
                                        ), //Female gender
                                        RadioListTile<Genders>(
                                          title: const Text(
                                            CaccoTxt.otherTxt,
                                            style: TextStyle(color: Colors.white),
                                          ),
                                          value: Genders.other,
                                          groupValue: _genders,
                                          onChanged: ((Genders? value) {
                                            _genders = value!;
                                          }),
                                        ), //Other gender
                                      ],
                                    ),
                                  ), //Gender
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 25.0,
                                        right: 25.0,
                                        top: 15.0,
                                        bottom: 15.0
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
                                          left: 25.0, right: 25.0, top: 15, bottom: 15
                                      ),
                                      child: TextFormField(
                                        controller: _passwTextController,
                                        validator: (value) =>
                                            Validator.validatePassword(password: value),
                                        style: const TextStyle(color: Colors.white),
                                        obscureText: true,
                                        decoration: CustomDecoration.loginInputDecoration('Password'),
                                      )
                                  ), //Password
                                  Padding(
                                      padding: const EdgeInsets.only(
                                          left: 25.0, right: 25.0, top: 15, bottom: 40
                                      ),
                                      child: TextFormField(
                                        controller: _confirmPasswTextController,
                                        validator: (value) =>
                                            Validator.validateEqualPassword(
                                                password: _passwTextController.text,
                                                chkPassword: value),
                                        style: const TextStyle(color: Colors.white),
                                        obscureText: true,
                                        decoration: CustomDecoration.loginInputDecoration(CaccoTxt.confirmPassw),
                                      )
                                  ),
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
                                    _focusUsername.unfocus();
                                    _focusEmail.unfocus();
                                    _focusPassw.unfocus();
                                    _focusConfirmPassw.unfocus();

                                    if(_formKey.currentState!.validate()){
                                      setState((){
                                        _isProcessing = true;
                                      });

                                      Object? user =
                                      await LoginService.signUpUsingEmailPassword(
                                          email: _emailTextController.text,
                                          password: _passwTextController.text
                                      );

                                      if(user != null && user is User){
                                        Object? result = await ProfileNetwork.addUser(
                                          username: _usernameController.text,
                                          email: _emailTextController.text,
                                          gender: _genders.name
                                        );

                                        if(result == null){
                                          if(context.mounted){
                                            Navigator.push(context,
                                                MaterialPageRoute(builder: (_) => const HomePage()));
                                          }
                                        }else{
                                          _showAlertDialog(result as String);
                                        }
                                      }else{
                                        _showAlertDialog(user as String);
                                      }

                                      setState(() {
                                        _isProcessing = false;
                                      });

                                    }
                                  },
                                  icon: const Icon(Icons.app_registration),
                                  label: const Text(
                                    CaccoTxt.signupButton,
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
                                    Navigation.navigate(context, const LoginPage());
                                  },
                                  child: const Text(
                                    CaccoTxt.loginLabel,
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