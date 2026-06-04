import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pdfrx/pdfrx.dart';

import '../data/default_mask_schemes.dart';
import '../l10n/localization_extensions.dart';
import '../models/editor_mode.dart';
import '../models/mask_scheme.dart';
import '../models/pdf_book.dart';
import '../models/rendered_pdf_page.dart';
import '../services/mask_scheme_storage.dart';
import '../services/pdf_asset_service.dart';
import '../theme/app_theme.dart';
import '../widgets/mask_editor_panel.dart';
import '../widgets/page_preview_panel.dart';

class PdfReaderPage extends StatefulWidget {
  const PdfReaderPage({
    super.key,
    required this.book,
    required this.pdfAssetService,
    required this.maskSchemeStorage,
  });

  final PdfBook book;
  final PdfAssetService pdfAssetService;
  final MaskSchemeStorage maskSchemeStorage;

  @override
  State<PdfReaderPage> createState() => _PdfReaderPageState();
}

class _PdfReaderPageState extends State<PdfReaderPage> {
  static const Duration _documentOpenTimeout = Duration(seconds: 15);

  EditorMode _mode = EditorMode.preset;
  int _selectedDefaultSchemeIndex = 0;
  late MaskEffectMode _effectMode;
  late double _red;
  late double _green;
  late double _blue;
  late double _opacity;
  late BlendMode _blendMode;

  PdfDocument? _document;
  StreamSubscription<PdfDocumentEvent>? _documentEventsSubscription;
  RenderedPdfPage? _renderedPage;
  bool _isOpeningDocument = true;
  bool _isRenderingPage = false;
  String? _pageError;
  int _renderTicket = 0;
  int _currentPage = 1;
  int _pageCount = 0;
  String? _documentError;

  List<MaskScheme> _savedSchemes = <MaskScheme>[];
  bool _isLoadingSavedSchemes = true;

  @override
  void initState() {
    super.initState();
    _applyScheme(defaultMaskSchemes.first);
    unawaited(_loadSavedSchemes());
    unawaited(_openDocument());
  }

  @override
  void dispose() {
    unawaited(_documentEventsSubscription?.cancel());
    _documentEventsSubscription = null;
    _disposeRenderedPage();
    final document = _document;
    _document = null;
    if (document != null) {
      unawaited(widget.pdfAssetService.closeDocument(document));
    }
    super.dispose();
  }

  MaskScheme get _selectedDefaultScheme =>
      localizedDefaultMaskSchemes(context.l10n)[_selectedDefaultSchemeIndex];

  Color get _customColor =>
      Color.fromRGBO(_red.round(), _green.round(), _blue.round(), 1);

  MaskScheme get _activeScheme => _mode == EditorMode.preset
      ? _selectedDefaultScheme
      : MaskScheme(
          id: 'draft',
          name: context.l10n.readerCustomBlendName,
          note: context.l10n.readerCustomBlendNote,
          color: _customColor,
          opacity: _opacity,
          blendMode: _blendMode,
          effectMode: _effectMode,
        );

  Future<void> _loadSavedSchemes() async {
    final schemes = await widget.maskSchemeStorage.loadSchemes();
    if (!mounted) {
      return;
    }

    setState(() {
      _savedSchemes = schemes;
      _isLoadingSavedSchemes = false;
    });
  }

