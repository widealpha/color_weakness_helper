import 'package:flutter/foundation.dart';

import '../data/book_catalog.dart';
import '../models/pdf_book.dart';
import '../services/pdf_asset_service.dart';

class BookCatalogProvider extends ChangeNotifier {
  BookCatalogProvider(this._pdfAssetService);

  final PdfAssetService _pdfAssetService;

  List<PdfBook> _books = const <PdfBook>[];
  bool _isLoading = true;
  Object? _error;
  bool _hasLoaded = false;
  bool _isDisposed = false;

  List<PdfBook> get books => _books;
  bool get isLoading => _isLoading;
  Object? get error => _error;

  Future<void> loadBooks() async {
    if (_hasLoaded) {
      return;
    }

    _hasLoaded = true;
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final books = await Future.wait(
        bookCatalog.map((PdfBook book) async {
          final available = await _pdfAssetService.assetExists(book.assetPath);
          return book.copyWith(isAvailable: available);
        }),
      );

      if (_isDisposed) {
        return;
      }

      _books = books;
      _isLoading = false;
      notifyListeners();
    } catch (error) {
      if (_isDisposed) {
        return;
      }

      _error = error;
      _isLoading = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }
}
