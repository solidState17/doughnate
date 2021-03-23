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
import 'package:url_launcher/url_launcher.dart';

class AppSettings extends StatefulWidget {
  AppSettings({Key key}) : super(key: key);

  @override
  _AppSettings createState() => _AppSettings();
}

class _AppSettings extends State<AppSettings> {
  FirebaseStorage _store = FirebaseStorage.instance;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  TextEditingController display_name = TextEditingController(
    text: name,
  );
  File _image;

  final ImagePicker picker = ImagePicker();

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(
          pickedFile.path,
        );
        uploadImage();
      } else {
        print('No image selected.');
      }
    });
  }

  Future<void> uploadImage() async {
    String fileName = Path.basename(_image.path);
    try {
      final upload = await FirebaseStorage.instance
          .ref('uploads/$fileName')
          .putFile(_image);
      final url = upload.ref.getDownloadURL();
      FirebaseFirestore.instance.collection('users').doc(userid).update({
        'profilePic': url,
      });
    } catch (e) {
      print(e);
    }
  }

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
      title: Text(
        'Are you sure?',
      ),
      content: ElevatedButton(
        onPressed: () {
          return deleteSelf();
        },
        child: Text(
          'Delete Account',
        ),
      ),
    );
  }

  AlertDialog imageDialog() {
    return AlertDialog(
      content: Column(
        children: [
          Container(
            child: Image.file(_image),
          ),
          TextButton(
            onPressed: () {},
            child: Text('Upload Image'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Text(
                  "Settings",
                  style: DefaultTextUI(
                    size: textHeading,
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Spacer(),
              PopupMenuButton(
                color: Colors.white,
                onSelected: (value) {
                  if (value == 'about') {
                    return showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        content: Container(
                          // width: 120,
                          height: 200,
                          child: Column(
                            children: [
                              Text(
                                'We are Solid State',
                                style: DefaultTextUI(
                                  size: 20,
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              Spacer(),
                              Text(
                                "This app written by us, Nick, Seth and Shota. We created this as a concept app while students at Code Chysalis, an immersive full stack software engineering bootcamp in Tokyo, Japan.",
                              ),
                              TextButton(
                                child: Text(
                                  "See us on Github.",
                                ),
                                onPressed: () async {
                                  if (await canLaunch(
                                      'https://github.com/solidState17/doughnate')) {
                                    await launch(
                                        'https://github.com/solidState17/doughnate');
                                  } else {
                                    throw 'Could not find solid state';
                                  }
                                },
                              ),
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
                      },
                    );
                  }
                },
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: userid,
                    child: Text('Delete Account'),
                  ),
                  PopupMenuItem(
                    value: 'about',
                    child: Text('About Us'),
                  ),
                ],
              ),
            ],
          ),
          CircleAvatar(
            radius: 60,
            backgroundColor: Color(0x00000000),
            child: ClipOval(
              child: Image(
                image: NetworkImage(photoURL),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(100.0, 0.0, 100.0, 0.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: primaryRed,
              ),
              onPressed: () async {
                await getImage();
                // return showDialog(
                //   context: context,
                //   builder: (context) {
                //     return imageDialog();
                //   },
                // );
              },
              child: Text(
                'Change Picture',
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: TextField(
              controller: display_name,
              style: DefaultTextUI(
                size: 18,
                color: Colors.black54,
                fontWeight: FontWeight.w700,
              ),
              decoration: InputDecoration(
                labelText: "Display Name",
                hintText: 'Enter your display name',
              ),
              onSubmitted: (value) => {
                setState(
                  () {
                    name = value;
                  },
                ),
              },
            ),
          ),
          Expanded(
            child: Column(
              children: [
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection(
                        'npos',
                      )
                      .snapshots(),
                  builder: (
                    BuildContext content,
                    AsyncSnapshot<QuerySnapshot> snapshot,
                  ) {
                    if (!snapshot.hasData)
                      return Text(
                        'No NPOs',
                        style: DefaultTextUI(
                          size: 24,
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      );
                    return Padding(
                      padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
                      child: DropdownSearch(
                        label: "NPO",
                        onChanged: (value) {
                          setState(
                            () {
                              npo = value;
                            },
                          );
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
                        activeColor: Colors.blue,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Spacer(),
          Padding(
            padding: EdgeInsets.all(5.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: primaryButtonColor,
              ),
              onPressed: () {
                UpdateUser();
                final snackBar = SnackBar(
                  content: Text(
                    'Saved changes successfully!',
                    style: DefaultTextUI(color: Colors.black87, size: 14, fontWeight: FontWeight.w600)
                  ),
                  backgroundColor: primaryGreen,
                );
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(
                  snackBar,
                );
              },
              child: Text(
                "Save Changes",
                style: TextStyle(
                  color: Colors.black87,
                ),
              ),
              autofocus: true,
            ),
          ),
        ],
      ),
    );
  }
}

Future<void> UpdateUser() async {
  final FirebaseFirestore db = FirebaseFirestore.instance;
  await db
      .collection(
        'users',
      )
      .doc(userid)
      .update(
        {
          "displayname": name,
          "display_doughnated": display_doughnated,
          "npo": npo,
        },
      )
      .then(
        (value) => print(
          'Save to Firebase suceeded',
        ),
      )
      .catchError(
        (
          onError,
        ) =>
            {
          print(onError),
        },
      );
}
