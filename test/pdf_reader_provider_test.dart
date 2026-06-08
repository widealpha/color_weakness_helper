import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:color_weakness_helper/data/default_mask_schemes.dart';
import 'package:color_weakness_helper/models/mask_scheme.dart';
import 'package:color_weakness_helper/models/pdf_book.dart';
import 'package:color_weakness_helper/providers/pdf_reader_provider.dart';
import 'package:color_weakness_helper/services/pdf_asset_service.dart';
import 'package:color_weakness_helper/utils/preferences_utils.dart';

void main() {
  test('color filter matrices remain valid Flutter 4x5 matrices', () {
    expect(deutanCompensationColorMatrix, hasLength(20));
    expect(deutanReverseColorMatrix, hasLength(20));
    expect(protanCompensationColorMatrix, hasLength(20));
    expect(protanReverseColorMatrix, hasLength(20));
    expect(tritanCompensationColorMatrix, hasLength(20));
    expect(tritanReverseColorMatrix, hasLength(20));
    expect(highContrastMonochromeColorMatrix, hasLength(20));
    expect(invertColorMatrix, hasLength(20));
  });

  test('default schemes include daltonization and alternating modes', () {
    expect(
      defaultMaskSchemes.map((MaskScheme scheme) => scheme.effectMode),
      containsAll(<MaskEffectMode>[
        MaskEffectMode.deutanCompensation,
        MaskEffectMode.protanCompensation,
        MaskEffectMode.redGreenPulse,
        MaskEffectMode.redGreenReversePulse,
        MaskEffectMode.tritanCompensation,
        MaskEffectMode.highContrast,
        MaskEffectMode.invert,
        MaskEffectMode.blend,
      ]),
    );
  });

  test('pdf render scale is capped for large pages', () {
    expect(
      PdfAssetService.resolveRenderScale(
        width: 1000,
        height: 1200,
        preferredScale: 2.2,
        maxTextureSide: 2400,
      ),
      2.0,
    );
    expect(
      PdfAssetService.resolveRenderScale(
        width: 600,
        height: 800,
        preferredScale: 2.2,
        maxTextureSide: 2400,
      ),
      2.2,
    );
    expect(
      () => PdfAssetService.resolveRenderScale(
        width: 0,
        height: 800,
        preferredScale: 2.2,
        maxTextureSide: 2400,
      ),
      throwsStateError,
    );
  });

  test('pdf render scale keeps a practical lower bound', () {
    expect(
      PdfAssetService.resolveRenderScale(
        width: 4000,
        height: 5000,
        preferredScale: 2.2,
        maxTextureSide: 2400,
      ),
      0.8,
    );
  });

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

  test('saves and reloads red-green alternating custom schemes', () async {
    final preferencesUtils = _MemoryPreferencesUtils();
    final writer = PdfReaderProvider(
      book: _book,
      pdfAssetService: const _FakePdfAssetService(),
      preferencesUtils: preferencesUtils,
    );

    writer.setEffectMode(MaskEffectMode.redGreenPulse);
    writer.setOpacity(0.82);
    await writer.saveCurrentScheme(name: '红绿交替', note: '红绿变化更明显');

    final reader = PdfReaderProvider(
      book: _book,
      pdfAssetService: const _FakePdfAssetService(),
      preferencesUtils: preferencesUtils,
    );
    await reader.loadSavedSchemes();

    expect(reader.savedSchemes, hasLength(1));
    expect(reader.savedSchemes.first.effectMode, MaskEffectMode.redGreenPulse);
    expect(reader.savedSchemes.first.opacity, 0.82);
  });

  test('saves and reloads two-pass combination custom schemes', () async {
    final preferencesUtils = _MemoryPreferencesUtils();
    final writer = PdfReaderProvider(
      book: _book,
      pdfAssetService: const _FakePdfAssetService(),
      preferencesUtils: preferencesUtils,
    );

    writer.setEffectMode(MaskEffectMode.redGreenReversePulse);
    writer.setFirstMatrixPass(MaskMatrixPass.protanCompensation);
    writer.setSecondMatrixPass(MaskMatrixPass.deutanReverse);
    writer.setOpacity(0.78);
    await writer.saveCurrentScheme(name: '双弱组合', note: '测试更强红绿分离');

    final reader = PdfReaderProvider(
      book: _book,
      pdfAssetService: const _FakePdfAssetService(),
      preferencesUtils: preferencesUtils,
    );
    await reader.loadSavedSchemes();

    expect(reader.savedSchemes, hasLength(1));
    expect(
      reader.savedSchemes.first.effectMode,
      MaskEffectMode.redGreenReversePulse,
    );
    expect(
      reader.savedSchemes.first.firstMatrixPass,
      MaskMatrixPass.protanCompensation,
    );
    expect(
      reader.savedSchemes.first.secondMatrixPass,
      MaskMatrixPass.deutanReverse,
    );
    expect(reader.savedSchemes.first.opacity, 0.78);
  });

  test('legacy two-pass schemes receive mode-specific matrix defaults', () {
    final pulse = MaskScheme.fromJson(<String, Object?>{
      'id': 'legacy-pulse',
      'effectMode': MaskEffectMode.redGreenPulse.name,
    });
    final combined = MaskScheme.fromJson(<String, Object?>{
      'id': 'legacy-combined',
      'effectMode': MaskEffectMode.redGreenReversePulse.name,
    });

    expect(pulse.firstMatrixPass, MaskMatrixPass.deutanCompensation);
    expect(pulse.secondMatrixPass, MaskMatrixPass.protanCompensation);
    expect(combined.firstMatrixPass, MaskMatrixPass.protanCompensation);
    expect(combined.secondMatrixPass, MaskMatrixPass.deutanReverse);
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
