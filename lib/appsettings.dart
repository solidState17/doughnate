import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'login.dart';

class AppSettings extends StatefulWidget {
  AppSettings({Key key}) : super(key: key);

  @override
  _AppSettings createState() => _AppSettings();
}

class _AppSettings extends State<AppSettings> {
  // make this bool equal to current value in firebase
  TextEditingController display_name = TextEditingController(text: name);

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
                    child: Text(
                      "Settings",
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
                  radius: 60,
                  child: ClipOval(child: Image(image: NetworkImage(photoURL)))),
              // input display name
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: display_name,
                  decoration: const InputDecoration(
                    labelText: "Display Name",
                    hintText: 'Enter your display name',
                  ),
                  onSubmitted: (value) => {
                    setState(() {
                      name = value;
                    })
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: DropdownSearch(
                  items: [
                    "Prefer to be reimbursed (No NPO)",
                    "Amnesty International",
                    "Green Peace",
                    "Doctors Without Boarders",
                    "Ashinaga",
                    "Scam NPO",
                    "No Hungry Kids",
                    "Your mom's NPO",
                    "Stop Crazy Politicians"
                  ],
                  label: "NPO",
                  onChanged: (value) {
                    setState(() {
                      npo = value;
                    });
                  },
                  selectedItem: npo,
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
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: <Widget>[
                    Text("Display Doughnations?"),
                    Switch(
                        value: display_doughnated,
                        onChanged: (value) {
                          setState(() {
                            display_doughnated = value;
                          });
                        },
                        activeTrackColor: Colors.red,
                        activeColor: Colors.blue)
                  ],
                ),
              ),
              Spacer(),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: TextButton(
                  onPressed: () {},
                  child: Text("Save Changes"),
                  autofocus: true,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: TextButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                                content: Container(
                              width: 120,
                              height: 120,
                              child: Column(
                                children: [
                                  Text('About Solid State'),
                                  Text(
                                      "Solid State Kabushikigaishi is amazing. Founded by Shota, Nick, and Seth. Solid State exceeded 200 gajilion USD in reveneue in it's first year"),
                                ],
                              ),
                            )));
                  },
                  child: Text("Learn about Solid State"),
                  autofocus: true,
                ),
              ),
            ],
          ),
        )));
  }
}
