import 'package:CaccoApp/utility/Extensions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:CaccoApp/view/widget/CustomButton.dart';
import 'package:CaccoApp/view/widget/TextWidgets.dart';

import 'package:CaccoApp/models/Cacco.dart';
import 'package:CaccoApp/utility/AppColors.dart';
import 'package:CaccoApp/utility/Navigation.dart';

import 'package:CaccoApp/network/CaccoNetwork.dart';
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
  int selectedPoop = 0;
  int amountPoop = 0;

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
    }
  }

  Widget formBody() {
    bool necessary = true;

    return Form(
        key: _formKey,
        child: Column(
          children: [
            const SizedBox(height: 10),
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
                  child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: <Widget>[
                          poopTypeCardButton('assets/fartPoop.png', 0),
                          poopTypeCardButton('assets/popsPoop.png', 1),
                          poopTypeCardButton('assets/milkFlakesPoop.png', 2),
                          poopTypeCardButton('assets/sausagePoop.png', 3), // <--
                          poopTypeCardButton('assets/snakePoop.png', 4),
                          poopTypeCardButton('assets/blobPoop.png', 5),
                          poopTypeCardButton('assets/snowFlakesPoop.png', 6),
                          poopTypeCardButton('assets/liquidPoop.png', 7),
                      ]
                    )
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
                  child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: <Widget>[
                          poopAmountCardButton('assets/childAmount.png', 0),
                          poopAmountCardButton('assets/lowAmount.png', 1),
                          poopAmountCardButton('assets/normalAmount.png', 2),
                          poopAmountCardButton('assets/highAmount.png', 3),
                          poopAmountCardButton('assets/tooMuchAmount.png', 4),
                      ],
                  ),
                )

            ),//Quantità cacco listview
          ],
        ));
  }

  // Card per i tipi di cacco
  Widget poopTypeCardButton(String poopName, int index){
      return OutlinedButton(
          onPressed: (){
              setState(() {
                selectedPoop = index;
              });
          },
          style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
              shape: const CircleBorder(eccentricity: 0),
              side: BorderSide(
                  width: (selectedPoop == index) ? 2.0 : 0.5,
                  color: (selectedPoop == index) ? AppColors.sandBrown : AppColors.caramelBrown,
              )
          ),
          child: Center(
              child: Image.asset(
                  poopName,
                  fit: BoxFit.contain,
                  width: 120,
                  height: 120,
              )
          ),
      );
  }

  // Card per la quantita' di cacco
  Widget poopAmountCardButton(String poopAmount, int index){
      return OutlinedButton(
          onPressed: (){
              setState(() {
                  amountPoop = index;
              });
          },
          style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
              shape: const CircleBorder(eccentricity: 0),
              side: BorderSide(
                  width: (amountPoop == index) ? 2.0 : 0.5,
                  color: (amountPoop == index) ? AppColors.sandBrown : AppColors.caramelBrown,
              )
          ),
          child: Center(
              child: Image.asset(
                  poopAmount,
                  fit: BoxFit.contain,
                  width: 120,
                  height: 120,
              )
          ),
      );
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