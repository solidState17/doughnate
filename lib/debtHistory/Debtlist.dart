import 'package:flutter/material.dart';
import '../pie_chart_view.dart';

class DebtList extends StatefulWidget{
  @override
  _DebtList createState() => _DebtList();
}

class _DebtList extends State<DebtList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.green,
        title: Text("shota", style: TextStyle(
          fontSize: 25,
            fontFamily: 'Futura',
        ),
        ),
      ),
      body: Expanded(
        child: Row(
          children: <Widget>[
          ],
        ),
      )
    );
  }

}
