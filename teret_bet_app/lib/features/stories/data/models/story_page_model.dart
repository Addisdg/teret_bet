class StoryPage {
  final int pageNumber;
  final String textAm;
  final String? textEn;
  final String imageUrl;

  StoryPage({
    required this.pageNumber,
    required this.textAm,
    this.textEn,
    required this.imageUrl,
  });

  factory StoryPage.fromMap(Map<String, dynamic> data) {
    return StoryPage(
      pageNumber: data['pageNumber'] ?? 0,
      textAm: data['textAm'] ?? '',
      textEn: data['textEn'],
      imageUrl: data['imageUrl'] ?? '',
    );
  }
}
