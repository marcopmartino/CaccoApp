import 'package:CaccoApp/network/FollowerNetwork.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:floating_snackbar/floating_snackbar.dart';
import 'package:flutter/material.dart';

import '../../helpers/Utils.dart';
import '../../network/CaccoNetwork.dart';
import '../../network/UsersNetwork.dart';
import '../../utility/AppColors.dart';
import '../../utility/AppFontWeight.dart';
import '../../utility/DocumentStreamBuilder.dart';
import '../../utility/ListViewBuilders.dart';
import '../../utility/Navigation.dart';
import '../../view/widget/CustomScaffold.dart';
import '../item/Item.dart';
import '../widget/TextWidgets.dart';
import 'CaccoFormPage.dart';

class UserDetailsPage extends StatefulWidget {
  static const String route = 'profileDetails';
  final String userId;
  final String username;

  const UserDetailsPage(
      {super.key, required this.userId, required this.username});

  @override
  State<UserDetailsPage> createState() => _UserDetailsPage();
}

class _UserDetailsPage extends State<UserDetailsPage> {
  var followed = false;

  @override
  void initState() {
    super.initState();

    FollowerNetwork.checkFollow(widget.userId).then((result) {
      setState(() {
        followed = result;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
        title: "Dettagli profilo",
        withAppbar: true,
        body: DocumentStreamBuilder(
          stream: CaccoNetwork.getCaccosInfo(widget.userId),
          builder:
              (BuildContext builder, DocumentSnapshot<Object?> caccosInfo) {
            return FutureBuilder(
                future: UsersNetwork.getUserDetails(widget.userId),
                builder: (BuildContext builder,
                    AsyncSnapshot<DocumentSnapshot> userDetails) {
                  if (userDetails.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else {
                    if (userDetails.hasError) {
                      return Center(
                          child: Text('Errore: ${userDetails.error}'));
                    } else {
                      return DocumentStreamBuilder(
                        stream: FollowerNetwork.getFollowInfo(widget.userId),
                        builder: (BuildContext builder,
                            DocumentSnapshot<Object?> followInfo) {
                          return Padding(
                              padding: const EdgeInsets.only(
                                  top: 15, right: 5, left: 5, bottom: 10),
                              child: Column(
                                children: <Widget>[
                                  Card(
                                      margin: const EdgeInsets.fromLTRB(
                                          15.0, 5.0, 15.0, 5.0),
                                      clipBehavior: Clip.antiAlias,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Center(
                                                  child: TextWidget(
                                                userDetails.data!['username']
                                                    .toString(),
                                                fontSize: 20,
                                              )),
                                              //Username
                                              const SizedBox(height: 10),
                                              Row(children: [
                                                Expanded(
                                                    flex: 1,
                                                    child: Center(
                                                        child: RichText(
                                                            textAlign: TextAlign
                                                                .center,
                                                            text: TextSpan(
                                                                children: <TextSpan>[
                                                                  TextSpan(
                                                                      text:
                                                                          "${caccosInfo['currentMonthPoops'].toString()}\n",
                                                                      style: const TextStyle(
                                                                          fontSize:
                                                                              18,
                                                                          fontWeight: FontWeight
                                                                              .bold,
                                                                          color:
                                                                              Colors.black)),
                                                                  TextSpan(
                                                                    text:
                                                                        "Cacco ${Utils.getCurrentMonth()}",
                                                                    style: const TextStyle(
                                                                        fontSize:
                                                                            14,
                                                                        color: Colors
                                                                            .black),
                                                                  )
                                                                ])))),
                                                Expanded(
                                                    flex: 1,
                                                    child: Center(
                                                        child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8.0),
                                                      child: Image.asset(
                                                        'assets/exemple-poop.png',
                                                        height: 90.0,
                                                        width: 90.0,
                                                      ),
                                                    ))),
                                                Expanded(
                                                    flex: 1,
                                                    child: Center(
                                                        child: RichText(
                                                            textAlign: TextAlign
                                                                .center,
                                                            text: TextSpan(
                                                                children: <TextSpan>[
                                                                  TextSpan(
                                                                      text:
                                                                          "${Utils.translateGender(userDetails.data!['gender'].toString())}\n",
                                                                      style: const TextStyle(
                                                                          fontSize:
                                                                              18,
                                                                          fontWeight: FontWeight
                                                                              .bold,
                                                                          color:
                                                                              Colors.black)),
                                                                  const TextSpan(
                                                                    text:
                                                                        " Genere",
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            14,
                                                                        color: Colors
                                                                            .black),
                                                                  )
                                                                ]))))
                                              ]),
                                              // Immagine profilo e prime info
                                              const SizedBox(height: 10),
                                              Row(
                                                children: [
                                                  Expanded(
                                                      flex: 2,
                                                      child: Center(
                                                          child: RichText(
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              text: TextSpan(
                                                                  children: <TextSpan>[
                                                                    TextSpan(
                                                                        text:
                                                                            "${followInfo['follower'].toString()}\n",
                                                                        style: const TextStyle(
                                                                            fontSize:
                                                                                18,
                                                                            fontWeight:
                                                                                FontWeight.bold,
                                                                            color: Colors.black)),
                                                                    const TextSpan(
                                                                      text:
                                                                          "Follower",
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              14,
                                                                          color:
                                                                              Colors.black),
                                                                    )
                                                                  ])))),
                                                  Expanded(
                                                      flex: 2,
                                                      child: Center(
                                                          child: RichText(
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              text: TextSpan(
                                                                  children: <TextSpan>[
                                                                    TextSpan(
                                                                        text:
                                                                            "${followInfo['following'].toString()}\n",
                                                                        style: const TextStyle(
                                                                            fontSize:
                                                                                18,
                                                                            fontWeight:
                                                                                FontWeight.bold,
                                                                            color: Colors.black)),
                                                                    const TextSpan(
                                                                      text:
                                                                          "Seguiti",
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              14,
                                                                          color:
                                                                              Colors.black),
                                                                    )
                                                                  ])))),
                                                ],
                                              ),
                                              //Numero follower e seguiti
                                              Center(child: StatefulBuilder(
                                                builder: (thisLowerContext,
                                                    innerSetState) {
                                                  return ButtonTheme(
                                                      minWidth: 150,
                                                      height: 100,
                                                      child: ElevatedButton(
                                                        style: followed
                                                            ? ElevatedButton
                                                                .styleFrom(
                                                                textStyle:
                                                                    const TextStyle(
                                                                        fontSize:
                                                                            16),
                                                                backgroundColor:
                                                                    Colors.red,
                                                              )
                                                            : ElevatedButton
                                                                .styleFrom(
                                                                textStyle:
                                                                    const TextStyle(
                                                                        fontSize:
                                                                            16),
                                                                backgroundColor:
                                                                    Colors
                                                                        .green,
                                                              ),
                                                        onPressed: () {
                                                          if (followed) {
                                                            FollowerNetwork
                                                                .removeFollowing(
                                                                    widget
                                                                        .userId);
                                                            innerSetState(() {
                                                              followed = false;
                                                            });
                                                            floatingSnackBar(
                                                                message:
                                                                    "Non segui piÃ¹ ${widget.username}",
                                                                backgroundColor:
                                                                    Colors.red,
                                                                textStyle:
                                                                    const TextStyle(
                                                                        fontSize:
                                                                            18),
                                                                context:
                                                                    context,
                                                                duration:
                                                                    const Duration(
                                                                        seconds:
                                                                            5));
                                                          } else {
                                                            FollowerNetwork
                                                                .addFollowing(
                                                                    widget
                                                                        .userId);
                                                            innerSetState(() {
                                                              followed = true;
                                                            });
                                                            floatingSnackBar(
                                                                message:
                                                                    "Ora segui ${widget.username}",
                                                                backgroundColor:
                                                                    Colors
                                                                        .green,
                                                                textStyle:
                                                                    const TextStyle(
                                                                        fontSize:
                                                                            18),
                                                                context:
                                                                    context,
                                                                duration:
                                                                    const Duration(
                                                                        seconds:
                                                                            5));
                                                          }
                                                        },
                                                        child: followed
                                                            ? const Text(
                                                                "Unfollow")
                                                            : const Text(
                                                                "Follow"),
                                                      ));
                                                },
                                              ))
                                              //Tasto segui
                                            ]),
                                      )),
                                  const Divider(
                                      indent: 36,
                                      endIndent: 36,
                                      color: Colors.yellow),
                                  Expanded(
                                      flex: 1,
                                      child: SizedBox(
                                          width: double.infinity,
                                          child: SingleChildScrollView(
                                              child: ConstrainedBox(
                                                  constraints: BoxConstraints(
                                                      maxHeight:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height -
                                                              65),
                                                  child: QueryStreamBuilder(
                                                      stream: CaccoNetwork
                                                          .getUserCaccos(
                                                              widget.userId),
                                                      builder: (BuildContext
                                                              context,
                                                          QuerySnapshot<Object?>
                                                              data) {
                                                        List<
                                                                QueryDocumentSnapshot<
                                                                    Object?>>
                                                            docs = data.docs;
                                                        if (docs.isEmpty) {
                                                          return const TextWidget(
                                                              "Nessun cacco da mostrare",
                                                              fontSize: 18,
                                                              fontWeight:
                                                                  AppFontWeight
                                                                      .semiBold,
                                                              textColor: AppColors
                                                                  .heavyBrown);
                                                        } else {
                                                          List<
                                                                  QueryDocumentSnapshot<
                                                                      Object?>>
                                                              caccoArray =
                                                              List.empty(
                                                                  growable:
                                                                      true);

                                                          //Ordina dalla piÃ¹ recente
                                                          docs.sort((a, b) => b[
                                                                  'timeStamp']
                                                              .toString()
                                                              .compareTo(a[
                                                                      'timeStamp']
                                                                  .toString()));
                                                          for (QueryDocumentSnapshot<
                                                                  Object?> cacco
                                                              in docs) {
                                                            caccoArray
                                                                .add(cacco);
                                                          }

                                                          if (caccoArray
                                                              .isEmpty) {
                                                            return const Center(
                                                                child: TextWidget(
                                                                    "Nessun cacco da mostrare",
                                                                    fontSize:
                                                                        18,
                                                                    fontWeight:
                                                                        AppFontWeight
                                                                            .semiBold,
                                                                    textColor:
                                                                        AppColors
                                                                            .heavyBrown));
                                                          } else {
                                                            return ListViewBuilder(
                                                              data: caccoArray,
                                                              itemType: ItemType
                                                                  .CACCO_HOME_VIEW,
                                                              scale: 1.0,
                                                              shrinkWrap: true,
                                                              scrollPhysics:
                                                                  const AlwaysScrollableScrollPhysics(),
                                                              onTap:
                                                                  (QueryDocumentSnapshot<
                                                                          Object?>
                                                                      cacco) {
                                                                Navigation.navigate(
                                                                    context,
                                                                    CaccoFormPage());
                                                              },
                                                            );
                                                          }
                                                        }
                                                      })))))
                                ],
                              ));
                        },
                      );
                    }
                  }
                });
          },
        ));
  }
}
