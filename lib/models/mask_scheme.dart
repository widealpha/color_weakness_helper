import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';

enum MaskEffectMode { blend, replace, invert }

const List<MaskEffectMode> supportedMaskEffectModes = <MaskEffectMode>[
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
    MaskEffectMode.blend => l10n.effectModeBlend,
    MaskEffectMode.replace => l10n.effectModeReplace,
    MaskEffectMode.invert => l10n.effectModeInvert,
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

bool effectModeUsesColor(MaskEffectMode mode) => mode != MaskEffectMode.invert;

bool effectModeUsesOpacity(MaskEffectMode mode) =>
    mode != MaskEffectMode.invert;

bool effectModeUsesBlendMode(MaskEffectMode mode) =>
    mode == MaskEffectMode.blend;

String schemeSummary(AppLocalizations l10n, MaskScheme scheme) {
  return switch (scheme.effectMode) {
    MaskEffectMode.blend =>
      '${effectModeLabel(l10n, scheme.effectMode)} · ${blendModeLabel(l10n, scheme.blendMode)} · ${maskHex(scheme.color)} · ${maskOpacityLabel(scheme.opacity)}',
    MaskEffectMode.replace =>
      '${effectModeLabel(l10n, scheme.effectMode)} · ${maskHex(scheme.color)} · ${maskOpacityLabel(scheme.opacity)}',
    MaskEffectMode.invert => effectModeLabel(l10n, scheme.effectMode),
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
