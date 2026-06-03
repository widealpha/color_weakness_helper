import 'package:flutter/material.dart';

import '../data/book_catalog.dart';
import '../l10n/localization_extensions.dart';
import '../models/pdf_book.dart';
import '../services/mask_scheme_storage.dart';
import '../services/pdf_asset_service.dart';
import '../theme/app_theme.dart';
import '../widgets/app_panel.dart';
import '../widgets/book_card.dart';
import 'pdf_reader_page.dart';

class BookHomePage extends StatefulWidget {
  const BookHomePage({
    super.key,
    required this.pdfAssetService,
    required this.maskSchemeStorage,
  });

  final PdfAssetService pdfAssetService;
  final MaskSchemeStorage maskSchemeStorage;

  @override
  State<BookHomePage> createState() => _BookHomePageState();
}

class _BookHomePageState extends State<BookHomePage> {
  late final Future<List<PdfBook>> _booksFuture = _loadBooks();

  Future<List<PdfBook>> _loadBooks() async {
    final books = await Future.wait(
      bookCatalog.map((PdfBook book) async {
        final available = await widget.pdfAssetService.assetExists(
          book.assetPath,
        );
        return book.copyWith(isAvailable: available);
      }),
    );
    return books;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final quickSteps = l10n.homeConventionsBody.split('\n');
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: AppTheme.pageBackgroundGradient(context),
        ),
        child: SafeArea(
          child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              final compact = constraints.maxHeight < 680;
              final pagePadding = compact ? 16.0 : 20.0;
              final heroPadding = compact ? 20.0 : 26.0;
              final heroGap = compact ? 16.0 : 20.0;

              return Padding(
                padding: EdgeInsets.all(pagePadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(heroPadding),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(28),
                        gradient: AppTheme.heroGradient(context),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            l10n.homeShelfTitle,
                            style: Theme.of(context).textTheme.headlineMedium
                                ?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w800,
                                ),
                          ),
                          const SizedBox(height: 12),
                          ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 680),
                            child: Text(
                              l10n.homeHeroDescription,
                              style: Theme.of(context).textTheme.bodyLarge
                                  ?.copyWith(
                                    color: Colors.white.withValues(alpha: 0.88),
                                    height: 1.45,
                                  ),
                            ),
                          ),
                          if (!compact) ...<Widget>[
                            const SizedBox(height: 18),
                            Text(
                              l10n.homeConventionsTitle,
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.92),
                                fontWeight: FontWeight.w700,
                                fontSize: 15,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Wrap(
                              spacing: 10,
                              runSpacing: 10,
                              children: quickSteps.map((String step) {
                                return Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 14,
                                    vertical: 10,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppTheme.heroBadgeBackground(context),
                                    borderRadius: BorderRadius.circular(99),
                                  ),
                                  child: Text(
                                    step,
                                    style: TextStyle(
                                      color: Colors.white.withValues(alpha: 0.9),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ],
                        ],
                      ),
                    ),
                    SizedBox(height: heroGap),
                    Expanded(
                      child: AppPanel(
                        title: l10n.homeShelfPanelTitle,
                        subtitle: compact ? '' : l10n.homeShelfPanelSubtitle,
                        expandChild: true,
                        child: FutureBuilder<List<PdfBook>>(
                          future: _booksFuture,
                          builder:
                              (
                                BuildContext context,
                                AsyncSnapshot<List<PdfBook>> snapshot,
                              ) {
                                if (snapshot.connectionState !=
                                    ConnectionState.done) {
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }

                                if (snapshot.hasError) {
                                  return Align(
                                    alignment: Alignment.topLeft,
                                    child: Text(
                                      l10n.bookCatalogLoadFailed(
                                        snapshot.error.toString(),
                                      ),
                                    ),
                                  );
                                }

                                final books =
                                    (snapshot.data ?? const <PdfBook>[])
                                        .map(
                                          (PdfBook book) =>
                                              localizeBook(l10n, book),
                                        )
                                        .toList(growable: false);
                                return SingleChildScrollView(
                                  child: Align(
                                    alignment: Alignment.topLeft,
                                    child: Wrap(
                                      spacing: 18,
                                      runSpacing: 18,
                                      children: books.map((PdfBook book) {
                                        return BookCard(
                                          book: book,
                                          onTap: book.isAvailable
                                              ? () {
                                                  Navigator.of(context).push(
                                                    MaterialPageRoute<void>(
                                                      builder: (_) =>
                                                          PdfReaderPage(
                                                            book: book,
                                                            pdfAssetService:
                                                                widget
                                                                    .pdfAssetService,
                                                            maskSchemeStorage:
                                                                widget
                                                                    .maskSchemeStorage,
                                                          ),
                                                    ),
                                                  );
                                                }
                                              : null,
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                );
                              },
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
