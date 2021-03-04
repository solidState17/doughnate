import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'login.dart';
import 'package:dropdown_search/dropdown_search.dart';

class AppSettings extends StatefulWidget {
  AppSettings({Key key}) : super(key: key);

  @override
  _AppSettings createState() => _AppSettings();
}

class _AppSettings extends State<AppSettings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Column(
      children: [
        CircleAvatar(radius: 100, child: Image(image: NetworkImage(photoURL))),
        // input display name
        TextFormField(
          decoration: const InputDecoration(
            labelText: "Name",
            hintText: 'Enter your display name',
          ),
        ),
        DropdownSearch(
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
        )
      ],
    )));

    // display donation ratio
    // about team solidstate
    // ROW ( save, cancel )
  }
}
