import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'login.dart';
import 'home.dart';
import 'package:url_launcher/url_launcher.dart';
import 'NpoList.dart';

class UpdateDebt extends StatefulWidget {
  final friend;
  const UpdateDebt({Key key, @required this.friend}) : super(key: key);

  @override
  _UpdateDebt createState() => _UpdateDebt();
}

class _UpdateDebt extends State<UpdateDebt> {
  final FirebaseFirestore db = FirebaseFirestore.instance;
  TextEditingController _enteredAmount = TextEditingController();

  var friendToDelete;

  Future<void> adjustDebt(id, amount, type) async {
    //! Getting Document from database
    final debt = db.collection("Friendship").doc(id);

    //! Awaiting for the data that we need
    var debtData = await debt.get();
    var debtTotal = debtData.data()['debt'];
    var debtOwner = debtData.data()['owner'];
    var friendUser = debtData.data()['userA'] == email
        ? debtData.data()['userB']
        : debtData.data()['userA'];

    if (debtOwner != 'userA' || debtOwner != 'userB') {
      if (amount > 0) {
        debtOwner = debtData.data()['userA'] == email ? 'userA' : 'userB';
      }
    } else {
      debtOwner = debtData.data()['userA'] == email ? 'userB' : 'userA';
    }

    if (debtData.data()[debtOwner] == email) {
      if (amount > 0) {
        //? lending more money
        handleAddingTransactions(friendUser, amount, "lent");
      } else {
        if (type == 'doughnation') {
          //? doughnated on your behalf
          handleAddingTransactions(friendUser, amount, "doughnated");
        } else {
          //? reduced debt
          handleAddingTransactions(friendUser, amount, "reduced");
        }
      }
    } else {
      if (amount > 0) {
        //? borrowed money
        handleAddingTransactions(friendUser, amount, "borrowed");
      } else {
        //? doughnation
        if (type == "doughnation") {
          handleAddingTransactions(friendUser, amount, "doughnated");
        } else {
          //? Payback
          handleAddingTransactions(friendUser, amount, "returned");
        }
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

  Future<void> handleAddingTransactions(updateEmail, amount, type) async {
    var friendData = await db.collection('users').where("email", isEqualTo: updateEmail).get();
    var friendEdit = db.collection('users').doc(friendData.docs[0].data()['authId']);

    final timestamp = DateTime.now();

    friendEdit.update({
      "transactions": FieldValue.arrayUnion([
        {
          "timestamp": timestamp,
          "amount": amount,
          "name": name,
          "type": type,
        }
      ])
    });
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
        db.collection("users").doc(lendingUser.docs[0].data()['authId']);
    final borrowUser =
        db.collection("users").doc(borrowingUser.docs[0].data()['authId']);

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

  Future<void> deleteFriend(friendId) async {
    final friendshipId = friendId['friendship']['friendshipid'];
    final userCollection = db.collection('users').doc(userid);
    final friendCollection = db.collection('users').doc(friendId['authId']);
    final friendshipCollection = db.collection('Friendship').doc(friendshipId);

    final userData = await userCollection.get();
    final friendsData = await friendCollection.get();

    friendshipCollection
        .delete()
        .then((value) => print('Deleted Friendship document'));

    var userFriendsArray = [];
    var friendsUserArray = [];

    userData.data()['friends'].forEach(
      (val) {
        if (friendshipId != val) {
          userFriendsArray.add(val);
        }
      },
    );

    friendsData.data()['friends'].forEach(
      (val) {
        if (friendshipId != val) {
          friendsUserArray.add(val);
        }
      },
    );

    userCollection.update(
      {
        "friends": userFriendsArray,
      },
    );

    friendCollection.update(
      {
        "friends": friendsUserArray,
      },
    );

    getAllFriends();
  }

  AlertDialog confirmDelete(friendDetails) {
    return AlertDialog(
      title: Text('Are you sure?'),
      content: ElevatedButton(
        onPressed: () {
          return deleteFriend(friendDetails);
        },
        child: Text('Remove Friend'),
      ),
    );
  }

  Widget build(BuildContext context) {
    return AlertDialog(
      title: Stack(
        children: [
          Center(
            child: Container(
              child: Column(
                children: [
                  Text("${widget.friend['displayName']}"),
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        fit: BoxFit.fill,
                        image: NetworkImage(
                          widget.friend['profilePic'],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 0,
            right: 0,
            child: PopupMenuButton(
              onSelected: (value) {
                showDialog(
                  context: context,
                  builder: (context) {
                    return confirmDelete(value);
                  },
                );
              },
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: widget.friend,
                  child: Text('Remove Friend'),
                ),
              ],
            ),
          ),
        ],
      ),
      content: Container(
        height: 300,
        width: 300,
        child: Column(
          children: [
            Text(
                "${widget.friend['displayName']} supports ${widget.friend['npo']}"),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Container(
                width: 200,
                height: 45,
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  gradient: LinearGradient(
                      colors: widget.friend['friendship']
                                  [widget.friend['friendship']['owner']] ==
                              email
                          ? [Color(0xFF07dfaf), Color(0xFF47e544)]
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
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          widget.friend['friendship']['debt'].toString(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
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
                TextButton(
                  onPressed: () {
                    visitNPO(
                      npo: widget.friend['npo'],
                    );
                    adjustDebt(widget.friend['friendship']['friendshipid'],
                        int.parse(_enteredAmount.text), "Doughnation");
                    Navigator.of(context, rootNavigator: true).pop();
                  },
                  child: Text('Doughnate'),
                ),
                Spacer(),
                TextButton(
                  onPressed: () {
                    adjustDebt(widget.friend['friendship']['friendshipid'],
                        int.parse(_enteredAmount.text), "Adjust");
                    Navigator.of(context, rootNavigator: true).pop();
                  },
                  child: Text('Adjust Debt'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// NPO Link Launcher:
String currentFriendsFavoriteNPO;

visitNPO({String npo}) async {
  final npoData = await FirebaseFirestore.instance
      .collection('npos')
      .where('name', isEqualTo: npo)
      .get();

  final url = npoData.docs[0].data()['url'];

  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}
