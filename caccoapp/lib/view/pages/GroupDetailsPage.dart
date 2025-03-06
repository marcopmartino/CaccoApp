import 'package:CaccoApp/helpers/LoginService.dart';
import 'package:CaccoApp/view/pages/GroupFormPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:floating_snackbar/floating_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:logo_n_spinner/logo_n_spinner.dart';
import 'package:share_plus/share_plus.dart';

import '../../helpers/Utils.dart';
import '../../network/GroupsNetwork.dart';
import '../../network/UsersNetwork.dart';
import '../../utility/AppColors.dart';
import '../../utility/DocumentStreamBuilder.dart';
import '../../utility/Navigation.dart';
import '../item/Item.dart';
import '../widget/TextWidgets.dart';

class GroupDetailsPage extends StatefulWidget {
  static const String route = 'profileDetails';
  final String groupId;

  const GroupDetailsPage({super.key, required this.groupId});

  @override
  State<GroupDetailsPage> createState() => _GroupDetailsPage();
}

class _GroupDetailsPage extends State<GroupDetailsPage> {
  bool _isProcessing = false;

  late DocumentSnapshot<Object?> _oldGroups;

  void startLoadingAnimation() {
    setState(() {
      _isProcessing = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBlack,
      appBar: Utils.getAppbarGroups(context, "Dettagli gruppo", widget.groupId),
      body: FutureBuilder(
        future: GroupsNetwork.getGroupDetails(widget.groupId),
        builder: (BuildContext builder, AsyncSnapshot<DocumentSnapshot> groupInfo) {
          if (groupInfo.connectionState == ConnectionState.waiting) {
            return const Scaffold(
                body: Center(
                    child: LogoandSpinner(
                      imageAssets: 'assets/temp-image.jpg',
                      reverse: true,
                      arcColor: AppColors.mainBrown,
                      spinSpeed: Duration(milliseconds: 500),
                    )
                )
            );
          } else if(_isProcessing){
            return const Scaffold(
              backgroundColor: AppColors.lightBlack,
              body: Center(
                child: LogoandSpinner(
                  imageAssets: 'assets/temp-image.jpg',
                  reverse: true,
                  arcColor: AppColors.mainBrown,
                  spinSpeed: Duration(milliseconds: 500),
                )
              )
            );
          }else{
            _oldGroups = groupInfo.data!;
            return Padding(
              padding: const EdgeInsets.only(top: 15, right: 5, left: 5, bottom: 10),
              child: Column(
                mainAxisSize: MainAxisSize.min,
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
                              groupInfo.data!['name'].toString(),
                              fontSize: 20,
                            )
                          ), //Nome gruppo
                          const SizedBox(height: 15),
                           //Immagine gruppo
                          Center(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: Image.asset(
                                'assets/exemple-poop.png',
                                height: 90.0,
                                 width: 90.0),
                            )
                          ),
                          const SizedBox(height: 15,),
                          infoRow(context,
                            groupInfo.data!['membersCounter'].toString(),
                            groupInfo.data!['creationDate'].toString()), // Membri e data creazione
                          const SizedBox(height: 10),
                          groupInfo.data!['adminId'] == LoginService.loggedInUserModel!.id?
                            Row(
                              children: [
                                Expanded(
                                  flex: 3,
                                  child: editButton(context),
                                ),
                                Expanded(
                                  flex: 3,
                                  child: shareButton(context, groupInfo.data!['name']),
                                ),
                                Expanded(
                                  flex: 3,
                                  child: deleteButton(context),
                                )
                              ],  
                            ): //Se utente é admin
                            Expanded(
                              child: shareButton(context, groupInfo.data!['name']
                            )
                          ), // Se utente non é admin
                        ],
                      )
                    )
                  ),
                  const Divider(indent: 36, endIndent: 36, color: Colors.yellow),// Lista membri
                  Expanded(
                    child: rankingList(context),
                  )
                ]
              )
            );
          }
        }
      )
    );
  }

  // Buttone per eliminare un gruppo
  Widget deleteButton(BuildContext context) {
    return Center(
      child: IconButton.filled(
        onPressed: () async {
          showDialog(
            context: context,
            builder: (dialogContext) {
              return AlertDialog(
                title: const Text('Conferma eliminazione'),
                content: const Text('Sei sicuro di voler eliminare questo gruppo?'),
                actionsPadding: const EdgeInsets.symmetric(horizontal: 16),
                actionsAlignment: MainAxisAlignment.spaceAround,
                actions: [
                  TextButton(
                    child: const Text(
                      'Si',
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 18)
                    ),
                    onPressed: () async {
                      Navigator.pop(dialogContext);
                      startLoadingAnimation();

                      for (var member in _oldGroups['members']) {
                        await UsersNetwork.removeGroup(member, widget.groupId);
                      }

                      //Elimino gruppo
                      await GroupsNetwork.deleteGroup(widget.groupId).then((_) {
                        Future.delayed(const Duration(seconds: 1), () =>{
                          if (context.mounted) Navigator.pop(context)
                        });
                      });
                    },
                  ),
                  TextButton(
                    child: const Text('No', style: TextStyle(color: AppColors.mainBrown, fontSize: 18)),
                    onPressed: () {
                      Navigator.pop(dialogContext);
                      },
                  )
                ],
              );
            });
        },
        style: IconButton.styleFrom(
          backgroundColor: Colors.redAccent,
        ),
        icon: const Icon(Icons.delete_outlined),
      )
    );
  }

  // Lista utenti
  Widget rankingList(BuildContext context){
    return SizedBox(
      width: double.infinity,
      child: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height - 65),
          child: ListViewStreamBuilderNoTap(
            stream: UsersNetwork.getGroupMembersList(widget.groupId),
            itemType: ItemType.RANKING_GROUP,
            filterFunction: (List<QueryDocumentSnapshot<Object?>> data) {
              data.sort((a, b) => b['currentMonthPoops'].toString().compareTo(a['currentMonthPoops'].toString()));
              return data;
            },
          ),
        )
      )
    );
  }

  //Riga con le info relative a numero membri e data creazione
  Widget infoRow(BuildContext context, String memberCounter, String creationDate){
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Center(
            child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                children: <TextSpan>[
                  TextSpan(
                    text: "$memberCounter\n",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black
                    )
                  ),
                  const TextSpan(
                    text: "Membri",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black
                    ),
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
                    text: "$creationDate\n",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black
                    )
                  ),
                  const TextSpan(
                    text: "Data creazione",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black
                    ),
                  )
                ]
              )
            )
          )
        ),
    ],
    );
  }

  //Bottone modifica
  Widget shareButton(BuildContext context, String name){
    return Center(
      child: IconButton.filled(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue
        ),
        onPressed: () {
          String inviteUrl = "http://www.caccoapp.it?groupId=${widget.groupId}";
          Share.share("Vuoi competere con me? Unisciti al gruppo $name su CaccoApp! $inviteUrl");
          floatingSnackBar(
            message: "Invito inviato",
            backgroundColor: Colors.blue,
            textStyle: const TextStyle(fontSize: 18),
            context: context,
            duration: const Duration(seconds: 5)
          );
        },
        icon: const Icon(Icons.share_outlined),
      )
    );
  }

  //Bottone per accedere alla schermata di modifica
  Widget editButton(BuildContext context){
    return Center(
      child: IconButton.filled(
        style: IconButton.styleFrom(
          backgroundColor: AppColors.mainBrown
        ),
        onPressed: () {
          Navigation.navigateFromLeft(context,
              GroupFormPage.edit(groupId: widget.groupId));
        },
        icon: const Icon(Icons.edit_outlined),
      ),
    );
  }

}
