import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../network/GroupsNetwork.dart';
import '../../../utility/AppColors.dart';
import '../../../utility/DocumentStreamBuilder.dart';
import '../../../utility/Navigation.dart';
import '../../item/Item.dart';

class GroupsTab extends StatefulWidget{
  const GroupsTab({super.key});

  @override
  State<GroupsTab> createState() => _GroupsTabState();
}

class _GroupsTabState extends State<GroupsTab>{
  bool _noGroup = false;

  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Colors.black54,
      body: Container(
        padding: const EdgeInsets.all(16),
        child: _noGroup?
        ListViewStreamBuilder(
            stream: GroupsNetwork.getGroupsList(),
            itemType: ItemType.GROUP,
            scale: 1.5,
            expanded: true,
            onTap: (QueryDocumentSnapshot<Object?> user) {
              //Navigation.navigate(context, UserDetailsPage(userId: user.id, username: user['username']));
            },
            filterFunction: (List<QueryDocumentSnapshot<Object?>> data) {
              List<QueryDocumentSnapshot<Object?>> filteredData = List.empty(growable: true);
              for (QueryDocumentSnapshot<Object?> group in data) {
                if (group['members'].contains(FirebaseAuth.instance.currentUser!.uid)) {
                  filteredData.add(group);
                }
              }
              _noGroup = filteredData.isEmpty;
              return filteredData;
            }
        ):
        ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: Image.asset(
            'assets/backgroundPoop.png',
            height: 150.0,
            width: 150.0,
          ),
        ),
      ),
    );
  }
}