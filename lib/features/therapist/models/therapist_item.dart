class TherapistItem {
  final String id;
  final String name;
  final String title;
  final List<String> languages;
  final double rating;
  final int reviews;
  final String avatar;
  final String bio;

  TherapistItem({
    required this.id,
    required this.name,
    required this.title,
    required this.languages,
    required this.rating,
    required this.reviews,
    required this.avatar,
    required this.bio,
  });
}
