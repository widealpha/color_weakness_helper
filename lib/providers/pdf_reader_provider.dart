import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pdfrx/pdfrx.dart';

import '../data/default_mask_schemes.dart';
import '../models/editor_mode.dart';
import '../models/mask_scheme.dart';
import '../models/pdf_book.dart';
import '../models/rendered_pdf_page.dart';
import '../services/pdf_asset_service.dart';
import '../utils/preferences_utils.dart';

enum PdfReaderErrorType { openTimeout, openFailed, renderTimeout, renderFailed }

class PdfReaderError {
  const PdfReaderError(this.type, {this.details});

  final PdfReaderErrorType type;
  final String? details;
}

class PdfReaderProvider extends ChangeNotifier {
  PdfReaderProvider({
    required this.book,
    required this.pdfAssetService,
    required this.preferencesUtils,
  }) {
    _applyScheme(defaultMaskSchemes.first);
  }

  static const Duration _documentOpenTimeout = Duration(seconds: 15);
  static const Duration _pageRenderTimeout = Duration(seconds: 30);
  static const String storageKey = 'user_mask_schemes';

  final PdfBook book;
  final PdfAssetService pdfAssetService;
  final PreferencesUtils preferencesUtils;

  EditorMode _mode = EditorMode.preset;
  int _selectedDefaultSchemeIndex = 0;
  late MaskEffectMode _effectMode;
  late double _red;
  late double _green;
  late double _blue;
  late double _opacity;
  late BlendMode _blendMode;
  late MaskMatrixPass _firstMatrixPass;
  late MaskMatrixPass _secondMatrixPass;

  PdfDocument? _document;
  StreamSubscription<PdfDocumentEvent>? _documentEventsSubscription;
  RenderedPdfPage? _renderedPage;
  bool _isOpeningDocument = true;
  bool _isRenderingPage = false;
  PdfReaderError? _pageError;
  int _renderTicket = 0;
  int _currentPage = 1;
  int _pageCount = 0;
  PdfReaderError? _documentError;

  List<MaskScheme> _savedSchemes = <MaskScheme>[];
  bool _isLoadingSavedSchemes = true;
  bool _initialized = false;
  bool _isDisposed = false;

  EditorMode get mode => _mode;
  int get selectedDefaultSchemeIndex => _selectedDefaultSchemeIndex;
  MaskEffectMode get effectMode => _effectMode;
  double get red => _red;
  double get green => _green;
  double get blue => _blue;
  double get opacity => _opacity;
  BlendMode get blendMode => _blendMode;
  MaskMatrixPass get firstMatrixPass => _firstMatrixPass;
  MaskMatrixPass get secondMatrixPass => _secondMatrixPass;
  RenderedPdfPage? get renderedPage => _renderedPage;
  bool get isOpeningDocument => _isOpeningDocument;
  bool get isRenderingPage => _isRenderingPage;
  PdfReaderError? get pageError => _pageError;
  int get currentPage => _currentPage;
  int get pageCount => _pageCount;
  PdfReaderError? get documentError => _documentError;
  List<MaskScheme> get savedSchemes =>
      List<MaskScheme>.unmodifiable(_savedSchemes);
  bool get isLoadingSavedSchemes => _isLoadingSavedSchemes;

  Future<void> initialize() async {
    if (_initialized) {
      return;
    }

    _initialized = true;
    unawaited(loadSavedSchemes());
    unawaited(_openDocument());
  }

  Color get customColor =>
      Color.fromRGBO(_red.round(), _green.round(), _blue.round(), 1);

  MaskScheme createCustomScheme({
    required String id,
    required String name,
    required String note,
  }) {
    return MaskScheme(
      id: id,
      name: name,
      note: note,
      color: customColor,
      opacity: _opacity,
      blendMode: _blendMode,
      effectMode: _effectMode,
      firstMatrixPass: _firstMatrixPass,
      secondMatrixPass: _secondMatrixPass,
    );
  }

