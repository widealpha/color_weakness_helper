import 'package:flutter/material.dart';

import '../l10n/localization_extensions.dart';
import '../models/pdf_book.dart';

class BookCard extends StatelessWidget {
  const BookCard({super.key, required this.book, required this.onTap});

  final PdfBook book;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final ready = book.isAvailable;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final ink = colorScheme.onSurface;
    final baseSurface = isDark
        ? colorScheme.surfaceContainerHigh
        : const Color(0xFFFCF8F1);
    final paper = Color.alphaBlend(
      book.accentColor.withValues(alpha: isDark ? 0.16 : 0.12),
      baseSurface,
    );
    final accentSoft = Color.alphaBlend(
      book.accentColor.withValues(alpha: isDark ? 0.24 : 0.18),
      isDark ? colorScheme.surfaceContainerHighest : Colors.white,
    );
    final l10n = context.l10n;
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final cardWidth = constraints.maxWidth.isFinite
            ? constraints.maxWidth.clamp(0.0, 360.0)
            : 360.0;
        final compact = cardWidth < 340;
        final radius = compact ? 22.0 : 28.0;
        final contentPadding = compact ? 16.0 : 22.0;
        final statusPadding = EdgeInsets.symmetric(
          horizontal: compact ? 10 : 12,
          vertical: compact ? 7 : 8,
        );

        return InkWell(
          borderRadius: BorderRadius.circular(radius),
          onTap: ready ? onTap : null,
          child: Ink(
            width: cardWidth,
            padding: const EdgeInsets.all(0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(radius),
              color: paper,
              border: Border.all(
                color: book.accentColor.withValues(alpha: 0.26),
              ),
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: book.accentColor.withValues(
                    alpha: isDark ? 0.18 : 0.26,
                  ),
                  blurRadius: isDark ? 16 : 22,
                  offset: const Offset(0, 12),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  height: compact ? 12 : 16,
                  decoration: BoxDecoration(
                    color: book.accentColor,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(radius),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(contentPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Flexible(
                            child: Container(
                              padding: statusPadding,
                              decoration: BoxDecoration(
                                color: ready
                                    ? book.accentColor.withValues(alpha: 0.14)
                                    : const Color(
                                        0xFFC44536,
                                      ).withValues(alpha: 0.14),
                                borderRadius: BorderRadius.circular(99),
                              ),
                              child: Text(
                                ready
                                    ? l10n.bookReadyStatus
                                    : l10n.bookMissingStatus,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: ready
                                      ? book.accentColor
                                      : const Color(0xFFC44536),
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Icon(
                            ready
                                ? Icons.menu_book_rounded
                                : Icons.library_books_outlined,
                            color: book.accentColor,
                          ),
                        ],
                      ),
                      SizedBox(height: compact ? 14 : 18),
                      Text(
                        book.title,
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(color: ink, fontWeight: FontWeight.w900),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        book.subtitle,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
                              color: ink.withValues(alpha: 0.78),
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        book.description,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: ink.withValues(alpha: 0.74),
                          height: 1.45,
                        ),
                      ),
                      SizedBox(height: compact ? 14 : 18),
                      Container(
                        padding: EdgeInsets.all(compact ? 12 : 14),
                        decoration: BoxDecoration(
                          color: accentSoft,
                          borderRadius: BorderRadius.circular(
                            compact ? 16 : 20,
                          ),
                          border: Border.all(
                            color: book.accentColor.withValues(alpha: 0.18),
                          ),
                        ),
                        child: Row(
                          children: <Widget>[
                            Icon(
                              ready
                                  ? Icons.play_circle_outline
                                  : Icons.folder_open_outlined,
                              color: book.accentColor,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                ready
                                    ? l10n.bookReadyAction
                                    : l10n.bookMissingAction,
                                style: TextStyle(
                                  color: ink.withValues(alpha: 0.78),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
