import 'package:CaccoApp/network/CaccoNetwork.dart';
import 'package:CaccoApp/utility/AppFontWeight.dart';
import 'package:CaccoApp/utility/DocumentStreamBuilder.dart';
import 'package:CaccoApp/view/pages/CaccoFormPage.dart';
import 'package:CaccoApp/view/widget/TextWidgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../item/Item.dart';
import '../../../utility/AppColors.dart';
import '../../../utility/ListViewBuilders.dart';
import '../../../utility/Navigation.dart';

class HomeTab extends StatefulWidget{
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab>{
  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Colors.brown,
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.heavyBrown,
        child: const Icon(Icons.add),
        onPressed: () => Navigation.navigate(context, CaccoFormPage()),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 15, right: 5, left: 5, bottom: 10),
        child: Column(
          children: <Widget>[
            Card(
              margin: const EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 15.0),
              clipBehavior: Clip.antiAlias,
              color: Colors.grey,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Padding(
                        padding: EdgeInsets.fromLTRB(10.0, 5.0, 15.0, 5.0),
                        child: Text(
                          "RIEPILOGO CACCO",
                          style: TextStyle(
                            fontFamily: "Roboto",
                            fontSize: 35.0,
                            color: Color(0xFFD4D7DA),
                          ),
                        )
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(width: 25),
                        Expanded(
                          flex: 1,
                          child: Container(
                            height: 70,
                            decoration: BoxDecoration(
                              color: Colors.white60,
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            child: const Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Mese corrente",
                                  style: TextStyle(
                                      fontSize: 20.0,
                                      color: Colors.black
                                  ),
                                ),
                                Text(
                                  "10",
                                  style: TextStyle(
                                      fontSize: 30.0,
                                      color: AppColors.problemBrown
                                  ),
                                )

                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 25),
                        Expanded(
                            flex: 1,
                            child: Container(
                              width: MediaQuery.of(context).size.width/2,
                              height: 70,
                              decoration: BoxDecoration(
                                  color: Colors.white60,
                                  borderRadius: BorderRadius.circular(15.0)
                              ),
                              child: const Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Mese scorso",
                                    style: TextStyle(
                                        fontSize: 20.0,
                                        color: Colors.black
                                    ),
                                  ),
                                  Text(
                                    "10",
                                    style: TextStyle(
                                        fontSize: 30.0,
                                        color: AppColors.problemBrown
                                    ),
                                  )

                                ],
                              ),
                            )
                        ),
                        const SizedBox(width: 25),
                      ],
                    )
                  ],
                ),
              )
          ),
            const Divider(indent: 36, endIndent: 36, color: Colors.yellow),
            Expanded(
              flex: 1,
              child: SizedBox(
                  width: double.infinity,
                  child: SingleChildScrollView(
                      child: Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                          child: QueryStreamBuilder(
                              stream: CaccoNetwork.getCurrentUserCaccos(),
                              builder: (BuildContext context, QuerySnapshot<Object?> data){
                                List<QueryDocumentSnapshot<Object?>> docs = data.docs;
                                if(docs.isEmpty) {
                                  return const TextWidget(
                                      "Nessun cacco da mostrare",
                                      fontSize: 18,
                                      fontWeight: AppFontWeight.semiBold,
                                      textColor: AppColors.heavyBrown);
                                }else{
                                  List<QueryDocumentSnapshot<Object?>> recentCaccos = List.empty(growable: true);
                                  //Ordina dalla più recente
                                  docs.sort((a,b) => b['timeStamp'].toString().compareTo(a['timeStamp'].toString()));

                                  int index = 0; int size = docs.length;
                                  while(index < 4 && index <size){
                                    recentCaccos.add(docs[index]);
                                    index++;
                                  }

                                  return ListViewBuilder(
                                    data: recentCaccos,
                                    itemType: ItemType.CACCO_HOME_VIEW,
                                    scale: 1.0,
                                    shrinkWrap: true,
                                    scrollPhysics: const AlwaysScrollableScrollPhysics(),
                                    onTap: (QueryDocumentSnapshot<Object?> cacco){
                                      Navigation.navigate(context, CaccoFormPage());
                                    },
                                  );
                                }
                              }
                          )
                      )
                  )
              )
            )

          ],
        )
      )
    );
  }
}