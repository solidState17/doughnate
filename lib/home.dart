import 'package:flutter/material.dart';
// import './login.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'appsettings.dart';
import 'friends.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentIndex = 0;

  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Doughnate'),
            automaticallyImplyLeading: false,
          ),
          // this is the home page
          body: Container(
            child:
                Center(child: _currentIndex == 2 ? AppSettings() : Friends()),
          ),

          bottomNavigationBar: BottomNavigationBar(
            currentIndex: _currentIndex,
            items: [
              BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  title: Text("Home"),
                  backgroundColor: Colors.blue),
              BottomNavigationBarItem(
                  icon: Icon(Icons.add_outlined),
                  title: Text("Add"),
                  backgroundColor: Colors.blue),
              BottomNavigationBarItem(
                  icon: Icon(Icons.settings),
                  title: Text("Settings"),
                  backgroundColor: Colors.blue),
            ],
            onTap: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
          ),
        ));
  }
}
