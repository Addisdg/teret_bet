class Story {
  final String id;
  final String titleAm;
  final String titleEn;
  final String coverImage;
  final String summaryAm;
  final int ageMin;
  final int ageMax;

  Story({
    required this.id,
    required this.titleAm,
    required this.titleEn,
    required this.coverImage,
    required this.summaryAm,
    required this.ageMin,
    required this.ageMax,
  });

  factory Story.fromFirestore(Map<String, dynamic> data, String id) {
    return Story(
      id: id,
      titleAm: data['titleAm'] ?? '',
      titleEn: data['titleEn'] ?? '',
      coverImage: data['coverImage'] ?? '',
      summaryAm: data['summaryAm'] ?? data['summary'] ?? '',
      ageMin: data['ageMin'] ?? 3,
      ageMax: data['ageMax'] ?? 6,
    );
  }
}
