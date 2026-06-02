import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class SettingsProvider with ChangeNotifier {
  static const double minFontSize = 20;
  static const double maxFontSize = 34;
  static const double defaultFontSize = 25;
  static const double fontSizeStep = 2;

  final Box _settingsBox;

  SettingsProvider({
    Box? settingsBox,
  }) : _settingsBox = settingsBox ?? Hive.box('settings');

  double get fontSize {
    final savedFontSize = _settingsBox.get(
      'reader_font_size',
      defaultValue: defaultFontSize,
    );

    if (savedFontSize is num) {
      return savedFontSize.toDouble();
    }

    return defaultFontSize;
  }

  Future<void> updateFontSize(double value) async {
    await _settingsBox.put('reader_font_size', _safeFontSize(value));
    notifyListeners();
  }

  Future<void> increaseFontSize() {
    return updateFontSize(fontSize + fontSizeStep);
  }

  Future<void> decreaseFontSize() {
    return updateFontSize(fontSize - fontSizeStep);
  }

  Future<void> resetFontSize() async {
    await _settingsBox.put('reader_font_size', defaultFontSize);
    notifyListeners();
  }

  double _safeFontSize(double value) {
    return value.clamp(minFontSize, maxFontSize).toDouble();
  }
}
