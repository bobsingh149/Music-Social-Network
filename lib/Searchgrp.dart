import 'package:dbms/Models.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:provider/provider.dart';

class Searchgrp extends StatefulWidget {
  @override
  _Searchgropustate createState() => _Searchgropustate();
}

class _Searchgropustate extends State<Searchgrp> {
  var grpname = TextEditingController();
  var artist = TextEditingController();
  var description = TextEditingController();

  var url = Uri.parse(
      'https://dbms-32996-default-rtdb.firebaseio.com/allgroups.json');

  List<Group> gropus = [];

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
      var username = Provider.of<Global>(context, listen: false).username;
      http.get(url).then((value) {
//id': 's1', 'title': 'red','artist':'taylor','album':'red','songyear'
        var data = jsonDecode(value.body) as Map<String, dynamic>;
        var creatorid;
        data.forEach((key, value) {
//if(value['email']!=username)
          gropus.add(Group(
            artist: value['artist'],
            creatorEmail: value['cemail'],
            pEmail: value['pemail'],
            des: value['des'],
            id: key,
            name: value['name'],
          ));
        });

        setState(() {
          isloading = false;
        });
      });

      /*.then((value) {
          setState(() {
            isloading = false;
          });
        });
      });*/
    }

    isinit = false;

    super.didChangeDependencies();
  }

  bool ishover = false;
  final myController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var username = Provider.of<Global>(context, listen: false).username;
    return MouseRegion(
      onEnter: (cursor) {
        setState(() {
          ishover = true;
        });
      },
      onExit: (cursor) {
        setState(() {
          ishover = false;
        });
      },
      child: isloading
          ? Center(child: CircularProgressIndicator())
          : Container(
              //color: Colors.red,
              child: Column(
                children: [
                  Container(
                    width: (MediaQuery.of(context).size.width) * 0.9,
                    decoration: BoxDecoration(
                        color: ishover ? Colors.black26 : Colors.black12,
                        borderRadius: BorderRadius.circular(30)),
                    child: ListTile(
                      leading: IconButton(
                          icon: Icon(Icons.search),
                          onPressed: () async {
                            print(myController.text);

                            print(username);

                            try {
                              /*  await http.post(url,
                            body: jsonEncode({'id': 's1', 'title': 'red','artist':'taylor','album':'red','songyear':'2011'}));
                              await http.post(url,
                            body: jsonEncode({'id': 's2', 'title': 'wild','artist':'drake','album':'xya','songyear':'2013'}));
                              await http.post(url,
                            body: jsonEncode({'id': 's3', 'title': 'in','artist':'salena','album':'abc','songyear':'2011'}));
                              await http.post(url,
                            body: jsonEncode({'id': 's4', 'title': 'tramp','artist':'taylor','album':'tyu','songyear':'2015'}));
                              await http.post(url,
                            body: jsonEncode({'id': 's5', 'title': 'lover','artist':'adam','album':'tbd','songyear':'2011'}));*/

                              var gropusel = myController.text;

                              var res = await http.get(url);
                              var data =
                                  jsonDecode(res.body) as Map<String, dynamic>;
                              var creatorid;
                              gropus.clear();
                              data.forEach((key, value) {
                                if (value['artist'] == gropusel) {
                                  creatorid = value['cemail'];
                                  gropus.add(Group(
                                    artist: value['artist'],
                                    creatorEmail: value['cemail'],
                                    pEmail: value['pemail'],
                                    des: value['des'],
                                    id: key,
                                    name: value['name'],
                                  ));
                                }
                              });

                              /*var res = await http.get(
                          url,
                        );*/

                              //    print(jsonDecode(res.body));

                              // var data = jsonDecode(res.body) as Map<String, dynamic>;

                              /* data.forEach((key, value) {
                          print(key);
                          print(value);
                          print(value['age']);*/

                              // var upd = Uri.parse(
                              //   'https://dbms-32996-default-rtdb.firebaseio.com/gropus/$key.json');

                              //http.delete(upd);

                              //var t= http.patch(upd,body: jsonEncode({'age':105}));
                              setState(() {});
                            } catch (e) {
                              print(e);
                            }
                            print('done');
                          }),
                      title: TextField(
                        controller: myController,
                        decoration: InputDecoration(
                          hintText: 'Search',
                          labelText: 'Search',
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 75,
                  ),
                  TextField(
                    controller: grpname,
                    decoration: InputDecoration(
                      hintText: 'groupname',
                      labelText: 'groupname',
                    ),
                  ),
                  TextField(
                    controller: artist,
                    decoration: InputDecoration(
                      hintText: 'Artist',
                      labelText: 'Artist',
                    ),
                  ),
                  TextField(
                    controller: description,
                    decoration: InputDecoration(
                      hintText: 'Description',
                      labelText: 'Description',
                    ),
                  ),
                  IconButton(
                      onPressed: () async {
                        await http.post(url,
                            body: jsonEncode({
                              'name': grpname.text,
                              'des': description.text,
                              'artist': artist.text,
                              'cemail': username,
                              'pemail': username,
                            }));
                        gropus.clear();
                        http.get(url).then((value) {
//id': 's1', 'title': 'red','artist':'taylor','album':'red','songyear'
                          var data =
                              jsonDecode(value.body) as Map<String, dynamic>;
                          var creatorid;
                          data.forEach((key, value) {
//if(value['email']!=username)
                            gropus.add(Group(
                              artist: value['artist'],
                              creatorEmail: value['cemail'],
                              pEmail: value['pemail'],
                              des: value['des'],
                              id: key,
                              name: value['name'],
                            ));
                          });

                          setState(() {
                          
                          });
                        });
                      },
                      icon: Icon(Icons.add)),
                  Container(
                    height: 500,
                    //color: Colors.amber,
                    child: ListView(
                        children: gropus.map((e) {
                      return Container(
                        width: 300,
                        color: Colors.amber,
                        child: Row(
                          children: [
                            SizedBox(
                              width: 30,
                            ),
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
                                  var url2 = Uri.parse(
                                      'https://dbms-32996-default-rtdb.firebaseio.com/groups.json');

                                  await http.post(url2,
                                      body: jsonEncode({
                                        'name': e.name,
                                        'artist': e.artist,
                                        'des': e.des,
                                        'cemail': e.creatorEmail,
                                        'pemail': username,
                                      }));
                                },
                                icon: Icon(Icons.message))
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
