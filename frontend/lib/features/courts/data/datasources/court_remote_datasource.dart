import 'package:basketvibe/features/courts/data/models/court_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// Firestore access for the `courts` collection.
class CourtRemoteDataSource {
  CourtRemoteDataSource(this._firestore);

  final FirebaseFirestore _firestore;

  Future<List<CourtModel>> getCourts() async {
    final snapshot =
        await _firestore.collection('courts').orderBy('name').get();
    return snapshot.docs.map(CourtModel.fromFirestore).toList();
  }
}
