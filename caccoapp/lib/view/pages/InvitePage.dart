import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:floating_snackbar/floating_snackbar.dart';
import 'package:flutter/material.dart';

import '../../helpers/Utils.dart';
import '../../network/GroupsNetwork.dart';
import '../../network/UsersNetwork.dart';
import '../../utility/AppColors.dart';
import '../../utility/DocumentStreamBuilder.dart';
import '../../utility/Navigation.dart';
import '../item/Item.dart';
import '../widget/TextWidgets.dart';
import 'GroupDetailsPage.dart';
import 'HomePage.dart';

class InvitePage extends StatefulWidget {
  static const String route = 'invitePage';
  final String groupId;

  const InvitePage({super.key, required this.groupId});

  @override
  State<InvitePage> createState() => _InvitePage();
}

class _InvitePage extends State<InvitePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkSandBrown,
      appBar: Utils.getAppbarGroups(context, "Accettare invito?", widget.groupId),
      body: DocumentStreamBuilder(
        stream: GroupsNetwork.getGroupDetails(widget.groupId),
        builder: (BuildContext builder, DocumentSnapshot<Object?> groupInfo) {
          return Padding(
              padding: const EdgeInsets.only(top: 15, right: 5, left: 5, bottom: 10),
              child: Column(
                children: <Widget>[
                  Card(
                      margin: const EdgeInsets.fromLTRB(15.0, 5.0, 15.0, 5.0),
                      clipBehavior: Clip.antiAlias,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Center(
                                  child: TextWidget(
                                    groupInfo['nome'].toString(),
                                    fontSize: 20,
                                  )
                              ), //Username
                              const SizedBox(height: 10),
                              Row(
                                  children: [
                                    Expanded(
                                        flex: 1,
                                        child: Center(
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.circular(8.0),
                                              child: Image.asset('assets/exemple-poop.png', height: 90.0, width: 90.0),
                                            )
                                        )
                                    ),
                                  ]
                              ),
                              // Group Image and name
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  Expanded(
                                      flex: 2,
                                      child: Center(
                                          child: RichText(
                                              textAlign: TextAlign.center,
                                              text: TextSpan(
                                                  children: <TextSpan>[
                                                    TextSpan(
                                                        text: "${groupInfo['membersCounter'].toString()}\n",
                                                        style: const TextStyle(
                                                            fontSize: 18,
                                                            fontWeight: FontWeight.bold,
                                                            color: Colors.black)
                                                    ),
                                                    const TextSpan(
                                                      text: "Membri",
                                                      style: TextStyle(fontSize: 14, color: Colors.black),
                                                    )
                                                  ]
                                              )
                                          )
                                      )
                                  ),
                                  Expanded(
                                      flex: 2,
                                      child: Center(
                                          child: RichText(
                                              textAlign: TextAlign.center,
                                              text: TextSpan(
                                                  children: <TextSpan>[
                                                    TextSpan(
                                                        text: "${groupInfo['creationDate'].toString()}\n",
                                                        style: const TextStyle(
                                                            fontSize: 18,
                                                            fontWeight: FontWeight.bold,
                                                            color: Colors.black)
                                                    ),
                                                    const TextSpan(
                                                      text: "Data creazione",
                                                      style: TextStyle(fontSize: 14, color: Colors.black),
                                                    )
                                                  ]
                                              )
                                          )
                                      )
                                  ),
                                ],
                              ),
                              // Membri e data creazione
                              Center(
                                  child: StatefulBuilder(
                                    builder: (thisLowerContext, innerSetState) {
                                      return ButtonTheme(
                                          minWidth: 150,
                                          height: 100,
                                          child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                                textStyle: const TextStyle(fontSize: 16),
                                                backgroundColor: Colors.blue),
                                            onPressed: () {
                                              floatingSnackBar(
                                                  message: "Invito inviato",
                                                  backgroundColor: Colors.blue,
                                                  textStyle: const TextStyle(fontSize: 18),
                                                  context: context,
                                                  duration: const Duration(seconds: 5));
                                            },
                                            child: const Text("Invita membro"),
                                          )
                                      );
                                    },
                                  )
                              )
                              //Tasto invitare
                            ]
                        ),
                      ) // Card con info gruppo
                  ), // Card con info gruppo
                  const Divider(indent: 36, endIndent: 36, color: Colors.yellow),
                  Expanded(
                      flex: 1,
                      child: SizedBox(
                          width: double.infinity,
                          child: SingleChildScrollView(
                              child: ConstrainedBox(
                                constraints: BoxConstraints(
                                    maxHeight: MediaQuery.of(context).size.height - 65),
                                child: ListViewStreamBuilderNoTap(
                                  stream: UsersNetwork.getGroupMembersList(widget.groupId),
                                  itemType: ItemType.RANKING_GROUP,
                                  filterFunction: (List<QueryDocumentSnapshot<Object?>> data) {

                                    // Ordina la lista in base al numero di cacco fatti nel mese corrente
                                    data.sort((a,b) => b['currentMonthCaccos'].toString().compareTo(a['currentMonthCaccos'].toString()));

                                    return data;
                                  },
                                ),
                              )
                          )
                      )
                  ),// Lista membri
                  Card(
                    margin: const EdgeInsets.fromLTRB(15.0, 5.0, 15.0, 5.0),
                    clipBehavior: Clip.antiAlias,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: ElevatedButton(
                                  onPressed: () {
                                    GroupsNetwork.addMember(widget.groupId, FirebaseAuth.instance.currentUser!.uid);
                                    floatingSnackBar(
                                        message: "Invito accettato",
                                        backgroundColor: Colors.green,
                                        textStyle: const TextStyle(fontSize: 18),
                                        context: context,
                                        duration: const Duration(seconds: 5));
                                    Navigation.replace(context, GroupDetailsPage(groupId: widget.groupId));
                                  },
                                  child: const Text("Accetta invito"),
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: ElevatedButton(
                                  onPressed: () {
                                    GroupsNetwork.addMember(widget.groupId, FirebaseAuth.instance.currentUser!.uid);
                                    floatingSnackBar(
                                        message: "Invito rifiutato",
                                        backgroundColor: Colors.red,
                                        textStyle: const TextStyle(fontSize: 18),
                                        context: context,
                                        duration: const Duration(seconds: 5));
                                    Navigation.replace(context, const HomePage());
                                  },
                                  child: const Text("Rifiuta invito"),
                                ),
                              ),
                            ],
                          ),
                          //Tasto invitare
                        ]
                      ),
                    ) // Card con info gruppo
                  ),
                ],
              )
          );
        },
      )
    );
  }
}

