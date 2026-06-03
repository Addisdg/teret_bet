class Story {
  final String id;
  final String collection;
  final String status;
  final int priority;
  final String titleAm;
  final String titleEn;
  final String coverImage;
  final String summaryAm;
  final String moralAm;
  final StorySource source;
  final int ageMin;
  final int ageMax;
  final List<String> themes;
  final StoryAudio audio;

  Story({
    required this.id,
    this.collection = '',
    this.status = 'published',
    this.priority = 0,
    required this.titleAm,
    required this.titleEn,
    required this.coverImage,
    required this.summaryAm,
    this.moralAm = '',
    StorySource? source,
    required this.ageMin,
    required this.ageMax,
    List<String>? themes,
    StoryAudio? audio,
  })  : source = source ?? StorySource.empty(),
        themes = themes ?? const [],
        audio = audio ?? StoryAudio.empty();

  factory Story.fromFirestore(Map<String, dynamic> data, String id) {
    return Story.fromMap(data, fallbackId: id);
  }

  factory Story.fromJson(Map<String, dynamic> data) {
    return Story.fromMap(data);
  }

  factory Story.fromMap(Map<String, dynamic> data, {String? fallbackId}) {
    return Story(
      id: _readString(data['id'], fallback: fallbackId ?? ''),
      collection: _readString(data['collection']),
      status: _readString(data['status'], fallback: 'published'),
      priority: _readInt(data['priority']),
      titleAm: _readString(data['titleAm']),
      titleEn: _readString(data['titleEn']),
      coverImage: _readString(data['coverImage']),
      summaryAm: _readString(data['summaryAm'],
          fallback: _readString(data['summary'])),
      moralAm: _readString(data['moralAm']),
      source: StorySource.fromMap(_readMap(data['source'])),
      ageMin: _readInt(data['ageMin'], fallback: 3),
      ageMax: _readInt(data['ageMax'], fallback: 6),
      themes: _readStringList(data['themes']),
      audio: StoryAudio.fromMap(_readMap(data['audio'])),
    );
  }

  Story copyWith({
    String? coverImage,
  }) {
    return Story(
      id: id,
      collection: collection,
      status: status,
      priority: priority,
      titleAm: titleAm,
      titleEn: titleEn,
      coverImage: coverImage ?? this.coverImage,
      summaryAm: summaryAm,
      moralAm: moralAm,
      source: source,
      ageMin: ageMin,
      ageMax: ageMax,
      themes: themes,
      audio: audio,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'collection': collection,
      'status': status,
      'priority': priority,
      'titleAm': titleAm,
      'titleEn': titleEn,
      'coverImage': coverImage,
      'summaryAm': summaryAm,
      'moralAm': moralAm,
      'source': source.toJson(),
      'ageMin': ageMin,
      'ageMax': ageMax,
      'themes': themes,
      'audio': audio.toJson(),
    };
  }

  static String _readString(Object? value, {String fallback = ''}) {
    if (value is String) {
      return value;
    }

    return fallback;
  }

  static int _readInt(Object? value, {int fallback = 0}) {
    if (value is num) {
      return value.toInt();
    }

    return fallback;
  }

  static Map<String, dynamic> _readMap(Object? value) {
    if (value is Map) {
      return Map<String, dynamic>.from(value);
    }

    return {};
  }

  static List<String> _readStringList(Object? value) {
    if (value is List) {
      return value.whereType<String>().toList();
    }

    return [];
  }

  static String? _readNullableString(Object? value) {
    if (value is String && value.isNotEmpty) {
      return value;
    }

    return null;
  }

  static int? _readNullableInt(Object? value) {
    if (value is num) {
      return value.toInt();
    }

    return null;
  }
}

class StorySource {
  final String type;
  final String name;
  final String sourceUrl;
  final String notes;

  const StorySource({
    required this.type,
    required this.name,
    required this.sourceUrl,
    required this.notes,
  });

  factory StorySource.empty() {
    return const StorySource(
      type: '',
      name: '',
      sourceUrl: '',
      notes: '',
    );
  }

  factory StorySource.fromMap(Map<String, dynamic> data) {
    return StorySource(
      type: Story._readString(data['type']),
      name: Story._readString(data['name']),
      sourceUrl: Story._readString(data['sourceUrl']),
      notes: Story._readString(data['notes']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'name': name,
      'sourceUrl': sourceUrl,
      'notes': notes,
    };
  }
}

class StoryAudio {
  final String? storyAudioUrl;
  final int? durationSeconds;
  final String? narratorName;

  const StoryAudio({
    this.storyAudioUrl,
    this.durationSeconds,
    this.narratorName,
  });

  factory StoryAudio.empty() {
    return const StoryAudio();
  }

  factory StoryAudio.fromMap(Map<String, dynamic> data) {
    return StoryAudio(
      storyAudioUrl: Story._readNullableString(data['storyAudioUrl']),
      durationSeconds: Story._readNullableInt(data['durationSeconds']),
      narratorName: Story._readNullableString(data['narratorName']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'storyAudioUrl': storyAudioUrl,
      'durationSeconds': durationSeconds,
      'narratorName': narratorName,
    };
  }
}
