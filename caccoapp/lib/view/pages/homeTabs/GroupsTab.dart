import 'package:CaccoApp/view/pages/GroupDetailsPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../network/GroupsNetwork.dart';
import '../../../network/UsersNetwork.dart';
import '../../../utility/AppColors.dart';
import '../../../utility/AppFontWeight.dart';
import '../../../utility/DocumentStreamBuilder.dart';
import '../../../utility/Navigation.dart';
import '../../item/Item.dart';

class GroupsTab extends StatefulWidget{
  const GroupsTab({super.key});

  static const route = '/homepage/groups';

  @override
  State<GroupsTab> createState() => _GroupsTabState();
}

Widget emptyList(BuildContext context){
  return Expanded(
      flex: 2,
      child: Center(
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.8,
            child: Column(
              children: [
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 200.0, bottom: 0.0),
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
                      "Non fai parte di nessun gruppo! \nCrea un gruppo o fatti invitare da un amico!",
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
            ),
          )
      )
  );
}

class _GroupsTabState extends State<GroupsTab>{
  List<QueryDocumentSnapshot<Object?>> filteredData = List
      .empty(growable: true);

  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: AppColors.lightBlack,
      body: Column(
        children:[
          DocumentStreamBuilder(
            stream: UsersNetwork.getUserGroupsListStream(),
            builder: (BuildContext context, DocumentSnapshot<Object?> userGroupsList){
              return userGroupsList['groups'] != []?
                ListViewStreamBuilderEmptyList(
                  stream: GroupsNetwork.getGroupsList(),
                  empty: emptyList(context),
                  itemType: ItemType.GROUP,
                  scale: 1.5,
                  expanded: true,
                  onTap: (QueryDocumentSnapshot<Object?> groupData) {
                    Navigation.navigateFromLeft(context, GroupDetailsPage(groupId: groupData.id));
                  },
                  filterFunction: (List<QueryDocumentSnapshot<Object?>> data) {
                    filteredData.clear();
                    for (QueryDocumentSnapshot<Object?> group in data) {
                      for (var j = 0; j < userGroupsList['groups'].length; j++) {
                        if (kDebugMode) {
                          print(group.id);
                        }
                        if (kDebugMode) {
                          print(userGroupsList['groups'][j]);
                        }
                        if (group.id == userGroupsList['groups'][j]) {
                          filteredData.add(group);
                        }
                      }
                    }
                    return filteredData;
                  }
              ): emptyList(context);
            }
          )
        ]
      ),
    );
  }


}