import 'package:flutter/material.dart';
import 'package:CaccoApp/utility/AppColors.dart';

class ThemeButton extends StatelessWidget {

  String? label;
  Function onClick;
  Color color;
  Color? highlight;
  Widget? icon;
  Color borderColor;
  Color labelColor;
  double borderWidth;

  ThemeButton({super.key,
    this.label,
    this.labelColor = Colors.white,
    this.color = AppColors.mainShit,
    this.highlight = AppColors.problemShit,
    this.icon,
    this.borderColor = Colors.transparent,
    this.borderWidth = 4,
    required this.onClick });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
      child: ClipRRect(
          borderRadius: BorderRadius.circular(50),
          child: Material(
            color: color,
            child: InkWell(
              splashColor: highlight,
              highlightColor: highlight,
              onTap: () {
                onClick();
              },
              child: Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      border: Border.all(
                          color: borderColor,
                          width: borderWidth)
                  ),
                  child: icon == null ?
                  Text(label!,
                      style: TextStyle(
                          fontSize: 16,
                          color: labelColor,
                          fontWeight: FontWeight.bold)) :
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      icon!,
                      const SizedBox(width: 10),
                      Text(label!,
                          style: TextStyle(
                              fontSize: 16,
                              color: labelColor,
                              fontWeight: FontWeight.bold)),
                    ],
                  )
              ),
            ),
          )),
    );
  }
}