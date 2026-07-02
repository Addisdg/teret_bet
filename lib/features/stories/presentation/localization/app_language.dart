enum AppLanguage {
  amharic,
  english;

  String get storageValue => name;

  static AppLanguage? fromStorage(Object? value) {
    return switch (value) {
      'amharic' => AppLanguage.amharic,
      'english' => AppLanguage.english,
      _ => null,
    };
  }

  String choose({required String amharic, required String english}) {
    return this == AppLanguage.english ? english : amharic;
  }
}
