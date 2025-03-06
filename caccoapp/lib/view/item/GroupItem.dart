import 'package:flutter/material.dart';

import '../../../utility/AppColors.dart';
import '../../widgets/TextWidgets.dart';
import '../item/Item.dart';

class GroupItem extends Item {
    const GroupItem({super.key, required super.itemData});

    @override
    Widget build(BuildContext context) {
        return Card(
            margin: const EdgeInsets.all(10),
            elevation: 5,
            color: AppColors.mainBrown,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
            ),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                    Padding(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 0), // Spaziatura esterna
                        child: TitleWidget(
                            itemData['name'].toString(),
                            textColor: Colors.white, fontSize: 18,
                        ),
                    ),//Nome gruppo
                    Padding(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                        child: SizedBox(
                            width: MediaQuery.of(context).size.width /3,
                            child: IconTextWidget(
                                text: itemData['membersCounter'].toString(),
                                textColor: AppColors.sandBrown,
                                icon: Icons.people_alt_rounded,
                                iconColor:Colors.white,
                                iconSize: 25,
                                fontSize: 12,
                                innerPadding: 8
                            ),
                        ), //Numero membri
                    ), //Data creazione e numero membri
                ]
            )
        );
    }
}