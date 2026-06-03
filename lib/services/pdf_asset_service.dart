import 'dart:async';

import 'package:flutter/services.dart';
import 'package:pdfrx/pdfrx.dart';

import '../models/rendered_pdf_page.dart';

class PdfAssetService {
  const PdfAssetService();

  static Future<void> _serializedOperations = Future<void>.value();

  Future<bool> assetExists(String assetPath) async {
    try {
      await rootBundle.load(assetPath);
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<PdfDocument> openDocument(String assetPath) => _runSerialized(
    () => PdfDocument.openAsset(assetPath, useProgressiveLoading: true),
  );

  Future<void> closeDocument(PdfDocument document) =>
      _runSerialized(() => document.dispose());

  Future<RenderedPdfPage> renderPage({
    required PdfDocument document,
    required int pageNumber,
    double scale = 2.2,
    int backgroundColor = 0xFFFDFBF7,
    Duration pageLoadTimeout = const Duration(seconds: 12),
  }) => _runSerialized(() async {
    final page = document.pages[pageNumber - 1];
    final loadedPage = page.isLoaded
        ? page
        : await page.waitForLoaded(timeout: pageLoadTimeout);
    if (loadedPage == null) {
      throw TimeoutException('Timed out while loading PDF page $pageNumber.');
    }

    final targetWidth = loadedPage.width * scale;
    final targetHeight = loadedPage.height * scale;
    final rendered = await loadedPage.render(
      fullWidth: targetWidth,
      fullHeight: targetHeight,
      backgroundColor: backgroundColor,
    );
    if (rendered == null) {
      throw StateError('Failed to render PDF page $pageNumber.');
    }

    try {
      final image = await rendered.createImage();

      return RenderedPdfPage(
        pageNumber: pageNumber,
        width: targetWidth,
        height: targetHeight,
        image: image,
      );
    } finally {
      rendered.dispose();
    }
  });

  Future<T> _runSerialized<T>(Future<T> Function() action) {
    final completer = Completer<T>();
    _serializedOperations = _serializedOperations
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
}
