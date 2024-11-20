import 'package:CaccoApp/view/widget/CustomDecoration.dart';
import 'package:CaccoApp/view/widget/TextWidgets.dart';
import 'package:flutter/material.dart';

class CustomElevatedButton extends StatelessWidget {
  final BorderRadiusGeometry? borderRadius;
  final double? width;
  final double height;
  final Gradient gradient;
  final VoidCallback? onPressed;
  final Widget child;

  const CustomElevatedButton({
    Key? key,
    required this.onPressed,
    required this.child,
    this.borderRadius,
    this.width,
    this.height = 44.0,
    this.gradient = const LinearGradient(colors: [Colors.cyan, Colors.indigo]),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final borderRadius = this.borderRadius ?? BorderRadius.circular(0);
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: borderRadius,
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(borderRadius: borderRadius)
        ),
        child: child,
      ),
    );
  }
}

class CustomElevatedIconButton extends StatelessWidget {
  final BorderRadiusGeometry? borderRadius;
  final double? width;
  final double height;
  final Gradient gradient;
  final Icon icon;
  final Text label;
  final VoidCallback? onPressed;

  const CustomElevatedIconButton({
    Key? key,
    required this.onPressed,
    required this.label,
    required this.icon,
    this.borderRadius,
    this.width,
    this.height = 44.0,
    this.gradient = const LinearGradient(colors: [Colors.cyan, Colors.indigo]),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final borderRadius = this.borderRadius ?? BorderRadius.circular(0);
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: borderRadius,
      ),
      child: ElevatedButton.icon(
        icon: icon,
        label: label,
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(borderRadius: borderRadius)
        ),
      ),
    );
  }
}

class CustomButtons{

  static submit(String text, {required void Function() onPressed}){
    return ElevatedButton(
      style: CustomDecoration.submitButtonDecoration(),
      onPressed: () => onPressed(),
      child: TitleWidget.formButton(text),
    );
  }

  static delete(String text, {required void Function() onPressed}) {
    return ElevatedButton(
        style: CustomDecoration.deleteButtonDecoration(),
        onPressed: () => onPressed(),
        child: TitleWidget.formButton(text)
    );
  }
}