import 'package:basketvibe/features/courts/data/models/sport_type_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// Firestore access for the `sportTypes` collection.
class SportTypeRemoteDataSource {
  SportTypeRemoteDataSource(this._firestore);

  final FirebaseFirestore _firestore;

  Future<List<SportTypeModel>> getSportTypes() async {
    final snapshot =
        await _firestore.collection('sportTypes').orderBy('name').get();
    return snapshot.docs.map(SportTypeModel.fromFirestore).toList();
  }
}
