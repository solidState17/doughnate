import 'package:flutter/material.dart';
import './login.dart';

class Home extends StatefulWidget{
  
  @override
  _HomeState createState() => _HomeState();

}

class _HomeState extends State<Home>{

    int _currentIndex = 0;

  Widget build(BuildContext context){
  return Scaffold(
    body: Container(
      child:Center(
        child:Column(
          children: <Widget>[
            Text("This is Home Page!"),
            RaisedButton(
              child: const Text('Log out'),
              color: Colors.blue,
              shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            onPressed: () {Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => GoogleAuth())
                      );},
          ),
          ],
        ),
      ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex:_currentIndex,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title:Text("Home"),
            backgroundColor:Colors.blue
            ),

            BottomNavigationBarItem(
            icon: Icon(Icons.search),
            title:Text("Search"),
            backgroundColor:Colors.blue
            ),

            BottomNavigationBarItem(
            icon: Icon(Icons.camera),
            title:Text("Home"),
            backgroundColor:Colors.blue
            ),

            BottomNavigationBarItem(
            icon: Icon(Icons.person),
            title:Text("Home"),
            backgroundColor:Colors.blue
            ), 
        ],
        onTap: (index) {
          setState((){
            _currentIndex = index;
          });
        },
      ),
    );
  }
}