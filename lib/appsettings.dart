import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'login.dart';

class AppSettings extends StatefulWidget {
  AppSettings({Key key}) : super(key: key);

  @override
  _AppSettings createState() => _AppSettings();
}

class _AppSettings extends State<AppSettings> {
  bool displayReimbursements = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff5f5f5),
        body: Center(
            child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Container(
            child: Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text("Settings",
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
          CircleAvatar(
              radius: 60, child: ClipOval(child: Image(image: NetworkImage(photoURL)))),
          // input display name
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              decoration: const InputDecoration(
                labelText: "Name",
                hintText: 'Enter your display name',
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DropdownSearch(
              items: [
                "Prefer to be reimbursed (No NPO)",
                "Amnesty International",
                "Green Peace",
                "Doctors Without Boarders"
              ],
              label: "NPO",
              onChanged: print,
              selectedItem: "Please Select",
              validator: (String item) {
                if (item == null)
                  return "Required field";
                else if (item == "Brazil")
                  return "Invalid item";
                else
                  return null;
              },
            ),
          ),
          Row(
            children: [
              Text("Display Doughnations?"),
              Switch(
                  value: false,
                  onChanged: (value) {
                    setState(() {
                      displayReimbursements = value;
                    });
                  },
                  activeTrackColor: Colors.red,
                  activeColor: Colors.blue)
            ],
          ),
          Spacer(),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: RaisedButton(onPressed: () {}, child: Text("Checkout out Solid State"), autofocus: true, clipBehavior: Clip.none),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Align(alignment: Alignment.bottomRight, child: RaisedButton(onPressed: () {}, child: Text("Save"), autofocus: true, clipBehavior: Clip.none)),
          )
        ],
      ),
    )));

    // display donation ratio
    // about team solidstate
    // ROW ( save, cancel )
  }
}