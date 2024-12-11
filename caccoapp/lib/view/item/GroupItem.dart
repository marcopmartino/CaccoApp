import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
                borderRadius: BorderRadius.circular(30.0),
            ),
            child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                        Padding(
                            padding: const EdgeInsets.only(bottom: 4),
                            child: Text(
                                "${itemData['nome']}",
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                ),
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
                                            text: itemData['creationDate'].toString(),
                                            textColor: AppColors.sandBrown,
                                            icon: Icons.calendar_today_rounded,
                                            iconSize: 25,
                                            fontSize: 12,
                                            innerPadding: 8
                                        ),
                                    ), //Data creazione
                                    SizedBox(
                                        width: MediaQuery.of(context).size.width /3,
                                        child: IconTextWidget(
                                            text: itemData['memberCounter'].toString(),
                                            textColor: AppColors.sandBrown,
                                            icon: Icons.people_alt_rounded,
                                            iconSize: 25,
                                            fontSize: 12,
                                            innerPadding: 8
                                        ),

                                    ), //Numero membri
                                ]
                            ),
                        ),
                    ]
                ),
            ),
        );
    }
}