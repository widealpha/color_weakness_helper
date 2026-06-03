import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:color_weakness_helper/models/mask_scheme.dart';
import 'package:color_weakness_helper/services/mask_scheme_storage.dart';
import 'package:color_weakness_helper/services/preferences_store.dart';

void main() {
  test('saves, reloads and deletes custom schemes', () async {
    final store = _MemoryPreferencesStore();
    final storage = MaskSchemeStorage(store: store);

    const first = MaskScheme(
      id: 'scheme-1',
      name: '夜间柔光',
      note: '第一次保存',
      color: Color(0xFF3FC1C9),
      opacity: 0.22,
      blendMode: BlendMode.softLight,
      effectMode: MaskEffectMode.replace,
    );

    await storage.saveScheme(first);

    final loadedAfterFirstSave = await storage.loadSchemes();
    expect(loadedAfterFirstSave, hasLength(1));
    expect(loadedAfterFirstSave.first.name, '夜间柔光');
    expect(loadedAfterFirstSave.first.effectMode, MaskEffectMode.replace);

    const replacement = MaskScheme(
      id: 'scheme-2',
      name: '夜间柔光',
      note: '同名覆盖',
      color: Color(0xFFFFB703),
      opacity: 0.18,
      blendMode: BlendMode.overlay,
      effectMode: MaskEffectMode.invert,
    );

    await storage.saveScheme(replacement);

    final loadedAfterReplacement = await storage.loadSchemes();
    expect(loadedAfterReplacement, hasLength(1));
    expect(loadedAfterReplacement.first.id, 'scheme-2');
    expect(loadedAfterReplacement.first.note, '同名覆盖');
    expect(loadedAfterReplacement.first.effectMode, MaskEffectMode.invert);

    await storage.deleteScheme('scheme-2');

    final loadedAfterDelete = await storage.loadSchemes();
    expect(loadedAfterDelete, isEmpty);
  });
}

class _MemoryPreferencesStore implements PreferencesStore {
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
