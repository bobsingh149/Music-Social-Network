import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class User {
  String id;
  int age;
  String gender;
  String name;
  String email;
  String password;
  String dob;
  String address;
  List<int> friends = [];
  User(
      {this.id = '',
      this.gender = '',
      this.age = 30,
      this.dob = '',
      this.email = '',
      this.address = '',
      this.password = '',
      this.name = ''});
}

class Song {
  String id;
  String songid;
  String title;
  String artist;
  String albumid;
  String songyear;

  Song(
      {this.id = '',
      this.albumid = '',
      this.artist = '',
      this.songid = '',
      this.songyear = '',
      this.title = ''});
}

class Global with ChangeNotifier {
  String username = 'x';

  String get isnewuser {
    return this.username;
  }

  void setuser(String u) {
    username = u;
  }
}

class Message {
  String id;
  String to;
  String from;
  String text;

  Message({this.from = '', this.id = '', this.text = '', this.to = ''});
}

class Group {
  String id;
  String name;
  String artist;
  String des;
  String creatorEmail;
  String pEmail;

  Group({this.artist='',this.creatorEmail='',this.des='',this.id='',this.name='',this.pEmail=''});
}
