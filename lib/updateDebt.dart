import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'login.dart';

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
          lendingUser.docs[0].data()['total_doughnated'] + amount;
      total_reimbursed =
          lendingUser.docs[0].data()['total_reimbursed'] + amount;
      total_returned = borrowingUser.docs[0].data()['total_returned'] + amount;

      lendUser.update({
        "total_doughnated": total_doughnated,
      });
      borrowUser.update({
        "total_returned": total_returned,
      });
    } else {}

    // if (type == "Lend") {
    //   total_lent = lendingData.docs[0].data()['total_lent'] + amount;
    //   total_borrowed = borrowingData.docs[0].data()['total_borrowed'] + amount;

    //   lendUser.update({"total_lent": total_lent});

    //   borrowUser.update({"total_borrowed": total_borrowed});
    // } else if (type == "Repay") {
    //   total_reimbursed =
    //       lendingData.docs[0].data()['total_reimbursed'] + amount;
    //   total_returned = borrowingData.docs[0].data()['total_returned'] + amount;

    //   lendUser.update({
    //     "total_reimbursed": total_reimbursed,
    //   });

    //   borrowUser.update({
    //     "total_returned": total_returned,
    //   });
    // } else if (type == "Doughnate") {
    //   total_doughnated =
    //       lendingData.docs[0].data()['total_doughnated'] + amount;
    //   total_returned = borrowingData.docs[0].data()['total_returned'] + amount;

    //   lendUser.update({
    //     "total_doughnated": total_doughnated,
    //   });

    //   borrowUser.update({
    //     "total_returned": total_returned,
    //   });
    // }
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
                    color: const Color(0xffa9e19c),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Align(
                      alignment: Alignment.center,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(widget.friend['friendship']['debt']
                                .toString()),
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
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ],
              ),
            ),
            Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                new TextButton(
                    onPressed: () {
                      print(widget.friend.friendship);
                      adjustDebt(widget.friend.friendship['friendshipid'],
                          _enteredAmount.text, "Doughnation");
                    },
                    child: Text('Doughnate')),
                Spacer(),
                new TextButton(
                    onPressed: () {
                      adjustDebt(widget.friend['friendship']['friendshipid'],
                          int.parse(_enteredAmount.text), "Adjust");
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
