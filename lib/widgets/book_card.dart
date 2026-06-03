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
    return InkWell(
      borderRadius: BorderRadius.circular(28),
      onTap: ready ? onTap : null,
      child: Ink(
        width: 360,
        padding: const EdgeInsets.all(0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
          color: paper,
          border: Border.all(color: book.accentColor.withValues(alpha: 0.26)),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: book.accentColor.withValues(alpha: isDark ? 0.18 : 0.26),
              blurRadius: isDark ? 16 : 22,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              height: 16,
              decoration: BoxDecoration(
                color: book.accentColor,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(28),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(22),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: ready
                              ? book.accentColor.withValues(alpha: 0.14)
                              : const Color(0xFFC44536).withValues(alpha: 0.14),
                          borderRadius: BorderRadius.circular(99),
                        ),
                        child: Text(
                          ready
                              ? l10n.bookReadyStatus
                              : l10n.bookMissingStatus,
                          style: TextStyle(
                            color: ready
                                ? book.accentColor
                                : const Color(0xFFC44536),
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      const Spacer(),
                      Icon(
                        ready
                            ? Icons.menu_book_rounded
                            : Icons.library_books_outlined,
                        color: book.accentColor,
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  Text(
                    book.title,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: ink,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    book.subtitle,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
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
                  const SizedBox(height: 18),
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: accentSoft,
                      borderRadius: BorderRadius.circular(20),
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
  }
}
