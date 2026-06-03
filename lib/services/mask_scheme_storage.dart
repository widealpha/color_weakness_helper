import 'dart:convert';

import '../models/mask_scheme.dart';
import 'preferences_store.dart';

class MaskSchemeStorage {
  const MaskSchemeStorage({PreferencesStore? store})
    : _store = store ?? const SharedPreferencesStore();

  static const String storageKey = 'user_mask_schemes';

  final PreferencesStore _store;

  Future<List<MaskScheme>> loadSchemes() async {
    final rawJson = await _store.getString(storageKey);
    if (rawJson == null || rawJson.isEmpty) {
      return <MaskScheme>[];
    }

    try {
      final decoded = jsonDecode(rawJson);
      if (decoded is! List) {
        return <MaskScheme>[];
      }

      return decoded
          .whereType<Map<Object?, Object?>>()
          .map(
            (Map<Object?, Object?> item) =>
                MaskScheme.fromJson(Map<String, Object?>.from(item)),
          )
          .toList();
    } catch (_) {
      return <MaskScheme>[];
    }
  }

  Future<void> saveScheme(MaskScheme scheme) async {
    final schemes = await loadSchemes();
    final normalizedName = scheme.name.trim().toLowerCase();
    final existingIndex = schemes.indexWhere((MaskScheme item) {
      return item.id == scheme.id ||
          item.name.trim().toLowerCase() == normalizedName;
    });

    if (existingIndex >= 0) {
      schemes[existingIndex] = scheme.copyWith(isBuiltIn: false);
    } else {
      schemes.add(scheme.copyWith(isBuiltIn: false));
    }

    await _persist(schemes);
  }

  Future<void> deleteScheme(String schemeId) async {
    final schemes = await loadSchemes();
    schemes.removeWhere((MaskScheme item) => item.id == schemeId);

    if (schemes.isEmpty) {
      await _store.remove(storageKey);
      return;
    }

    await _persist(schemes);
  }

  Future<void> _persist(List<MaskScheme> schemes) {
    final encoded = jsonEncode(
      schemes.map((MaskScheme scheme) => scheme.toJson()).toList(),
    );
    return _store.setString(storageKey, encoded);
  }
}
