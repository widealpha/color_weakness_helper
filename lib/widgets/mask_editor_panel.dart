import 'package:flutter/material.dart';

import '../l10n/localization_extensions.dart';
import '../models/editor_mode.dart';
import '../models/mask_scheme.dart';
import '../theme/app_theme.dart';
import 'app_panel.dart';

class MaskEditorPanel extends StatelessWidget {
  const MaskEditorPanel({
    super.key,
    required this.mode,
    required this.defaultSchemes,
    required this.selectedDefaultSchemeIndex,
    required this.savedSchemes,
    required this.isLoadingSavedSchemes,
    required this.customColor,
    required this.customOpacity,
    required this.customRed,
    required this.customGreen,
    required this.customBlue,
    required this.customEffectMode,
    required this.customFirstMatrixPass,
    required this.customSecondMatrixPass,
    required this.customBlendMode,
    required this.onModeChanged,
    required this.onDefaultSchemeSelected,
    required this.onStartCustomFromDefault,
    required this.onEffectModeChanged,
    required this.onFirstMatrixPassChanged,
    required this.onSecondMatrixPassChanged,
    required this.onBlendModeChanged,
    required this.onRedChanged,
    required this.onGreenChanged,
    required this.onBlueChanged,
    required this.onOpacityChanged,
    required this.onResetCustom,
    required this.onSaveCustomScheme,
    required this.onLoadSavedScheme,
    required this.onDeleteSavedScheme,
  });

