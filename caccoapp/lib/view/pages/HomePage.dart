import 'package:CaccoApp/helpers/LoginService.dart';
import 'package:CaccoApp/models/LoggedUser.dart';
import 'package:CaccoApp/utility/AppColors.dart';
import 'package:flutter/material.dart';
import 'package:logo_n_spinner/logo_n_spinner.dart';

import '../../helpers/Utils.dart';
import '../../utility/Navigation.dart';
import './homeTabs/HomeTab.dart';
import 'CaccoFormPage.dart';
import 'GroupFormPage.dart';
import 'homeTabs/SearchUsersTab.dart';
import 'homeTabs/GroupsTab.dart';

class HomePage extends StatefulWidget{
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>{

  bool loading = true;
  bool _isVisible = true;

  final LoggedUser? userData = LoginService.loggedInUserModel;

  int _selectedIndex = 0;
  static const TextStyle optionStyle =
  TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  static const List<Widget> _widgetOptions = <Widget>[
    HomeTab(),
    //SearchUsersTab(),
    GroupsTab(),
  ];

  void _onItemTapped(int index){
    setState(() {
      //index == 1 || index == 3 ? _isVisible = false : _isVisible = true;
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
    if(loading){
      return const LogoandSpinner(
        imageAssets: 'assets/temp-image.jpg',
        reverse: true,
        arcColor: AppColors.mainBrown,
        spinSpeed: Duration(milliseconds: 500),
      );
    }

    return Scaffold(
        appBar: Utils.getAppbar(context),
        extendBody: true,
        body: Center(
          child: _widgetOptions.elementAt(_selectedIndex),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: Visibility(
          visible: _isVisible,
          child: FloatingActionButton(
            backgroundColor: AppColors.caramelBrown,
            onPressed: (){
              if (_selectedIndex == 0){
                Navigation.navigate(context, CaccoFormPage());
              }else if(_selectedIndex == 1){
                Navigation.navigate(context, GroupFormPage());
              }
            },
            child: const Icon(Icons.add, size:20),
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          color: AppColors.mainBrown,
          shape: const CircularNotchedRectangle(),
          notchMargin: 5,
          height: 60,
          clipBehavior: Clip.antiAlias,
          child: BottomNavigationBar(
            backgroundColor: AppColors.mainBrown,
            type: BottomNavigationBarType.fixed,
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              /*BottomNavigationBarItem(
                icon: Icon(Icons.handshake_rounded),
                label: 'Friends',
              ),*/
              BottomNavigationBarItem(
                icon: Icon(Icons.people_rounded),
                label: 'Groups',
              ),
              /*BottomNavigationBarItem(
                icon: Icon(Icons.person_rounded),
                label: 'Profile'
              )*/
            ],
            currentIndex: _selectedIndex,
            selectedItemColor: AppColors.sandBrown,
            unselectedItemColor: AppColors.caramelBrown,
            onTap: _onItemTapped,
          ),
          ),
        );
        /*bottomNavigationBar: BottomAppBar(
          color: AppColors.caramelBrown,
          shape: const CircularNotchedRectangle(),
          child: BottomNavigationBar(

            backgroundColor: AppColors.mainBrown,
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              /*BottomNavigationBarItem(
                                icon: Icon(Icons.person_add_rounded),
                                label: 'Friends',
                              ),*/
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
              /*child: ClipRRect(
                borderRadius: const BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
                child:
              )*/
        )*/
        /*child: Container(
            decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(topRight: Radius.circular(30), topLeft: Radius.circular(30)),
            boxShadow: [BoxShadow(color:Colors.black38, spreadRadius: 0, blurRadius: 10)],
          ),*/
  }

  void _getUserData(){
    LoginService.getLoggedUserData().then((_){
      setState(() { loading = false; });
    });
  }
}