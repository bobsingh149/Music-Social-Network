import 'package:dbms/Myfriends.dart';
import 'package:dbms/allusers.dart';
import 'package:dbms/friends.dart';
import 'package:dbms/userinfo.dart';
import 'package:flutter/material.dart';

class Drawers extends StatelessWidget {
  Widget build(BuildContext context) {
    return Drawer(
      // Add a ListView to the drawer. This ensures the user can scroll
      // through the options in the drawer if there isn't enough vertical
      // space to fit everything.
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text('Menu'),
          ),
          ListTile(
            title: Text('My Fav Songs'),
            onTap: () {
              // Update the state of the app
              // ...
            },
          ),
          ListTile(
            title: Text('Find friends'),
            onTap: () {
              // Update the state of the app
              // ...
              // Then close the drawer
              Navigator.of(context).pushReplacementNamed(Allusers.routenamme);
            },
          ),
          ListTile(
            title: Text('Search Songs'),
            onTap: () {
              print('hello');
              Navigator.of(context).pushReplacementNamed(Friends.routenamme);
              // Update the state of the app
              // ...
              // Then close the drawer
              //Navigator.pop(context);
            },
          ),
          ListTile(
            title: Text('Join groups'),
            onTap: () {
               Navigator.of(context).pushReplacementNamed(Additional.routename);
              // Update the state of the app
              // ...
              // Then close the drawer
            },
          ),
           ListTile(
            title: Text('My Friends'),
            onTap: () {
               Navigator.of(context).pushReplacementNamed(Myfriends.routname);
              // Update the state of the app
              // ...
              // Then close the drawer
            },
          ),
        ],
      ),
    );
  }
}