  Future<void> saveCurrentScheme({
    required String name,
    required String note,
  }) async {
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

    final scheme = createCustomScheme(
      id: existingId ?? DateTime.now().millisecondsSinceEpoch.toString(),
      name: trimmedName,
      note: note,
    );

    final schemes = await _readStoredSchemes();
    final normalizedName = trimmedName.toLowerCase();
    final existingIndex = schemes.indexWhere((MaskScheme item) {
      return item.id == scheme.id ||
          item.name.trim().toLowerCase() == normalizedName;
    });

    if (existingIndex >= 0) {
      schemes[existingIndex] = scheme.copyWith(isBuiltIn: false);
    } else {
      schemes.add(scheme.copyWith(isBuiltIn: false));
    }

    await _persistSchemes(schemes);
    await loadSavedSchemes();
  }

  Future<void> deleteSavedScheme(String schemeId) async {
    final schemes = await _readStoredSchemes();
    schemes.removeWhere((MaskScheme item) => item.id == schemeId);

    if (schemes.isEmpty) {
      await preferencesUtils.remove(storageKey);
    } else {
      await _persistSchemes(schemes);
    }

    await loadSavedSchemes();
  }

  void setMode(EditorMode mode) {
    if (_mode == mode) {
      return;
    }

    _mode = mode;
    notifyListeners();
  }

  void selectDefaultScheme(int index) {
    if (_selectedDefaultSchemeIndex == index) {
      return;
    }

    _selectedDefaultSchemeIndex = index;
    notifyListeners();
  }

  void startCustomFromScheme(MaskScheme scheme) {
    _applyScheme(scheme);
    _mode = EditorMode.custom;
    notifyListeners();
  }

  void loadSavedScheme(MaskScheme scheme) {
    _applyScheme(scheme);
    _mode = EditorMode.custom;
    notifyListeners();
  }

  void resetCustom() {
    _applyScheme(defaultMaskSchemes.first);
    notifyListeners();
  }

  void setEffectMode(MaskEffectMode value) {
    if (_effectMode == value) {
      return;
    }

    _effectMode = value;
    _opacity = _opacity.clamp(0.0, effectModeMaxOpacity(value)).toDouble();
    if (effectModeUsesMatrixPasses(value)) {
      _firstMatrixPass = defaultFirstMatrixPass(value);
      _secondMatrixPass = defaultSecondMatrixPass(value);
    }
    notifyListeners();
  }

  void setFirstMatrixPass(MaskMatrixPass value) {
    if (_firstMatrixPass == value) {
      return;
    }

    _firstMatrixPass = value;
    notifyListeners();
  }

  void setSecondMatrixPass(MaskMatrixPass value) {
    if (_secondMatrixPass == value) {
      return;
    }

    _secondMatrixPass = value;
    notifyListeners();
  }

  void setBlendMode(BlendMode value) {
    if (_blendMode == value) {
      return;
    }

    _blendMode = value;
    notifyListeners();
  }

  void setRed(double value) {
    if (_red == value) {
      return;
    }

    _red = value;
    notifyListeners();
  }

  void setGreen(double value) {
    if (_green == value) {
      return;
    }

    _green = value;
    notifyListeners();
  }

  void setBlue(double value) {
    if (_blue == value) {
      return;
    }

    _blue = value;
    notifyListeners();
  }

  void setOpacity(double value) {
    final nextOpacity = value
        .clamp(0.0, effectModeMaxOpacity(_effectMode))
        .toDouble();
    if (_opacity == nextOpacity) {
      return;
    }

    _opacity = nextOpacity;
    notifyListeners();
  }

  Future<void> showPage(int pageNumber) async {
    if (_document == null || pageNumber < 1 || pageNumber > _pageCount) {
      return;
    }

    await _renderPage(pageNumber);
  }

