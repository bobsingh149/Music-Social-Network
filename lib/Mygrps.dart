
import 'package:dbms/Models.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:provider/provider.dart';

class Favgroups extends StatefulWidget {
  static String routname = '/fav';
  @override
  _FavgroupsState createState() => _FavgroupsState();
}

class _FavgroupsState extends State<Favgroups> {
  var username;
  var url =
      Uri.parse('https://dbms-32996-default-rtdb.firebaseio.com/groups.json');

  List<Group> groups = [];
  Map<String, String> favgroups = {};
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
//id': 's1', 'title': 'red','artist':'taylor','album':'red','Groupyear'
        var data = jsonDecode(value.body) as Map<String, dynamic>;
        var Groupid;
        data.forEach((key, value) {
          if (!favgroups.containsKey(value['name'])) {
            if (value['pemail'] == u) {
              favgroups[value['name']] = key;

              groups.add(Group(
                artist: value['artist'],
                name: value['name'],
                pEmail: value['pemail'],
                creatorEmail: value['cemail'],
                id: key,
                des: value['des'],
              ));
            }
          }

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
      body: Container(
        child: isloading
            ? Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  Text(
                    'MY  groups',
                    style: TextStyle(fontSize: 21),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Container(
                    height: 500,
                    //color: Colors.amber,

                    child: ListView(
                        children: groups.map((e) {
                      return Container(
                        width: 300,
                        color: Colors.amber,
                        child: Row(
                          children: [
                            Text(e.name),
                            SizedBox(
                              width: 15,
                            ),
                            Text(e.artist),
                            SizedBox(
                              width: 15,
                            ),
                            Text(e.des),
                            SizedBox(
                              width: 15,
                            ),
                            Text(e.creatorEmail),
                            SizedBox(
                              width: 15,
                            ),
                            IconButton(
                                onPressed: () async {
                                  var s = e.id;

                                  print(e.id);

                                  http.delete(Uri.parse(
                                      'https://dbms-32996-default-rtdb.firebaseio.com/groups/$s.json'));

                                  groups.removeWhere(
                                      (element) => element.name == e.name);

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
