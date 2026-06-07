import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:color_weakness_helper/models/mask_scheme.dart';
import 'package:color_weakness_helper/models/pdf_book.dart';
import 'package:color_weakness_helper/providers/pdf_reader_provider.dart';
import 'package:color_weakness_helper/services/pdf_asset_service.dart';
import 'package:color_weakness_helper/utils/preferences_utils.dart';

void main() {
  test('saves, reloads and deletes custom schemes', () async {
    final preferencesUtils = _MemoryPreferencesUtils();

    final writer = PdfReaderProvider(
      book: _book,
      pdfAssetService: const _FakePdfAssetService(),
      preferencesUtils: preferencesUtils,
    );

    writer.setEffectMode(MaskEffectMode.replace);
    writer.setRed(63);
    writer.setGreen(193);
    writer.setBlue(201);
    writer.setOpacity(0.22);
    writer.setBlendMode(BlendMode.softLight);
    await writer.saveCurrentScheme(name: '夜间柔光', note: '第一次保存');

    final reader = PdfReaderProvider(
      book: _book,
      pdfAssetService: const _FakePdfAssetService(),
      preferencesUtils: preferencesUtils,
    );
    await reader.loadSavedSchemes();
    expect(reader.savedSchemes, hasLength(1));
    expect(reader.savedSchemes.first.name, '夜间柔光');
    expect(reader.savedSchemes.first.effectMode, MaskEffectMode.replace);

    writer.setEffectMode(MaskEffectMode.invert);
    writer.setRed(255);
    writer.setGreen(183);
    writer.setBlue(3);
    writer.setOpacity(0.18);
    writer.setBlendMode(BlendMode.overlay);
    await writer.saveCurrentScheme(name: '夜间柔光', note: '同名覆盖');

    await reader.loadSavedSchemes();
    expect(reader.savedSchemes, hasLength(1));
    expect(reader.savedSchemes.first.note, '同名覆盖');
    expect(reader.savedSchemes.first.effectMode, MaskEffectMode.invert);

    await reader.deleteSavedScheme(reader.savedSchemes.first.id);
    expect(reader.savedSchemes, isEmpty);
  });
}

const PdfBook _book = PdfBook(
  id: 'test-book',
  title: 'test.pdf',
  subtitle: 'Test Book',
  assetPath: 'assets/test.pdf',
  description: 'test',
  accentColor: Color(0xFF355070),
);

class _FakePdfAssetService extends PdfAssetService {
  const _FakePdfAssetService();
}

class _MemoryPreferencesUtils implements PreferencesUtils {
  String? _value;

  @override
  Future<String?> getString(String key) async => _value;

  @override
  Future<void> remove(String key) async {
    _value = null;
  }

  @override
  Future<void> setString(String key, String value) async {
    _value = value;
  }
}
