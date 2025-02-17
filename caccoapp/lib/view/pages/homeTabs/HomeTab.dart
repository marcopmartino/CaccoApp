import 'package:CaccoApp/helpers/LoginService.dart';
import 'package:CaccoApp/network/CaccoNetwork.dart';
import 'package:CaccoApp/network/UsersNetwork.dart';
import 'package:CaccoApp/utility/AppFontWeight.dart';
import 'package:CaccoApp/utility/DocumentStreamBuilder.dart';
import 'package:CaccoApp/view/pages/CaccoFormPage.dart';
import 'package:CaccoApp/view/widget/TextWidgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../item/Item.dart';
import '../../../utility/AppColors.dart';
import '../../../utility/ListViewBuilders.dart';
import '../../../utility/Navigation.dart';
import '../../widget/CustomButton.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  var user = LoginService.loggedInUserModel!;
  var scrollable = true;
  var thereIsListView = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        if (thereIsListView) {
          setState(() {
            scrollable = true;
          });
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: AppColors.grayBrown,
      body: Padding(
        padding: const EdgeInsets.only(top: 15, right: 5, left: 5, bottom: 15),
        child: Column(
          children: <Widget>[
            DocumentStreamBuilder(
              stream: UsersNetwork.getCurrentUserDetails(),
              builder: (BuildContext context, DocumentSnapshot<Object?> data) {
                return Card(
                  margin: const EdgeInsets.fromLTRB(15.0, 5.0, 15.0, 5.0),
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
                            padding: EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 15.0),
                            child: Text(
                              "RIEPILOGO CACCO",
                              style: TextStyle(
                                fontFamily: "Roboto",
                                fontSize: 35.0,
                                color: Colors.black45,
                              ),
                            )
                          ),//Riepilogo cacco label
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                flex: 1,
                                child: Container(
                                  height: 70,
                                  decoration: BoxDecoration(
                                    color: Colors.white60,
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Text(
                                        "Mese corrente",
                                        style: TextStyle(fontSize: 20.0, color: Colors.black),
                                      ),
                                      Text(
                                        data['currentMonthPoops'].toString(),
                                        style: const TextStyle(fontSize: 30.0, color: AppColors.problemBrown),
                                      )
                                    ],
                                  ),
                                ),
                              ), //Current month cacco
                              const SizedBox(width: 15),
                              Expanded(
                                flex: 1,
                                child: Container(
                                  width: MediaQuery.of(context).size.width / 2,
                                  height: 70,
                                  decoration: BoxDecoration(
                                      color: Colors.white60, borderRadius: BorderRadius.circular(15.0)),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Text(
                                        "Mese scorso",
                                        style: TextStyle(fontSize: 20.0, color: Colors.black),
                                      ),
                                      Text(
                                        data['lastMonthPoops'].toString(),
                                        style: const TextStyle(fontSize: 30.0, color: AppColors.problemBrown),
                                      )
                                    ],
                                  ),
                                )
                              ), //Last month cacco
                            ],
                          ), //Current and last month cacco
                        ]),
                  ));
              }),
              Expanded(
                flex: 1,
                child: SizedBox(
                  width: double.infinity,
                  child: SingleChildScrollView(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height -300),
                      child: QueryStreamBuilder(
                        stream: CaccoNetwork.getCurrentUserCaccos(),
                        builder: (BuildContext context, QuerySnapshot<Object?> data) {
                          List<QueryDocumentSnapshot<Object?>> docs = data.docs;
                          if (docs.isEmpty) {
                            return const Center(
                              child: TextWidget("Nessun cacco da mostrare",
                                fontSize: 18,
                                fontWeight: AppFontWeight.semiBold,
                                textColor: AppColors.heavyBrown)
                            );
                          } else {
                            List<QueryDocumentSnapshot<Object?>> recentCaccos = List.empty(growable: true);
                            //Ordina dalla piÃ¹ recente
                            docs.sort((a, b) => b['timeStamp'].toString().compareTo(a['timeStamp'].toString()));
                            int index = 0;
                            int size = docs.length;
                            while (index < size) {
                              recentCaccos.add(docs[index]);
                              index++;
                            }
                            if (recentCaccos.isEmpty) {
                              return const TextWidget(
                                "Nessun cacco da mostrare",
                                fontSize: 18,
                                fontWeight: AppFontWeight.semiBold,
                                textColor: AppColors.heavyBrown
                              );
                            } else {
                              thereIsListView = true;
                              return ListViewBuilder(
                                data: recentCaccos,
                                itemType: ItemType.CACCO_HOME_VIEW,
                                scale: 1.0,
                                shrinkWrap: true,
                                scrollPhysics: !thereIsListView ? const NeverScrollableScrollPhysics() :
                                const AlwaysScrollableScrollPhysics(),
                                onTap: (QueryDocumentSnapshot<Object?> cacco) {
                                  Navigation.navigate(context, CaccoFormPage());
                                },
                              );
                            }
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
