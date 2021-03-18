import 'package:cloud_firestore/cloud_firestore.dart';
import '../login.dart';

final FirebaseFirestore fireStore = FirebaseFirestore.instance;
final CollectionReference friendCollection = fireStore.collection('Friendship');

class Friendship {
  double debt;
  String friendshipid;
  String owner;
  String userA;
  String userB;
}

Future<String> createFriendship(friendData) async {
  final newFriendship = await friendCollection.add(friendData);

  return newFriendship.id;
}

Future<void> updateFriendship(id, amount, owner) async {
  await friendCollection.doc(id).update({
    "owner": owner,
    "amount": amount,
  });
}

Future<void> deleteFriendship(id) async {
  await friendCollection.doc(id).delete();
}
