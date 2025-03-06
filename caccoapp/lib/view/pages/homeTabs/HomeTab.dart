import 'package:CaccoApp/helpers/LoginService.dart';
import 'package:CaccoApp/network/CaccoNetwork.dart';
import 'package:CaccoApp/utility/AppFontWeight.dart';
import 'package:CaccoApp/utility/DocumentStreamBuilder.dart';
import 'package:CaccoApp/view/pages/CaccoDetailsPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../item/Item.dart';
import '../../../utility/AppColors.dart';
import '../../../utility/ListViewBuilders.dart';
import '../../../utility/Navigation.dart';

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

  Widget _noCacco(){
    return Column(
      children: [
        Expanded(
          flex: 1,
          child: Padding(
            padding: const EdgeInsets.only(top: 175.0, bottom: 20.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.asset(
                'assets/cryPoop.png',
                height: 175.0,
                width: 175.0,
              ),
            ),
          ),
        ),
        const Expanded(
          flex: 1,
          child: Padding(
            padding: EdgeInsets.only(top: 0.0),
            child: Text(
              "Nessun cacco da mostrare! \n Aggiungine uno ora!",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: AppFontWeight.semiBold,
                color: AppColors.heavyBrown,
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBlack,
      body: Padding(
        padding: const EdgeInsets.only(top: 15, right: 5, left: 5, bottom: 10),
        child: Column(
          children: <Widget>[
            DocumentStreamBuilder(
              stream: CaccoNetwork.getCaccosInfo(null),
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
                            child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
                              const Padding(
                                  padding: EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 15.0),
                                  child: Text(
                                    "RIEPILOGO CACCO",
                                    style: TextStyle(
                                      fontFamily: "Roboto",
                                      fontSize: 35.0,
                                      color: Colors.black45,
                                    ),
                                  )),
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
                                  ),
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
                                      )),
                                ],
                              ),
                            ]),
                          ));
              }),
            Expanded(
              flex: 1,
              child: SizedBox(
                width: double.infinity,
                child: SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height - 350),
                    child: QueryStreamBuilder(
                      stream: CaccoNetwork.getCurrentUserCaccos(),
                      builder: (BuildContext context, QuerySnapshot<Object?> data) {
                        List<QueryDocumentSnapshot<Object?>> docs = data.docs;
                        if (docs.isEmpty) {
                          return _noCacco();
                        } else {
                          List<QueryDocumentSnapshot<Object?>> recentCaccos = List.empty(growable: true);
                          //Ordina dalla piu´ recente
                          docs.sort(
                            (a, b) => b['timeStamp'].toString().compareTo(a['timeStamp'].toString()));

                          int index = 0;
                          int size = docs.length;
                          while (index < size) {
                            recentCaccos.add(docs[index]);
                            index++;
                          }

                          if (recentCaccos.isEmpty) {
                            return _noCacco();
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
                                Navigation.navigateFromLeft(context, CaccoDetailsPage(caccoId: cacco.id, caccoName: cacco['name']));
                                },
                            );
                          }
                        }
                      })
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
