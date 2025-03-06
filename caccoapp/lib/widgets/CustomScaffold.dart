import 'package:flutter/material.dart';
import 'package:CaccoApp/utility/AppColors.dart';


class CustomScaffold extends StatelessWidget {
  final String title;
  final Widget body;
  final FloatingActionButton? floatingActionButton;
  final bool withAppbar;
  final bool resize;

  const CustomScaffold({super.key, required this.title, this.resize = false, this.withAppbar = false, this.floatingActionButton, required this.body});
  const CustomScaffold.form({super.key, required this.title, this.resize = true, this.withAppbar = false, this.floatingActionButton, required this.body});
  const CustomScaffold.withAppbar({super.key, required this.title, this.resize = false, this.withAppbar = true, this.floatingActionButton, required this.body});

  @override
  Scaffold build(BuildContext context) {
    return Scaffold(
      appBar: withAppbar ? AppBar(
          backgroundColor: AppColors.mainBrown,
          title: Text(title, style: const TextStyle(fontFamily: 'Matemasie'))
      ) : null,
      backgroundColor: AppColors.lightBlack,
      body: body,
      floatingActionButton: floatingActionButton,
      resizeToAvoidBottomInset: resize,
    );
  }
}