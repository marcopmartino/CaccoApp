import 'package:CaccoApp/helpers/LoginService.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:logo_n_spinner/logo_n_spinner.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../helpers/Utils.dart';
import '../../network/CaccoNetwork.dart';
import '../../network/UsersNetwork.dart';
import '../../utility/AppColors.dart';
import '../../utility/DocumentStreamBuilder.dart';
import '../../utility/Navigation.dart';
import '../../utility/Validator.dart';
import '../../widgets/CustomDecoration.dart';
import '../widget/TextWidgets.dart';

class CurrentUserDetailsPage extends StatefulWidget {
  static const String route = 'profileDetails';
  final String userId;
  final String username;

  const CurrentUserDetailsPage({super.key, required this.userId, required this.username});

  @override
  State<CurrentUserDetailsPage> createState() => _CurrentUserDetailsPage();
}

class _CurrentUserDetailsPage extends State<CurrentUserDetailsPage> {

  final _passwTextController = TextEditingController();

  Future _showConfirmDialog() async {

    return showDialog(
        context: context,
        builder: (BuildContext context) {

          void dismissDialog() {
            Navigation.back(context);
          }

          return AlertDialog(
              title: const Text(
                'Sei sicuro di voler eliminare il profilo?\n Quest\' azione è irreversibile.',
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              content: TextFormField(
                controller: _passwTextController,
                validator: (value) =>
                    Validator.validatePassword(password: value),
                style: const TextStyle(color: Colors.black),
                obscureText: true,
                decoration: CustomDecoration.loginInputDecoration('Inserire la password per confermare'),
              ),
              actionsPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              actionsAlignment: MainAxisAlignment.center,
              actions: [
                ElevatedButton(
                  style: ButtonStyle(
                    shadowColor: WidgetStateProperty.all<Color>(Colors.black),
                    elevation: WidgetStateProperty.all<double>(5.0),
                    backgroundColor: WidgetStateProperty.all<Color>(Colors.white),
                    shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    ),
                  ),
                  onPressed: () {
                    dismissDialog();
                  },
                  child: const Text('Annulla', style: TextStyle(color: Colors.black),)
                ),
                const SizedBox(width: 15,),
                ElevatedButton(
                  style: ButtonStyle(
                    shadowColor: WidgetStateProperty.all<Color>(Colors.black),
                    elevation: WidgetStateProperty.all<double>(5.0),
                    backgroundColor: WidgetStateProperty.all<Color>(Colors.red),
                    shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    ),
                  ),
                  onPressed:  () {
                    dismissDialog();
                    try{
                      LoginService.deleteUser(widget.userId, _passwTextController.text);
                      Navigation.removeUntil(context, '/welcomepage');
                    }catch (e){
                      if (kDebugMode) {
                        print(e);
                      }
                    }
                  },
                  child: const Text('Conferma', style: TextStyle(color: Colors.black))),
              ]);
        });
  }

  void _launchURL(Uri url) async {
    if(!await launchUrl(url)){
      throw Exception('nop');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBlack,
      appBar: Utils.getAppbarProfile(context),
      body: DocumentStreamBuilder(
        stream: CaccoNetwork.getCaccosInfo(null),
        builder: (BuildContext builder, DocumentSnapshot<Object?> caccosInfo) {
          return FutureBuilder(
            future: UsersNetwork.getUserDetails(widget.userId),
            builder: (BuildContext builder, AsyncSnapshot<DocumentSnapshot> userDetails) {
              if (userDetails.connectionState == ConnectionState.waiting) {
                //Caricamento
                return const Center(
                  child: LogoandSpinner(
                    imageAssets: 'assets/temp-image.jpg',
                    reverse: true,
                    arcColor: AppColors.mainBrown,
                    spinSpeed: Duration(milliseconds: 500),
                  )
                );
              } else {
                if (userDetails.hasError) {
                  return Center(child: Text('Errore: ${userDetails.error}'));
                } else {
                  return Padding(
                    padding: const EdgeInsets.only(top: 15, right: 5, left: 5, bottom: 10),
                    child: Column(
                      children: <Widget>[
                        Card(
                          margin: const EdgeInsets.fromLTRB(15.0, 5.0, 15.0, 5.0),
                          clipBehavior: Clip.antiAlias,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Center(
                                    child: TextWidget(
                                      userDetails.data!['username'].toString(),
                                      fontSize: 20,
                                    )
                                  ), //Username
                                  const SizedBox(height: 10),
                                  Row(
                                    children: [
                                      Expanded(
                                        flex: 1,
                                          child: Center(
                                            child: RichText(
                                              textAlign: TextAlign.center,
                                                text: TextSpan(
                                                  children: <TextSpan>[
                                                    TextSpan(
                                                      text: "${caccosInfo['currentMonthPoops'].toString()}\n",
                                                      style: const TextStyle(
                                                      fontSize: 18,
                                                      fontWeight: FontWeight.bold,
                                                      color: Colors.black)
                                                    ), //Numero cacchi
                                                    TextSpan(
                                                      text: "Cacco a ${Utils.getCurrentMonth()}",
                                                      style: const TextStyle(fontSize: 14, color: Colors.black),
                                                    )//Mese corrente
                                                  ]
                                                )
                                            )
                                          )
                                      ), //Cacco mese corrente
                                      Expanded(
                                        flex: 1,
                                        child: Center(
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(8.0),
                                            child: Image.asset('assets/exemple-poop.png', height: 90.0, width: 90.0),
                                          )
                                        )
                                      ), //Immagine profilo
                                      Expanded(
                                        flex: 1,
                                        child: Center(
                                          child: RichText(
                                            textAlign: TextAlign.center,
                                            text: TextSpan(
                                              children: <TextSpan>[
                                                TextSpan(
                                                  text: "${Utils.translateGender(userDetails.data!['gender'].toString())}\n",
                                                  style: const TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black)
                                                ),
                                                const TextSpan(
                                                  text: " Genere",
                                                  style: TextStyle(fontSize: 14, color: Colors.black),
                                                )
                                              ]
                                            )
                                          )
                                        )
                                      )  //Genere
                                    ]
                                  ),
                                  const SizedBox(height: 10),
                                ]// Immagine profilo e prime info
                            ),
                          )
                        ),
                        const SizedBox(height: 30),
                        ElevatedButton(
                          onPressed: (){
                            _showConfirmDialog();
                          },
                          style: ButtonStyle(
                            shadowColor: WidgetStateProperty.all<Color>(Colors.black),
                            elevation: WidgetStateProperty.all<double>(5.0),
                            backgroundColor: WidgetStateProperty.all<Color>(Colors.red),
                            shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                            ),
                          ),
                          child: const Text('Elimina profilo', style: TextStyle(color: Colors.white),),
                        ),
                        const SizedBox(height: 30),
                        ElevatedButton(
                          onPressed: (){
                            _launchURL(Uri.parse('https://forms.gle/ndAYvMA2w5SFcGHL6'));
                          },
                          style: ButtonStyle(
                            shadowColor: WidgetStateProperty.all<Color>(Colors.black),
                            elevation: WidgetStateProperty.all<double>(5.0),
                            backgroundColor: WidgetStateProperty.all<Color>(Colors.blue),
                            shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                            ),
                          ),
                          child: const Text('Lascia un feedback', style: TextStyle(color: Colors.black),),
                        )
                      ],
                    )
                  );
                }}}
            );
          },
        )
    );
  }
}