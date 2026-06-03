import 'package:flutter/material.dart';

import 'l10n/app_localizations.dart';
import 'l10n/localization_extensions.dart';
import 'pages/book_home_page.dart';
import 'services/mask_scheme_storage.dart';
import 'services/pdf_asset_service.dart';
import 'theme/app_theme.dart';

class ColorWeaknessHelperApp extends StatelessWidget {
  const ColorWeaknessHelperApp({
    super.key,
    PdfAssetService? pdfAssetService,
    MaskSchemeStorage? maskSchemeStorage,
  }) : _pdfAssetService = pdfAssetService ?? const PdfAssetService(),
       _maskSchemeStorage = maskSchemeStorage ?? const MaskSchemeStorage();

  final PdfAssetService _pdfAssetService;
  final MaskSchemeStorage _maskSchemeStorage;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      onGenerateTitle: (BuildContext context) => context.l10n.appTitle,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: AppTheme.build(Brightness.light),
      darkTheme: AppTheme.build(Brightness.dark),
      themeMode: ThemeMode.system,
      home: BookHomePage(
        pdfAssetService: _pdfAssetService,
        maskSchemeStorage: _maskSchemeStorage,
      ),
    );
  }
}
