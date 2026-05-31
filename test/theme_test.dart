import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:designgrid_ai/logic/theme/theme_bloc.dart';
import 'package:designgrid_ai/logic/theme/theme_event.dart';
import 'package:designgrid_ai/logic/theme/theme_state.dart';
import 'package:designgrid_ai/core/theme/app_theme.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  GoogleFonts.config.allowRuntimeFetching = false;

  group('ThemeBloc Tests', () {
    late ThemeBloc themeBloc;

    setUp(() {
      themeBloc = ThemeBloc();
    });

    tearDown(() {
      themeBloc.close();
    });

    test('initial state is dark mode', () {
      expect(themeBloc.state.themeMode, ThemeMode.dark);
    });

    test('ToggleThemeEvent changes dark to light', () {
      themeBloc.add(ToggleThemeEvent());
      expectLater(
        themeBloc.stream,
        emits(const ThemeState(ThemeMode.light)),
      );
    });
  });

  group('Core Theme Tests', () {
    test('Dark theme has correct background color', () {
      final darkTheme = AppTheme.darkTheme;
      expect(darkTheme.scaffoldBackgroundColor, const Color(0xFF0D0E12));
    });

    test('Dark theme use primary amber', () {
      final darkTheme = AppTheme.darkTheme;
      expect(darkTheme.colorScheme.primary, const Color(0xFFFFC72C));
    });
  });
}
