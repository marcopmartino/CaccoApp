import 'package:CaccoApp/utility/DocumentStreamBuilder.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:logo_n_spinner/logo_n_spinner.dart';

import '../../helpers/Utils.dart';
import '../../network/CaccoNetwork.dart';
import '../../utility/AppColors.dart';
import '../../utility/Navigation.dart';
import '../widget/TextWidgets.dart';
import 'CaccoFormPage.dart';

class CaccoDetailsPage extends StatefulWidget {
  static const String route = 'caccoDetails';
  final String caccoId;
  final String caccoName;

  const CaccoDetailsPage(
      {super.key, required this.caccoId, required this.caccoName});

  @override
  State<CaccoDetailsPage> createState() => _CaccoDetailsPage();
}

class _CaccoDetailsPage extends State<CaccoDetailsPage> {
  String chefId = FirebaseAuth.instance.currentUser!.uid;

  bool _isProcessing = false;

  void startLoadingAnimation(){
    setState(() {
      _isProcessing = true;
    });
  }

  @override
  Widget build(BuildContext context) {

    if(_isProcessing){
      return const Scaffold(
        backgroundColor: AppColors.lightBlack,
        body: Center(
          child: LogoandSpinner(
            imageAssets: 'assets/temp-image.jpg',
            reverse: true,
            arcColor: AppColors.mainBrown,
            spinSpeed: Duration(milliseconds: 500),
          )
        )
      );
    }else{
      return Scaffold(
        backgroundColor: AppColors.lightBlack,
        appBar: Utils.getAppbarCacco(context),
        body: DocumentStreamBuilder(
            stream: CaccoNetwork.getCaccoById(widget.caccoId, chefId),
            builder: (BuildContext builder, DocumentSnapshot<Object?> caccoDetails) {
              var date = caccoDetails['timeStamp'].substring(0,11);
              return Padding(
                  padding: const EdgeInsets.only(top: 15, right: 5, left: 5, bottom: 10),
                  child: Column(
                    children: <Widget>[
                      Card(
                          margin:const EdgeInsets.fromLTRB(15.0, 5.0, 15.0, 5.0),
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
                                        caccoDetails['name'].toString() != '' ?
                                        caccoDetails['name'].toString() : "Cacco del $date",
                                        fontSize: 20,)
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
                                                              text: "${caccoDetails['caccoType'].toString()}\n",
                                                              style: const TextStyle(
                                                                  fontSize: 18,
                                                                  fontWeight: FontWeight.bold,
                                                                  color: Colors.black)),
                                                          const TextSpan(
                                                            text: "Consistenza",
                                                            style: TextStyle(
                                                                fontSize: 14,
                                                                color: Colors.black),
                                                          ) //Consistenza
                                                        ]
                                                    )
                                                )
                                            )
                                        ), //Consistenza
                                        Expanded(
                                            flex: 1,
                                            child: Center(
                                                child: ClipRRect(
                                                  borderRadius: BorderRadius.circular(8.0),
                                                  child: Image.asset(
                                                      'assets/exemple-poop.png',
                                                      height: 90.0,
                                                      width: 90.0),
                                                )
                                            )
                                        ), //Immagine Cacco
                                        Expanded(
                                            flex: 1,
                                            child: Center(
                                                child: RichText(
                                                    textAlign: TextAlign.center,
                                                    text: TextSpan(
                                                        children: <TextSpan>[
                                                          TextSpan(
                                                              text: "${caccoDetails['caccoQuantity'].toString()}\n",
                                                              style: const TextStyle(
                                                                  fontSize: 18,
                                                                  fontWeight: FontWeight.bold,
                                                                  color: Colors.black)
                                                          ),
                                                          const TextSpan(
                                                            text: "Quantità",
                                                            style: TextStyle(
                                                                fontSize: 14,
                                                                color:Colors.black),
                                                          )
                                                        ]
                                                    )
                                                )
                                            )
                                        ) //Quantità
                                      ]
                                  ),
                                  const SizedBox(height: 25),
                                  Center(
                                      child: RichText(
                                          textAlign: TextAlign.center,
                                          text: TextSpan(
                                              children: <TextSpan>[
                                                const TextSpan(
                                                    text: "Chef: ",
                                                    style: TextStyle(
                                                        fontSize: 18,
                                                        color: Colors.black)
                                                ),
                                                TextSpan(
                                                    text: "${caccoDetails['chefUsername'].toString()}\n",
                                                    style: const TextStyle(
                                                        fontSize: 18,
                                                        fontWeight: FontWeight.bold,
                                                        color: Colors.black)),
                                                const TextSpan(
                                                  text: "Cacco effettuato il: ",
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.black),
                                                ), //Consistenza
                                                TextSpan(
                                                  text: "${caccoDetails['timeStamp'].toString()}\n",
                                                  style: const TextStyle(
                                                      fontSize: 14,
                                                      fontWeight: FontWeight.bold,
                                                      color: Colors.black),
                                                ) //Eta
                                              ]
                                          )
                                      )
                                  ), //Chef e data cacco
                                  const SizedBox(height: 25),
                                  caccoDetails['description'] != '' ? (
                                    Center(
                                        child: RichText(
                                            textAlign: TextAlign.center,
                                            text:
                                            TextSpan(
                                                text: "${caccoDetails['description'].toString()}\n",
                                                style: const TextStyle(
                                                    fontSize: 18,
                                                    color: Colors.black)),
                                        )
                                    )
                                  ): const Center(
                                      child: Text(
                                        "Nessuna descrizione",
                                        style: TextStyle(
                                            fontSize: 18,
                                            color: Colors.black),
                                      )
                                  ),
                                  const SizedBox(height: 25),
                                  Row(
                                    children: [
                                      Expanded(
                                        flex: 2,
                                        child: openEditButton(context),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: deleteButton(context),
                                      )
                                    ],
                                  )
                                ] // Immagine profilo e prime info
                            ),
                          )
                      ),
                    ],
                  )
              );
            }),
      );
    }
  }

  Widget openEditButton(BuildContext context){
    return Center(
        child: ElevatedButton(
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
            Navigation.navigateFromLeft(context,
                CaccoFormPage.edit(caccoId: widget.caccoId));
          },
          child: const Text(
            'Modifica cacco',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
              color: Colors.black
            )
          ),
        )
    );
  }

  // Button per eliminare un cacco
  Widget deleteButton(BuildContext context){

    return Center(
      child: ElevatedButton(
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
        onPressed: () async{
          showDialog(context: context, builder: (dialogContext) {

            void dismissDialog(){
              Navigation.back(context);
            }

            return AlertDialog(
              title: const Text('Conferma eliminazione'),
              content: const Text('Sei sicuro di voler eliminare questo cacco?'),
              actionsPadding: const EdgeInsets.symmetric(horizontal: 16),
              actionsAlignment: MainAxisAlignment.spaceAround,
              actions: [
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
                  onPressed: () async {
                    Navigator.pop(dialogContext);
                    startLoadingAnimation();

                    //Elimino cacco
                    await CaccoNetwork.deleteCacco(widget.caccoId).then((_){
                      Future.delayed(const Duration(seconds: 1), () =>{
                        if(context.mounted) Navigator.pop(context)
                      });
                    });

                  },
                  child: const Text(
                    'Si',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18)
                  ),
                ), //Conferma
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
                  onPressed: (){
                    dismissDialog();
                  },
                  child: const Text(
                      'No',
                      style: TextStyle(color: AppColors.mainBrown, fontSize: 18)),
                ) //Rifiuta
              ],
            );

          });
        },
        child: const Text(
          "Elimina cacco",
          style: TextStyle(
            fontSize: 18,
            color: Colors.white
          ),
        ))
    );
  }
}
