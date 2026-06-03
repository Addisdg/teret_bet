class StoryPage {
  final int pageNumber;
  final String textAm;
  final String? textEn;
  final String imageUrl;
  final String illustrationPrompt;
  final String? audioUrl;

  StoryPage({
    required this.pageNumber,
    required this.textAm,
    this.textEn,
    required this.imageUrl,
    this.illustrationPrompt = '',
    this.audioUrl,
  });

  factory StoryPage.fromMap(Map<String, dynamic> data) {
    return StoryPage(
      pageNumber: _readInt(data['pageNumber']),
      textAm: _readString(data['textAm']),
      textEn: _readNullableString(data['textEn']),
      imageUrl: _readString(data['imageUrl']),
      illustrationPrompt: _readString(data['illustrationPrompt']),
      audioUrl: _readNullableString(data['audioUrl']),
    );
  }

  StoryPage copyWith({
    String? imageUrl,
  }) {
    return StoryPage(
      pageNumber: pageNumber,
      textAm: textAm,
      textEn: textEn,
      imageUrl: imageUrl ?? this.imageUrl,
      illustrationPrompt: illustrationPrompt,
      audioUrl: audioUrl,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'pageNumber': pageNumber,
      'textAm': textAm,
      'textEn': textEn,
      'imageUrl': imageUrl,
      'illustrationPrompt': illustrationPrompt,
      'audioUrl': audioUrl,
    };
  }

  static int _readInt(Object? value, {int fallback = 0}) {
    if (value is num) {
      return value.toInt();
    }

    return fallback;
  }

  static String _readString(Object? value, {String fallback = ''}) {
    if (value is String) {
      return value;
    }

    return fallback;
  }

  static String? _readNullableString(Object? value) {
    if (value is String && value.isNotEmpty) {
      return value;
    }

    return null;
  }
}
