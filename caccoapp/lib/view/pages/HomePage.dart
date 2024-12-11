import 'package:CaccoApp/helpers/LoginService.dart';
import 'package:CaccoApp/models/LoggedUser.dart';
import 'package:CaccoApp/utility/AppColors.dart';
import 'package:flutter/material.dart';

import '../../helpers/Utils.dart';
import './homeTabs/HomeTab.dart';
import 'homeTabs/SearchUsersTab.dart';
import 'homeTabs/GroupsTab.dart';

class HomePage extends StatefulWidget{
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>{

  bool loading = true;

  final LoggedUser? userData = LoginService.loggedInUserModel;

  int _selectedIndex = 0;
  static const TextStyle optionStyle =
  TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  static const List<Widget> _widgetOptions = <Widget>[
    HomeTab(),
    SearchUsersTab(),
    GroupsTab(),
  ];

  void _onItemTapped(int index){
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState(){
    super.initState();
    _getUserData();
  }

  @override
  Widget build(BuildContext context) {
    if(loading) return const CircularProgressIndicator();

    return Scaffold(
        appBar: Utils.getAppbar(context),
        extendBody: true,
        body: Center(
          child: _widgetOptions.elementAt(_selectedIndex),
        ),
        bottomNavigationBar: Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(topRight: Radius.circular(30), topLeft: Radius.circular(30)),
              boxShadow: [BoxShadow(color:Colors.black38, spreadRadius: 0, blurRadius: 10)],
            ),
            child: ClipRRect(
              borderRadius: const BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
              child: BottomNavigationBar(
                backgroundColor: AppColors.mainBrown,
                items: const <BottomNavigationBarItem>[
                  BottomNavigationBarItem(
                    icon: Icon(Icons.home),
                    label: 'Home',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.person_add_rounded),
                    label: 'Friends',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.people_rounded),
                    label: 'Groups',
                  ),
                ],
                currentIndex: _selectedIndex,
                selectedItemColor: AppColors.sandBrown,
                unselectedItemColor: AppColors.caramelBrown,
                onTap: _onItemTapped,
              ),
            )
        )
    );
  }

  void _getUserData(){
    LoginService.getLoggedUserData().then((_){
      setState(() { loading = false; });
    });
  }
}