import 'package:cloud_firestore/cloud_firestore.dart';

class Therapist {
  final String? id;
  final String name;
  final String aboutDetails;
  final double rating;
  final int totalReviews;
  final List<String> specialties;
  final List<String> languages;
  final String profileImageUrl;
  final bool isActive;
  final DateTime? createdAt;

  Therapist({
    this.id,
    required this.name,
    required this.aboutDetails,
    required this.rating,
    required this.totalReviews,
    required this.specialties,
    required this.languages,
    this.profileImageUrl = '',
    this.isActive = true,
    this.createdAt,
  });

  /// Convert model → Firestore map
  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'aboutDetails': aboutDetails,
      'rating': rating,
      'totalReviews': totalReviews,
      'specialties': specialties,
      'languages': languages,
      'profileImageUrl': profileImageUrl,
      'isActive': isActive,
      'createdAt': createdAt ?? FieldValue.serverTimestamp(),
    };
  }

  /// Firestore document → model
  factory Therapist.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;

    return Therapist(
      id: doc.id,
      name: data['name'] ?? '',
      aboutDetails: data['aboutDetails'] ?? '',
      rating: (data['rating'] ?? 0).toDouble(),
      totalReviews: data['totalReviews'] ?? 0,
      specialties: List<String>.from(data['specialties'] ?? []),
      languages: List<String>.from(data['languages'] ?? []),
      profileImageUrl: data['profileImageUrl'] ?? '',
      isActive: data['isActive'] ?? true,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
    );
  }
}
