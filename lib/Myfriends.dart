import 'package:dbms/Models.dart';
import 'package:dbms/chat.dart';
import 'package:dbms/drawer.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:provider/provider.dart';

class Myfriends extends StatefulWidget {
  static String routname = '/Myfriends';
  @override
  _FavsongsState createState() => _FavsongsState();
}

class _FavsongsState extends State<Myfriends> {
  var username;
  var url =
      Uri.parse('https://dbms-32996-default-rtdb.firebaseio.com/friend.json');
  var url2 =
      Uri.parse('https://dbms-32996-default-rtdb.firebaseio.com/users.json');

  List<User> myf = [];
  Map<String, String> Myfriends = {};
  bool isinit = true;
  // bool fav = false;
  bool isloading = false;
  @override
  void initState() {
    super.initState();
  }

  void didChangeDependencies() {
    if (isinit) {
      setState(() {
        isloading = true;
      });

      var u = Provider.of<Global>(context, listen: false).username;
      username = u;
      http.get(url).then((value) {
//email': 's1', 'title': 'red','artist':'taylor','album':'red','songyear'
        var data = jsonDecode(value.body) as Map<String, dynamic>;
        var songid;
        data.forEach((key, value) {
          if (value['uid'] == u) {
            if (!Myfriends.containsKey(value['fid'])) {
              Myfriends[value['fid']] = key;
            }
          }
        });

        http.get(url2).then((value) {
//email': 's1', 'title': 'red','artist':'taylor','album':'red','songyear'
          var data = jsonDecode(value.body) as Map<String, dynamic>;
          var songid;
          data.forEach((key, value) {
            if (Myfriends.containsKey(value['email'])) {
              var s = Myfriends[value['email']];
              String x = '';
              if (s != null) x = s;
              myf.add(User(
                email: value['email'],
                age: value['age'],
                name: value['name'],
                gender: value['gender'],
                id: x,
              ));
            }
          });

          setState(() {
            isloading = false;
          });
        });
      });
    }
    isinit = false;

    super.didChangeDependencies();
  }

  bool ishover = false;
  final myController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawers(),
      body: Container(
        child: isloading
            ? Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  Text(
                    'MY Friends',
                    style: TextStyle(fontSize: 25),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Container(
                    height: 500,
                    //color: Colors.amber,

                    child: ListView(
                        children: myf.map((e) {
                      return Container(
                        width: 300,
                        color: Colors.amber,
                        child: Row(
                          children: [
                            Text(e.name),
                            SizedBox(
                              width: 15,
                            ),
                            Text(e.age.toString()),
                            SizedBox(
                              width: 15,
                            ),
                            Text(e.gender),
                            SizedBox(
                              width: 15,
                            ),
                            Text(e.email),
                            SizedBox(
                              width: 15,
                            ),
                            IconButton(
                                onPressed: () async {
                                  Navigator.of(context)
                                      .pushNamed(Chat.routenamme, arguments: {
                                    'email': e.email,
                                    'myid': username
                                  });
                                },
                                icon: Icon(Icons.message)),
                            IconButton(
                                onPressed: () async {
                                  var s = e.id;

                                  print(e.id);

                                  http.delete(Uri.parse(
                                      'https://dbms-32996-default-rtdb.firebaseio.com/friend/$s.json'));

                                  final value = await http.get(url);
                                  var data = jsonDecode(value.body)
                                      as Map<String, dynamic>;
                                  data.forEach((key, value) {
                                    if ((value['uid'] == e.email &&
                                            value['fid'] == username) ||
                                        (value['uid'] == username &&
                                            value['fid'] == e.email))
                                      http.delete(
                                          Uri.parse('https://dbms-32996-default-rtdb.firebaseio.com/friend/$key.json'));
                                  });

                                  myf.removeWhere(
                                      (element) => element.email == e.email);

                                  setState(() {});
                                },
                                icon: Icon(Icons.delete))
                          ],
                        ),
                      );
                    }).toList()),
                  ),
                ],
              ),
      ),
    );
  }
}