  Future<void> loadSavedSchemes() async {
    try {
      final schemes = await _readStoredSchemes();
      if (_isDisposed) {
        return;
      }

      _savedSchemes = schemes;
      _isLoadingSavedSchemes = false;
      notifyListeners();
    } catch (_) {
      if (_isDisposed) {
        return;
      }

      _savedSchemes = <MaskScheme>[];
      _isLoadingSavedSchemes = false;
      notifyListeners();
    }
  }

  Future<List<MaskScheme>> _readStoredSchemes() async {
    final rawJson = await preferencesUtils.getString(storageKey);
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

  Future<void> _persistSchemes(List<MaskScheme> schemes) {
    final encoded = jsonEncode(
      schemes.map((MaskScheme scheme) => scheme.toJson()).toList(),
    );
    return preferencesUtils.setString(storageKey, encoded);
  }

  Future<void> _openDocument() async {
    try {
      _isOpeningDocument = true;
      _documentError = null;
      _pageError = null;
      _pageCount = 0;
      notifyListeners();

      final document = await pdfAssetService
          .openDocument(book.assetPath)
          .timeout(_documentOpenTimeout);
      if (_isDisposed) {
        await pdfAssetService.closeDocument(document);
        return;
      }

      await _documentEventsSubscription?.cancel();
      _documentEventsSubscription = document.events.listen((_) {
        if (_isDisposed) {
          return;
        }

        final nextPageCount = document.pages.length;
        if (nextPageCount != _pageCount) {
          _pageCount = nextPageCount;
          notifyListeners();
        }
      });

      _document = document;
      _pageCount = document.pages.length;
      if (_pageCount == 0) {
        throw StateError('PDF document has no readable pages.');
      }

      _currentPage = 1;
      _documentError = null;
      _isOpeningDocument = false;
      notifyListeners();

      await _renderPage(_currentPage);
    } on TimeoutException {
      if (_isDisposed) {
        return;
      }

      _isOpeningDocument = false;
      _documentError = const PdfReaderError(PdfReaderErrorType.openTimeout);
      notifyListeners();
    } catch (error) {
      if (_isDisposed) {
        return;
      }

      _isOpeningDocument = false;
      _documentError = PdfReaderError(
        PdfReaderErrorType.openFailed,
        details: error.toString(),
      );
      notifyListeners();
    }
  }

  Future<void> _renderPage(int pageNumber) async {
    final document = _document;
    if (document == null) {
      return;
    }

    final ticket = ++_renderTicket;
    _disposeRenderedPage();
    _currentPage = pageNumber;
    _isRenderingPage = true;
    _pageError = null;
    _renderedPage = null;
    notifyListeners();

    try {
      final page = await pdfAssetService
          .renderPage(document: document, pageNumber: pageNumber)
          .timeout(_pageRenderTimeout);

      // Drop stale render results when users switch pages quickly.
      if (_isDisposed || ticket != _renderTicket) {
        page.dispose();
        return;
      }

      _renderedPage = page;
      _isRenderingPage = false;
      notifyListeners();
    } on TimeoutException {
      if (_isDisposed || ticket != _renderTicket) {
        return;
      }

      _isRenderingPage = false;
      _pageError = const PdfReaderError(PdfReaderErrorType.renderTimeout);
      notifyListeners();
    } catch (error) {
      if (_isDisposed || ticket != _renderTicket) {
        return;
      }

      _isRenderingPage = false;
      _pageError = PdfReaderError(
        PdfReaderErrorType.renderFailed,
        details: error.toString(),
      );
      notifyListeners();
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
    _firstMatrixPass = scheme.firstMatrixPass;
    _secondMatrixPass = scheme.secondMatrixPass;
  }

  @override
  void dispose() {
    _isDisposed = true;
    unawaited(_documentEventsSubscription?.cancel());
    _documentEventsSubscription = null;
    _disposeRenderedPage();
    final document = _document;
    _document = null;
    if (document != null) {
      unawaited(pdfAssetService.closeDocument(document));
    }
    super.dispose();
  }
}
