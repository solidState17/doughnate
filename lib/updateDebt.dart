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

  Future<void> adjustDebt(id, direction, amount, type) async {
    //! Getting Document from database
    final debt = db.collection("Friendship").doc(id);

    //! Awaiting for the data that we need
    var debtData = await debt.get();
    var debtTotal = debtData.data()['debt'];
    var debtOwner = debtData.data()['owner'];
    var lender = debtData.data()[debtOwner];
    var borrower = debtOwner == 'userA' ? 'userB' : 'userA';

    //! Check whether the direction of the transation is addition or subtraction
    if (direction == "+") {
      debtTotal += amount;
      handleIndividualUserUpdates(
          debtData.data()[lender], debtData.data()[borrower], amount, "Lend");
    } else {
      //! if the new amount is less than 0, change owner of debt
      if (debtTotal - amount < 0) {
        if (debtOwner == "userA") {
          debtOwner = "userB";
        } else {
          debtOwner = "userA";
        }
      }

      debtTotal -= amount;

      if (type == "doughnate") {
        handleIndividualUserUpdates(debtData.data()[lender],
            debtData.data()[borrower], amount, "Doughnate");
      } else {
        handleIndividualUserUpdates(debtData.data()[lender],
            debtData.data()[borrower], amount, "Repay");
      }
      //! set the subtracted amount
    }

    //! Update the database to reflect changes
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

    final lendingUser =
        db.collection("users").where(lender, isEqualTo: "email");
    final lendingData = await lendingUser.get();
    final borrowingUser =
        db.collection("users").where(borrower, isEqualTo: "email");
    final borrowingData = await borrowingUser.get();

    final lendUser =
        db.collection("users").doc(lendingData.docs[0].data()['userid']);

    final borrowUser =
        db.collection("users").doc(borrowingData.docs[0].data()['userid']);

    if (type == "Lend") {
      total_lent = lendingData.docs[0].data()['total_lent'] + amount;
      total_borrowed = borrowingData.docs[0].data()['total_borrowed'] + amount;

      lendUser.update({"total_lent": total_lent});

      borrowUser.update({"total_borrowed": total_borrowed});
    } else if (type == "Repay") {
      total_reimbursed =
          lendingData.docs[0].data()['total_reimbursed'] + amount;
      total_returned = borrowingData.docs[0].data()['total_returned'] + amount;

      lendUser.update({
        "total_reimbursed": total_reimbursed,
      });

      borrowUser.update({
        "total_returned": total_returned,
      });
    } else if (type == "Doughnate") {
      total_doughnated =
          lendingData.docs[0].data()['total_doughnated'] + amount;
      total_returned = borrowingData.docs[0].data()['total_returned'] + amount;

      lendUser.update({
        "total_doughnated": total_doughnated,
      });

      borrowUser.update({
        "total_returned": total_returned,
      });
    }
  }

  AlertDialog enterAdjustment() {
    return AlertDialog();

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
                  width: 300,
                  height: 50,
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
                            child: Text(
                                widget.friend['friendship']['debt'].toString()),
                          ),
                          Spacer(),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextField(
                              decoration: InputDecoration(labelText: 'Enter adjustment'),
                              keyboardType: TextInputType.number,
                              inputFormatters:
                                <TextInputFormatter>[
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                            ),
                          )
                        ],
                      ))),
            ),
            Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                new TextButton(onPressed: () {}, child: Text('Doughnate')),
                Spacer(),
                new TextButton(onPressed: () {}, child: Text('Adjust Debt'))
              ],
            )
          ],
        ),
      ),
    );
  }
}
