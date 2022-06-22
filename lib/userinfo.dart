import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dbms/Models.dart';
import 'package:dbms/drawer.dart';
import 'package:dbms/favsongs.dart';
import 'package:dbms/friends.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:provider/provider.dart';

class Additional extends StatefulWidget {
  static const routename = '/additonal';
  @override
  _AdditionalState createState() => _AdditionalState();
}

class _AdditionalState extends State<Additional> {
  String username = '';
  String url = 'https://dbms-32996-default-rtdb.firebaseio.com/users.json';
  String gender = 'male';

  String name = '';
  bool isloading = false;
  int age = 0;

  String profession = 'Student';
  final formkey = GlobalKey<FormState>();
  bool edit = false;
  Future<void> saveform() async {
    var state = formkey.currentState;

    if (state != null) state.save();

    print(name);
    print(age);
    print(gender);
    print(username);
    Provider.of<Global>(context, listen: false).setuser(username);

    var uri = Uri.parse(url);

    var url2 =
        Uri.parse('https://dbms-32996-default-rtdb.firebaseio.com/users.json');

    final value = await http.get(url2);
    var data = jsonDecode(value.body) as Map<String, dynamic>;
    bool edit = false;
    data.forEach((key, value) async {
      if (value['email'] == username) {
        edit = true;
        try {
          var res = await http.patch(
              Uri.parse(
                  'https://dbms-32996-default-rtdb.firebaseio.com/users/$key.json'),
              body: jsonEncode({
                'name': name,
                'age': age,
                'gender': gender,
                'email': username
              }));

          print(res.body);
        } catch (e) {
          print(e);
        }
      }
    });
    if (!edit) {
      try {
        var res = await http.post(uri,
            body: jsonEncode({
              'name': name,
              'age': age,
              'gender': gender,
              'email': username
            }));

        print(res.body);
      } catch (e) {
        print(e);
      }
    }
    /*var url2 =
        Uri.parse('https://dbms-32996-default-rtdb.firebaseio.com/fav.json');

    try {
      await http.post(url2, body: jsonEncode({'songid': 's1', 'uid': 'b1'}));
    } catch (e) {
      print(e);
    }*/
    print('reach');
    Navigator.of(context).pushNamed(Friends.routenamme);
  }

  @override
  Widget build(BuildContext context) {
    FocusNode focusNode1 = FocusNode();
    FocusNode focusNode2 = FocusNode();

    return Scaffold(
      appBar: AppBar(
        title:
            FittedBox(child: Text('We need to collect some additional info')),
        actions: [
          IconButton(icon: Icon(Icons.navigate_next), onPressed: saveform)
        ],
      ),
      drawer: Drawers(),
      body: isloading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                //mainAxisSize: MainAxisSize.max,
                children: [
                  Form(
                      key: formkey,
                      child: Container(
                        height: 250,
                        //  color: Colors.amber,
                        child: ListView(
                          children: [
                            /* Checkbox(
                          value: c1,
                          onChanged: (newval) {
                            setState(() {
                              c1 = newval;
                            });
                          }),
                      Checkbox(value: c2, onChanged:(newval) {
                            setState(() {
                              c2 = newval;
                            });
                          }), 
                      Checkbox(value: c3, onChanged: (newval) {
                            setState(() {
                              c3 = newval;
                            });
                          }),*/
                            TextFormField(
                              decoration: InputDecoration(labelText: 'Email'),
                              onFieldSubmitted: (val) {
                                FocusScope.of(context).requestFocus(focusNode2);
                              },
                              keyboardType: TextInputType.name,
                              textInputAction: TextInputAction.next,
                              onSaved: (val) {
                                if (val != null) {
                                  username = val;
                                }
                              },
                            ),
                            TextFormField(
                              decoration: InputDecoration(
                                  labelText: 'What should we call you'),
                              onFieldSubmitted: (val) {
                                FocusScope.of(context).requestFocus(focusNode2);
                              },
                              keyboardType: TextInputType.name,
                              textInputAction: TextInputAction.next,
                              onSaved: (val) {
                                if (val != null) {
                                  name = val;
                                }
                              },
                            ),
                            SizedBox(height: 35),
                            TextFormField(
                              decoration:
                                  InputDecoration(labelText: 'Tell your age'),

                              //onEditingComplete: (){FocusScope.of(context).requestFocus()},

                              keyboardType: TextInputType.phone,

                              onFieldSubmitted: (val) {
                                FocusScope.of(context).unfocus();
                              },

                              textInputAction: TextInputAction.done,

                              onSaved: (val) {
                                if (val != null) age = int.parse(val);
                              },

                              focusNode: focusNode2,
                            ),
                          ],
                        ),
                      )),

                  SizedBox(
                    height: 20,
                  ),

                  SizedBox(height: 50),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                          alignment: Alignment.centerLeft,
                          width: 170,
                          // color: Colors.black38,
                          padding: EdgeInsets.symmetric(horizontal: 15),
                          child: Card(
                              color: Colors.pink[300],
                              child: Container(
                                  padding: EdgeInsets.all(5),
                                  child: Text(
                                    'Gender',
                                    style: TextStyle(color: Colors.white),
                                  )))),
                      Container(
                        //alignment: Alignment.center,
                        child: DropdownButton<String>(
                          value: gender, //initial selected value
                          onChanged: (selval) {
                            setState(() {
                              if (selval != null) gender = selval;
                            });
                          },
                          icon: Icon(Icons.arrow_drop_down),
                          iconSize: 30,
                          hint: Text('Select your gender'),
                          elevation: 9,

                          items: [
                            DropdownMenuItem(
                              child: Text('Male'),
                              value: 'male',
                            ),
                            DropdownMenuItem(
                              child: Text('Female'),
                              value: 'female',
                            ),
                            DropdownMenuItem(
                              child: Text('Others'),
                              value: 'others',
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  SizedBox(
                    height: 20,
                  ),

                  SizedBox(
                    height: 70,
                  ),

                  SizedBox(height: 50),
                  FloatingActionButton(
                    onPressed: saveform,
                    child: Icon(Icons.navigate_next),
                  )

                  //Text(countryname),
                ],
              ),
            ),
    );
  }
}
