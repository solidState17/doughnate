import 'dart:io';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'login.dart';
import './UI/colorsUI.dart';
import 'package:path/path.dart' as Path;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AppSettings extends StatefulWidget {
  AppSettings({Key key}) : super(key: key);

  @override
  _AppSettings createState() => _AppSettings();
}

class _AppSettings extends State<AppSettings> {
  FirebaseStorage _store = FirebaseStorage.instance;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  // make this bool equal to current value in firebase
  TextEditingController display_name = TextEditingController(text: name);
  File _image;

  final ImagePicker picker = ImagePicker();

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        imageDialog();
      } else {
        print('No image selected.');
      }
    });
  }

  Future uploadImage() {}

  void deleteOthers(doc) async {}

  void deleteSelf() async {
    final GoogleSignIn _googleSignIn = GoogleSignIn();
    final deletedUser =
        FirebaseFirestore.instance.collection('users').doc(userid);

    // final deletedData = await deletedUser.get();

    // deletedData.data()['friends'].forEach((person) {
    //   FirebaseFirestore.instance
    //       .collection('friendship')
    //       .doc(person)
    //       .delete()
    //       .then((doc) {
    //     print('Friendship deleted');
    //   });
    // });

    deletedUser.delete();
    _firebaseAuth.currentUser.delete();

    _firebaseAuth.signOut();
    _googleSignIn.signOut();
    return Navigator.popUntil(context, ModalRoute.withName("/"));
  }

  AlertDialog confirmDeleteAccount(userInfo) {
    return AlertDialog(
        title: Text('Are you sure?'),
        content: ElevatedButton(
          onPressed: () {
            return deleteSelf();
          },
          child: Text('Delete Account'),
        ));
  }

  AlertDialog imageDialog() {
    return AlertDialog(
      content: Column(children: [
        Container(child: Image.file(_image)),
        TextButton(onPressed: () {}, child: Text('Upload Image')),
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Row(children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                "Settings",
                style: DefaultTextUI(
                  size: 24,
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.left,
              ),
            ),
            Spacer(),
            PopupMenuButton(
              onSelected: (value) {
                if (value == 'about') {
                  return showDialog(
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
                } else {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return confirmDeleteAccount(value);
                      });
                }
              },
              itemBuilder: (context) => [
                PopupMenuItem(value: userid, child: Text('Delete Account')),
                PopupMenuItem(value: 'about', child: Text('About Us')),
              ],
            ),
          ]),
          CircleAvatar(
            radius: 60,
            backgroundColor: const Color(0x00000000),
            child: ClipOval(
              child: Image(
                image: NetworkImage(photoURL),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(100.0, 0.0, 100.0, 0.0),
            child: ElevatedButton(
              onPressed: () async {
                await getImage();
                return showDialog(
                    context: context,
                    builder: (context) {
                      return imageDialog();
                    });
              },
              child: Text('Change Picture'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: display_name,
              style: DefaultTextUI(
                size: 18,
                color: Colors.black54,
                fontWeight: FontWeight.w700,
              ),
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
          Expanded(
            child: Column(
              children: [
                StreamBuilder<QuerySnapshot>(
                  stream:
                      FirebaseFirestore.instance.collection('npos').snapshots(),
                  builder: (BuildContext content,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (!snapshot.hasData)
                      return Text('No NPOs',
                          style: DefaultTextUI(
                            size: 24,
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ));
                    return Padding(
                      padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
                      child: DropdownSearch(
                        label: "NPO",
                        onChanged: (value) {
                          setState(() {
                            npo = value;
                          });
                        },
                        selectedItem: npo,
                        validator: (item) {
                          if (item == null)
                            return "Required field";
                          else if (item == "Brazil")
                            return "Invalid item";
                          else
                            return null;
                        },
                        items: snapshot.data.docs.map(
                          (doc) {
                            return doc['name'];
                          },
                        ).toList(),
                      ),
                    );
                  },
                ),
                Expanded(
                                  child: Row(
                    children: <Widget>[
                      Text("Display Doughnations?",
                          style: DefaultTextUI(
                            size: 14,
                            color: Colors.black54,
                            fontWeight: FontWeight.w700,
                          )),
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
              ],
            ),
          ),
          // Padding(
          //   padding: const EdgeInsets.fromLTRB(8.0, 0.0, 0.0, 0.0),
          //   child: Row(
          //     children: <Widget>[
          //       Text("Display Doughnations?",
          //           style: DefaultTextUI(
          //             size: 14,
          //             color: Colors.black54,
          //             fontWeight: FontWeight.w700,
          //           )),
          //       Switch(
          //           value: display_doughnated,
          //           onChanged: (value) {
          //             setState(
          //               () {
          //                 display_doughnated = value;
          //               },
          //             );
          //           },
          //           activeTrackColor: Colors.red,
          //           activeColor: Colors.blue),
          //     ],
          //   ),
          // ),
          Spacer(),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: ElevatedButton(
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
        ],
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
