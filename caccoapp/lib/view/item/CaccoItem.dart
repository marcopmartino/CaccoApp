import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../utility/AppColors.dart';
import '../item/Item.dart';

class CaccoItem extends Item {
  const CaccoItem({super.key, required super.itemData});

  String calculateEta(String data){
    DateTime current = DateTime.now();
    DateTime temp = DateFormat("yyyy-MM-dd hh:mm:ss").parse(data);

    Duration difference = current.difference(temp);

    print(difference);

    if(difference.inDays>0){
      if(difference.inDays>6){
        int week = (difference.inDays/7).round();
        if(week>4){
          return "PiÃ¹ di un mese fa";
        }else{
          return "$week settimane fa";
        }
      }else{
        return "${difference.inDays} giorni fa";
      }
    }else if((difference.inHours%24)<24){
      return "${difference.inHours%24} ore fa";
    }else if((difference.inMinutes%60)<60){
      return "${difference.inMinutes%60} minuti fa";
    }else if((difference.inSeconds%60)<60){
      return "${difference.inSeconds%60} secondi fa";
    }else{
      return "Un attimo fa";
    }
  }

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
                padding: const EdgeInsets.only(bottom: 4),
                child: Text(
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.normal,
                    ),
                    "${itemData['nome']} â€¢ ${calculateEta(itemData['data'])}"
                ),
              )
            ]
        ),
      ),
    );
  }
}