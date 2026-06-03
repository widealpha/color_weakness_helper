import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../models/mask_scheme.dart';

const List<MaskScheme> defaultMaskSchemes = <MaskScheme>[
  MaskScheme(
    id: 'builtin-green-weak',
    name: 'Green-weak Assist',
    note:
        'A warm amber assist that helps nearby green, yellow, and brown areas feel easier to separate.',
    color: Color(0xFFFFB703),
    opacity: 0.18,
    blendMode: BlendMode.overlay,
    effectMode: MaskEffectMode.blend,
    isBuiltIn: true,
  ),
  MaskScheme(
    id: 'builtin-red-weak',
    name: 'Red-weak Assist',
    note:
        'A cool-toned assist that can make red and orange details easier to notice.',
    color: Color(0xFF3FC1C9),
    opacity: 0.22,
    blendMode: BlendMode.softLight,
    effectMode: MaskEffectMode.blend,
    isBuiltIn: true,
  ),
  MaskScheme(
    id: 'builtin-blue-yellow-weak',
    name: 'Blue-yellow Assist',
    note:
        'A soft magenta assist that helps cool and warm color blocks feel more distinct.',
    color: Color(0xFFEF476F),
    opacity: 0.16,
    blendMode: BlendMode.softLight,
    effectMode: MaskEffectMode.blend,
    isBuiltIn: true,
  ),
  MaskScheme(
    id: 'builtin-replace-warm',
    name: 'Warm Replace',
    note:
        'Replace most colors with a warm tone so it is easier to focus on light and dark contrast.',
    color: Color(0xFFE9C46A),
    opacity: 0.82,
    blendMode: BlendMode.overlay,
    effectMode: MaskEffectMode.replace,
    isBuiltIn: true,
  ),
  MaskScheme(
    id: 'builtin-invert',
    name: 'Invert Colors',
    note:
        'Invert the page colors for a stronger contrast view, especially useful under bright light.',
    color: Color(0xFFFFFFFF),
    opacity: 1,
    blendMode: BlendMode.overlay,
    effectMode: MaskEffectMode.invert,
    isBuiltIn: true,
  ),
  MaskScheme(
    id: 'builtin-none',
    name: 'No Mask',
    note: 'Turn off the assistance layer and inspect the original page only.',
    color: Color(0xFF000000),
    opacity: 0,
    blendMode: BlendMode.overlay,
    effectMode: MaskEffectMode.blend,
    isBuiltIn: true,
  ),
];

List<MaskScheme> localizedDefaultMaskSchemes(AppLocalizations l10n) {
  return defaultMaskSchemes
      .map((MaskScheme scheme) => localizeMaskScheme(l10n, scheme))
      .toList(growable: false);
}

MaskScheme localizeMaskScheme(AppLocalizations l10n, MaskScheme scheme) {
  return switch (scheme.id) {
    'builtin-green-weak' => scheme.copyWith(
      name: l10n.defaultSchemeGreenWeakName,
      note: l10n.defaultSchemeGreenWeakNote,
    ),
    'builtin-red-weak' => scheme.copyWith(
      name: l10n.defaultSchemeRedWeakName,
      note: l10n.defaultSchemeRedWeakNote,
    ),
    'builtin-blue-yellow-weak' => scheme.copyWith(
      name: l10n.defaultSchemeBlueYellowWeakName,
      note: l10n.defaultSchemeBlueYellowWeakNote,
    ),
    'builtin-replace-warm' => scheme.copyWith(
      name: l10n.defaultSchemeReplaceWarmName,
      note: l10n.defaultSchemeReplaceWarmNote,
    ),
    'builtin-invert' => scheme.copyWith(
      name: l10n.defaultSchemeInvertName,
      note: l10n.defaultSchemeInvertNote,
    ),
    'builtin-none' => scheme.copyWith(
      name: l10n.defaultSchemeNoneName,
      note: l10n.defaultSchemeNoneNote,
    ),
    _ => scheme,
  };
}
