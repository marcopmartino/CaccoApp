import 'package:CaccoApp/models/LoggedUser.dart';
import 'package:CaccoApp/utility/Extensions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../network/ProfileNetwork.dart';
import '../../utility/AppColors.dart';
import '../../utility/CaccoTxt.dart';
import '../../utility/DocumentStreamBuilder.dart';
import '../widget/TextWidgets.dart';
import 'Item.dart';

class CaccoHomeViewItem extends Item {
  const CaccoHomeViewItem({super.key, required super.itemData});

  int checkToday(DateTime date){
    DateTime now = DateTime.now();
    return DateTime(date.year, date.month, date.day).difference(DateTime(now.year, now.month, now.day)).inDays;
  }

  @override
  Widget build(BuildContext context) {
    final String chef = itemData['chef'].toString();

    final timeStamp = DateFormat('dd-MM-yy HH:mm').parse(itemData['timeStamp']);
    final date = itemData['timeStamp'].substring(0,11);
    final time = itemData['timeStamp'].substring(11);

    Widget caccoItem(String itemSubtitle) {
      return Card(
          color: AppColors.transparentCaramelBrown,
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 0), // Spaziatura esterna
                    child: TitleWidget(
                        itemData['name'].toString() != '' ?
                          itemData['name'].toString() : "Cacco del $date",
                        fontSize: 18, textColor: AppColors.sandBrown)
                ), //Name
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 8), // Spaziatura esterna
                  child: TextWidget(
                    itemSubtitle,
                    textColor: AppColors.sandBrown,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [//Description
                        SizedBox(
                          width: MediaQuery.of(context).size.width /3,
                          child:
                          // Visualizzazioni
                          IconTextWidget(
                              text: itemData['caccoType'].toString(),
                              textColor: AppColors.sandBrown,
                              icon: Icons.type_specimen_rounded,
                              iconSize: 30,
                              fontSize: 16,
                              innerPadding: 8
                          ),
                        ), //CaccoType
                        SizedBox(
                          width: MediaQuery.of(context).size.width /3,
                          child:
                          // Like
                          IconTextWidget(
                              text: itemData['caccoQuantity'].toString(),
                              textColor: AppColors.sandBrown,
                              icon: Icons.waves_rounded,
                              iconSize: 30,
                              fontSize: 16,
                              innerPadding: 8
                          ),
                        ), //CaccoQuantity
                      ]
                  ),
                ),
              ]
          )
      );
    }

    final check = checkToday(timeStamp);
    if (chef == FirebaseAuth.instance.currentUserId) {
      var username = FirebaseAuth.instance.currentUser?.displayName!;
      if(check == 0){
        return caccoItem('$username - Oggi alle $time');
      }else if(check == -1){
        return caccoItem('$username - Ieri alle $time');
      }else{
        return caccoItem('$username - $date');
      }
    } else {
      return DocumentStreamBuilder(
          stream: ProfileNetwork.getUserInfo(chef),
          builder: (BuildContext builder, DocumentSnapshot<Object?> data) {
            if(check == 0){
              return caccoItem('${data['username']} - Oggi alle $time');
            }else if(check == -1){
              return caccoItem('${data['username']} - Ieri alle $time');
            }else{
              return caccoItem('${data['username']} - $date');
            }
          }
      );
    }
  }
}