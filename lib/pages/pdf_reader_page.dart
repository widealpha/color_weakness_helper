import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/default_mask_schemes.dart';
import '../l10n/localization_extensions.dart';
import '../models/editor_mode.dart';
import '../models/mask_scheme.dart';
import '../models/pdf_book.dart';
import '../providers/pdf_reader_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/mask_editor_panel.dart';
import '../widgets/page_preview_panel.dart';

class PdfReaderPage extends StatelessWidget {
  const PdfReaderPage({super.key, required this.book});

  final PdfBook book;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<PdfReaderProvider>(
      create: (BuildContext context) => PdfReaderProvider(
        book: book,
        pdfAssetService: context.read(),
        preferencesUtils: context.read(),
      )..initialize(),
      child: _PdfReaderView(book: book),
    );
  }
}

class _PdfReaderView extends StatelessWidget {
  const _PdfReaderView({required this.book});

  final PdfBook book;

  Future<String?> _askSchemeName(BuildContext context) {
    final controller = TextEditingController();
    return showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        final l10n = context.l10n;
        return AlertDialog(
          title: Text(l10n.readerSaveSchemeDialogTitle),
          content: TextField(
            controller: controller,
            autofocus: true,
            decoration: InputDecoration(
              labelText: l10n.schemeNameLabel,
              hintText: l10n.schemeNameHint,
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(l10n.cancelButton),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(controller.text),
              child: Text(l10n.saveButton),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<PdfReaderProvider>();
    final l10n = context.l10n;
    final defaultSchemes = localizedDefaultMaskSchemes(l10n);
    final activeScheme = provider.mode == EditorMode.preset
        ? defaultSchemes[provider.selectedDefaultSchemeIndex]
        : provider.createCustomScheme(
            id: 'draft',
            name: l10n.readerCustomBlendName,
            note: l10n.readerCustomBlendNote,
          );

    return Scaffold(
      appBar: AppBar(title: Text(book.title)),
      body: Container(
        decoration: BoxDecoration(
          gradient: AppTheme.pageBackgroundGradient(context),
        ),
        child: SafeArea(
          top: false,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(28),
                    gradient: AppTheme.heroGradient(context),
                  ),
                  child: Wrap(
                    spacing: 18,
                    runSpacing: 18,
                    alignment: WrapAlignment.spaceBetween,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        width: 580,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              book.subtitle,
                              style: Theme.of(context).textTheme.headlineMedium
                                  ?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w800,
                                  ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              l10n.readerCurrentSource(book.title),
                              style: Theme.of(context).textTheme.bodyLarge
                                  ?.copyWith(
                                    color: Colors.white.withValues(alpha: 0.88),
                                    height: 1.45,
                                  ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: 260,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppTheme.heroBadgeBackground(context),
                          borderRadius: BorderRadius.circular(22),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              activeScheme.name,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Container(
                              height: 72,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(18),
                                gradient: schemePreviewGradient(activeScheme),
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              schemeSummary(l10n, activeScheme),
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.84),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                    final preview = PagePreviewPanel(
                      page: provider.renderedPage,
                      isOpeningDocument: provider.isOpeningDocument,
                      isLoading: provider.isRenderingPage,
                      mask: activeScheme,
                      currentPage: provider.currentPage,
                      pageCount: provider.pageCount,
                      errorMessage: _buildErrorMessage(context, provider),
                      onPreviousPage: provider.currentPage > 1
                          ? () => provider.showPage(provider.currentPage - 1)
                          : null,
                      onNextPage:
                          provider.pageCount > 0 &&
                              provider.currentPage < provider.pageCount
                          ? () => provider.showPage(provider.currentPage + 1)
                          : null,
                      onJumpToPage: (int pageNumber) {
                        unawaited(provider.showPage(pageNumber));
                      },
                    );

                    final controls = MaskEditorPanel(
                      mode: provider.mode,
                      defaultSchemes: defaultSchemes,
                      selectedDefaultSchemeIndex:
                          provider.selectedDefaultSchemeIndex,
                      savedSchemes: provider.savedSchemes,
                      isLoadingSavedSchemes: provider.isLoadingSavedSchemes,
                      customColor: provider.customColor,
                      customOpacity: provider.opacity,
                      customRed: provider.red,
                      customGreen: provider.green,
                      customBlue: provider.blue,
                      customEffectMode: provider.effectMode,
                      customFirstMatrixPass: provider.firstMatrixPass,
                      customSecondMatrixPass: provider.secondMatrixPass,
                      customBlendMode: provider.blendMode,
                      onModeChanged: provider.setMode,
                      onDefaultSchemeSelected: provider.selectDefaultScheme,
                      onStartCustomFromDefault: () {
                        provider.startCustomFromScheme(
                          defaultSchemes[provider.selectedDefaultSchemeIndex],
                        );
                      },
                      onEffectModeChanged: provider.setEffectMode,
                      onFirstMatrixPassChanged: provider.setFirstMatrixPass,
                      onSecondMatrixPassChanged: provider.setSecondMatrixPass,
                      onBlendModeChanged: provider.setBlendMode,
                      onRedChanged: provider.setRed,
                      onGreenChanged: provider.setGreen,
                      onBlueChanged: provider.setBlue,
                      onOpacityChanged: provider.setOpacity,
                      onResetCustom: provider.resetCustom,
                      onSaveCustomScheme: () {
                        unawaited(_saveCurrentScheme(context, provider));
                      },
                      onLoadSavedScheme: provider.loadSavedScheme,
                      onDeleteSavedScheme: (String schemeId) {
                        unawaited(
                          _deleteSavedScheme(context, provider, schemeId),
                        );
                      },
                    );

                    if (constraints.maxWidth >= 1080) {
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Expanded(flex: 5, child: preview),
                          const SizedBox(width: 20),
                          Expanded(flex: 4, child: controls),
                        ],
                      );
                    }

                    return Column(
                      children: <Widget>[
                        preview,
                        const SizedBox(height: 20),
                        controls,
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _saveCurrentScheme(
    BuildContext context,
    PdfReaderProvider provider,
  ) async {
    final name = await _askSchemeName(context);
    if (!context.mounted || name == null) {
      return;
    }

    final activeScheme = provider.createCustomScheme(
      id: 'draft',
      name: context.l10n.readerCustomBlendName,
      note: context.l10n.readerCustomBlendNote,
    );
    final trimmedName = name.trim();
    if (trimmedName.isEmpty) {
      return;
    }

    await provider.saveCurrentScheme(
      name: trimmedName,
      note: schemeSummary(context.l10n, activeScheme),
    );

    if (!context.mounted) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(context.l10n.readerSchemeSaved(trimmedName))),
    );
  }

  Future<void> _deleteSavedScheme(
    BuildContext context,
    PdfReaderProvider provider,
    String schemeId,
  ) async {
    await provider.deleteSavedScheme(schemeId);
    if (!context.mounted) {
      return;
    }

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(context.l10n.readerSchemeDeleted)));
  }

  String? _buildErrorMessage(BuildContext context, PdfReaderProvider provider) {
    final error = provider.documentError ?? provider.pageError;
    if (error == null) {
      return null;
    }

    return switch (error.type) {
      PdfReaderErrorType.openTimeout => context.l10n.readerOpenPdfTimedOut,
      PdfReaderErrorType.openFailed => context.l10n.readerOpenPdfFailed(
        error.details ?? '',
      ),
      PdfReaderErrorType.renderTimeout => context.l10n.readerRenderPageTimedOut,
      PdfReaderErrorType.renderFailed => context.l10n.readerRenderPageFailed(
        error.details ?? '',
      ),
    };
  }
}
