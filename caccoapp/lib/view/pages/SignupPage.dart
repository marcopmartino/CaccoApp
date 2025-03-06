import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:logo_n_spinner/logo_n_spinner.dart';
import 'package:radio_group_v2/radio_group_v2.dart';

import 'package:CaccoApp/network/ProfileNetwork.dart';
import 'package:CaccoApp/view/widget/CustomButton.dart';
import 'package:CaccoApp/helpers/LoginService.dart';
import 'package:CaccoApp/utility/AppColors.dart';
import 'package:CaccoApp/utility/CaccoTxt.dart';
import 'package:CaccoApp/utility/Navigation.dart';
import 'package:CaccoApp/utility/Validator.dart';
import 'package:CaccoApp/view/widget/CustomDecoration.dart';
import 'HomePage.dart';
import 'LoginPage.dart';

enum Genders { male, female, other, none}
Genders _genders = Genders.none;

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  static const route = '/signupage';

  @override
  State<SignupPage> createState() => _SignupPageState();
}


class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();

  final _usernameController = TextEditingController();
  final _genderController = RadioGroupController();
  final _emailTextController = TextEditingController();
  final _passwTextController = TextEditingController();
  final _confirmPasswTextController = TextEditingController();

  bool _isProcessing = false;

  final _focusUsername = FocusNode();
  final _focusEmail = FocusNode();
  final _focusPassw = FocusNode();
  final _focusConfirmPassw = FocusNode();

  Genders translateGender(String value) {
    switch (value) {
      case 'Uomo':
        return Genders.male;
      case 'Donna':
        return Genders.female;
      case 'Altro':
        return Genders.other;
      default:
        return Genders.none;
    }
  }

  Future<void> _showAlertDialog(String error) async {
    return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(error),
            content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    Text(error),
                  ],
                )),
            actions: <Widget>[
              TextButton(
                child: const Text('Ok'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
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
                    )),
                child: Stack(
                  children: <Widget>[
                    Center(
                      child: ListView(
                        children: <Widget>[
                          const SizedBox(height: 80),
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
                          Form(
                              key: _formKey,
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 25.0, right: 25.0, top: 60.0, bottom: 15.0),
                                    child: TextFormField(
                                      focusNode: _focusUsername,
                                      controller: _usernameController,
                                      validator: (value) =>
                                          Validator.validateUsername(username: value),
                                      style: const TextStyle(color: Colors.black),
                                      decoration: CustomDecoration.loginInputDecoration('Username'),
                                    ),
                                  ), //Username
                                  Padding(
                                      padding: const EdgeInsets.only(
                                          left: 25.0, right: 25.0, top: 15.0, bottom:15.0),
                                      child: Column(
                                        children: <Widget>[
                                          const Text(
                                            CaccoTxt.genderLabel,
                                            style: TextStyle(color: Colors.black, fontSize: 18.0),
                                          ), //GenderLabel
                                          const SizedBox(height: 15),
                                          RadioGroup(
                                            controller: _genderController,
                                            values: const ["Altro", "Uomo", "Donna"],
                                            indexOfDefault: 0,
                                            orientation: RadioGroupOrientation.horizontal,
                                            decoration: const RadioGroupDecoration(
                                                spacing: 10.0,
                                                labelStyle: TextStyle(
                                                  color: Colors.black,
                                                ),
                                                activeColor: AppColors.mainBrown
                                            ),
                                          ),
                                        ],
                                      )
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 25.0, right: 25.0, top: 15.0, bottom: 15.0),
                                    child: TextFormField(
                                        focusNode: _focusEmail,
                                        controller: _emailTextController,
                                        validator: (value) => Validator.validateEmail(email: value),
                                        style: const TextStyle(color: Colors.black),
                                        decoration: CustomDecoration.loginInputDecoration('Email')),
                                  ), //Email
                                  Padding(
                                      padding: const EdgeInsets.only(
                                          left: 25.0, right: 25.0, top: 15, bottom: 15),
                                      child: TextFormField(
                                        controller: _passwTextController,
                                        validator: (value) =>
                                            Validator.validatePassword(password: value),
                                        style: const TextStyle(color: Colors.black),
                                        obscureText: true,
                                        decoration:
                                        CustomDecoration.loginInputDecoration('Password'),
                                      )), //Password
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 25.0, right: 25.0, top: 15, bottom: 40),
                                    child: TextFormField(
                                        controller: _confirmPasswTextController,
                                        validator: (value) => Validator.validateEqualPassword(
                                            password: _passwTextController.text,
                                            chkPassword: value),
                                        style: const TextStyle(color: Colors.black),
                                        obscureText: true,
                                        decoration: CustomDecoration.loginInputDecoration(
                                            CaccoTxt.confirmPassw)
                                    ),
                                  ), //Conferma password
                                ],
                              )), //Email&Password
                          _isProcessing
                            ? const Center(
                              child: LogoandSpinner(
                                imageAssets: 'assets/temp-image.jpg',
                                reverse: true,
                                arcColor: AppColors.mainBrown,
                                spinSpeed: Duration(milliseconds: 500),
                              )
                            )
                          : Column(
                            children: [
                              CustomElevatedIconButton(
                                  height: 50,
                                  width: 150,
                                  onPressed: () async {
                                    _focusUsername.unfocus();
                                    _focusEmail.unfocus();
                                    _focusPassw.unfocus();
                                    _focusConfirmPassw.unfocus();

                                    if (_formKey.currentState!.validate()) {
                                      setState(() {
                                        _isProcessing = true;
                                      });

                                      Object? user =
                                      await LoginService.signUpUsingEmailPassword(
                                          email: _emailTextController.text,
                                          password: _passwTextController.text);

                                      if (user != null && user is User) {
                                        _genders = translateGender(_genderController.value);
                                        Object? result = await ProfileNetwork.addUser(
                                            id: user.uid,
                                            username: _usernameController.text,
                                            email: _emailTextController.text,
                                            groups: [],
                                            gender: _genders.name);

                                        if (result == null) {
                                          if (context.mounted) {
                                            Navigator.pushAndRemoveUntil(context,
                                                MaterialPageRoute(
                                                    builder: (_) => const HomePage()
                                                ),
                                                    (Route route) => false);
                                          }
                                        } else {
                                          _showAlertDialog(result as String);
                                        }
                                      } else {
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
                                  borderRadius: BorderRadius.circular(25.0)),
                              const SizedBox(height: 25),
                              InkWell(
                                  onTap: () {
                                    Navigation.navigateFromLeft(context, const LoginPage());
                                  },
                                  child: const Text(
                                    CaccoTxt.loginLabel,
                                    style: TextStyle(
                                        color: AppColors.heavyBrown,
                                        fontSize: 18.0,
                                        decoration: TextDecoration.underline),
                                  )),
                              const SizedBox(height: 25)//Signup email button
                            ],
                          )
                        ],
                      ),
                    )
                  ],
                ))));
  }
}