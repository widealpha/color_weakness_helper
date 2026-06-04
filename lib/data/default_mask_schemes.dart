import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../models/mask_scheme.dart';

const List<MaskScheme> defaultMaskSchemes = <MaskScheme>[
  MaskScheme(
    id: 'builtin-green-weak',
    name: 'Green-weak Compensation',
    note:
        'Re-map confusing red-green ranges so nearby green, yellow, and brown details become easier to tell apart.',
    color: Color(0xFF8ECAE6),
    opacity: 0.72,
    blendMode: BlendMode.overlay,
    effectMode: MaskEffectMode.deutanCompensation,
    isBuiltIn: true,
  ),
  MaskScheme(
    id: 'builtin-red-weak',
    name: 'Red-weak Compensation',
    note:
        'Shift hard-to-separate red tones into channels that stay easier to notice.',
    color: Color(0xFF4CC9F0),
    opacity: 0.72,
    blendMode: BlendMode.softLight,
    effectMode: MaskEffectMode.protanCompensation,
    isBuiltIn: true,
  ),
  MaskScheme(
    id: 'builtin-blue-yellow-weak',
    name: 'Blue-yellow Compensation',
    note:
        'Re-balance blue and yellow confusion so cool and warm areas separate more clearly.',
    color: Color(0xFFEF476F),
    opacity: 0.72,
    blendMode: BlendMode.softLight,
    effectMode: MaskEffectMode.tritanCompensation,
    isBuiltIn: true,
  ),
  MaskScheme(
    id: 'builtin-high-contrast',
    name: 'High-contrast Mono',
    note:
        'Drop most color information and push luminance contrast harder when you only need clean shapes.',
    color: Color(0xFFF5F5F5),
    opacity: 0.88,
    blendMode: BlendMode.overlay,
    effectMode: MaskEffectMode.highContrast,
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
    'builtin-high-contrast' => scheme.copyWith(
      name: l10n.defaultSchemeHighContrastName,
      note: l10n.defaultSchemeHighContrastNote,
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
