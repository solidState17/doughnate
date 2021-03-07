import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/rendering.dart';
import './login.dart';

 var friendUserPic = "";
 var friendUserName = "";

class Search extends StatefulWidget {
  @override
  _SearchTextFieldState createState() => _SearchTextFieldState();

}

class _SearchTextFieldState extends State<Search>{
  final _controller = TextEditingController();
  final FirebaseFirestore fireStore = FirebaseFirestore.instance;
  String name = "";
  var index = 0;
  final pages = [
    DefaultPage(),
    FriendsInfo(),
    ErrorMassage()
  ];

  searchFriends(email) async{
  await fireStore
   .collection("users")
   .where("email", isEqualTo: name)
   .get()
   .then((value) {
     setState(() {
       index = 1;
       friendUserPic = value.docs[0].data()["profilePic"];
       friendUserName = value.docs[0].data()["displayName"];
     });
     print("ユーザーはいるよ。");
   })
   .catchError((err) {
    setState(() {
       index = 2;
     });
     print("Invalid Email Adress");
        });
  }
   Widget build(BuildContext context){
     return Scaffold(
       appBar: AppBar(
         title: Text("Search Friends"),
       ),
       body: Column(
         children: [
           Row(
           children: [
             Container(
             padding: EdgeInsets.only(top: 10, right: 20, bottom: 30, left: 20),
             child: TextField(
               controller: _controller,
               onChanged: (x) => name = x,
               decoration: InputDecoration(
                 enabledBorder: OutlineInputBorder(
                   borderSide: BorderSide(color: Colors.transparent),
                   borderRadius: BorderRadius.all(Radius.circular(10))
                 ),
                 focusedBorder: OutlineInputBorder(
                   borderSide: BorderSide(color:Colors.transparent),
                   borderRadius:BorderRadius.all(Radius.circular(10))
                 ),
                 hintText: "Email",
                 filled: true,
               ),
             ),
           ),
           Container(
             
           )
           ],
           ),
           Container(
             color: Colors.blue,
             child: TextButton(
               onPressed: (){searchFriends(name);},
               child: Text(
                 "Search", style: TextStyle(
                   color:Colors.white,
                 ),
               )
             )
           ),
           Container(
             child: Center(
               child: pages[index]
             )
           )
         ],
       ),
     );
   }
}

class ErrorMassage extends StatelessWidget{
  Widget build(BuildContext context){
    return Container(
        padding: EdgeInsets.symmetric(horizontal:30, vertical:30),
        child: Text(
        "Inputed Email Address is not registered in Doughnate",
        style: TextStyle(
          fontSize: 20, fontWeight: FontWeight.bold, color: Colors.grey
        ),),
    );
  }
}

class FriendsInfo extends StatelessWidget{
  Widget build(BuildContext context){
    return  Column(
      children:[
      Container(
        padding: EdgeInsets.symmetric(horizontal:30, vertical:30),
        child:CircleAvatar(
          radius: 60, 
          child: ClipOval(
            child: Image(
            image: NetworkImage(
              friendUserPic
             ),
            ),
          ),
        ),
      ), 
      Container(
        child:Text(
          friendUserName,
          style: TextStyle(
            fontSize: 20, fontWeight: FontWeight.bold
          ),
        )
      ),
      Container(
        margin: EdgeInsets.only(top:20),
        width:120,
        color: Colors.green,
        child:TextButton(
          onPressed: (){},
          child: Text(
            "Add",
            style: TextStyle(
              color:Colors.white,
            ),
          )
          )
      )
      ]
    );
  }
}

class DefaultPage extends StatelessWidget{
  Widget build(BuildContext context){
    return Container();
  }
}