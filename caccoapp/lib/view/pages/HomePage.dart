import 'dart:async';

import 'package:CaccoApp/helpers/LoginService.dart';
import 'package:CaccoApp/models/LoggedUser.dart';
import 'package:CaccoApp/utility/AppColors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:logo_n_spinner/logo_n_spinner.dart';
import 'package:uni_links5/uni_links.dart';

import '../../helpers/Utils.dart';
import '../../utility/CaccoIcons.dart';
import '../../utility/Navigation.dart';
import './homeTabs/HomeTab.dart';
import 'CaccoFormPage.dart';
import 'GroupDetailsPage.dart';
import 'GroupFormPage.dart';
import 'InvitePage.dart';
import 'homeTabs/GroupsTab.dart';

class HomePage extends StatefulWidget{
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>{
  String _currentPage = 'Home';
  String _link = "No deep link detected";
  late StreamSubscription _sub;

  bool loading = true; //Variabile per il caricamento della pagina

  final LoggedUser? userData = LoginService.loggedInUserModel; //Dati dell'utente loggato

  int _selectedIndex = 0; //Indice della pagina della home

  static const List<Widget> _widgetOptions = <Widget>[
    HomeTab(),
    GroupsTab(),
  ]; //Lista delle pagine della home

  void _onItemTapped(int index){
    setState(() {
      _selectedIndex = index;
    });
  } //Funzione per cambiare la pagina della home

  @override
  void initState(){
    super.initState();
    _getUserData();
    _initLinkListener();
  }

  //Funzione per ottenere i dati dell'utente loggato
  void _getUserData(){
    LoginService.getLoggedUserData().then((_){
      setState(() { loading = false; });
    });
  }

  //Funzione per inizializzare il listener per i deep link
  Future<void> _initLinkListener() async{
    _sub = linkStream.listen((String? link) {
      setState((){
        _link = link ?? "No deep link detected";
      });

      if(link != null){
        _handleDeepLink(link);
      }
    }, onError: (Object err){
      print("Error in deep link: $err");
    });

    try {
      final initialLink = await getInitialLink();
      if (initialLink != null) {
        _handleDeepLink(initialLink);
      }
    }catch(e){
      print("Error in deep link: $e");
    }
  }

  void _handleDeepLink(String link){
    Uri uri = Uri.parse(link);
    if(uri.queryParameters['groupId'] != null){
      String? groupId= uri.queryParameters['groupId'];
      Navigation.navigate(context, InvitePage(groupId: groupId!));
    }
  }

  @override
  void dispose(){
    super.dispose();
    _sub.cancel();
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
        appBar: Utils.getAppbarHome(context),
        extendBody: true,
        body: Center(
          child: _widgetOptions.elementAt(_selectedIndex),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingActionButton(
          backgroundColor: AppColors.caramelBrown,
          onPressed: (){
            if (_selectedIndex == 0){
              Navigation.navigate(context, CaccoFormPage());
            }else if(_selectedIndex == 1){
              Navigation.navigate(context, GroupFormPage());
            }
          },
          child: _selectedIndex == 0 ?
            const Icon(CustomIcons.addPoop, size:20,) : const Icon(Icons.group_add_outlined, size:20),
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
          ),
        );
  }


}