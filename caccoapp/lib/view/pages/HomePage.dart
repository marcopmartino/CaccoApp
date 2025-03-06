import 'dart:async';

import 'package:CaccoApp/helpers/LoginService.dart';
import 'package:CaccoApp/models/LoggedUser.dart';
import 'package:CaccoApp/utility/AppColors.dart';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:app_links/app_links.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:logo_n_spinner/logo_n_spinner.dart';

import '../../helpers/Utils.dart';
import '../../utility/CaccoIcons.dart';
import '../../utility/Navigation.dart';
import '../../utility/ScheduledFunction.dart';
import './homeTabs/HomeTab.dart';
import 'CaccoFormPage.dart';
import 'GroupFormPage.dart';
import 'InvitePage.dart';
import 'homeTabs/GroupsTab.dart';

class HomePage extends StatefulWidget{
  const HomePage({super.key, this.index = 0 });

  static const route = '/homepage';

  final int index;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>{
  StreamSubscription<Uri>? _linkSubscription;

  bool loading = true; //Variabile per il caricamento della pagina

  final LoggedUser? userData = LoginService.loggedInUserModel; //Dati dell'utente loggato

  int _selectedIndex = 0; //Indice della pagina della home
  final PageController _pageViewController = PageController(); //Controller per le pagine della home

  static const List<Widget> _widgetOptions = <Widget>[
    HomeTab(),
    GroupsTab(),
  ]; //Lista delle pagine della home

  void _onItemTapped(int index){
    setState(() {
      _selectedIndex = index;
    });
    _pageViewController.animateToPage(index, duration: const Duration(milliseconds: 500), curve: Curves.ease);
  } //Funzione per cambiare la pagina della home

  @override
  void initState(){
    _selectedIndex = widget.index;
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
    _linkSubscription = AppLinks().uriLinkStream.listen((Uri link) {
      _handleDeepLink(link);
    }, onError: (Object err){
      if (kDebugMode) {
        print("Error in deep link: $err");
      }
    });
  }

  void _handleDeepLink(Uri uri){
    if(uri.queryParameters['groupId'] != null){
      String? groupId= uri.queryParameters['groupId'];
      Navigation.navigateFromLeft(context, InvitePage(groupId: groupId!));
    }
  }

  @override
  void dispose(){
    _linkSubscription?.cancel();
    _pageViewController.dispose();
    super.dispose();
  }

  @pragma('vm:entry-point')
  void alarmStarter(String code) async{
    await AndroidAlarmManager.periodic(const Duration(hours: 2), 104, ScheduledFunction.checkLastCacco);
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
      backgroundColor: AppColors.lightBlack,
      body: PageView(
        controller: _pageViewController,
        children: <Widget>[
          _widgetOptions[0],
          _widgetOptions[1],
        ],
        onPageChanged: (index){
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.caramelBrown,
        onPressed: (){
          if (_selectedIndex == 0){
            Navigation.navigateFromBottom(context, CaccoFormPage());
          }else if(_selectedIndex == 1){
            Navigation.navigateFromBottom(context, GroupFormPage());
          }
        },
        child: _selectedIndex == 0 ?
          const Icon(CaccoIcons.addPoop, size:28,color: Colors.white, ) :
          const Icon(Icons.group_add_outlined, size:20, color: Colors.white),
      ),
      bottomNavigationBar: Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(50),
              topLeft: Radius.circular(50),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black38,
                spreadRadius: 0,
                blurRadius: 10,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(50),
              topLeft: Radius.circular(50),
            ),
            child: NavigationBarTheme(
                data: const NavigationBarThemeData(
                  indicatorColor: Colors.white,
                  labelTextStyle: WidgetStatePropertyAll(
                      TextStyle(color: Colors.white, fontSize: 11)
                  ),
                ),
                child: NavigationBar(
                  animationDuration: const Duration(seconds: 1),
                  labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
                  selectedIndex: _selectedIndex,
                  height: 60,
                  elevation: 5,
                  backgroundColor: AppColors.mainBrown,
                  onDestinationSelected: (int index){
                    _onItemTapped(index);
                  },
                  destinations: const [
                    NavigationDestination(
                      icon: Icon(Icons.home, color: Colors.white),
                      selectedIcon: Icon(Icons.home),
                      label: 'Home',
                    ),
                    NavigationDestination(
                      icon: Icon(Icons.people_rounded, color: Colors.white),
                      selectedIcon: Icon(Icons.people_rounded),
                      label: 'Groups',
                    ),
                  ],
                )
            ),
          )
      ),
    );
  }


}