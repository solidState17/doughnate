import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'login.dart';
import 'home.dart';
import 'package:url_launcher/url_launcher.dart';

class UpdateDebt extends StatefulWidget {
  final friend;
  const UpdateDebt({Key key, @required this.friend}) : super(key: key);

  @override
  _UpdateDebt createState() => _UpdateDebt();
}

class _UpdateDebt extends State<UpdateDebt> {
  final FirebaseFirestore db = FirebaseFirestore.instance;
  TextEditingController _enteredAmount = TextEditingController();

  Future<void> adjustDebt(id, amount, type) async {
    //! Getting Document from database
    final debt = db.collection("Friendship").doc(id);

    //! Awaiting for the data that we need
    var debtData = await debt.get();
    var debtTotal = debtData.data()['debt'];
    var debtOwner = debtData.data()['owner'];

    if (debtOwner == "") {
      if (amount < 0) {
        debtOwner = debtData.data()['userA'] == email ? 'userA' : 'userB';
      } else {
        debtOwner = debtData.data()['userA'] == email ? 'userB' : 'userA';
      }
    }

    var lender = debtData.data()[debtOwner];
    var borrower = debtOwner == 'userA' ? 'userB' : 'userA';

    //! Check whether the direction of the transation is addition or subtraction

    if (debtTotal + amount < 0) {
      debtOwner = debtOwner == 'userA' ? 'userB' : 'userA';
      handleIndividualUserUpdates(
          debtData.data()[debtOwner],
          debtData.data()[debtOwner == 'userA' ? 'userB' : 'userA'],
          amount,
          type);
    } else {
      handleIndividualUserUpdates(
          debtData.data()[lender], debtData.data()[borrower], amount, type);
    }

    //! Update the database to reflect changes
    debtTotal += amount;
    debt.update({
      "debt": debtTotal.abs(),
      "owner": debtOwner,
    });
    getAllFriends();
  }

  Future<void> handleIndividualUserUpdates(
      lender, borrower, amount, type) async {
    var total_lent;
    var total_reimbursed;
    var total_doughnated;
    var total_borrowed;
    var total_returned;

    //! Get both users Id from the database

    final lendingUser =
        await db.collection("users").where("email", isEqualTo: lender).get();
    final borrowingUser =
        await db.collection("users").where("email", isEqualTo: borrower).get();
    final lendUser =
        db.collection("users").doc(lendingUser.docs[0].data()['userid']);
    final borrowUser =
        db.collection("users").doc(borrowingUser.docs[0].data()['userid']);

    //! Handle Doughnation cases
    if (type == "Doughnation") {
      total_doughnated =
          lendingUser.docs[0].data()['total_doughnated'] + amount.abs();
      total_reimbursed =
          lendingUser.docs[0].data()['total_reimbursed'] + amount.abs();
      total_returned =
          borrowingUser.docs[0].data()['total_reimbursed'] + amount.abs();

      lendUser.update({
        "total_doughnated": total_doughnated,
        "total_reimbursed": total_reimbursed,
      });
      borrowUser.update({
        "total_returned": total_returned,
      });
    } else if (amount < 0) {
      total_returned =
          borrowingUser.docs[0].data()['total_returned'] + amount.abs();
      total_reimbursed =
          lendingUser.docs[0].data()['total_reimbursed'] + amount.abs();

      lendUser.update({
        "total_reimbursed": total_reimbursed,
      });

      borrowUser.update({
        "total_returned": total_returned,
      });
    } else {
      total_lent = lendingUser.docs[0].data()['total_lent'] + amount;
      total_borrowed = borrowingUser.docs[0].data()['total_borrowed'] + amount;

      lendUser.update({
        "total_lent": total_lent,
      });

      borrowUser.update({
        "total_borrowed": total_borrowed,
      });
    }
  }

  Widget build(BuildContext context) {
    return AlertDialog(
      /*
        Add an on-press to friend widget
        display same content plus prefered NPO > as a link
        donate and adjust debt > number input fields
        */
      title: Column(
        children: [
          new Text("${widget.friend['displayName']}"),
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                  fit: BoxFit.fill,
                  image: NetworkImage(widget.friend['profilePic'])),
            ),
          ),
        ],
      ),
      content: Container(
        height: 300,
        width: 300,
        child: Column(
          children: [
            new Text(
                "${widget.friend['displayName']} supports ${widget.friend['npo']}"),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                  width: 200,
                  height: 45,
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    gradient: LinearGradient(
                        colors: widget.friend['friendship']
                                    [widget.friend['friendship']['owner']] ==
                                email
                            ? [Color(0xFF07dfaf), const Color(0xFF47e544)]
                            : [
                                Colors.redAccent,
                                Colors.red
                              ] //[const Color(0xFF02b5e0), const Color(0xFF02cabd)]
                        ,
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Align(
                      alignment: Alignment.center,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                                widget.friend['friendship']['debt'].toString()),
                          ),
                        ],
                      ))),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _enteredAmount,
                decoration: InputDecoration(labelText: 'Enter adjustment'),
                keyboardType: TextInputType.number,
              ),
            ),
            Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                new TextButton(
                    onPressed: () {
                      // this takes the user to the npo page.
                      _launchURL(npo: widget.friend['npo']);
                      // print(widget.friend.friendship);
                      adjustDebt(widget.friend['friendship']['friendshipid'],
                          int.parse(_enteredAmount.text), "Doughnation");
                      Navigator.of(context, rootNavigator: true).pop();
                    },
                    child: Text('Doughnate')),
                Spacer(),
                new TextButton(
                    onPressed: () {
                      adjustDebt(widget.friend['friendship']['friendshipid'],
                          int.parse(_enteredAmount.text), "Adjust");
                      Navigator.of(context, rootNavigator: true).pop();
                    },
                    child: Text('Adjust Debt'))
              ],
            )
          ],
        ),
      ),
    );
  }
}

// NPO Link Launcher:

String currentFriendsFavoriteNPO;

_launchURL({String npo = "https://www.google.com/"}) async {
  final url = npos[npo];
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

// Hard-coded NPO data:
final npos = {
  "Prefer to be reimbursed (No NPO)": "https://www.google.com/",
  "Amnesty International": "https://www.google.com/",
  "Green Peace": "https://www.greenpeace.org/global/",
  "Doctors Without Boarders": "https://www.google.com/",
  "Ashinaga": "https://www.google.com/",
  "No Hungry Kids": "https://www.google.com/",
  "Stop Crazy Politicians": "https://www.google.com/",
};
