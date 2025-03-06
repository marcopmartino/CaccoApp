import 'package:CaccoApp/helpers/LoginService.dart';
import 'package:CaccoApp/utility/CustomEdgeInsets.dart';
import 'package:CaccoApp/utility/DocumentStreamBuilder.dart';
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
import 'package:logo_n_spinner/logo_n_spinner.dart';

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
  int selectedPoop = 0;
  int amountPoop = 0;

  bool _isProcessing = false;
  bool _initializationCompleted = false;

  late DocumentSnapshot<Object?> _oldCacco;

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

  final _focusNome = FocusNode();
  final _focusDescription = FocusNode();

  void startLoadingAnimation(){
    setState(() {
      _isProcessing = true;
    });
  }

  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;
    String title = widget.newCacco ? 'Aggiungi cacco' : 'Modifica cacco';

    if (_isProcessing) {
      return CustomScaffold(
        title: title,
        withAppbar: true,
        body: const Center(
          child: LogoandSpinner(
            imageAssets: 'assets/temp-image.jpg',
            reverse: true,
            arcColor: AppColors.mainBrown,
            spinSpeed: Duration(milliseconds: 500),
          )
        ),
      );
    } else if(widget.newCacco){
      return CustomScaffold(
          title: title,
          withAppbar: true,
          body: SingleChildScrollView(
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
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
    }else if(_initializationCompleted){
      return CustomScaffold.form(
        title: title,
        withAppbar: true,
        body: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: SizedBox(
            height: size.height,
            width: size.width,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Flexible(
                  flex: 3,
                  child: formBody(),
                ),
                Flexible(
                  flex: 1,
                  child: editButton(context)
                )
              ],
            ),
          ),
        )
      );
    }else{
      return CustomScaffold.form(
        title: title,
        withAppbar: true,
        body: DocumentStreamBuilder(
          stream: CaccoNetwork.getCaccoDetails(widget.caccoId!),
          builder: (BuildContext context, DocumentSnapshot<Object?> caccoDetails){
            _nameTextController.text = caccoDetails['name'];
            _descriptionTextController.text = caccoDetails['description'];
            selectedPoop = caccoTypeName.indexOf(caccoDetails['caccoType']);
            amountPoop = caccoQuantityName.indexOf(caccoDetails['caccoQuantity']);
            _initializationCompleted = true;

            _oldCacco = caccoDetails;

            return SingleChildScrollView(
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
              child: SizedBox(
                height: size.height,
                width: size.width,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Flexible(
                      flex: 3,
                      child: formBody(),
                    ),
                    Flexible(
                      flex: 1,
                        child: editButton(context),
                    )
                  ],
                ),
              ),
            );
          }
        )
      );
    }
  }

  Widget formBody() {
    return Form(
        key: _formKey,
        child: Column(
          children: [
            const SizedBox(height: 10),
            Flexible(
              flex: 0,
              child: Padding(
                padding: const EdgeInsets.only(left: 25, right: 25, top: 20, bottom: 20),
                child: TextFormFieldWidget(
                  controller: _nameTextController,
                  label: 'Nome',
                  hint: 'Inserire nome (opzionale)',
                  maxLines: 1,
                ),
              ),
            ), //Nome
            Flexible(
              flex: 0,
              child: Padding(
                  padding: const EdgeInsets.only(left: 25, right: 25, top: 0, bottom: 0),
                  child: TextFormFieldWidget(
                    controller: _descriptionTextController,
                    label: 'Descrizione',
                    hint: 'Inserire descrizione (opzionale)',
                    maxLines: 2,
                  )),
            ), //Descrizione
            const SizedBox(height: 60),
            const Flexible(
                flex: 0,
                child: Text(
                  'Tipo di cacco',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: AppFontWeight.semiBold,
                      color: AppColors.sandBrown),
                )
            ), //Tipo di cacco txt
            const SizedBox(height: 10,),
            Flexible(
                flex: 1,
                child: SizedBox(
                    height: 210,
                    width: MediaQuery.of(context).size.width,
                    child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: <Widget>[
                          const SizedBox(width: 10,),
                          poopTypeCardButton('assets/fartPoop.png', "Fart", 0),
                          const SizedBox(width: 10,),
                          poopTypeCardButton('assets/popsPoop.png', "Pops", 1),
                          const SizedBox(width: 10,),
                          poopTypeCardButton('assets/milkFlakesPoop.png', "Milk flakes", 2),
                          const SizedBox(width: 10,),
                          poopTypeCardButton('assets/sausagePoop.png', "Sausage", 3),
                          const SizedBox(width: 10,),
                          poopTypeCardButton('assets/snakePoop.png', "Snake", 4),
                          const SizedBox(width: 10,),
                          poopTypeCardButton('assets/blobPoop.png', "Blob", 5),
                          const SizedBox(width: 10,),
                          poopTypeCardButton('assets/snowFlakesPoop.png', "Snow flakes", 6),
                          const SizedBox(width: 10,),
                          poopTypeCardButton('assets/liquidPoop.png', "Liquid", 7),
                          const SizedBox(width: 10,),
                        ]
                    )
                )
            ),//Tipo di cacco listview
            const Flexible(
                flex: 0,
                child: Text(
                  'Quantità di cacco',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: AppFontWeight.semiBold,
                      color: AppColors.sandBrown),
                )
            ), //Quantità cacco txt
            const SizedBox(height: 10,),
            Flexible(
                flex: 1,
                child: SizedBox(
                  height: 250,
                  width: MediaQuery.of(context).size.width,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: <Widget>[
                      const SizedBox(width: 10,),
                      poopAmountCardButton('assets/childAmount.png', 0),
                      const SizedBox(width: 10,),
                      poopAmountCardButton('assets/lowAmount.png', 1),
                      const SizedBox(width: 10,),
                      poopAmountCardButton('assets/normalAmount.png', 2),
                      const SizedBox(width: 10,),
                      poopAmountCardButton('assets/highAmount.png', 3),
                      const SizedBox(width: 10,),
                      poopAmountCardButton('assets/tooMuchAmount.png', 4),
                      const SizedBox(width: 10,),
                    ],
                  ),
                )
            ),//Quantità cacco listview
          ],
        ));
  }

  // Card per i tipi di cacco
  Widget poopTypeCardButton(String fileName, String poopName, int index){
    return Column(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: (){
              setState(() {
                selectedPoop = index;
              });
            },
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
              shape: const CircleBorder(eccentricity: 0),
              side: BorderSide(
                width: (selectedPoop == index) ? 5.0 : 0.5,
                color: (selectedPoop == index) ? Colors.yellowAccent : AppColors.caramelBrown,
              )
            ),
            child: Center(
              child: ClipOval(
                child: Image.asset(
                  fileName,
                  fit: BoxFit.cover,
                  width: 100,
                  height: 100,
                ),
              )
            ),
          )
        ),
        Expanded(
          child: Text(
            caccoTypeName[index],
            style: const TextStyle(
              height:  2,
              fontSize: 14,
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontFamily: 'Roboto'
            )
          )
        )

      ],
    );
  }

  // Card per la quantita' di cacco
  Widget poopAmountCardButton(String fileName, int index){
    return Column(
      children: [
        Expanded(
            child: OutlinedButton(
              onPressed: (){
                setState(() {
                  amountPoop = index;
                });
              },
              style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                  shape: const CircleBorder(eccentricity: 0),
                  side: BorderSide(
                    width: (amountPoop == index) ? 5.0 : 0.5,
                    color: (amountPoop == index) ? Colors.yellowAccent : AppColors.caramelBrown,
                  )
              ),
              child: Center(
                  child: ClipOval(
                    child: Image.asset(
                      fileName,
                      fit: BoxFit.fill,
                      width: 100,
                      height: 100,
                    ),
                  )
              ),
            )
        ),
        Expanded(
          child:Text(
            caccoQuantityName[index],
            style: const TextStyle(
              height:  1,
              fontSize: 14,
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontFamily: 'Roboto'
            )
          )
        )
      ],
    );
  }

  // Button per creare un nuovo cacco
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
                chefId: FirebaseAuth.instance.currentUserId!,
                chefUsername: LoginService.loggedInUserModel!.username,
                name: _nameTextController.text,
                description: _descriptionTextController.text,
                caccoType: caccoTypeName[selectedPoop],
                caccoQuantity: caccoQuantityName[amountPoop],
                timeStamp: formattedDate,
              ).toMap());

              if (context.mounted) {
                Navigation.back(context);
              }
            }
          },
        ));
  }

  // Button per modificare un cacco
  Widget editButton(BuildContext context){
    
    return Padding(
      padding: const CustomEdgeInsets.only(left:16, right: 16, top: 16, bottom:32),
      child: CustomButtons.submit(
        'Salva modifiche',
        onPressed: () async {
          if(_formKey.currentState!.validate()){
            startLoadingAnimation();
            
            if(_nameTextController.text != _oldCacco['name'] || 
                _descriptionTextController.text != _oldCacco['description'] ||
                caccoTypeName[selectedPoop] != _oldCacco['caccoType'] ||
                caccoQuantityName[amountPoop] != _oldCacco['caccoQuantity']
            ){
              Cacco cacco = Cacco(
                  id: _oldCacco.id,
                  chefId: FirebaseAuth.instance.currentUser!.uid,
                  chefUsername: _oldCacco['chefUsername'],
                  name: _nameTextController.text,
                  description: _descriptionTextController.text,
                  caccoType: caccoTypeName[selectedPoop],
                  caccoQuantity: caccoQuantityName[amountPoop],
                  timeStamp: _oldCacco['timeStamp']
              );
              await CaccoNetwork.updateCacco(cacco);
            }
            if(context.mounted) Navigation.back(context);

          }
        }
      )
    );

  }




}