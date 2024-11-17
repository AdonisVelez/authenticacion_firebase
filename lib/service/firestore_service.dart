import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addData(String collection, Map<String, dynamic> data) async {
    await _firestore.collection(collection).add(data);
  }

  Stream<QuerySnapshot> getData(String collection) {
    return _firestore.collection(collection).snapshots();
  }
}
