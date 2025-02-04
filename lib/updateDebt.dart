import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'UI/colorsUI.dart';
import 'login.dart';
import 'home.dart';
import 'package:url_launcher/url_launcher.dart';
import './database/users.dart';
import './database/friendships.dart';

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


  Future<void> adjustDebt(friendUser, amount, type) async {
    final friendship = db
        .collection('Friendship')
        .doc(friendUser['friendship']['friendshipid']);
    final friendshipData = await friendship.get();
    final friendshipDocument = friendshipData.data();
    final currentOwner = friendshipDocument['owner'];
    var setOwner;
    var typeOfTransaction;
    var remainder = friendshipDocument['debt'] + amount;

    //! Clarify ownership

    if (friendshipData.data()['debt'] == 0) {
      if (amount > 0) {
        setOwner = friendshipDocument['userA'] == email ? 'userA' : 'userB';
        typeOfTransaction = 'lent';
      } else {
        setOwner = friendshipDocument['userA'] == email ? 'userB' : 'userA';
        typeOfTransaction = 'borrowed';
      }
    } else if (friendshipData.data()['debt'] + amount < 0) {
      setOwner = currentOwner == 'userA' ? 'userB' : 'userA';
      if (friendshipDocument[setOwner] == email) {
        typeOfTransaction = 'lent';
      } else {
        typeOfTransaction = 'borrowed';
      }
    } else {
      setOwner = currentOwner;
      if (amount > 0) {
        typeOfTransaction = 'lent';
      } else {
        typeOfTransaction = 'borrowed';
      }
    }

    // if (friendshipDocument['debt'] + amount < 0) {
    // }

    //? Create transaction notification for friend
    if (amount > 0) {
      handleAddingTransactions(friendUser['authID'], amount, typeOfTransaction);
    } else {
      handleAddingTransactions(friendUser['authID'], amount, typeOfTransaction);
    }

    if (friendshipDocument[setOwner] == email) {
      handleIndividualUserUpdates(userid, friendUser['authID'], amount, type);
    } else {
      handleIndividualUserUpdates(friendUser['authID'], userid, amount, type);
    }

    final total = friendshipData.data()['debt'] + amount;
    friendship.update({
      'owner': setOwner,
      'debt': total.abs(),
    });
  }

  Future<void> handleAddingTransactions(id, amount, type) async {
    var friendData = db.collection('users').doc(id);

    final timestamp = DateTime.now();

    friendData.update({
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

    final lendingUser = db.collection("users").doc(lender);
    final borrowingUser = db.collection("users").doc(borrower);
    final lendUserData = await lendingUser.get();
    final borrowUserData = await borrowingUser.get();

    //! Handle Doughnation cases
    if (type == "Doughnation") {
      if (amount)
        total_doughnated =
            lendUserData.data()['total_doughnated'] + amount.abs();
      total_reimbursed = lendUserData.data()['total_reimbursed'] + amount.abs();
      total_returned = borrowUserData.data()['total_returned'] + amount.abs();

      lendingUser.update({
        "total_doughnated": total_doughnated,
        "total_reimbursed": total_reimbursed,
      });
      borrowingUser.update({
        "total_returned": total_returned,
      });
    } else if (amount < 0) {
      total_returned = borrowUserData.data()['total_returned'] + amount.abs();
      total_reimbursed = lendUserData.data()['total_reimbursed'] + amount.abs();

      lendingUser.update({
        "total_reimbursed": total_reimbursed,
      });

      borrowingUser.update({
        "total_returned": total_returned,
      });
    } else {
      total_lent = lendUserData.data()['total_lent'] + amount;
      total_borrowed = borrowUserData.data()['total_borrowed'] + amount;

      lendingUser.update({
        "total_lent": total_lent,
      });

      borrowingUser.update({
        "total_borrowed": total_borrowed,
      });
    }
    getAllFriends();
  }

  Future<void> deleteFriend(friendId) async {
    final friendshipId = friendId['friendship']['friendshipid'];

    await deleteFriendship(friendshipId);
    await removeFriend(userid, friendId['authID']);
    await removeFriend(friendId['authID'], userid);

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

  changedColor() {
    if (widget.friend['friendship']['debt'] == 0) {
      return bgColor1;
    } else if (widget.friend['friendship']
            [widget.friend['friendship']['owner']] ==
        email) {
      return primaryGreen2;
    } else {
      return primaryRed2;
    }
  }

  Widget build(BuildContext context) {
    return AlertDialog(
      title: Stack(
        children: [
          Center(
            child: Container(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 10.0),
                    child: Text("${widget.friend['displayName']}"),
                  ),
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
            top: -12,
            right: -15,
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
      content: SingleChildScrollView(
        child: Container(
          height: 240,
          width: 300,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 8.0),
                child: Text("Supports ${widget.friend['npo']}",
                    style: DefaultTextUI(
                        color: Colors.black,
                        fontWeight: FontWeight.w400,
                        size: 15)),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Container(
                  width: 200,
                  height: 45,
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    color: changedColor(),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      "¥${widget.friend['friendship']['debt'].toString()}",
                      style: DefaultTextUI(
                        size: 22,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
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
              Padding(
                padding: const EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 0.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () {
                        visitNPO(
                          npo: widget.friend['npo'],
                        );
                        adjustDebt(widget.friend,
                            int.parse(_enteredAmount.text), "Doughnation");
                        Navigator.of(context, rootNavigator: true).pop();
                      },
                      child: Text('Doughnate'),
                    ),
                    Spacer(),
                    TextButton(
                      onPressed: () {
                        adjustDebt(widget.friend,
                            int.parse(_enteredAmount.text), "Adjust");
                        Navigator.of(context, rootNavigator: true).pop();
                      },
                      child: Text('Adjust Debt'),
                    ),
                  ],
                ),
              ),
            ],
          ),
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
