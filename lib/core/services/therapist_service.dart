import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/therapist.dart';

class TherapistService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  CollectionReference<Therapist> get _therapistRef => _db
      .collection('therapists')
      .withConverter<Therapist>(
        fromFirestore: (snap, _) => Therapist.fromFirestore(snap),
        toFirestore: (therapist, _) => therapist.toFirestore(),
      );

  /// ➕ Add new therapist
  Future<void> addTherapist(Therapist therapist) async {
    await _therapistRef.add(therapist);
  }

  /// 📥 Get all therapists
  Future<List<Therapist>> getTherapists() async {
    final snapshot = await _therapistRef.get();
    return snapshot.docs.map((e) => e.data()).toList();
  }

  /// 🔄 Update therapist
  Future<void> updateTherapist(Therapist therapist) async {
    await _therapistRef.doc(therapist.id).update(therapist.toFirestore());
  }

  /// ❌ Delete therapist
  Future<void> deleteTherapist(String id) async {
    await _therapistRef.doc(id).delete();
  }

  /// Live updates
  Stream<List<Therapist>> watchTherapists() {
    return _therapistRef.snapshots().map(
      (snap) => snap.docs.map((e) => e.data()).toList(),
    );
  }
}
