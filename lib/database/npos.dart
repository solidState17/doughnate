import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> changeNPOActiveCount(npoid, direction) async {
  final CollectionReference npos =
      FirebaseFirestore.instance.collection('npos');
  final npoRef = npos.doc(npoid);
  final npoData = await npoRef.get();

  if (direction == 'up') {
    final total = npoData.data()['supporters'] + 1;
    npoRef.update({
      'supporters': total,
    });
  } else {
    final total = npoData.data()['supporters'] - 1;
    npoRef.update({
      'supporters': total,
    });
  }
}
