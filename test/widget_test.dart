import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pdfx/pdfx.dart';

import 'package:color_weakness_helper/app.dart';
import 'package:color_weakness_helper/models/rendered_pdf_page.dart';
import 'package:color_weakness_helper/services/pdf_asset_service.dart';
import 'package:color_weakness_helper/utils/preferences_utils.dart';

void main() {
  tearDown(() {
    final binding = TestWidgetsFlutterBinding.ensureInitialized();
    binding.platformDispatcher.clearLocaleTestValue();
    binding.platformDispatcher.clearLocalesTestValue();
    binding.platformDispatcher.clearPlatformBrightnessTestValue();
  });

  testWidgets('renders home shelf with 1th to 6th entries in Chinese', (
    WidgetTester tester,
  ) async {
    tester.binding.platformDispatcher.localeTestValue = const Locale('zh');
    tester.binding.platformDispatcher.localesTestValue = const <Locale>[
      Locale('zh'),
    ];
    addTearDown(tester.binding.platformDispatcher.clearLocaleTestValue);
    addTearDown(tester.binding.platformDispatcher.clearLocalesTestValue);

    await tester.pumpWidget(
      ColorWeaknessHelperApp(
        pdfAssetService: const _FakePdfAssetService(),
        preferencesUtils: const _InMemoryPreferencesUtils(),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('色弱辅助书架'), findsOneWidget);
    expect(find.text('1th.pdf'), findsOneWidget);
    expect(find.text('2th.pdf'), findsOneWidget);
    expect(find.text('3th.pdf'), findsOneWidget);
    expect(find.text('4th.pdf'), findsOneWidget);
    expect(find.text('5th.pdf'), findsOneWidget);
    expect(find.text('6th.pdf'), findsOneWidget);
    expect(find.text('已就绪'), findsNWidgets(5));
    expect(find.text('待放入'), findsOneWidget);
  });

  testWidgets('renders translated shelf in English dark mode', (
    WidgetTester tester,
  ) async {
    tester.binding.platformDispatcher.localeTestValue = const Locale('en');
    tester.binding.platformDispatcher.localesTestValue = const <Locale>[
      Locale('en'),
    ];
    tester.binding.platformDispatcher.platformBrightnessTestValue =
        Brightness.dark;
    addTearDown(tester.binding.platformDispatcher.clearLocaleTestValue);
    addTearDown(tester.binding.platformDispatcher.clearLocalesTestValue);
    addTearDown(
      tester.binding.platformDispatcher.clearPlatformBrightnessTestValue,
    );

    await tester.pumpWidget(
      ColorWeaknessHelperApp(
        pdfAssetService: const _FakePdfAssetService(),
        preferencesUtils: const _InMemoryPreferencesUtils(),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Color Weakness Bookshelf'), findsOneWidget);
    expect(find.text('Ready'), findsNWidgets(5));
    expect(find.text('Missing'), findsOneWidget);
  });

  testWidgets('home shelf adapts to narrow Android-sized viewport', (
    WidgetTester tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(320, 720));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    tester.binding.platformDispatcher.localeTestValue = const Locale('zh');
    tester.binding.platformDispatcher.localesTestValue = const <Locale>[
      Locale('zh'),
    ];

    await tester.pumpWidget(
      ColorWeaknessHelperApp(
        pdfAssetService: const _FakePdfAssetService(),
        preferencesUtils: const _InMemoryPreferencesUtils(),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('色弱辅助书架'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('home shelf keeps responsive layout on wide viewport', (
    WidgetTester tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(1200, 900));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    tester.binding.platformDispatcher.localeTestValue = const Locale('en');
    tester.binding.platformDispatcher.localesTestValue = const <Locale>[
      Locale('en'),
    ];

    await tester.pumpWidget(
      ColorWeaknessHelperApp(
        pdfAssetService: const _FakePdfAssetService(),
        preferencesUtils: const _InMemoryPreferencesUtils(),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Color Weakness Bookshelf'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}

class _FakePdfAssetService extends PdfAssetService {
  const _FakePdfAssetService();

  @override
  Future<bool> assetExists(String assetPath) async {
    return !assetPath.endsWith('4th.pdf');
  }

  @override
  Future<PdfDocument> openDocument(
    String assetPath, {
    Duration timeout = const Duration(seconds: 15),
  }) {
    throw UnimplementedError();
  }

  @override
  Future<RenderedPdfPage> renderPage({
    required PdfDocument document,
    required int pageNumber,
    double scale = 2.2,
    double maxTextureSide = 2400,
    int backgroundColor = 0xFFFDFBF7,
    Duration pageLoadTimeout = const Duration(seconds: 12),
    Duration renderTimeout = const Duration(seconds: 20),
  }) {
    throw UnimplementedError();
  }
}

class _InMemoryPreferencesUtils implements PreferencesUtils {
  const _InMemoryPreferencesUtils();

  @override
  Future<String?> getString(String key) async => null;

  @override
  Future<void> remove(String key) async {}

  @override
  Future<void> setString(String key, String value) async {}
}
