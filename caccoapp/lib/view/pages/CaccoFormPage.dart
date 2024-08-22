import 'package:CaccoApp/utility/Extensions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:CaccoApp/view/widget/CustomButton.dart';
import 'package:CaccoApp/view/widget/TextWidgets.dart';

import 'package:CaccoApp/models/Cacco.dart';
import 'package:CaccoApp/utility/AppColors.dart';
import 'package:CaccoApp/utility/Navigation.dart';

import 'package:CaccoApp/network/CaccoNetwork.dart';
import 'package:flutter/painting.dart';
import 'package:intl/intl.dart';

import '../../utility/AppFontWeight.dart';
import '../widget/CustomScaffold.dart';

class CaccoFormPage extends StatefulWidget {
  CaccoFormPage({super.key}) {
    newCacco = true;
  }

  static const String route = 'caccoForm';

  CaccoFormPage.edit({super.key, required this.caccoId}) {
    newCacco = false;
  }

  late final String? caccoId;
  late final bool newCacco;

  @override
  State<CaccoFormPage> createState() => _CaccoFormState();
}

class _CaccoFormState extends State<CaccoFormPage> {
  final _formKey = GlobalKey<FormState>();

  final _nameTextController = TextEditingController();
  final _descriptionTextController = TextEditingController();
  var _caccoType = "";
  var _caccoQuantity = "";

  bool _isProcessing = false;

  final List<String> caccoTypeName = [
    'Falso allarme',
    'Pops',
    'Fiocchi di latte',
    'Salsiccia',
    'Serpente',
    'Blob',
    'Fiocchi di neve',
    'Liquida',
  ];
  final List<String> caccoQuantityName = [
    "Bambino",
    "Poca",
    "Normale",
    "Abbondante",
    "Eccessiva"
  ];

  late DocumentSnapshot<Object?> _oldData;