  Future<void> _openDocument() async {
    try {
      if (mounted) {
        setState(() {
          _isOpeningDocument = true;
          _documentError = null;
          _pageError = null;
          _pageCount = 0;
        });
      }

      final document = await widget.pdfAssetService.openDocument(
        widget.book.assetPath,
      ).timeout(_documentOpenTimeout);
      if (!mounted) {
        await widget.pdfAssetService.closeDocument(document);
        return;
      }

      await _documentEventsSubscription?.cancel();
      _documentEventsSubscription = document.events.listen((_) {
        if (!mounted) {
          return;
        }

        final nextPageCount = document.pages.length;
        if (nextPageCount != _pageCount) {
          setState(() {
            _pageCount = nextPageCount;
          });
        }
      });

      setState(() {
        _document = document;
        _pageCount = document.pages.length;
        _currentPage = 1;
        _documentError = null;
        _isOpeningDocument = false;
      });
      unawaited(
        document.loadPagesProgressively<void>(
          onPageLoadProgress: (int loadedPageCount, int totalPageCount, void _) {
            if (!mounted) {
              return false;
            }

            final nextPageCount = totalPageCount;
            if (nextPageCount != _pageCount) {
              setState(() {
                _pageCount = nextPageCount;
              });
            }
            return true;
          },
        ),
      );
      await _renderPage(_currentPage);
    } on TimeoutException {
      if (!mounted) {
        return;
      }

      setState(() {
        _isOpeningDocument = false;
        _documentError = context.l10n.readerOpenPdfTimedOut;
      });
    } catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        _isOpeningDocument = false;
        _documentError = context.l10n.readerOpenPdfFailed(error.toString());
      });
    }
  }

  Future<void> _showPage(int pageNumber) async {
    if (_document == null || pageNumber < 1 || pageNumber > _pageCount) {
      return;
    }

    await _renderPage(pageNumber);
  }

  Future<void> _renderPage(int pageNumber) async {
    final document = _document;
    if (document == null) {
      return;
    }

    final ticket = ++_renderTicket;
    _disposeRenderedPage();
    setState(() {
      _currentPage = pageNumber;
      _isRenderingPage = true;
      _pageError = null;
      _renderedPage = null;
    });

    try {
      final page = await widget.pdfAssetService.renderPage(
        document: document,
        pageNumber: pageNumber,
      );

      if (!mounted || ticket != _renderTicket) {
        page.dispose();
        return;
      }

      setState(() {
        _renderedPage = page;
        _isRenderingPage = false;
      });
    } on TimeoutException {
      if (!mounted || ticket != _renderTicket) {
        return;
      }

      setState(() {
        _isRenderingPage = false;
        _pageError = context.l10n.readerRenderPageTimedOut;
      });
    } catch (error) {
      if (!mounted || ticket != _renderTicket) {
        return;
      }

      setState(() {
        _isRenderingPage = false;
        _pageError = context.l10n.readerRenderPageFailed(error.toString());
      });
    }
  }

  void _disposeRenderedPage() {
    final page = _renderedPage;
    _renderedPage = null;
    page?.dispose();
  }

  void _applyScheme(MaskScheme scheme) {
    _effectMode = scheme.effectMode;
    _red = colorChannelToInt(scheme.color.r).toDouble();
    _green = colorChannelToInt(scheme.color.g).toDouble();
    _blue = colorChannelToInt(scheme.color.b).toDouble();
    _opacity = scheme.opacity;
    _blendMode = scheme.blendMode;
  }

  void _startCustomFromDefault() {
    setState(() {
      _applyScheme(_selectedDefaultScheme);
      _mode = EditorMode.custom;
    });
  }

  void _resetCustom() {
    setState(() {
      _applyScheme(defaultMaskSchemes.first);
    });
  }

  Future<void> _saveCurrentScheme() async {
    final name = await _askSchemeName();
    if (!mounted || name == null) {
      return;
    }

    final trimmedName = name.trim();
    if (trimmedName.isEmpty) {
      return;
    }

    String? existingId;
    for (final scheme in _savedSchemes) {
      if (scheme.name.trim().toLowerCase() == trimmedName.toLowerCase()) {
        existingId = scheme.id;
        break;
      }
    }

    final scheme = MaskScheme(
      id: existingId ?? DateTime.now().millisecondsSinceEpoch.toString(),
      name: trimmedName,
      note: schemeSummary(context.l10n, _activeScheme),
      color: _customColor,
      opacity: _opacity,
      blendMode: _blendMode,
      effectMode: _effectMode,
    );

    await widget.maskSchemeStorage.saveScheme(scheme);
    await _loadSavedSchemes();

    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(
      SnackBar(content: Text(context.l10n.readerSchemeSaved(trimmedName))),
    );
  }

  Future<void> _deleteSavedScheme(String schemeId) async {
    await widget.maskSchemeStorage.deleteScheme(schemeId);
    await _loadSavedSchemes();

    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(context.l10n.readerSchemeDeleted)));
  }

  Future<String?> _askSchemeName() {
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
    final activeScheme = _activeScheme;
    final l10n = context.l10n;
    final defaultSchemes = localizedDefaultMaskSchemes(l10n);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.book.title),
      ),
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
                              widget.book.subtitle,
                              style: Theme.of(context).textTheme.headlineMedium
                                  ?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w800,
                                  ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              l10n.readerCurrentSource(widget.book.title),
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
                      page: _renderedPage,
                      isOpeningDocument: _isOpeningDocument,
                      isLoading: _isRenderingPage,
                      mask: activeScheme,
                      currentPage: _currentPage,
                      pageCount: _pageCount,
                      errorMessage: _documentError ?? _pageError,
                      onPreviousPage: _currentPage > 1
                          ? () => _showPage(_currentPage - 1)
                          : null,
                      onNextPage: _pageCount > 0 && _currentPage < _pageCount
                          ? () => _showPage(_currentPage + 1)
                          : null,
                      onJumpToPage: (int pageNumber) {
                        unawaited(_showPage(pageNumber));
                      },
                    );

                    final controls = MaskEditorPanel(
                      mode: _mode,
                      defaultSchemes: defaultSchemes,
                      selectedDefaultSchemeIndex: _selectedDefaultSchemeIndex,
                      savedSchemes: _savedSchemes,
                      isLoadingSavedSchemes: _isLoadingSavedSchemes,
                      customColor: _customColor,
                      customOpacity: _opacity,
                      customRed: _red,
                      customGreen: _green,
                      customBlue: _blue,
                      customEffectMode: _effectMode,
                      customBlendMode: _blendMode,
                      onModeChanged: (EditorMode mode) {
                        setState(() {
                          _mode = mode;
                        });
                      },
                      onDefaultSchemeSelected: (int index) {
                        setState(() {
                          _selectedDefaultSchemeIndex = index;
                        });
                      },
                      onStartCustomFromDefault: _startCustomFromDefault,
                      onEffectModeChanged: (MaskEffectMode value) {
                        setState(() {
                          _effectMode = value;
                        });
                      },
                      onBlendModeChanged: (BlendMode value) {
                        setState(() {
                          _blendMode = value;
                        });
                      },
                      onRedChanged: (double value) {
                        setState(() {
                          _red = value;
                        });
                      },
                      onGreenChanged: (double value) {
                        setState(() {
                          _green = value;
                        });
                      },
                      onBlueChanged: (double value) {
                        setState(() {
                          _blue = value;
                        });
                      },
                      onOpacityChanged: (double value) {
                        setState(() {
                          _opacity = value;
                        });
                      },
                      onResetCustom: _resetCustom,
                      onSaveCustomScheme: _saveCurrentScheme,
                      onLoadSavedScheme: (MaskScheme scheme) {
                        setState(() {
                          _applyScheme(scheme);
                          _mode = EditorMode.custom;
                        });
                      },
                      onDeleteSavedScheme: _deleteSavedScheme,
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
}
