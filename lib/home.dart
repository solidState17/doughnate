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
          backgroundColor: const Color(0xfff5f5f5),
          appBar: AppBar(
            elevation: 0,
            centerTitle: true,
            title: const Text('Doughnate', 
              style: TextStyle(
                fontFamily: 'Futura', 
                fontSize: 30,
                color: const Color(0xff707070),
                fontWeight: FontWeight.w700,
                )),
            automaticallyImplyLeading: false,
          ),
          // this is the home page
          body: Container(
            child:
                Center(child: _currentIndex == 2 ? AppSettings() : Friends()),
          ),

          bottomNavigationBar: BottomNavigationBar(
            // showUnselectedLabels: true,
            backgroundColor: const Color(0xfff5f5f5),
            elevation: 0,
            currentIndex: _currentIndex,
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: "Home",
              ),
              BottomNavigationBarItem(
                  icon: Icon(Icons.add_outlined),
                  label: "Add",
              ),
              BottomNavigationBarItem(
                  icon: Icon(Icons.settings),
                  label: "Settings",
              ),
            ],
            onTap: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            selectedItemColor: const Color(0xff4d4d4d),
          ),
        ));
  }
}