  final _focusNome = FocusNode();
  final _focusDescription = FocusNode();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    String title = widget.newCacco ? 'Aggiungi cacco' : 'Modifica cacco';
    if (_isProcessing) {
      return CustomScaffold(
          title: title,
          body: const Center(
              child: CircularProgressIndicator(
            color: AppColors.mainBrown,
          )));
    } else /*if(widget.newCacco)*/ {
      return CustomScaffold(
          title: title,
          withAppbar: true,
          body: SingleChildScrollView(
            child: SizedBox(
              height: size.height,
              width: size.width,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Flexible(
                    fit: FlexFit.tight,
                    child: formBody(),
                  ),
                  const SizedBox(height: 40),
                  createButton(context)
                ],
              ),
            ),
          ));
    } /* else if (_initializationCompleted) {
      return CustomScaffold(
          title: title,
          body: SizedBox(
            height: size.height-80,
            width: size.width,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Flexible(
                  fit: FlexFit.loose,
                  child: formBody(),
                ),
                editButton(context),
                deleteButton(context)
              ],
            ),
          )
      );
    }else {
      return CustomScaffold(
          title: title,
          body: DocumentStreamBuilder(
            stream: CaccoNetwork.getCaccoById(widget.caccoId!),
            builder: (BuildContext builder, DocumentSnapshot<Object?> data){
              _nameTextController.text = data['nome'];
              _descriptionTextController.text = data['description'];
              _caccoTypeTextController.text = data['caccoType'];
              print(_misuraTextController.text);
              _dateTextController.text = data['scadenza'];
              if(_dateTextController.text != '--/--/----') _noExpire = false;
              _initializationCompleted = true;

              _oldData = data;

              return SingleChildScrollView(
                  child: SizedBox(
                      height: size.height-80,
                      width: size.width,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Flexible(
                            fit: FlexFit.loose,
                            child: formBody(),
                          ),
                          editButton(context),
                          deleteButton(context),
                        ],
                      )
                  )
              );
            },
          )
      );
    }*/
  }

  Widget formBody() {
    bool necessary = true;

    return Form(
        key: _formKey,
        child: Column(
          children: [
            Flexible(
              flex: 0,
              child: Padding(
                padding: const EdgeInsets.only(left: 25, right: 25, top: 40, bottom: 40),
                child: TextFormFieldWidget(
                    controller: _nameTextController,
                    label: 'Nome',
                    hint: 'Inserire nome (opzionale)'),
              ),
            ), //Nome
            Flexible(
              flex: 0,
              child: Padding(
                  padding: const EdgeInsets.only(left: 25, right: 25, top: 15, bottom: 0),
                  child: TextFormFieldWidget(
                      controller: _descriptionTextController,
                      label: 'Descrizione',
                      hint: 'Inserire descrizione opzionale')),
            ), //Descrizione
            const SizedBox(height: 40),
            const Flexible(
                flex: 0,
                child: Text(
                  'Tipo di cacco',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: AppFontWeight.semiBold,
                      color: AppColors.mainBrown),
                )
            ), //Tipo di cacco txt
            Flexible(
              child: SizedBox(
                height: 150,
                width: MediaQuery.of(context).size.width,
                child: ListView.separated(
                    shrinkWrap: true,
                    separatorBuilder: (context,index) => const SizedBox(width: 10,),
                    scrollDirection: Axis.horizontal,
                    itemCount: caccoTypeName.length,
                    itemBuilder: (context, index) => Container(
                        height: 150,
                        width: 150,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                                fit: BoxFit.cover,
                                image: AssetImage('assets/temp-image.jpg')
                            ),
                          shape: BoxShape.circle,
                        ),
                        child: RadioListTile(
                          contentPadding: const EdgeInsets.only(left:5, right: 5, top: 0, bottom: 10),
                          title: Text(caccoTypeName[index]),
                          value: caccoTypeName[index],
                          groupValue: _caccoType,
                          enableFeedback: false,
                          onChanged: (value) {
                            setState(() {
                              _caccoType = value.toString();
                              if(value.toString() == "Falso allarme"){
                                necessary = false;
                                _caccoQuantity = "";
                              }else{
                                necessary = true;
                              }
                            });
                          },
                        ),
                    )),
              )

            ),//Tipo di cacco listview
            const SizedBox(height: 40),
            const Flexible(
                flex: 0,
                child: Text(
                  'Quantità di cacco',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: AppFontWeight.semiBold,
                      color: AppColors.mainBrown),
                )
            ), //Quantità cacco txt
            Flexible(
                child: SizedBox(
                  height: 150,
                  width: MediaQuery.of(context).size.width,
                  child: ListView.separated(
                      shrinkWrap: true,
                      separatorBuilder: (context,index) => const SizedBox(width: 10,),
                      scrollDirection: Axis.horizontal,
                      itemCount: caccoQuantityName.length,
                      itemBuilder: (context, index) => Container(
                        height: 150,
                        width: 150,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: AssetImage('assets/temp-image.jpg')
                          ),
                          shape: BoxShape.circle,
                        ),
                        child: RadioListTile(
                          contentPadding: const EdgeInsets.only(left:5, right: 5, top: 0, bottom: 10),
                          title: Text(caccoQuantityName[index]),
                          value: caccoQuantityName[index],
                          groupValue: _caccoQuantity,
                          onChanged: (value) {
                            setState(() {
                              _caccoQuantity = value.toString();
                            });
                          },
                          toggleable: necessary,
                        ),
                      )),
                )

            ),//Quantità cacco listview
          ],
        ));
  }

  // Button per creare un nuovo prodotto
  Widget createButton(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(bottom: 200),
        child: CustomButtons.submit(
          'Aggiungi cacco',
          onPressed: () async {
            _focusNome.unfocus();
            _focusDescription.unfocus();

            if (_formKey.currentState!.validate()) {
              setState(() {
                _isProcessing = true;
              });

              var now = DateTime.now();
              var formatter = DateFormat('dd-MM-yyyy HH:mm');
              String formattedDate = formatter.format(now);

              await CaccoNetwork.addCacco(Cacco(
                chef: FirebaseAuth.instance.currentUserId!,
                name: _nameTextController.text,
                description: _descriptionTextController.text,
                caccoType: _caccoType,
                caccoQuantity: _caccoQuantity,
                timeStamp: formattedDate,
              ).toMap());

              if (context.mounted) {
                Navigation.back(context);
              }
            }
          },
        ));
  }

  // Button per eliminare il prodotto
  Widget deleteButton(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(bottom: 175),
        child: CustomButtons.delete(
          'Elimina prodotto',
          onPressed: () async {
            _focusNome.unfocus();
            _focusDescription.unfocus();

            if (_formKey.currentState!.validate()) {
              setState(() {
                _isProcessing = true;
              });

              CaccoNetwork.deleteCacco(_oldData.id);

              Navigation.back(context);
            }
          },
        ));
  }
}
