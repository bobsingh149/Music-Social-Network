import 'package:dbms/drawer.dart';
import 'package:dbms/search.dart';
import 'package:flutter/material.dart';

class Friends extends StatefulWidget {
  static String  routenamme = '/Friends';
  
  @override
  _FriendsState createState() => _FriendsState();
}

class _FriendsState extends State<Friends> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Search Songs')),
      drawer: Drawers(),
      body:
        SearchBar(),
      
      );
      
    
  }
}
