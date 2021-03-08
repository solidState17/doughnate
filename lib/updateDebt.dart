import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'home.dart';

class UpdateDebt extends StatefulWidget {
  @override
  _UpdateDebt createState() => _UpdateDebt();
}

class _UpdateDebt extends State<UpdateDebt> {

  final FirebaseFirestore db = FirebaseFirestore.instance;

  Future<void> adjustDebt() async {
    const debt = await db.collection("Friendship");
  }

  Widget build(BuildContext context) {
    return 
  }

}