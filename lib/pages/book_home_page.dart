import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/book_catalog.dart';
import '../l10n/app_localizations.dart';
import '../l10n/localization_extensions.dart';
import '../models/pdf_book.dart';
import '../providers/book_catalog_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/app_panel.dart';
import '../widgets/book_card.dart';
import 'pdf_reader_page.dart';

class BookHomePage extends StatelessWidget {
  const BookHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final quickSteps = l10n.homeConventionsBody.split('\n');
    final provider = context.watch<BookCatalogProvider>();

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: AppTheme.pageBackgroundGradient(context),
        ),
        child: SafeArea(
          child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              final narrow = constraints.maxWidth < 420;
              final compact = narrow || constraints.maxHeight < 680;
              final pagePadding = narrow ? 12.0 : (compact ? 16.0 : 20.0);
              final heroPadding = narrow ? 16.0 : (compact ? 20.0 : 26.0);
              final heroGap = compact ? 14.0 : 20.0;
              final heroRadius = narrow ? 20.0 : 28.0;

              return Padding(
                padding: EdgeInsets.all(pagePadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(heroPadding),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(heroRadius),
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
                                    color: AppTheme.heroBadgeBackground(
                                      context,
                                    ),
                                    borderRadius: BorderRadius.circular(99),
                                  ),
                                  child: Text(
                                    step,
                                    style: TextStyle(
                                      color: Colors.white.withValues(
                                        alpha: 0.9,
                                      ),
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
                        child: _buildShelf(context, provider, l10n),
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

  Widget _buildShelf(
    BuildContext context,
    BookCatalogProvider provider,
    AppLocalizations l10n,
  ) {
    if (provider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (provider.error != null) {
      return Align(
        alignment: Alignment.topLeft,
        child: Text(l10n.bookCatalogLoadFailed(provider.error.toString())),
      );
    }

    final books = provider.books
        .map((PdfBook book) => localizeBook(l10n, book))
        .toList(growable: false);

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final narrow = constraints.maxWidth < 420;
        final cardWidth = narrow
            ? constraints.maxWidth
            : constraints.maxWidth.clamp(0.0, 360.0).toDouble();

        return SingleChildScrollView(
          child: Align(
            alignment: Alignment.topLeft,
            child: Wrap(
              spacing: narrow ? 12 : 18,
              runSpacing: narrow ? 12 : 18,
              children: books.map((PdfBook book) {
                return SizedBox(
                  width: cardWidth,
                  child: BookCard(
                    book: book,
                    onTap: book.isAvailable
                        ? () {
                            Navigator.of(context).push(
                              MaterialPageRoute<void>(
                                builder: (_) => PdfReaderPage(book: book),
                              ),
                            );
                          }
                        : null,
                  ),
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }
}
