import 'dart:async';

import 'package:flutter/services.dart';
import 'package:pdfrx/pdfrx.dart';

import '../models/rendered_pdf_page.dart';

class PdfAssetService {
  const PdfAssetService();

  static const Duration _documentOperationTimeout = Duration(seconds: 15);
  static const Duration _documentCloseTimeout = Duration(seconds: 3);
  static const Duration _engineInitializeTimeout = Duration(seconds: 8);

  static Future<void> _documentOperations = Future<void>.value();
  static Future<void>? _initializeOperation;
  static bool _isEngineInitialized = false;
  static int _documentOperationTicket = 0;

  Future<bool> assetExists(String assetPath) async {
    try {
      await rootBundle.load(assetPath);
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<PdfDocument> openDocument(
    String assetPath, {
    Duration timeout = _documentOperationTimeout,
  }) => _runDocumentOp(
    () async {
      await initializeEngine();
      final data = await rootBundle.load(assetPath);
      return PdfDocument.openData(
        data.buffer.asUint8List(),
        sourceName: 'asset:$assetPath',
        useProgressiveLoading: false,
      );
    },
    timeout: timeout,
    onTimeout: _recoverTimedOutEngine,
  );

  Future<void> closeDocument(PdfDocument document) =>
      _runDocumentOp(() => document.dispose(), timeout: _documentCloseTimeout);

  Future<void> initializeEngine() {
    final existing = _initializeOperation;
    if (existing != null) {
      return existing;
    }

    final operation = pdfrxFlutterInitialize()
        .timeout(
          _engineInitializeTimeout,
          onTimeout: () {
            throw TimeoutException(
              'Timed out while initializing the PDF engine.',
              _engineInitializeTimeout,
            );
          },
        )
        .then((_) {
          _isEngineInitialized = true;
        });
    _initializeOperation = operation;
    operation.catchError((Object _) {
      if (identical(_initializeOperation, operation)) {
        _initializeOperation = null;
      }
    });
    return operation;
  }

  Future<void> stopEngineWorker({bool force = false}) async {
    if (!_isEngineInitialized && !force) {
      return;
    }

    try {
      await PdfrxEntryFunctions.instance.stopBackgroundWorker().timeout(
        const Duration(seconds: 2),
      );
      _initializeOperation = null;
      _isEngineInitialized = false;
    } catch (_) {
      // Best-effort cleanup only; app shutdown must not be blocked by PDFium.
    }
  }

  Future<void> _recoverTimedOutEngine() async {
    _initializeOperation = null;
    await stopEngineWorker(force: true);
  }

  Future<RenderedPdfPage> renderPage({
    required PdfDocument document,
    required int pageNumber,
    double scale = 2.2,
    double maxTextureSide = 2400,
    int backgroundColor = 0xFFFDFBF7,
    Duration pageLoadTimeout = const Duration(seconds: 12),
    Duration renderTimeout = const Duration(seconds: 20),
  }) async {
    if (pageNumber < 1 || pageNumber > document.pages.length) {
      throw RangeError.range(
        pageNumber,
        1,
        document.pages.length,
        'pageNumber',
      );
    }

    final page = document.pages[pageNumber - 1];
    final loadedPage = page.isLoaded
        ? page
        : await page.waitForLoaded(timeout: pageLoadTimeout);
    if (loadedPage == null) {
      throw TimeoutException('Timed out while loading PDF page $pageNumber.');
    }

    final targetScale = resolveRenderScale(
      width: loadedPage.width,
      height: loadedPage.height,
      preferredScale: scale,
      maxTextureSide: maxTextureSide,
    );
    final targetWidth = loadedPage.width * targetScale;
    final targetHeight = loadedPage.height * targetScale;
    final rendered = await loadedPage
        .render(
          fullWidth: targetWidth,
          fullHeight: targetHeight,
          backgroundColor: backgroundColor,
        )
        .timeout(renderTimeout);
    if (rendered == null) {
      throw StateError('Failed to render PDF page $pageNumber.');
    }

    try {
      final image = await rendered.createImage().timeout(renderTimeout);

      return RenderedPdfPage(
        pageNumber: pageNumber,
        width: targetWidth,
        height: targetHeight,
        image: image,
      );
    } finally {
      rendered.dispose();
    }
  }

  Future<T> _runDocumentOp<T>(
    Future<T> Function() action, {
    required Duration timeout,
    FutureOr<void> Function()? onTimeout,
  }) {
    final ticket = ++_documentOperationTicket;
    final queuedOperation = _documentOperations
        .catchError((Object _, StackTrace stackTrace) {})
        .then((_) => action());
    final guardedOperation = queuedOperation.timeout(
      timeout,
      onTimeout: () async {
        if (ticket == _documentOperationTicket) {
          _documentOperations = Future<void>.value();
        }
        await onTimeout?.call();
        throw TimeoutException(
          'Timed out while running a PDF document operation.',
          timeout,
        );
      },
    );
    final nextDocumentOperations = guardedOperation.then<void>(
      (_) {},
      onError: (Object _, StackTrace stackTrace) {},
    );
    if (ticket == _documentOperationTicket) {
      _documentOperations = nextDocumentOperations;
    }
    return guardedOperation;
  }

  static double resolveRenderScale({
    required double width,
    required double height,
    required double preferredScale,
    required double maxTextureSide,
  }) {
    if (width <= 0 || height <= 0) {
      throw StateError('PDF page has an invalid size: $width x $height.');
    }

    final largestSide = width > height ? width : height;
    final cappedScale = maxTextureSide / largestSide;
    final nextScale = preferredScale < cappedScale
        ? preferredScale
        : cappedScale;
    return nextScale < 0.8 ? 0.8 : nextScale;
  }
}
