import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dbms/drawer.dart';
import 'package:dbms/search.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:dbms/Models.dart';
import 'package:bubble/bubble.dart';

class Chat extends StatefulWidget {
  static String routenamme = '/Chat';

  @override
  _FriendsState createState() => _FriendsState();
}

class _FriendsState extends State<Chat> {
  int time = 0;
  TextEditingController text = TextEditingController();
  List<Message> messages = [];
  String my = '';
  String to = '';
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
      final routeArgs =
          ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      String t = routeArgs['email'];
      String m = routeArgs['myid'];

      my = m;
      to = t;
      http
          .get(Uri.parse(
              'https://dbms-32996-default-rtdb.firebaseio.com/message.json'))
          .then((value) {
        var data = jsonDecode(value.body) as Map<String, dynamic>;

        data.forEach((key, value) {
          if ((value['to'] == my && value['from'] == to) ||
              (value['to'] == to && value['from'] == my))
            messages.add(Message(
              id: key,
              from: value['from'],
              to: value['to'],
              text: value['text'],
            ));
        });

        setState(() {
          isloading = false;
        });
      });
    }
    isinit = false;

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Chat')),
        drawer: Drawers(),
        body: isloading
            ? Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  Container(
                    color: Colors.black12,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          width: 300,
                          child: TextField(
                            decoration:
                                InputDecoration(labelText: 'Start typing text'),
                            controller: text,
                            keyboardType: TextInputType.text,
                          ),
                        ),
                        IconButton(
                            icon: Icon(Icons.send),
                            color: Colors.green,
                            onPressed: () async {
                              print(text.text);
                              await http.post(
                                  Uri.parse(
                                      'https://dbms-32996-default-rtdb.firebaseio.com/message.json'),
                                  body: jsonEncode({
                                    'to': to,
                                    'from': my,
                                    'text': text.text,
                                  }));

                              messages.clear();

                              final value = await http.get(Uri.parse(
                                  'https://dbms-32996-default-rtdb.firebaseio.com/message.json'));

                              var data = jsonDecode(value.body)
                                  as Map<String, dynamic>;

                              data.forEach((key, value) {
                                if ((value['to'] == my &&
                                        value['from'] == to) ||
                                    (value['to'] == to && value['from'] == my))
                                  messages.add(Message(
                                    id: key,
                                    from: value['from'],
                                    to: value['to'],
                                    text: value['text'],
                                  ));
                              });
                              setState(() {});
                            }),
                      ],
                    ),
                  ),
                  Container(
                      height: 500,
                      child: ListView(
                          children: messages.map((e) {
                        return Container(
                          alignment: my == e.from
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.7,
                                  // color:itsmymessage(snapshot.data.docs[idx]['sender']) ?Colors.lightGreen
                                  //:Colors.amber,
                                  // alignment: Alignment.center,
                                  padding: EdgeInsets.all(7),
                                  child: Bubble(
                                    margin: BubbleEdges.only(top: 10),
                                    radius: Radius.zero,
                                    alignment: my == e.from
                                        ? Alignment.topRight
                                        : Alignment.topLeft,
                                    nipWidth: 8,
                                    nipHeight: 24,
                                    nip: BubbleNip.rightTop,
                                    color: my == e.from
                                        ? Color.fromRGBO(225, 255, 199, 1.0)
                                        : Colors.white70,

                                    /*color:itsmymessage(snapshot.data.docs[idx]['sender']) ?Colors.lightGreen
                                      :Colors.amber*/
                                    child: ListTile(
                                      title: Text(e.text),
                                      subtitle: Text(e.from),
                                    ),
                                  )),
                              SizedBox(height: 15),
                            ],
                          ),
                        );
                      }).toList()))
                ],
              ));
  }
}
