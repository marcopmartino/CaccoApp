import 'package:flutter/material.dart';

class Navigation {
  static navigateFromBottom(BuildContext context, Widget view, {String? route}){
    Navigator.of(context).push(
        _createRouteFromBottom(view));
  }
  
  static navigateFromLeft(BuildContext context, Widget view, {String? route}){
    Navigator.of(context).push(
        _createRouteFromLeft(view));
  }

  static replaceFromBottom(BuildContext context, Widget view, {String? route}){
    Navigator.of(context).pushReplacement(
        _createRouteFromBottom(view));
  }
  
  static replaceFromLeft(BuildContext context, Widget view, {String? route}){
    Navigator.of(context).pushReplacement(
        _createRouteFromLeft(view));
  }

  static back(BuildContext context){
    Navigator.of(context).pop();
  }

  static backUntil(BuildContext context, String route){
    Navigator.of(context).popUntil(ModalRoute.withName(route));
  }
  
  static removeUntil(BuildContext context, String route){
    Navigator.of(context).pushNamedAndRemoveUntil(route, (route) => false);
  }

  static Route _createRouteFromBottom(Widget child){
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => child,
      transitionDuration: const Duration(milliseconds: 200),
      transitionsBuilder: (context, animation, secondaryAnimation, child){
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        const curve = Curves.ease;

        var tween = Tween(begin: begin, end: end);
        final curvedAnimation = CurvedAnimation(parent: animation, curve: curve);

        var offsetAnimation = tween.animate(curvedAnimation);
        return SlideTransition(
          position: offsetAnimation,
          child: child,
        );
      }
    );
  }

  static Route _createRouteFromLeft(Widget child){
    return PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.linear;

        final tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        final offsetAnimation = animation.drive(tween);

        return SlideTransition(position: offsetAnimation, child: child);
      },
    );
  }

  static void replaceWithoutAnimation(BuildContext context, Widget view, {String? route}){
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        settings: RouteSettings(name: route),
        builder: (context) => view,
      ),
    );
  }
}