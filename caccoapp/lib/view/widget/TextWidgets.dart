import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:CaccoApp/utility/AppFontWeight.dart';

import '../../utility/AppColors.dart';
import 'CustomDecoration.dart';

class TitleWidget extends StatelessWidget {
  final String text;
  final double fontSize;
  final Color textColor;

  const TitleWidget(this.text, {super.key, this.fontSize = 18, this.textColor = AppColors.problemBrown});
  const TitleWidget.formButton(this.text, {super.key, this.fontSize = 20, this.textColor = Colors.white});

  @override
  Widget build(BuildContext context) {
    return Text(
      text.toUpperCase(),
      textAlign: TextAlign.start,
      style: TextStyle(
        fontSize: fontSize,
        fontFamily: 'BalooBhai',
        color: textColor,
      ),
    );
  }
}

class SubtitleWidget extends StatelessWidget {
  final String text;
  final double fontSize;
  final Color textColor;
  final FontWeight? fontWeight;

  const SubtitleWidget(this.text, {super.key, this.fontSize = 16, this.textColor = AppColors.mainBrown, this.fontWeight = AppFontWeight.semiBold});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: TextAlign.start,
      style: TextStyle(
        fontSize: fontSize,
        fontFamily: 'BalooBhai2',
        fontWeight: fontWeight,
        color: textColor,
      ),
    );
  }
}

class TextWidget extends StatelessWidget {
  final String text;
  final double fontSize;
  final Color textColor;
  final FontWeight? fontWeight;

  const TextWidget(this.text, {super.key, this.fontSize = 16, this.textColor = Colors.black, this.fontWeight});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: TextAlign.start,
      style: TextStyle(
        fontSize: fontSize,
        fontFamily: 'BalooBhai2',
        fontWeight: fontWeight,
        color: textColor,
      ),
    );
  }
}

class IconTextWidget extends StatelessWidget {
  final String text;
  final double fontSize;
  final Color textColor;
  final double iconSize;
  final Color iconColor;
  final FontWeight fontWeight;
  final IconData icon;
  final double innerPadding;
  final Function()? onIconTap;

  const IconTextWidget({super.key,
    required this.text,
    this.fontSize = 18,
    this.textColor = Colors.black,
    this.fontWeight = AppFontWeight.medium,
    required this.icon,
    this.iconSize = 35.0,
    this.iconColor = AppColors.mainBrown,
    this.innerPadding = 16.0,
    this.onIconTap});

  @override
  Widget build(BuildContext context) {
    Icon tempIcon = Icon(icon, size: iconSize, color: iconColor);

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
            padding: EdgeInsets.only(right: innerPadding),
            child: onIconTap == null ? tempIcon : GestureDetector(
                onTap: () => onIconTap!(),
                child: tempIcon
            )
        ),
        TextWidget(text, fontWeight: fontWeight, textColor: textColor, fontSize: fontSize)
      ],
    );
  }
}

class TextFormFieldWidget extends StatelessWidget {
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final String label;
  final String hint;
  final int? minLines;
  final int? maxLines;
  final bool obscureText;
  final InputDecoration? decoration;
  late final TextInputType? keyboardType;
  late final List<TextInputFormatter>? inputFormatters;


  TextFormFieldWidget({
    super.key,
    required this.controller,
    this.validator,
    this.label = '',
    this.hint = '',
    this.obscureText = false,
    this.keyboardType,
    this.inputFormatters,
    this.minLines,
    this.maxLines,
    this.decoration
  });

  TextFormFieldWidget.numeric({
    super.key,
    required this.controller,
    this.validator,
    this.label = '',
    this.obscureText = false,
    this.hint = '',
    this.minLines,
    this.maxLines,
    this.decoration
  })
  {
    keyboardType = TextInputType.number;
    inputFormatters = <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly];
  }

  TextFormFieldWidget.multiline({super.key,
    required this.controller,
    this.validator,
    this.label = '',
    this.hint = '',
    this.obscureText = false,
    this.inputFormatters,
    this.minLines = 1,
    this.maxLines = 5,
    this.decoration
  })
  {
    keyboardType = TextInputType.multiline;
  }

  TextFormFieldWidget.psw({super.key,
    required this.controller,
    this.validator,
    this.label = '',
    this.hint = '',
    required this.obscureText,
    this.keyboardType,
    this.inputFormatters,
    this.minLines = 1,
    this.maxLines = 1,
    this.decoration
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      validator: validator,
      minLines: minLines, // Normal textInputField will be displayed,
      maxLines: maxLines,
      obscureText: obscureText,
      style: const TextStyle(color: Colors.white),
      decoration: decoration ?? CustomDecoration.textFieldInputDecoration(label, hint),
    );
  }

}