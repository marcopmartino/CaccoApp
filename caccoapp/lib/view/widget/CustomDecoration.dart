import 'package:flutter/material.dart';
import 'package:CaccoApp/utility/AppFontWeight.dart';

import 'package:CaccoApp/utility/AppColors.dart';

class CustomDecoration {

  static InputDecoration loginInputDecoration(String nome){
    return InputDecoration(
        hintStyle: const TextStyle(color: Colors.black),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(
            color: AppColors.heavyBrown,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(
            color: AppColors.mainBrown,
          ),
        ),
        labelStyle: const TextStyle(color: Colors.black),
        filled: true,
        fillColor: Colors.white,
        hintText: nome,
        labelText: nome);
  }

  static InputDecoration textFieldInputDecoration(String nome, String hint){
    return InputDecoration(
      floatingLabelBehavior: FloatingLabelBehavior.always,
      floatingLabelAlignment: FloatingLabelAlignment.start,
      hintStyle: const TextStyle(color: Colors.white30),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(5),
        borderSide: const BorderSide(
          color: AppColors.mainBrown,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(5),
        borderSide: const BorderSide(
          color: AppColors.mainBrown,
        ),
      ),
      labelStyle: const TextStyle(
          fontSize: 20,
          fontWeight: AppFontWeight.bold,
          color: Colors.yellow
      ),
      labelText: nome,
      filled: true,
      fillColor: AppColors.softBrown,
      hintText: hint,
    );
  }

  static InputDecoration searchInputDecoration(String nome, String hint){
    return InputDecoration(
      floatingLabelBehavior: FloatingLabelBehavior.always,
      floatingLabelAlignment: FloatingLabelAlignment.start,
      hintStyle: const TextStyle(color: Colors.black12),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(5),
        borderSide: const BorderSide(
          color: AppColors.mainBrown,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(5),
        borderSide: const BorderSide(
          color: AppColors.mainBrown,
        ),
      ),
      labelStyle: const TextStyle(
          fontSize: 20,
          fontWeight: AppFontWeight.semiBold,
          color: AppColors.mainBrown
      ),
      labelText: nome,
      filled: true,
      fillColor: Colors.white,
      hintText: hint,
      suffixIcon: Container(
        margin: const EdgeInsets.all(8),
        child: IconButton(
          icon: const Icon(Icons.search),
          onPressed: () {

          },
        ),
      ),
    );
  }

  static InputDecoration dropDownInputDecoration(){
    return InputDecoration(
      contentPadding: const EdgeInsets.all(17),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(5),
        borderSide: const BorderSide(
          color: AppColors.mainBrown,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(5),
        borderSide: const BorderSide(
          color: AppColors.mainBrown,
        ),
      ),
      labelStyle: const TextStyle(color: Colors.black),
      filled: true,
      fillColor: Colors.white,
    );
  }

  static InputDecoration dataLabelDecoration(){
    return InputDecoration(
        floatingLabelBehavior: FloatingLabelBehavior.always,
        floatingLabelAlignment: FloatingLabelAlignment.start,
        hintStyle: const TextStyle(color: Colors.black12),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: const BorderSide(
            color: AppColors.mainBrown,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: const BorderSide(
            color: AppColors.mainBrown,
          ),
        ),
        labelStyle: const TextStyle(
            fontSize: 20,
            color: AppColors.mainBrown
        ),
        labelText: 'Scadenza',
        filled: true,
        fillColor: Colors.white,
        suffixIcon: const Icon(Icons.calendar_today)
    );
  }

  static ButtonStyle textButtonDecoration(bool isDelete){
    if(!isDelete) {
      return ElevatedButton.styleFrom(
        foregroundColor: AppColors.softBrown,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
        fixedSize: const Size(250,60),
      );
    }else{
      return ElevatedButton.styleFrom(
        foregroundColor: Colors.red,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
        fixedSize: const Size(250,60),
      );
    }
  }

  static ButtonStyle submitButtonDecoration() {
    return ElevatedButton.styleFrom(
      backgroundColor: AppColors.softBrown,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
      fixedSize: const Size(280,60),
    );
  }

  static ButtonStyle submitSmallButtonDecoration() {
    return ElevatedButton.styleFrom(
      backgroundColor: AppColors.softBrown,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
      fixedSize: const Size(180,40),
    );
  }

  static ButtonStyle deleteButtonDecoration() {
    return ElevatedButton.styleFrom(
      backgroundColor: Colors.red,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
      fixedSize: const Size(280,60),
    );
  }

  static ButtonStyle deleteSmallButtonDecoration() {
    return ElevatedButton.styleFrom(
      backgroundColor: Colors.red,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
      fixedSize: const Size(180,40),
    );
  }
}