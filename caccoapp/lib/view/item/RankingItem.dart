import 'package:flutter/material.dart';

import '../../utility/AppColors.dart';
import '../../helpers/Utils.dart';
import '../../utility/CaccoIcons.dart';
import '../widget/TextWidgets.dart';
import 'Item.dart';

class RankingItem extends Item {
  const RankingItem({super.key, required super.itemData, required this.rank});
  
  final String rank;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.caramelBrown,
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 4, 8, 4), // Spaziatura esterna
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width /18,
              child: TextWidget(
                rank.toString(),
                fontSize: 18,
                textColor: AppColors.sandBrown
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width/2,
              child: TitleWidget(
                itemData['username'].toString(),
                fontSize: 18, textColor: AppColors.sandBrown)
            ), //Name
            SizedBox(
              width: MediaQuery.of(context).size.width /6,
              child: IconTextWidget(
                text: itemData['currentMonthPoops'].toString(),
                textColor: AppColors.sandBrown,
                  icon: CustomIcons.poop,
                  iconSize: 30,
                  fontSize: 16,
                  innerPadding: 8
              ),
            ),
          ]
        )
      )
    );
  }
}