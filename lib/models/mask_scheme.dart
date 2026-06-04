import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';

enum MaskEffectMode {
  deutanCompensation,
  protanCompensation,
  tritanCompensation,
  highContrast,
  blend,
  replace,
  invert,
}

const List<MaskEffectMode> supportedMaskEffectModes = <MaskEffectMode>[
  MaskEffectMode.deutanCompensation,
  MaskEffectMode.protanCompensation,
  MaskEffectMode.tritanCompensation,
  MaskEffectMode.highContrast,
  MaskEffectMode.blend,
  MaskEffectMode.replace,
  MaskEffectMode.invert,
];

const List<BlendMode> supportedBlendModes = <BlendMode>[
  BlendMode.softLight,
  BlendMode.overlay,
  BlendMode.multiply,
  BlendMode.screen,
];

class MaskScheme {
  const MaskScheme({
    required this.id,
    required this.name,
    required this.note,
    required this.color,
    required this.opacity,
    required this.blendMode,
    this.effectMode = MaskEffectMode.blend,
    this.isBuiltIn = false,
  });

  final String id;
  final String name;
  final String note;
  final Color color;
  final double opacity;
  final BlendMode blendMode;
  final MaskEffectMode effectMode;
  final bool isBuiltIn;

  MaskScheme copyWith({
    String? id,
    String? name,
    String? note,
    Color? color,
    double? opacity,
    BlendMode? blendMode,
    MaskEffectMode? effectMode,
    bool? isBuiltIn,
  }) {
    return MaskScheme(
      id: id ?? this.id,
      name: name ?? this.name,
      note: note ?? this.note,
      color: color ?? this.color,
      opacity: opacity ?? this.opacity,
      blendMode: blendMode ?? this.blendMode,
      effectMode: effectMode ?? this.effectMode,
      isBuiltIn: isBuiltIn ?? this.isBuiltIn,
    );
  }

  Map<String, Object?> toJson() {
    return <String, Object?>{
      'id': id,
      'name': name,
      'note': note,
      'color': color.toARGB32(),
      'opacity': opacity,
      'blendMode': blendMode.name,
      'effectMode': effectMode.name,
    };
  }

  factory MaskScheme.fromJson(Map<String, Object?> json) {
    final blendModeName =
        json['blendMode'] as String? ?? BlendMode.overlay.name;
    final effectModeName =
        json['effectMode'] as String? ?? MaskEffectMode.blend.name;
    return MaskScheme(
      id:
          json['id'] as String? ??
          DateTime.now().millisecondsSinceEpoch.toString(),
      name: json['name'] as String? ?? 'Unnamed scheme',
      note: json['note'] as String? ?? '',
      color: Color((json['color'] as num?)?.toInt() ?? 0xFF000000),
      opacity: (json['opacity'] as num?)?.toDouble() ?? 0,
      blendMode: supportedBlendModes.firstWhere(
        (BlendMode mode) => mode.name == blendModeName,
        orElse: () => BlendMode.overlay,
      ),
      effectMode: supportedMaskEffectModes.firstWhere(
        (MaskEffectMode mode) => mode.name == effectModeName,
        orElse: () => MaskEffectMode.blend,
      ),
    );
  }
}

String effectModeLabel(AppLocalizations l10n, MaskEffectMode mode) {
  return switch (mode) {
    MaskEffectMode.deutanCompensation => l10n.effectModeDeutanCompensation,
    MaskEffectMode.protanCompensation => l10n.effectModeProtanCompensation,
    MaskEffectMode.tritanCompensation => l10n.effectModeTritanCompensation,
    MaskEffectMode.highContrast => l10n.effectModeHighContrast,
    MaskEffectMode.blend => l10n.effectModeBlend,
    MaskEffectMode.replace => l10n.effectModeReplace,
    MaskEffectMode.invert => l10n.effectModeInvert,
  };
}

String effectModeHint(AppLocalizations l10n, MaskEffectMode mode) {
  return switch (mode) {
    MaskEffectMode.deutanCompensation => l10n.effectModeDeutanCompensationHint,
    MaskEffectMode.protanCompensation => l10n.effectModeProtanCompensationHint,
    MaskEffectMode.tritanCompensation => l10n.effectModeTritanCompensationHint,
    MaskEffectMode.highContrast => l10n.effectModeHighContrastHint,
    MaskEffectMode.blend => l10n.effectModeBlendHint,
    MaskEffectMode.replace => l10n.effectModeReplaceHint,
    MaskEffectMode.invert => l10n.effectModeInvertHint,
  };
}

String blendModeLabel(AppLocalizations l10n, BlendMode mode) {
  return switch (mode) {
    BlendMode.softLight => l10n.blendModeSoftLight,
    BlendMode.overlay => l10n.blendModeOverlay,
    BlendMode.multiply => l10n.blendModeMultiply,
    BlendMode.screen => l10n.blendModeScreen,
    _ => mode.name,
  };
}

bool effectModeUsesColor(MaskEffectMode mode) {
  return switch (mode) {
    MaskEffectMode.blend || MaskEffectMode.replace => true,
    _ => false,
  };
}

bool effectModeUsesOpacity(MaskEffectMode mode) {
  return switch (mode) {
    MaskEffectMode.invert => false,
    _ => true,
  };
}

bool effectModeUsesBlendMode(MaskEffectMode mode) =>
    mode == MaskEffectMode.blend;

double effectModeMaxOpacity(MaskEffectMode mode) {
  return switch (mode) {
    MaskEffectMode.blend => 0.65,
    MaskEffectMode.invert => 1,
    _ => 1,
  };
}

