import 'package:dbms/Searchgrp.dart';
import 'package:dbms/Searchusers.dart';
import 'package:dbms/drawer.dart';
import 'package:dbms/search.dart';
import 'package:flutter/material.dart';

class AllGropus extends StatefulWidget {
  static String  routenamme = '/AllGropus';
  
  @override
  _AllGropusState createState() => _AllGropusState();
}

class _AllGropusState extends State<AllGropus> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Search Gropus")),
      drawer: Drawers(),
      body:
        Searchgrp(),
      
      );
      
    
  }
}
