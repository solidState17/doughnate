import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/rendering.dart';
import './login.dart';
import 'UI/colorsUI.dart';
import 'home.dart';

class Apply extends StatefulWidget {
  @override
  _npo_application createState() => _npo_application();
}

class _npo_application extends State<Apply> {
  final _org_controller = TextEditingController();
  final _contact_controller = TextEditingController();
  final _email_controller = TextEditingController();
  final _url_controller = TextEditingController();

  String contactPerson = '', email = '', organizationName = '', url = '';

  Widget build(BuildContext context) {
    final node = FocusScope.of(context);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        elevation: 0,
        backgroundColor: bgColor1,
        title: Text(
          'Become NPO Partner',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(
                top: 30,
                left: 20,
                right: 20,
              ),
              child: Text(
                "Do you represent an NPO and are interested in adding your organization to our app? Feel free to reach out to us and we will answer your inquiry as soon as possible.",
                style: TextStyle(
                  fontFamily: 'Futura',
                  fontSize: 16,
                  color: Colors.blueGrey,
                  fontWeight: FontWeight.w400,
                ),
                textAlign: TextAlign.left,
              ),
            ),
            Container(
              padding: EdgeInsets.only(
                top: 30,
                left: 10,
                right: 10,
              ),
              child: TextField(
                controller: _org_controller,
                autofocus: true,
                onChanged: (x) => organizationName = x,
                textInputAction: TextInputAction.next,
                onEditingComplete: () => node.nextFocus(),
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.transparent,
                    ),
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.transparent,
                    ),
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                  hintText: "Organization Name",
                  filled: true,
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(
                top: 10,
                left: 10,
                right: 10,
              ),
              child: TextField(
                controller: _contact_controller,
                autofocus: true,
                onChanged: (x) => contactPerson = x,
                textInputAction: TextInputAction.next,
                onEditingComplete: () => node.nextFocus(),
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.transparent,
                    ),
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.transparent,
                    ),
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                  hintText: "Contact Name",
                  filled: true,
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(
                top: 10,
                left: 10,
                right: 10,
              ),
              child: TextField(
                controller: _email_controller,
                autofocus: true,
                onChanged: (x) => email = x,
                textInputAction: TextInputAction.next,
                onEditingComplete: () => node.nextFocus(),
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.transparent,
                    ),
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.transparent,
                    ),
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                  hintText: "Email",
                  filled: true,
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(
                top: 10,
                left: 10,
                right: 10,
              ),
              child: TextField(
                controller: _url_controller,
                autofocus: true,
                onChanged: (x) => url = x,
                textInputAction: TextInputAction.next,
                onEditingComplete: () => node.nextFocus(),
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.transparent,
                    ),
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.transparent,
                    ),
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                  hintText: "Your Organization's Homepage",
                  filled: true,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(30.0),
              child: ElevatedButton(
                onPressed: () {
                  submitForm();
                  Navigator.of(context, rootNavigator: true).pop();
                  final snackBar = SnackBar(
                    content: Text(
                      'Form Submitted',
                    ),
                    backgroundColor: Colors.pink,
                  );
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(
                    snackBar,
                  );
                },
                child: Text("Submit My Info"),
                autofocus: true,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> submitForm() async {
    final FirebaseFirestore db = FirebaseFirestore.instance;
    await db.collection('npoApplication').add(
      {
        'contactPerson': contactPerson,
        'email': email,
        'organizationName': organizationName,
        'url': url,
      },
    );
    print('saved');
  }
}
