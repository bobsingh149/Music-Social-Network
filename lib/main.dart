import 'package:dbms/Myfriends.dart';
import 'package:dbms/allgroups.dart';
import 'package:dbms/allusers.dart';
import 'package:dbms/chat.dart';
import 'package:dbms/drawer.dart';
import 'package:dbms/favsongs.dart';
import 'package:dbms/friends.dart';
import 'package:dbms/userinfo.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:dbms/Models.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
//await Firebase.initializeApp();
  runApp(App());
}

class App extends StatefulWidget {
  // Create the initialization Future outside of `build`:
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  /// The future is part of the state of our widget. We should not call `initializeApp`

  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Initialize FlutterFire:
      future: _initialization,
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          print("error");
        }

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          return ChangeNotifierProvider(
            create: (ctx) => Global(),
            child: MaterialApp(title: 'DBMS', home: MyHomePage(), routes: {
              Friends.routenamme: (ctx) => Friends(),
              Favsongs.routname: (ctx) => Favsongs(),
              MyHomePage.routename:(ctx)=>MyHomePage(),
              Additional.routename:(ctx)=>Additional(),
              Allusers.routenamme:(ctx)=>Allusers(),
              Myfriends.routname:(ctx)=>Myfriends(),
              Chat.routenamme:(ctx)=>Chat(),
              AllGropus.routenamme:(ctx)=>AllGropus(),
            }),
          );
        }

        // Otherwise, show something whilst waiting for initialization to complete
        return CircularProgressIndicator();
      },
    );
  }
}

/*FutureBuilder(
      // Initialize FlutterFire:
      future: _initialization,
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          print("error");
        }

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          return MaterialApp(
          title: 'DBMS',
          home: MyHomePage(),
        );
        }

        // Otherwise, show something whilst waiting for initialization to complete
        return CircularProgressIndicator();
      },
    );
  }
}*/

class MyHomePage extends StatelessWidget {
  static String routename = '/home';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('DBMS')),
      body: Center(
        child: Text('Welcome'),
      ),
      drawer: Drawers(),
    );
  }
}
