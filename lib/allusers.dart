import 'package:dbms/Searchusers.dart';
import 'package:dbms/drawer.dart';
import 'package:dbms/search.dart';
import 'package:flutter/material.dart';

class Allusers extends StatefulWidget {
  static String  routenamme = '/Allusers';
  
  @override
  _AllusersState createState() => _AllusersState();
}

class _AllusersState extends State<Allusers> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Search Allusers")),
      drawer: Drawers(),
      body:
        Searchuser(),
      
      );
      
    
  }
}
