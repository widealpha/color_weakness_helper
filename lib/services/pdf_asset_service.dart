import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/services.dart';
import 'package:pdfx/pdfx.dart';

import '../models/rendered_pdf_page.dart';

class PdfAssetService {
  const PdfAssetService();

  static const Duration _documentOperationTimeout = Duration(seconds: 15);
  static const Duration _documentCloseTimeout = Duration(seconds: 3);

  static Future<void> _documentOperations = Future<void>.value();
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
  }) => _runDocumentOp(() async {
    final data = await rootBundle.load(assetPath);
    final bytes = data.buffer.asUint8List(
      data.offsetInBytes,
      data.lengthInBytes,
    );
    return PdfDocument.openData(bytes);
  }, timeout: timeout);

  Future<void> closeDocument(PdfDocument document) =>
      _runDocumentOp(() => document.close(), timeout: _documentCloseTimeout);

  Future<RenderedPdfPage> renderPage({
    required PdfDocument document,
    required int pageNumber,
    double scale = 2.2,
    double maxTextureSide = 2400,
    int backgroundColor = 0xFFFDFBF7,
    Duration pageLoadTimeout = const Duration(seconds: 12),
    Duration renderTimeout = const Duration(seconds: 20),
  }) async {
    if (pageNumber < 1 || pageNumber > document.pagesCount) {
      throw RangeError.range(pageNumber, 1, document.pagesCount, 'pageNumber');
    }

    final page = await document.getPage(pageNumber).timeout(pageLoadTimeout);

    try {
      final targetScale = resolveRenderScale(
        width: page.width,
        height: page.height,
        preferredScale: scale,
        maxTextureSide: maxTextureSide,
      );
      final targetWidth = page.width * targetScale;
      final targetHeight = page.height * targetScale;
      final rendered = await page
          .render(
            width: targetWidth,
            height: targetHeight,
            format: PdfPageImageFormat.png,
            backgroundColor: formatPdfxBackgroundColor(backgroundColor),
          )
          .timeout(renderTimeout);
      if (rendered == null) {
        throw StateError('Failed to render PDF page $pageNumber.');
      }

      final image = await _decodePageImage(
        rendered.bytes,
      ).timeout(renderTimeout);

      return RenderedPdfPage(
        pageNumber: pageNumber,
        width: targetWidth,
        height: targetHeight,
        image: image,
      );
    } finally {
      await page.close();
    }
  }

  Future<T> _runDocumentOp<T>(
    Future<T> Function() action, {
    required Duration timeout,
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

  static String formatPdfxBackgroundColor(int value) {
    final rgb = value & 0xFFFFFF;
    return '#${rgb.toRadixString(16).padLeft(6, '0').toUpperCase()}';
  }

  static Future<ui.Image> _decodePageImage(Uint8List bytes) async {
    final codec = await ui.instantiateImageCodec(bytes);
    try {
      final frame = await codec.getNextFrame();
      return frame.image;
    } finally {
      codec.dispose();
    }
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
