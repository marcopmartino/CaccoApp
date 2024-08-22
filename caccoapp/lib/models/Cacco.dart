import 'package:cloud_firestore/cloud_firestore.dart';

enum CaccoType{
  fake,         //Falso allarme
  pops,         //Pops
  cottageCheese,//Fiocchi di latte
  sausage,      //Salsiccia
  snake,        //Serpente
  blob,         //Blob
  snowFlakes,   //Fiocchi di neve
  liquid;       //Liquida
}

enum CaccoQuantity{
  nope,
  child, //Bambino
  small, //Poca
  normal,//Normale
  huge,  //Abbondante
  gigantic//Eccessiva
}


class Cacco{
  late final String? id;
  late final String chef;
  late final String? name;
  late final String? description;
  late final String caccoType;
  late final String caccoQuantity;
  late final String timeStamp;

  Cacco({
    this.id,
    required this.chef,
    this.name = "",
    this.description = "",
    required this.caccoType,
    this.caccoQuantity = "",
    required this.timeStamp,
  });

  Map<String, dynamic> toMap(){
    return{
      'chef': chef,
      'name': name,
      'description': description,
      'caccoType': caccoType,
      'caccoQuantity': caccoQuantity,
      'timeStamp': timeStamp
    };
  }

  Cacco.fromMap(Map<String, dynamic> caccoMap):
    id = caccoMap['id'],
    chef = caccoMap['chef'],
    name = caccoMap['name'],
    description = caccoMap['description'],
    caccoType = caccoMap['caccoType'],
    caccoQuantity = caccoMap['caccoQuantity'],
    timeStamp = caccoMap['timeStamp'];

  Cacco.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> doc):
    id = doc.id,
    chef = doc.data()!['chef'],
    name = doc.data()!['name'],
    description = doc.data()!['description'],
    caccoType = doc.data()!['caccoType'],
    caccoQuantity = doc.data()!['caccoQuantity'],
    timeStamp = doc.data()!['timeStamp'];

  String? getId(){
    return id;
  }

  String getTimeStamp(){
    return timeStamp;
  }
}