String schemeSummary(AppLocalizations l10n, MaskScheme scheme) {
  return switch (scheme.effectMode) {
    MaskEffectMode.blend =>
      '${effectModeLabel(l10n, scheme.effectMode)} · ${blendModeLabel(l10n, scheme.blendMode)} · ${maskHex(scheme.color)} · ${maskOpacityLabel(scheme.opacity)}',
    MaskEffectMode.replace =>
      '${effectModeLabel(l10n, scheme.effectMode)} · ${maskHex(scheme.color)} · ${maskOpacityLabel(scheme.opacity)}',
    MaskEffectMode.deutanCompensation ||
    MaskEffectMode.protanCompensation ||
    MaskEffectMode.tritanCompensation ||
    MaskEffectMode.highContrast =>
      '${effectModeLabel(l10n, scheme.effectMode)} · ${maskOpacityLabel(scheme.opacity)}',
    MaskEffectMode.invert => effectModeLabel(l10n, scheme.effectMode),
  };
}

Gradient schemePreviewGradient(MaskScheme scheme) {
  final previewStrength = scheme.effectMode == MaskEffectMode.invert
      ? 1.0
      : scheme.opacity <= 0
      ? 0.22
      : 0.22 + (scheme.opacity.clamp(0.0, 1.0) * 0.78);
  return switch (scheme.effectMode) {
    MaskEffectMode.deutanCompensation => LinearGradient(
      colors: <Color>[
        const Color(0xFFFFB703).withValues(alpha: previewStrength),
        const Color(0xFF1D3557).withValues(alpha: previewStrength),
      ],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    MaskEffectMode.protanCompensation => LinearGradient(
      colors: <Color>[
        const Color(0xFF4CC9F0).withValues(alpha: previewStrength),
        const Color(0xFFF4A261).withValues(alpha: previewStrength),
      ],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    MaskEffectMode.tritanCompensation => LinearGradient(
      colors: <Color>[
        const Color(0xFFEF476F).withValues(alpha: previewStrength),
        const Color(0xFF118AB2).withValues(alpha: previewStrength),
      ],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    MaskEffectMode.highContrast || MaskEffectMode.invert => LinearGradient(
      colors: <Color>[
        const Color(0xFFF5F5F5).withValues(alpha: previewStrength),
        const Color(0xFF101010).withValues(alpha: previewStrength),
      ],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    MaskEffectMode.blend || MaskEffectMode.replace => LinearGradient(
      colors: <Color>[
        scheme.color.withValues(alpha: scheme.opacity == 0 ? 0.10 : scheme.opacity),
        scheme.color.withValues(
          alpha: scheme.opacity == 0 ? 0.03 : scheme.opacity / 2,
        ),
      ],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
  };
}

const List<double> invertColorMatrix = <double>[
  -1,
  0,
  0,
  0,
  255,
  0,
  -1,
  0,
  0,
  255,
  0,
  0,
  -1,
  0,
  255,
  0,
  0,
  0,
  1,
  0,
];

const List<double> deutanCompensationColorMatrix = <double>[
  0.885,
  0.115,
  0,
  0,
  0,
  0,
  1,
  0,
  0,
  0,
  -0.49,
  0.19,
  1.3,
  0,
  0,
  0,
  0,
  0,
  1,
  0,
];

const List<double> protanCompensationColorMatrix = <double>[
  1,
  0,
  0,
  0,
  0,
  -0.255,
  1.255,
  0,
  0,
  0,
  0.303331,
  -0.545001,
  1.24167,
  0,
  0,
  0,
  0,
  0,
  1,
  0,
];

const List<double> tritanCompensationColorMatrix = <double>[
  1.05,
  -0.3825,
  0.3325,
  0,
  0,
  0,
  1.23417,
  -0.23417,
  0,
  0,
  0,
  0,
  1,
  0,
  0,
  0,
  0,
  0,
  1,
  0,
];

const List<double> highContrastMonochromeColorMatrix = <double>[
  0.36142,
  1.21584,
  0.12274,
  0,
  -89.6,
  0.36142,
  1.21584,
  0.12274,
  0,
  -89.6,
  0.36142,
  1.21584,
  0.12274,
  0,
  -89.6,
  0,
  0,
  0,
  1,
  0,
];

List<double> replacementColorMatrix(Color color) {
  final red = colorChannelToInt(color.r) / 255;
  final green = colorChannelToInt(color.g) / 255;
  final blue = colorChannelToInt(color.b) / 255;
  const redLuma = 0.2126;
  const greenLuma = 0.7152;
  const blueLuma = 0.0722;

  return <double>[
    redLuma * red,
    greenLuma * red,
    blueLuma * red,
    0,
    0,
    redLuma * green,
    greenLuma * green,
    blueLuma * green,
    0,
    0,
    redLuma * blue,
    greenLuma * blue,
    blueLuma * blue,
    0,
    0,
    0,
    0,
    0,
    1,
    0,
  ];
}

String maskOpacityLabel(double value) => '${(value * 100).round()}%';

int colorChannelToInt(double channel) {
  return (channel * 255).round().clamp(0, 255);
}

String maskHex(Color color) {
  final red = colorChannelToInt(color.r).toRadixString(16).padLeft(2, '0');
  final green = colorChannelToInt(color.g).toRadixString(16).padLeft(2, '0');
  final blue = colorChannelToInt(color.b).toRadixString(16).padLeft(2, '0');
  return '#${(red + green + blue).toUpperCase()}';
}
