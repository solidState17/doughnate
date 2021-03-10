import 'dart:io';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'login.dart';
import 'package:path/path.dart' as Path;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class AppSettings extends StatefulWidget {
  AppSettings({Key key}) : super(key: key);

  @override
  _AppSettings createState() => _AppSettings();
}

class _AppSettings extends State<AppSettings> {
  FirebaseStorage _store = FirebaseStorage.instance;
  // make this bool equal to current value in firebase
  TextEditingController display_name = TextEditingController(text: name);
  File _image;

  final ImagePicker picker = ImagePicker();

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff5f5f5),
      body: Center(
        // child: Padding(
        // padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                shrinkWrap: true,
                children: [
                  Container(
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding: const EdgeInsets.all(18.0),
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
                    child: ClipOval(
                      child: Image(
                        image: NetworkImage(photoURL),
                      ),
                    ),
                  ),
                  OutlinedButton(
                    onPressed: () async {
                      await getImage();
                    },
                    child: Text('Upload Picture'),
                  ),
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
                        }),
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
                        "No Hungry Kids",
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
                              setState(
                                () {
                                  display_doughnated = value;
                                },
                              );
                            },
                            activeTrackColor: Colors.red,
                            activeColor: Colors.blue),
                      ],
                    ),
                  ),
                  Spacer(),
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: TextButton(
                      onPressed: () {
                        UpdateUser();
                        final snackBar = SnackBar(
                          content: Text('Saved changes successfully!'),
                          backgroundColor: Colors.pink,
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      },
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
                            ),
                          ),
                        );
                      },
                      child: Text("Learn about Solid State"),
                      autofocus: true,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// maybe we should make one single class / for updating firebase after MVP that includes users, debts, etc ? 🤔

Future<void> UpdateUser() async {
  final FirebaseFirestore db = FirebaseFirestore.instance;
  await db
      .collection('users')
      .doc(userid)
      .update({
        "displayname": name,
        "display_doughnated": display_doughnated,
        "npo": npo,
      })
      .then((value) => print('Save to Firebase suceeded'))
      .catchError((onError) => {print(onError)});
}

// Another exception was thrown: Incorrect use of
// ParentDataWidget.
