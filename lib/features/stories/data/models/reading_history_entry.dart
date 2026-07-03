class ReadingHistoryEntry {
  final String storyId;
  final int lastPageIndex;
  final int pageCount;
  final DateTime lastReadAt;
  final bool isCompleted;

  const ReadingHistoryEntry({
    required this.storyId,
    required this.lastPageIndex,
    required this.pageCount,
    required this.lastReadAt,
    required this.isCompleted,
  });

  factory ReadingHistoryEntry.fromMap(Map<String, dynamic> data) {
    final lastReadAt = DateTime.tryParse(data['lastReadAt'] as String? ?? '');

    return ReadingHistoryEntry(
      storyId: data['storyId'] as String? ?? '',
      lastPageIndex: (data['lastPageIndex'] as num?)?.toInt() ?? 0,
      pageCount: (data['pageCount'] as num?)?.toInt() ?? 0,
      lastReadAt: lastReadAt ?? DateTime.fromMillisecondsSinceEpoch(0),
      isCompleted: data['isCompleted'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'storyId': storyId,
      'lastPageIndex': lastPageIndex,
      'pageCount': pageCount,
      'lastReadAt': lastReadAt.toIso8601String(),
      'isCompleted': isCompleted,
    };
  }
}
