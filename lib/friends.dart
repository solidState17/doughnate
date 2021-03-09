import 'home.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'updateDebt.dart';
import 'dart:ui' as ui;

class Friends extends StatefulWidget {
  Friends({Key key}) : super(key: key);

  @override
  _Friends createState() => _Friends();
}

class _Friends extends State<Friends> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Container(
            child: Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  "Friends",
                  style: TextStyle(
                    fontFamily: 'Futura',
                    fontSize: 24,
                    color: const Color(0xff707070),
                    fontWeight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
            ),
            height: 80.0,
          ),
          Expanded(
            child: Column(
                  children: [
                    Expanded(
                      child: ListView(
                        shrinkWrap: true,
                        children: friends.map((friend) => buildCard(friend)).toList(),
                      ),
                    ),
            ]
                ),
          ),
        ],
      ),
    );
  }

  Card buildCard(friend) {
    print(friend);
final db = FirebaseFirestore.instance;
final friendship = "nick";
    //take the debt from specific friendship
    toggleOwe (){
      //debt === 0
      if(friendship=="nick"){
        return Container(
          height: 70.0,
          width: 220.0,
          margin: EdgeInsets.only(top: 10),
          decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [const Color(0xFF02b5e0),const Color(0xFF02cabd) ],
                begin: Alignment.topRight,
                end:Alignment.bottomLeft
            ),
            // color: const Color(0xffa9e19c),
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "No Debt", style: TextStyle(
                fontSize: 35, fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              ),
            ],
          ),
        );
      }
      // owner === userA
      else if(friendship == "shota"){
        return Container(
          height: 70.0,
          width: 220.0,
          margin: EdgeInsets.only(top: 10),
          decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [const Color(0xFF07dfaf),const Color(0xFF47e544) ],
                begin: Alignment.topRight,
                end:Alignment.bottomLeft
            ),
            // color: const Color(0xffa9e19c),
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "You Owe", style: TextStyle(
                fontSize: 18, fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              ),
              Text("¥${friend['friendship']['debt'].toString()}",
                style: TextStyle(
                  fontSize: 30, fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),),
            ],
          ),
        );
      }else{
        //owner === userB
        return Container(
          height: 70.0,
          width: 220.0,
          margin: EdgeInsets.only(top: 10),
          decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [Colors.redAccent,Colors.red ],
                begin: Alignment.topRight,
                end:Alignment.bottomLeft
            ),
            // color: const Color(0xffa9e19c),
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "You are Owed", style: TextStyle(
                fontSize: 18, fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              ),
              Text("¥${friend['friendship']['debt'].toString()}",
                style: TextStyle(
                  fontSize: 30, fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),),
            ],
          ),
        );
      }

    }

    return Card(
      shadowColor: Colors.black,
      elevation: 15,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15.0),
          bottomLeft: Radius.circular(15.0),
        )
      ),
      child: InkWell(
        onTap: () {
          // WHAT IS THE ON TAP FOR? I THINK THE WIDGET CALL GOES HERE 🤔
          showDialog(
              context: context, builder: (context) => UpdateDebt(friend: friend));
        },
        child: Container(
          padding: EdgeInsets.all(10.0),
          height: 160,
          child: Row(
            children: [
              Expanded(
                flex: 7,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    // mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        friend['displayName'],
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "Friends name has doughnated 100%",
                        style: TextStyle(
                          fontSize: 14,
                        ),
                      ),
                      //If owner is user, show green card, otherwise show red card.
                      Container(
                        child: toggleOwe()
                      ),
                    ]),
              ),
              Expanded(
                flex: 3,
                child: Container(
                  child: CircleAvatar(
                    radius: 60,
                    backgroundImage: NetworkImage(friend['profilePic']),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


