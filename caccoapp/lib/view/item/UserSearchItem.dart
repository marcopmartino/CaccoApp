import 'package:flutter/material.dart';

import '../../utility/AppColors.dart';
import '../../helpers/Utils.dart';
import '../widget/TextWidgets.dart';
import 'Item.dart';

class UserSearchItem extends Item {
  const UserSearchItem({super.key, required super.itemData});

  @override
  Widget build(BuildContext context) {
    return Card(
        color: AppColors.caramelBrown,
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
                      itemData['username'].toString(),
                      fontSize: 18, textColor: AppColors.sandBrown)
              ), //Name
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                child: IconTextWidget(
                    text: Utils.translateGender(itemData['gender'].toString()),
                    textColor: AppColors.sandBrown,
                    icon: itemData['gender'].toString() == 'Male' ?
                    Icons.male_rounded : itemData['gender'].toString() == 'Female' ?
                    Icons.female_rounded : Icons.question_mark_rounded,
                    iconSize: 30,
                    fontSize: 16,
                    innerPadding: 8
                ),
              ), //Gender
            ]
        )
    );
  }
}