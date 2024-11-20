import 'package:flutter/material.dart';

class SearchBar extends StatefulWidget{
  const SearchBar({super.key});

  @override
  State<SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar>{
  String query = "";

  void onQueryChanged(String newQuery){
    setState(() {
      query = newQuery;
    });
  }

  @override
  Widget build(BuildContext context){
    return Container(
      padding: const EdgeInsets.all(16),
        child: const TextField(
          decoration: InputDecoration(
              hintText: "Cerca",
              hintStyle: TextStyle(color: Colors.white),
              fillColor: Colors.white,
              prefixIcon: Icon(Icons.search_rounded, color: Colors.white,)
          ),
        ),
    );
  }
}