  final EditorMode mode;
  final List<MaskScheme> defaultSchemes;
  final int selectedDefaultSchemeIndex;
  final List<MaskScheme> savedSchemes;
  final bool isLoadingSavedSchemes;
  final Color customColor;
  final double customOpacity;
  final double customRed;
  final double customGreen;
  final double customBlue;
  final MaskEffectMode customEffectMode;
  final MaskMatrixPass customFirstMatrixPass;
  final MaskMatrixPass customSecondMatrixPass;
  final BlendMode customBlendMode;
  final ValueChanged<EditorMode> onModeChanged;
  final ValueChanged<int> onDefaultSchemeSelected;
  final VoidCallback onStartCustomFromDefault;
  final ValueChanged<MaskEffectMode> onEffectModeChanged;
  final ValueChanged<MaskMatrixPass> onFirstMatrixPassChanged;
  final ValueChanged<MaskMatrixPass> onSecondMatrixPassChanged;
  final ValueChanged<BlendMode> onBlendModeChanged;
  final ValueChanged<double> onRedChanged;
  final ValueChanged<double> onGreenChanged;
  final ValueChanged<double> onBlueChanged;
  final ValueChanged<double> onOpacityChanged;
  final VoidCallback onResetCustom;
  final VoidCallback onSaveCustomScheme;
  final ValueChanged<MaskScheme> onLoadSavedScheme;
  final ValueChanged<String> onDeleteSavedScheme;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return AppPanel(
      title: l10n.maskEditorTitle,
      subtitle: l10n.maskEditorSubtitle,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SegmentedButton<EditorMode>(
            showSelectedIcon: false,
            segments: <ButtonSegment<EditorMode>>[
              ButtonSegment(
                value: EditorMode.preset,
                icon: Icon(Icons.visibility_outlined),
                label: Text(l10n.presetModeLabel),
              ),
              ButtonSegment(
                value: EditorMode.custom,
                icon: Icon(Icons.palette_outlined),
                label: Text(l10n.customBlendModeLabel),
              ),
            ],
            selected: <EditorMode>{mode},
            onSelectionChanged: (Set<EditorMode> selected) {
              onModeChanged(selected.first);
            },
          ),
          const SizedBox(height: 18),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child: mode == EditorMode.preset
                ? _buildPresetEditor(context)
                : _buildCustomEditor(context),
          ),
          const SizedBox(height: 20),
          _buildSavedSchemesSection(context),
        ],
      ),
    );
  }

  Widget _buildPresetEditor(BuildContext context) {
    final l10n = context.l10n;
    final scheme = defaultSchemes[selectedDefaultSchemeIndex];
    final stats = <Widget>[
      _statChip(
        context,
        l10n.schemeStatMode,
        effectModeLabel(l10n, scheme.effectMode),
      ),
    ];
    if (effectModeUsesColor(scheme.effectMode)) {
      stats.add(
        _statChip(context, l10n.schemeStatColor, maskHex(scheme.color)),
      );
    }
    if (effectModeUsesOpacity(scheme.effectMode)) {
      stats.add(
        _statChip(
          context,
          l10n.schemeStatIntensity,
          maskOpacityLabel(scheme.opacity),
        ),
      );
    }
    if (effectModeUsesBlendMode(scheme.effectMode)) {
      stats.add(
        _statChip(
          context,
          l10n.schemeStatBlend,
          blendModeLabel(l10n, scheme.blendMode),
        ),
      );
    }
    return Column(
      key: const ValueKey<String>('preset-editor'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: List<Widget>.generate(defaultSchemes.length, (int index) {
            return ChoiceChip(
              avatar: Container(
                width: 18,
                height: 18,
                decoration: BoxDecoration(
                  gradient: schemePreviewGradient(defaultSchemes[index]),
                  shape: BoxShape.circle,
                ),
              ),
              label: Text(
                defaultSchemes[index].name,
                overflow: TextOverflow.ellipsis,
              ),
              selected: selectedDefaultSchemeIndex == index,
              onSelected: (_) => onDefaultSchemeSelected(index),
            );
          }),
        ),
        const SizedBox(height: 16),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppTheme.mutedSurface(context),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(scheme.note, style: const TextStyle(height: 1.45)),
              const SizedBox(height: 12),
              Wrap(spacing: 10, runSpacing: 10, children: stats),
            ],
          ),
        ),
        const SizedBox(height: 16),
        FilledButton.tonalIcon(
          onPressed: onStartCustomFromDefault,
          icon: const Icon(Icons.tune),
          label: Text(l10n.startCustomFromPresetButton),
        ),
      ],
    );
  }

  Widget _buildCustomEditor(BuildContext context) {
    final l10n = context.l10n;
    final previewScheme = MaskScheme(
      id: 'preview',
      name: '',
      note: '',
      color: customColor,
      opacity: customOpacity,
      blendMode: customBlendMode,
      effectMode: customEffectMode,
      firstMatrixPass: customFirstMatrixPass,
      secondMatrixPass: customSecondMatrixPass,
    );
    return Column(
      key: const ValueKey<String>('custom-editor'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppTheme.mutedSurface(context),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            children: <Widget>[
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  gradient: schemePreviewGradient(previewScheme),
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(child: Text(schemeSummary(l10n, previewScheme))),
            ],
          ),
        ),
        const SizedBox(height: 16),
        DropdownButtonFormField<MaskEffectMode>(
          key: ValueKey<MaskEffectMode>(customEffectMode),
          initialValue: customEffectMode,
          decoration: InputDecoration(
            labelText: l10n.effectModeFieldLabel,
            border: const OutlineInputBorder(),
          ),
          items: supportedMaskEffectModes
              .map(
                (MaskEffectMode mode) => DropdownMenuItem<MaskEffectMode>(
                  value: mode,
                  child: Text(effectModeLabel(l10n, mode)),
                ),
              )
              .toList(),
          onChanged: (MaskEffectMode? value) {
            if (value != null) {
              onEffectModeChanged(value);
            }
          },
        ),
        const SizedBox(height: 12),
        Text(
          effectModeHint(l10n, customEffectMode),
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
            height: 1.4,
          ),
        ),
        if (effectModeUsesMatrixPasses(customEffectMode)) ...<Widget>[
          const SizedBox(height: 16),
          LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              final vertical = constraints.maxWidth < 560;
              final selectors = <Widget>[
                _matrixPassDropdown(
                  context,
                  label: l10n.matrixPassFirstLabel,
                  value: customFirstMatrixPass,
                  onChanged: onFirstMatrixPassChanged,
                ),
                _matrixPassDropdown(
                  context,
                  label: l10n.matrixPassSecondLabel,
                  value: customSecondMatrixPass,
                  onChanged: onSecondMatrixPassChanged,
                ),
              ];

              if (vertical) {
                return Column(
                  children: <Widget>[
                    selectors[0],
                    const SizedBox(height: 12),
                    selectors[1],
                  ],
                );
              }

              return Row(
                children: <Widget>[
                  Expanded(child: selectors[0]),
                  const SizedBox(width: 12),
                  Expanded(child: selectors[1]),
                ],
              );
            },
          ),
        ],
        if (effectModeUsesBlendMode(customEffectMode)) ...<Widget>[
          const SizedBox(height: 16),
          DropdownButtonFormField<BlendMode>(
            key: ValueKey<BlendMode>(customBlendMode),
            initialValue: customBlendMode,
            decoration: InputDecoration(
              labelText: l10n.blendModeFieldLabel,
              border: const OutlineInputBorder(),
            ),
            items: supportedBlendModes
                .map(
                  (BlendMode mode) => DropdownMenuItem<BlendMode>(
                    value: mode,
                    child: Text(blendModeLabel(l10n, mode)),
                  ),
                )
                .toList(),
            onChanged: (BlendMode? value) {
              if (value != null) {
                onBlendModeChanged(value);
              }
            },
          ),
        ],
        if (effectModeUsesColor(customEffectMode)) ...<Widget>[
          const SizedBox(height: 12),
          _slider(
            label: l10n.redChannelLabel,
            value: customRed,
            max: 255,
            color: const Color(0xFFD94841),
            onChanged: onRedChanged,
          ),
          _slider(
            label: l10n.greenChannelLabel,
            value: customGreen,
            max: 255,
            color: const Color(0xFF43AA8B),
            onChanged: onGreenChanged,
          ),
          _slider(
            label: l10n.blueChannelLabel,
            value: customBlue,
            max: 255,
            color: const Color(0xFF457B9D),
            onChanged: onBlueChanged,
          ),
        ],
        if (effectModeUsesOpacity(customEffectMode))
          _slider(
            label: l10n.maskOpacityLabel,
            value: customOpacity,
            max: effectModeMaxOpacity(customEffectMode),
            color: Theme.of(context).colorScheme.primary,
            onChanged: onOpacityChanged,
          ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: <Widget>[
            FilledButton.icon(
              onPressed: onSaveCustomScheme,
              icon: const Icon(Icons.save_outlined),
              label: Text(l10n.saveMySchemeButton),
            ),
            FilledButton.tonalIcon(
              onPressed: onStartCustomFromDefault,
              icon: const Icon(Icons.copy_all_outlined),
              label: Text(l10n.loadCurrentPresetButton),
            ),
            TextButton.icon(
              onPressed: onResetCustom,
              icon: const Icon(Icons.refresh),
              label: Text(l10n.resetCustomButton),
            ),
          ],
        ),
      ],
    );
  }

  Widget _matrixPassDropdown(
    BuildContext context, {
    required String label,
    required MaskMatrixPass value,
    required ValueChanged<MaskMatrixPass> onChanged,
  }) {
    final l10n = context.l10n;
    return DropdownButtonFormField<MaskMatrixPass>(
      key: ValueKey<String>('matrix-pass-$label-${value.name}'),
      initialValue: value,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      items: supportedMaskMatrixPasses
          .map(
            (MaskMatrixPass pass) => DropdownMenuItem<MaskMatrixPass>(
              value: pass,
              child: Text(matrixPassLabel(l10n, pass)),
            ),
          )
          .toList(),
      onChanged: (MaskMatrixPass? nextValue) {
        if (nextValue != null) {
          onChanged(nextValue);
        }
      },
    );
  }

  Widget _buildSavedSchemesSection(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final l10n = context.l10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          l10n.mySchemesTitle,
          style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
        ),
        const SizedBox(height: 10),
        if (isLoadingSavedSchemes)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: CircularProgressIndicator(),
          )
        else if (savedSchemes.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.mutedSurface(context),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(l10n.noSavedSchemesDescription),
          )
        else
          Column(
            children: savedSchemes.map((MaskScheme scheme) {
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppTheme.mutedSurface(context),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: <Widget>[
                    Container(
                      width: 18,
                      height: 18,
                      decoration: BoxDecoration(
                        gradient: schemePreviewGradient(scheme),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            scheme.name,
                            style: const TextStyle(fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            schemeSummary(l10n, scheme),
                            style: TextStyle(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      tooltip: l10n.loadSchemeTooltip,
                      onPressed: () => onLoadSavedScheme(scheme),
                      icon: const Icon(Icons.upload_outlined),
                    ),
                    IconButton(
                      tooltip: l10n.deleteSchemeTooltip,
                      onPressed: () => onDeleteSavedScheme(scheme.id),
                      icon: const Icon(Icons.delete_outline),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
      ],
    );
  }

  Widget _slider({
    required String label,
    required double value,
    required double max,
    required Color color,
    required ValueChanged<double> onChanged,
  }) {
    final text = max <= 1 ? maskOpacityLabel(value) : value.round().toString();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(label, style: const TextStyle(fontWeight: FontWeight.w700)),
            Text(text),
          ],
        ),
        SliderTheme(
          data: SliderThemeData(
            activeTrackColor: color,
            thumbColor: color,
            overlayColor: color.withValues(alpha: 0.12),
            inactiveTrackColor: color.withValues(alpha: 0.18),
          ),
          child: Slider(value: value, min: 0, max: max, onChanged: onChanged),
        ),
      ],
    );
  }

  Widget _statChip(BuildContext context, String label, String value) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: AppTheme.tintSurface(context),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            label,
            style: TextStyle(fontSize: 11, color: colorScheme.onSurfaceVariant),
          ),
          const SizedBox(height: 2),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}
