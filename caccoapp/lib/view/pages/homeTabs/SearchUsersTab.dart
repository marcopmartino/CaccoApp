import 'package:CaccoApp/helpers/LoginService.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../../network/UsersNetwork.dart';
import '../../../utility/AppColors.dart';
import '../../../utility/DocumentStreamBuilder.dart';
import '../../../utility/Navigation.dart';
import '../../item/Item.dart';
import '../../widget/CustomDecoration.dart';
import '../UserDetailsPage.dart';

class SearchUsersTab extends StatefulWidget{
  const SearchUsersTab({super.key});

  @override
  State<SearchUsersTab> createState() => _SearchUsersTabState();
}

class _SearchUsersTabState extends State<SearchUsersTab>{

  final _searchController = TextEditingController();

  var _searchValue = '';

  var user = LoginService.loggedInUserModel;

  @override
  Widget build(BuildContext context){
    return Scaffold(
        backgroundColor: AppColors.lightBlack,
        body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8, top: 16, right: 8, bottom: 16),
                child: TextField(
                    controller: _searchController,
                    style: const TextStyle(color: Colors.black),

                    decoration: CustomDecoration.searchInputDecoration('', 'Inserire nome utente da cercare'),
                    onChanged: (text) {
                      setState(() {
                        _searchValue = _searchController.text;
                      });
                    }
                ),
              ),
              _searchValue.isNotEmpty ?
              ListViewStreamBuilder(
                  stream: UsersNetwork.getUsersList(),
                  itemType: ItemType.USER_SEARCH,
                  scale: 1.5,
                  expanded: true,
                  onTap: (QueryDocumentSnapshot<Object?> user) {
                    Navigation.navigateFromLeft(context, UserDetailsPage(userId: user.id, username: user['username']));
                  },
                  filterFunction: (List<QueryDocumentSnapshot<Object?>> data) {
                    List<QueryDocumentSnapshot<Object?>> filteredData = List.empty(growable: true);
                    for (QueryDocumentSnapshot<Object?> document in data) {
                      if (document['username'].toString().contains(_searchValue) &&
                          document['username'].toString() != user!.username.toString()) {
                        filteredData.add(document);
                      }
                    }
                    return filteredData;
                  }
              ) :
              ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.asset(
                    'assets/exemple-poop.png',
                    height: 150.0,
                    width: 150.0,
                ),
              ),

            ]
        )
    );
  }
}