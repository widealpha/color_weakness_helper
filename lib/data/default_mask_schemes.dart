import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../models/mask_scheme.dart';

const List<MaskScheme> defaultMaskSchemes = <MaskScheme>[
  MaskScheme(
    id: 'builtin-green-weak',
    name: 'Deutan Daltonize',
    note:
        'Simulate green-channel loss, then move the lost difference into red and blue contrast for common red-green confusion.',
    color: Color(0xFF2A9D8F),
    opacity: 0.84,
    blendMode: BlendMode.overlay,
    effectMode: MaskEffectMode.deutanCompensation,
    isBuiltIn: true,
  ),
  MaskScheme(
    id: 'builtin-red-weak',
    name: 'Protan Daltonize',
    note:
        'Reconstruct red-heavy information through green and blue contrast, useful when reds look dark or disappear.',
    color: Color(0xFFE76F51),
    opacity: 0.86,
    blendMode: BlendMode.softLight,
    effectMode: MaskEffectMode.protanCompensation,
    isBuiltIn: true,
  ),
  MaskScheme(
    id: 'builtin-blue-yellow-weak',
    name: 'Tritan Daltonize',
    note:
        'Separate blue-yellow confusion by transferring lost blue-channel contrast into red and green cues.',
    color: Color(0xFF3A86FF),
    opacity: 0.78,
    blendMode: BlendMode.softLight,
    effectMode: MaskEffectMode.tritanCompensation,
    isBuiltIn: true,
  ),
  MaskScheme(
    id: 'builtin-red-green-pulse',
    name: 'Red-Green Fast Blink',
    note:
        'Switches protan and deutan compensation every 0.4 seconds so red-green differences become easier to notice through temporal contrast.',
    color: Color(0xFF2A9D8F),
    opacity: 0.82,
    blendMode: BlendMode.overlay,
    effectMode: MaskEffectMode.redGreenPulse,
    firstMatrixPass: MaskMatrixPass.deutanCompensation,
    secondMatrixPass: MaskMatrixPass.protanCompensation,
    isBuiltIn: true,
  ),
  MaskScheme(
    id: 'builtin-red-green-reverse-pulse',
    name: 'Red + Reverse Green',
    note:
        'Combines protan compensation with an inverse deutan pass to exaggerate red-green separation without temporal switching.',
    color: Color(0xFF5E548E),
    opacity: 0.78,
    blendMode: BlendMode.overlay,
    effectMode: MaskEffectMode.redGreenReversePulse,
    firstMatrixPass: MaskMatrixPass.protanCompensation,
    secondMatrixPass: MaskMatrixPass.deutanReverse,
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
    'builtin-red-green-pulse' => scheme.copyWith(
      name: l10n.defaultSchemeRedGreenPulseName,
      note: l10n.defaultSchemeRedGreenPulseNote,
    ),
    'builtin-red-green-reverse-pulse' => scheme.copyWith(
      name: l10n.defaultSchemeRedGreenReversePulseName,
      note: l10n.defaultSchemeRedGreenReversePulseNote,
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
