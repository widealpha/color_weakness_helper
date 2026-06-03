import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../models/pdf_book.dart';

const List<PdfBook> bookCatalog = <PdfBook>[
  PdfBook(
    id: 'book-1th',
    title: '1th.pdf',
    subtitle: 'Edition 1 Atlas',
    assetPath: 'assets/1th.pdf',
    description:
        'This PDF is already in the project and can be opened directly with the assistance mask overlay.',
    accentColor: Color(0xFF355070),
  ),
  PdfBook(
    id: 'book-2th',
    title: '2th.pdf',
    subtitle: 'Edition 2 Atlas',
    assetPath: 'assets/2th.pdf',
    description:
        'This PDF is already in the project and can be opened directly with the assistance mask overlay.',
    accentColor: Color(0xFF6C584C),
  ),
  PdfBook(
    id: 'book-3th',
    title: '3th.pdf',
    subtitle: 'Edition 3 Atlas',
    assetPath: 'assets/3th.pdf',
    description:
        'This PDF is already in the project and can be opened directly with the assistance mask overlay.',
    accentColor: Color(0xFF6D597A),
  ),
  PdfBook(
    id: 'book-4th',
    title: '4th.pdf',
    subtitle: 'Edition 4 Atlas',
    assetPath: 'assets/4th.pdf',
    description:
        'The slot is reserved. Once `assets/4th.pdf` is added, it becomes readable automatically.',
    accentColor: Color(0xFFBC6C25),
  ),
  PdfBook(
    id: 'book-5th',
    title: '5th.pdf',
    subtitle: 'Edition 5 Atlas',
    assetPath: 'assets/5th.pdf',
    description:
        'This PDF is already in the project and can be opened directly with the assistance mask overlay.',
    accentColor: Color(0xFF197278),
  ),
  PdfBook(
    id: 'book-6th',
    title: '6th.pdf',
    subtitle: 'Edition 6 Atlas',
    assetPath: 'assets/6th.pdf',
    description:
        'This PDF is already in the project and can be opened directly with the assistance mask overlay.',
    accentColor: Color(0xFFC44536),
  ),
];

PdfBook localizeBook(AppLocalizations l10n, PdfBook book) {
  final edition = switch (book.id) {
    'book-1th' => 1,
    'book-2th' => 2,
    'book-3th' => 3,
    'book-4th' => 4,
    'book-5th' => 5,
    'book-6th' => 6,
    _ => 0,
  };

  return book.copyWith(
    subtitle: edition > 0 ? l10n.bookEditionSubtitle(edition) : book.subtitle,
    description: book.id == 'book-4th'
        ? l10n.bookReservedDescription
        : l10n.bookAvailableDescription,
  );
}
