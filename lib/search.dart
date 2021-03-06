import 'package:flutter/material.dart';

class Search extends StatelessWidget {
   Widget build(BuildContext context){
     return Scaffold(
       appBar: AppBar(
         title: Text("Search"),
       ),
     );
   }
}

// TextEditingController email = TextEditingController();
//                 showDialog(
//                     context: context,
//                     builder: (context) => new AlertDialog(
//                             title: new Text("Enter an email address:"),
//                             content: new TextFormField(
//                               controller: _email,
//                               decoration: const InputDecoration(
//                                 labelText: "email",
//                                 hintText: 'Enter an email',
//                               ),
//                             ),
//                             actions: <Widget>[
//                               new TextButton(
//                                   onPressed: () {
//                                     handleAddingFriend();
//                                     getAllFriends();
//                                   },
//                                   child: new Text("Add"))
//                             ],
                            
//                             )
//                             );