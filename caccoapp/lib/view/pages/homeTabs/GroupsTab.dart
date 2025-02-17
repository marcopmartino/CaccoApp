import 'dart:convert';
import 'dart:developer';

import 'package:CaccoApp/utility/Extensions.dart';
import 'package:CaccoApp/view/pages/GroupDetailsPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:logo_n_spinner/logo_n_spinner.dart';
import 'package:multi_stream_builder/multi_stream_builder.dart';

import '../../../network/GroupsNetwork.dart';
import '../../../network/UsersNetwork.dart';
import '../../../utility/AppColors.dart';
import '../../../utility/DocumentStreamBuilder.dart';
import '../../../utility/ListViewBuilders.dart';
import '../../../utility/Navigation.dart';
import '../../item/Item.dart';

class GroupsTab extends StatefulWidget{
  const GroupsTab({super.key});

  @override
  State<GroupsTab> createState() => _GroupsTabState();
}

class _GroupsTabState extends State<GroupsTab>{
  bool _noGroup = true;


  var emptyList = Center(
      child:ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: Image.asset(
          'assets/backgroundPoop.png',
          height: 150.0,
          width: 150.0,
        ),
      )
  );


  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Colors.black54,
      body: Column(
        children:[
          FutureBuilder(
            future: Future.wait([
              UsersNetwork.getUserGroupsList(FirebaseAuth.instance.currentUser!.uid),
            ]),
            builder: (BuildContext context, AsyncSnapshot<dynamic> futureList){
              if (!futureList.hasData){
                return const LogoandSpinner(
                  imageAssets: 'assets/temp-image.jpg',
                  reverse: true,
                  arcColor: AppColors.mainBrown,
                  spinSpeed: Duration(milliseconds: 500),
                );
              }
              final userGroupsList = futureList.data[0];
              return _noGroup?
               ListViewStreamBuilder(
                  stream: GroupsNetwork.getGroupsList(),
                  itemType: ItemType.GROUP,
                  scale: 1.5,
                  expanded: true,
                  onTap: (QueryDocumentSnapshot<Object?> groupData) {
                    Navigation.navigate(context, GroupDetailsPage(groupId: groupData.id));
                  },
                  filterFunction: (List<QueryDocumentSnapshot<Object?>> data) {
                    List<QueryDocumentSnapshot<Object?>> filteredData = List.empty(growable: true);
                    for (QueryDocumentSnapshot<Object?> group in data) {
                      for (var j=0; j<userGroupsList.length; j++){
                        if(group.id == userGroupsList[j]){
                          filteredData.add(group);
                        }
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
              );
            }
        )]
      ),
    );
  }


}