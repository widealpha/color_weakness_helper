import 'dart:async';

import 'package:flutter/material.dart';

import '../l10n/localization_extensions.dart';
import '../models/mask_scheme.dart';
import '../models/rendered_pdf_page.dart';
import '../theme/app_theme.dart';
import 'app_panel.dart';

class PagePreviewPanel extends StatelessWidget {
  const PagePreviewPanel({
    super.key,
    required this.page,
    required this.isOpeningDocument,
    required this.isLoading,
    required this.mask,
    required this.currentPage,
    required this.pageCount,
    required this.onPreviousPage,
    required this.onNextPage,
    required this.onJumpToPage,
    this.onRetryOpenDocument,
    this.errorMessage,
  });

  final RenderedPdfPage? page;
  final bool isOpeningDocument;
  final bool isLoading;
  final MaskScheme mask;
  final int currentPage;
  final int pageCount;
  final VoidCallback? onPreviousPage;
  final VoidCallback? onNextPage;
  final ValueChanged<int> onJumpToPage;
  final VoidCallback? onRetryOpenDocument;
  final String? errorMessage;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return AppPanel(
      title: l10n.pagePreviewTitle,
      subtitle: l10n.pagePreviewSubtitle,
      trailing: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: AppTheme.tintSurface(context),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Text(
          errorMessage != null
              ? l10n.pageCounterUnavailable
              : pageCount == 0
              ? l10n.pageCounterPreparing
              : '$currentPage / $pageCount',
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              final compact = constraints.maxWidth < 360;
              if (compact) {
                return Row(
                  children: <Widget>[
                    Expanded(
                      child: IconButton.filledTonal(
                        tooltip: l10n.previousPageButton,
                        onPressed: onPreviousPage,
                        icon: const Icon(Icons.chevron_left),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: IconButton.filledTonal(
                        tooltip: l10n.nextPageButton,
                        onPressed: onNextPage,
                        icon: const Icon(Icons.chevron_right),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: IconButton.filledTonal(
                        tooltip: l10n.jumpToPageButton,
                        onPressed: pageCount > 0
                            ? () => _showJumpDialog(context)
                            : null,
                        icon: const Icon(Icons.pin_outlined),
                      ),
                    ),
                  ],
                );
              }

              return Wrap(
                spacing: 12,
                runSpacing: 12,
                children: <Widget>[
                  FilledButton.tonalIcon(
                    onPressed: onPreviousPage,
                    icon: const Icon(Icons.chevron_left),
                    label: Text(l10n.previousPageButton),
                  ),
                  FilledButton.tonalIcon(
                    onPressed: onNextPage,
                    icon: const Icon(Icons.chevron_right),
                    label: Text(l10n.nextPageButton),
                  ),
                  FilledButton.tonalIcon(
                    onPressed: pageCount > 0
                        ? () => _showJumpDialog(context)
                        : null,
                    icon: const Icon(Icons.pin_outlined),
                    label: Text(l10n.jumpToPageButton),
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 16),
          if (errorMessage != null)
            _messageCard(
              context,
              errorMessage!,
              action: onRetryOpenDocument == null
                  ? null
                  : FilledButton.tonalIcon(
                      onPressed: onRetryOpenDocument,
                      icon: const Icon(Icons.refresh),
                      label: Text(l10n.retryOpenPdfButton),
                    ),
            )
          else if (isOpeningDocument || isLoading)
            const AspectRatio(
              aspectRatio: 4 / 3,
              child: Center(child: CircularProgressIndicator()),
            )
          else if (page == null)
            _messageCard(context, l10n.currentPageUnavailable)
          else
            LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                final vertical = constraints.maxWidth < 760;
                final original = _pageCard(
                  context,
                  l10n.originalPageLabel,
                  page!,
                  null,
                );
                final masked = _pageCard(
                  context,
                  l10n.assistedPreviewLabel,
                  page!,
                  mask,
                );

                if (vertical) {
                  return Column(
                    children: <Widget>[
                      original,
                      const SizedBox(height: 16),
                      masked,
                    ],
                  );
                }

                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(child: original),
                    const SizedBox(width: 16),
                    Expanded(child: masked),
                  ],
                );
              },
            ),
        ],
      ),
    );
  }

  Widget _pageCard(
    BuildContext context,
    String title,
    RenderedPdfPage page,
    MaskScheme? mask,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
        const SizedBox(height: 10),
        ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: Material(
            color: Colors.white,
            child: InkWell(
              onTap: () => _showPreviewDialog(context, title, page, mask),
              child: AspectRatio(
                aspectRatio: page.width / page.height,
                child: LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                    final showBadgeLabel = constraints.maxWidth >= 210;
                    return Container(
                      color: Colors.white,
                      padding: const EdgeInsets.all(10),
                      child: Stack(
                        children: <Widget>[
                          Positioned.fill(
                            child: _buildEffectPreview(page, mask),
                          ),
                          Positioned(
                            top: 10,
                            right: 10,
                            child: _PreviewZoomBadge(
                              label: context.l10n.viewLargeImage,
                              showLabel: showBadgeLabel,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _showJumpDialog(BuildContext context) async {
    final controller = TextEditingController(text: currentPage.toString());
    final result = await showDialog<int>(
      context: context,
      builder: (BuildContext context) {
        final l10n = context.l10n;
        return AlertDialog(
          title: Text(l10n.jumpToPageDialogTitle),
          content: TextField(
            controller: controller,
            autofocus: true,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: l10n.pageNumberLabel,
              hintText: l10n.pageNumberHint(pageCount),
            ),
            onSubmitted: (String value) {
              final page = int.tryParse(value.trim());
              if (page != null) {
                Navigator.of(context).pop(page);
              }
            },
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(l10n.cancelButton),
            ),
            FilledButton(
              onPressed: () {
                final page = int.tryParse(controller.text.trim());
                Navigator.of(context).pop(page);
              },
              child: Text(l10n.jumpButton),
            ),
          ],
        );
      },
    );

    if (!context.mounted || result == null) {
      return;
    }

    if (result < 1 || result > pageCount) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.invalidPageNumber(pageCount))),
      );
      return;
    }

    onJumpToPage(result);
  }

  Future<void> _showPreviewDialog(
    BuildContext context,
    String title,
    RenderedPdfPage page,
    MaskScheme? mask,
  ) {
    return showDialog<void>(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.82),
      builder: (BuildContext context) {
        final l10n = context.l10n;
        return Dialog(
          backgroundColor: AppTheme.previewDialogBackground(context),
          insetPadding: const EdgeInsets.all(24),
          child: SizedBox(
            width: 1100,
            height: 760,
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(18, 14, 10, 10),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          l10n.previewDialogTitle(title, page.pageNumber),
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      IconButton(
                        tooltip: l10n.closeTooltip,
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.close, color: Colors.white),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1, color: Color(0x33FFFFFF)),
                Expanded(
                  child: InteractiveViewer(
                    minScale: 0.7,
                    maxScale: 6,
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(18),
                        child: _buildEffectPreview(page, mask),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _messageCard(BuildContext context, String message, {Widget? action}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppTheme.errorSurface(context),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(message),
          if (action != null) ...<Widget>[const SizedBox(height: 12), action],
        ],
      ),
    );
  }

  Widget _buildEffectPreview(RenderedPdfPage page, MaskScheme? mask) {
    if (mask == null) {
      return _buildPageImage(page);
    }

    return switch (mask.effectMode) {
      MaskEffectMode.blend =>
        mask.opacity <= 0
            ? _buildPageImage(page)
            : ColorFiltered(
                colorFilter: ColorFilter.mode(
                  mask.color.withValues(alpha: mask.opacity),
                  mask.blendMode,
                ),
                child: _buildPageImage(page),
              ),
      MaskEffectMode.replace =>
        mask.opacity <= 0
            ? _buildPageImage(page)
            : Stack(
                fit: StackFit.expand,
                children: <Widget>[
                  _buildPageImage(page),
                  Opacity(
                    opacity: mask.opacity,
                    child: ColorFiltered(
                      colorFilter: ColorFilter.matrix(
                        replacementColorMatrix(mask.color),
                      ),
                      child: _buildPageImage(page),
                    ),
                  ),
                ],
              ),
      MaskEffectMode.deutanCompensation => _buildMatrixEffectPreview(
        page,
        const ColorFilter.matrix(deutanCompensationColorMatrix),
        mask.opacity,
      ),
      MaskEffectMode.protanCompensation => _buildMatrixEffectPreview(
        page,
        const ColorFilter.matrix(protanCompensationColorMatrix),
        mask.opacity,
      ),
      MaskEffectMode.redGreenPulse => _AlternatingMatrixPairPreview(
        page: page,
        strength: mask.opacity,
        firstFilter: matrixPassColorFilter(mask.firstMatrixPass),
        secondFilter: matrixPassColorFilter(mask.secondMatrixPass),
        switchInterval: const Duration(milliseconds: 400),
        imageBuilder: _buildPageImage,
      ),
      MaskEffectMode.redGreenReversePulse => _CombinedMatrixPairPreview(
        page: page,
        strength: mask.opacity,
        firstFilter: matrixPassColorFilter(mask.firstMatrixPass),
        secondFilter: matrixPassColorFilter(mask.secondMatrixPass),
        imageBuilder: _buildPageImage,
      ),
      MaskEffectMode.tritanCompensation => _buildMatrixEffectPreview(
        page,
        const ColorFilter.matrix(tritanCompensationColorMatrix),
        mask.opacity,
      ),
      MaskEffectMode.highContrast => _buildMatrixEffectPreview(
        page,
        const ColorFilter.matrix(highContrastMonochromeColorMatrix),
        mask.opacity,
      ),
      MaskEffectMode.invert => ColorFiltered(
        colorFilter: const ColorFilter.matrix(invertColorMatrix),
        child: _buildPageImage(page),
      ),
    };
  }

  Widget _buildMatrixEffectPreview(
    RenderedPdfPage page,
    ColorFilter colorFilter,
    double strength,
  ) {
    if (strength <= 0) {
      return _buildPageImage(page);
    }

    if (strength >= 1) {
      return ColorFiltered(
        colorFilter: colorFilter,
        child: _buildPageImage(page),
      );
    }

    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        _buildPageImage(page),
        Opacity(
          opacity: strength,
          child: ColorFiltered(
            colorFilter: colorFilter,
            child: _buildPageImage(page),
          ),
        ),
      ],
    );
  }

  Widget _buildPageImage(RenderedPdfPage page) {
    return RawImage(
      image: page.image,
      fit: BoxFit.contain,
      filterQuality: FilterQuality.high,
    );
  }
}

class _PreviewZoomBadge extends StatelessWidget {
  const _PreviewZoomBadge({required this.label, required this.showLabel});

  final String label;
  final bool showLabel;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: label,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: showLabel ? 10 : 8,
          vertical: 6,
        ),
        decoration: BoxDecoration(
          color: AppTheme.previewBadgeBackground(context),
          borderRadius: BorderRadius.circular(99),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Icon(Icons.zoom_out_map, size: 16, color: Colors.white),
            if (showLabel) ...<Widget>[
              const SizedBox(width: 6),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _CombinedMatrixPairPreview extends StatelessWidget {
  const _CombinedMatrixPairPreview({
    required this.page,
    required this.strength,
    required this.firstFilter,
    required this.secondFilter,
    required this.imageBuilder,
  });

  final RenderedPdfPage page;
  final double strength;
  final ColorFilter firstFilter;
  final ColorFilter secondFilter;
  final Widget Function(RenderedPdfPage page) imageBuilder;

  @override
  Widget build(BuildContext context) {
    if (strength <= 0) {
      return imageBuilder(page);
    }

    final layerOpacity = (strength * 0.62).clamp(0.0, 1.0).toDouble();
    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        imageBuilder(page),
        Opacity(
          opacity: layerOpacity,
          child: ColorFiltered(
            colorFilter: firstFilter,
            child: imageBuilder(page),
          ),
        ),
        Opacity(
          opacity: layerOpacity,
          child: ColorFiltered(
            colorFilter: secondFilter,
            child: imageBuilder(page),
          ),
        ),
      ],
    );
  }
}

class _AlternatingMatrixPairPreview extends StatefulWidget {
  const _AlternatingMatrixPairPreview({
    required this.page,
    required this.strength,
    required this.firstFilter,
    required this.secondFilter,
    required this.switchInterval,
    required this.imageBuilder,
  });

  final RenderedPdfPage page;
  final double strength;
  final ColorFilter firstFilter;
  final ColorFilter secondFilter;
  final Duration switchInterval;
  final Widget Function(RenderedPdfPage page) imageBuilder;

  @override
  State<_AlternatingMatrixPairPreview> createState() =>
      _AlternatingMatrixPairPreviewState();
}

class _AlternatingMatrixPairPreviewState
    extends State<_AlternatingMatrixPairPreview> {
  Timer? _timer;
  bool _showSecondPass = false;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void didUpdateWidget(_AlternatingMatrixPairPreview oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.strength <= 0) {
      _timer?.cancel();
      _timer = null;
      return;
    }

    if (oldWidget.switchInterval != widget.switchInterval) {
      _timer?.cancel();
      _timer = null;
    }

    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.strength <= 0) {
      return widget.imageBuilder(widget.page);
    }

    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        widget.imageBuilder(widget.page),
        Opacity(
          opacity: widget.strength,
          child: ColorFiltered(
            colorFilter: _showSecondPass
                ? widget.secondFilter
                : widget.firstFilter,
            child: widget.imageBuilder(widget.page),
          ),
        ),
      ],
    );
  }

  void _startTimer() {
    if (widget.strength <= 0 || _timer != null) {
      return;
    }

    _timer = Timer.periodic(widget.switchInterval, (_) {
      if (!mounted) {
        return;
      }

      setState(() {
        _showSecondPass = !_showSecondPass;
      });
    });
  }
}
