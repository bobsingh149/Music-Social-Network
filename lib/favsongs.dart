import 'package:dbms/Models.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:provider/provider.dart';

class Favsongs extends StatefulWidget {
  static String routname = '/fav';
  @override
  _FavsongsState createState() => _FavsongsState();
}

class _FavsongsState extends State<Favsongs> {
  var username;
  var url =
      Uri.parse('https://dbms-32996-default-rtdb.firebaseio.com/fav.json');
  var url2 =
      Uri.parse('https://dbms-32996-default-rtdb.firebaseio.com/song.json');

  List<Song> songs = [];
  Map<String, String> favsongs = {};
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
//id': 's1', 'title': 'red','artist':'taylor','album':'red','songyear'
        var data = jsonDecode(value.body) as Map<String, dynamic>;
        var songid;
        data.forEach((key, value) {
          if (value['uid'] == u) {
            if (!favsongs.containsKey(value['songid'])) {
              favsongs[value['songid']] = key;
            }
          }
        });

        http.get(url2).then((value) {
//id': 's1', 'title': 'red','artist':'taylor','album':'red','songyear'
          var data = jsonDecode(value.body) as Map<String, dynamic>;
          var songid;
          data.forEach((key, value) {
            if (favsongs.containsKey(value['id'])) {
              var s = favsongs[value['id']];
              String x = '';
              if (s != null) x = s;
              songs.add(Song(
                  id: x,
                  songid: value['id'],
                  title: value['title'],
                  artist: value['artist'],
                  albumid: value['album'],
                  songyear: value['songyear']));
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
      body: Container(
        child: isloading
            ? Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  Text(
                    'MY Favorite Songs',
                    style: TextStyle(fontSize: 21),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Container(
                    height: 500,
                    //color: Colors.amber,

                    child: ListView(
                        children: songs.map((e) {
                      return Container(
                        width: 300,
                        color: Colors.amber,
                        child: Row(
                          children: [
                            Text(e.title),
                            SizedBox(
                              width: 15,
                            ),
                            Text(e.artist),
                            SizedBox(
                              width: 15,
                            ),
                            Text(e.songyear),
                            SizedBox(
                              width: 15,
                            ),
                            Text(e.albumid),
                            SizedBox(
                              width: 15,
                            ),
                            IconButton(
                                onPressed: () async {
                                  var s = e.id;
                                 

                                  print(e.id);
                                 

                                  http.delete(Uri.parse(
                                      'https://dbms-32996-default-rtdb.firebaseio.com/fav/$s.json'));

                                  songs.removeWhere(
                                      (element) => element.songid == e.songid);

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
