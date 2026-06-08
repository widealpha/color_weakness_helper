import 'dart:async';

import 'package:flutter/services.dart';
import 'package:pdfrx/pdfrx.dart';

import '../models/rendered_pdf_page.dart';

class PdfAssetService {
  const PdfAssetService();

  static Future<void> _documentOperations = Future<void>.value();

  Future<bool> assetExists(String assetPath) async {
    try {
      await rootBundle.load(assetPath);
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<PdfDocument> openDocument(String assetPath) => _runDocumentOp(
    () => PdfDocument.openAsset(assetPath, useProgressiveLoading: false),
  );

  Future<void> closeDocument(PdfDocument document) =>
      _runDocumentOp(() => document.dispose());

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

  Future<T> _runDocumentOp<T>(Future<T> Function() action) {
    final completer = Completer<T>();
    _documentOperations = _documentOperations
        .catchError((Object _, StackTrace stackTrace) {})
        .then((_) async {
          try {
            completer.complete(await action());
          } catch (error, stackTrace) {
            completer.completeError(error, stackTrace);
          }
        });
    return completer.future;
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
