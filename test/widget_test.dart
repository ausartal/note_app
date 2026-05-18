import 'package:flutter_test/flutter_test.dart';
import 'package:note_app/providers/theme_provider.dart';

void main() {
  test('ThemeProvider toggles dark mode', () {
    final provider = ThemeProvider();
    expect(provider.isDarkMode, isFalse);

    provider.toggleTheme();
    expect(provider.isDarkMode, isTrue);
  });
}
