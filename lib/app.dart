import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'l10n/app_localizations.dart';
import 'l10n/localization_extensions.dart';
import 'pages/book_home_page.dart';
import 'providers/book_catalog_provider.dart';
import 'services/pdf_asset_service.dart';
import 'theme/app_theme.dart';
import 'utils/preferences_utils.dart';

class ColorWeaknessHelperApp extends StatelessWidget {
  const ColorWeaknessHelperApp({
    super.key,
    PdfAssetService? pdfAssetService,
    PreferencesUtils? preferencesUtils,
  }) : _pdfAssetService = pdfAssetService ?? const PdfAssetService(),
       _preferencesUtils = preferencesUtils ?? const SharedPreferencesUtils();

  final PdfAssetService _pdfAssetService;
  final PreferencesUtils _preferencesUtils;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<PdfAssetService>.value(value: _pdfAssetService),
        Provider<PreferencesUtils>.value(value: _preferencesUtils),
        ChangeNotifierProvider<BookCatalogProvider>(
          create: (BuildContext context) =>
              BookCatalogProvider(context.read<PdfAssetService>())..loadBooks(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        onGenerateTitle: (BuildContext context) => context.l10n.appTitle,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        theme: AppTheme.build(Brightness.light),
        darkTheme: AppTheme.build(Brightness.dark),
        themeMode: ThemeMode.system,
        home: const BookHomePage(),
      ),
    );
  }
}
