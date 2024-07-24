import 'package:CaccoApp/utility/AppColors.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../helpers/IconHelper.dart';
import '../helpers/Utils.dart';
import '../widgets/IconFont.dart';

class SplashPage extends StatelessWidget{
  int? duration = 0;
  String? goToPage;

  SplashPage({super.key, this.goToPage, this.duration});

  @override
  Widget build(BuildContext context){

    /* CaccoService shitService = Provider.of<CaccoService>(context, listen: false);

    Future.delayed(Duration(seconds: duration!), () async{
      FirebaseApp app= await Firebase.initializeApp();

      shitService.getShitCollectionFromFirebase().then((value){
        Utils.mainAppNav.currentState!.pushNamed(goToPage!);
      });
    });
    */

    return Material(
      child: Container(
        color: AppColors.mainShit,
        alignment: Alignment.center,
        child: Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: IconFont(
                color: Colors.white,
                iconName: IconFontHelper.LOGO,
                size: 80
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: SizedBox(
                width: 150,
                height: 150,
                child: CircularProgressIndicator(
                  strokeWidth: 10,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white.withOpacity(0.5)),
                )
              )
            )
          ]
        )
      )
    );
  }
}