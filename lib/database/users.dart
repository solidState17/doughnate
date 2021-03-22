import 'package:cloud_firestore/cloud_firestore.dart';
import '../login.dart';

final FirebaseFirestore fireStore = FirebaseFirestore.instance;
final CollectionReference userCollection = fireStore.collection('users');

class UserDB {
  String authID;
  String name;
  String displayName;
  String email;
  String npo;
  String profilePic;
  double total_lent;
  double total_reimbursed;
  double total_doughnated;
  double total_borrowed;
  double total_returned;
  bool display_doughnated;
  List friends;
  List friends_requests;
  List transactions;
}

Future<void> createUser(currentUser) async {
  userCollection.where("authID", isEqualTo: currentUser.uid).get().then(
    (value) {
      if (value.size == 0) {
        fireStore.collection("users").doc(currentUser.uid).set(
          {
            "authID": currentUser.uid,
            "name": name,
            "displayName": name,
            "email": email,
            "npo": npo,
            "profilePic": photoURL,
            "total_lent": 0,
            "total_reimbursed": 0,
            "total_doughnated": 0,
            "total_borrowed": 0,
            "total_returned": 0,
            "display_doughnated": display_doughnated,
            "friends": [],
            "friend_requests": [],
            "transactions": []
          },
        );
      } else {
        userid = currentUser.uid;
        print(value.docs[0].data()['userid']);
      }
    },
  );
}

Future<void> updateUser(user_id) async {
  await userCollection
      .doc(userid)
      .update({
        "displayname": name,
        "display_doughnated": display_doughnated,
        "npo": npo,
      })
      .then((value) => print('Save to Firebase suceeded'))
      .catchError((onError) => {print(onError)});
}

Future<void> deleteUser() async {
  userCollection.doc(userid).delete();
}

Future<void> removeFriend(userA, userB) async {
  final userRef = userCollection.doc(userA);
  final userData = await userRef.get();
  final friendsData = userData.data()['friends'];

  final newArr = [];

  friendsData.forEach((value) {
    if (value['friendid'] != userB) {
      newArr.add(value);
    }
  });

  userRef.update({
    'friends': newArr,
  });
}
