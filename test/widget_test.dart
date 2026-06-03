import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pdfrx/pdfrx.dart';

import 'package:color_weakness_helper/app.dart';
import 'package:color_weakness_helper/models/rendered_pdf_page.dart';
import 'package:color_weakness_helper/services/mask_scheme_storage.dart';
import 'package:color_weakness_helper/services/preferences_store.dart';
import 'package:color_weakness_helper/services/pdf_asset_service.dart';

void main() {
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
        maskSchemeStorage: const MaskSchemeStorage(store: _InMemoryStore()),
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
        maskSchemeStorage: const MaskSchemeStorage(store: _InMemoryStore()),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Color Weakness Bookshelf'), findsOneWidget);
    expect(find.text('Ready'), findsNWidgets(5));
    expect(find.text('Missing'), findsOneWidget);
  });
}

class _FakePdfAssetService extends PdfAssetService {
  const _FakePdfAssetService();

  @override
  Future<bool> assetExists(String assetPath) async {
    return !assetPath.endsWith('4th.pdf');
  }

  @override
  Future<PdfDocument> openDocument(String assetPath) {
    throw UnimplementedError();
  }

  @override
  Future<RenderedPdfPage> renderPage({
    required PdfDocument document,
    required int pageNumber,
    double scale = 2.2,
    int backgroundColor = 0xFFFDFBF7,
    Duration pageLoadTimeout = const Duration(seconds: 12),
  }) {
    throw UnimplementedError();
  }
}

class _InMemoryStore implements PreferencesStore {
  const _InMemoryStore();

  @override
  Future<String?> getString(String key) async => null;

  @override
  Future<void> remove(String key) async {}

  @override
  Future<void> setString(String key, String value) async {}
}
