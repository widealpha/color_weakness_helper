import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('zh')
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Color Vision Reader'**
  String get appTitle;

  /// No description provided for @homeShelfTitle.
  ///
  /// In en, this message translates to:
  /// **'Color Weakness Bookshelf'**
  String get homeShelfTitle;

  /// No description provided for @homeHeroDescription.
  ///
  /// In en, this message translates to:
  /// **'Pick an atlas to start viewing and find the display style that feels clearer and more comfortable.'**
  String get homeHeroDescription;

  /// No description provided for @homeConventionsTitle.
  ///
  /// In en, this message translates to:
  /// **'Quick Start'**
  String get homeConventionsTitle;

  /// No description provided for @homeConventionsBody.
  ///
  /// In en, this message translates to:
  /// **'1. Pick an atlas\n2. Open the reader\n3. Switch effects'**
  String get homeConventionsBody;

  /// No description provided for @homeShelfPanelTitle.
  ///
  /// In en, this message translates to:
  /// **'PDF Shelf'**
  String get homeShelfPanelTitle;

  /// No description provided for @homeShelfPanelSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Editions 1-6 are listed here. Ready items can be opened right away.'**
  String get homeShelfPanelSubtitle;

  /// No description provided for @bookCatalogLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to load the book catalog: {error}'**
  String bookCatalogLoadFailed(Object error);

  /// No description provided for @bookEditionSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Edition {edition} Atlas'**
  String bookEditionSubtitle(int edition);

  /// No description provided for @bookAvailableDescription.
  ///
  /// In en, this message translates to:
  /// **'This item is ready and can be opened right away.'**
  String get bookAvailableDescription;

  /// No description provided for @bookReservedDescription.
  ///
  /// In en, this message translates to:
  /// **'Prepare the matching file to open it.'**
  String get bookReservedDescription;

  /// No description provided for @bookReadyStatus.
  ///
  /// In en, this message translates to:
  /// **'Ready'**
  String get bookReadyStatus;

  /// No description provided for @bookMissingStatus.
  ///
  /// In en, this message translates to:
  /// **'Missing'**
  String get bookMissingStatus;

  /// No description provided for @bookReadyAction.
  ///
  /// In en, this message translates to:
  /// **'Open and start reading'**
  String get bookReadyAction;

  /// No description provided for @bookMissingAction.
  ///
  /// In en, this message translates to:
  /// **'Prepare the file to unlock it'**
  String get bookMissingAction;

  /// No description provided for @readerCustomBlendName.
  ///
  /// In en, this message translates to:
  /// **'Custom Effect'**
  String get readerCustomBlendName;

  /// No description provided for @readerCustomBlendNote.
  ///
  /// In en, this message translates to:
  /// **'Adjust the color and display style to match what feels best for you.'**
  String get readerCustomBlendNote;

  /// No description provided for @readerOpenPdfFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to open the PDF: {error}'**
  String readerOpenPdfFailed(Object error);

  /// No description provided for @readerOpenPdfTimedOut.
  ///
  /// In en, this message translates to:
  /// **'Opening the document is taking too long. Please go back and try again.'**
  String get readerOpenPdfTimedOut;

  /// No description provided for @readerRenderPageFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to render the current page: {error}'**
  String readerRenderPageFailed(Object error);

  /// No description provided for @readerRenderPageTimedOut.
  ///
  /// In en, this message translates to:
  /// **'Loading this page is taking too long. Please try again shortly.'**
  String get readerRenderPageTimedOut;

  /// No description provided for @readerSchemeSaved.
  ///
  /// In en, this message translates to:
  /// **'Saved scheme: {name}'**
  String readerSchemeSaved(Object name);

  /// No description provided for @readerSchemeDeleted.
  ///
  /// In en, this message translates to:
  /// **'Deleted saved scheme'**
  String get readerSchemeDeleted;

  /// No description provided for @readerSaveSchemeDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Save to My Schemes'**
  String get readerSaveSchemeDialogTitle;

  /// No description provided for @schemeNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Scheme name'**
  String get schemeNameLabel;

  /// No description provided for @schemeNameHint.
  ///
  /// In en, this message translates to:
  /// **'For example: Evening soft light'**
  String get schemeNameHint;

  /// No description provided for @cancelButton.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancelButton;

  /// No description provided for @saveButton.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get saveButton;

  /// No description provided for @readerCurrentSource.
  ///
  /// In en, this message translates to:
  /// **'You are viewing {title}. Compare different effects and keep the view that feels easiest to read.'**
  String readerCurrentSource(Object title);

  /// No description provided for @maskEditorTitle.
  ///
  /// In en, this message translates to:
  /// **'Reading Effects'**
  String get maskEditorTitle;

  /// No description provided for @maskEditorSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Use a ready-made effect or fine-tune one that suits your eyes better.'**
  String get maskEditorSubtitle;

  /// No description provided for @presetModeLabel.
  ///
  /// In en, this message translates to:
  /// **'Preset Mode'**
  String get presetModeLabel;

  /// No description provided for @customBlendModeLabel.
  ///
  /// In en, this message translates to:
  /// **'Custom Effect'**
  String get customBlendModeLabel;

  /// No description provided for @effectModeFieldLabel.
  ///
  /// In en, this message translates to:
  /// **'Effect mode'**
  String get effectModeFieldLabel;

  /// No description provided for @effectModeBlend.
  ///
  /// In en, this message translates to:
  /// **'Blend'**
  String get effectModeBlend;

  /// No description provided for @effectModeReplace.
  ///
  /// In en, this message translates to:
  /// **'Replace Color'**
  String get effectModeReplace;

  /// No description provided for @effectModeInvert.
  ///
  /// In en, this message translates to:
  /// **'Invert Colors'**
  String get effectModeInvert;

  /// No description provided for @effectModeBlendHint.
  ///
  /// In en, this message translates to:
  /// **'Adds a gentle color layer on top of the page for subtle adjustment.'**
  String get effectModeBlendHint;

  /// No description provided for @effectModeReplaceHint.
  ///
  /// In en, this message translates to:
  /// **'Replaces most page colors with your chosen color so light and dark contrast is easier to follow.'**
  String get effectModeReplaceHint;

  /// No description provided for @effectModeInvertHint.
  ///
  /// In en, this message translates to:
  /// **'Directly inverts the page colors for a stronger contrast view.'**
  String get effectModeInvertHint;

  /// No description provided for @schemeStatColor.
  ///
  /// In en, this message translates to:
  /// **'Color'**
  String get schemeStatColor;

  /// No description provided for @schemeStatIntensity.
  ///
  /// In en, this message translates to:
  /// **'Strength'**
  String get schemeStatIntensity;

  /// No description provided for @schemeStatMode.
  ///
  /// In en, this message translates to:
  /// **'Style'**
  String get schemeStatMode;

  /// No description provided for @schemeStatBlend.
  ///
  /// In en, this message translates to:
  /// **'Blend'**
  String get schemeStatBlend;

  /// No description provided for @startCustomFromPresetButton.
  ///
  /// In en, this message translates to:
  /// **'Start from this preset'**
  String get startCustomFromPresetButton;

  /// No description provided for @blendModeFieldLabel.
  ///
  /// In en, this message translates to:
  /// **'Blend style'**
  String get blendModeFieldLabel;

  /// No description provided for @redChannelLabel.
  ///
  /// In en, this message translates to:
  /// **'Red channel'**
  String get redChannelLabel;

  /// No description provided for @greenChannelLabel.
  ///
  /// In en, this message translates to:
  /// **'Green channel'**
  String get greenChannelLabel;

  /// No description provided for @blueChannelLabel.
  ///
  /// In en, this message translates to:
  /// **'Blue channel'**
  String get blueChannelLabel;

  /// No description provided for @maskOpacityLabel.
  ///
  /// In en, this message translates to:
  /// **'Effect strength'**
  String get maskOpacityLabel;

  /// No description provided for @saveMySchemeButton.
  ///
  /// In en, this message translates to:
  /// **'Save to My Schemes'**
  String get saveMySchemeButton;

  /// No description provided for @loadCurrentPresetButton.
  ///
  /// In en, this message translates to:
  /// **'Load current preset'**
  String get loadCurrentPresetButton;

  /// No description provided for @resetCustomButton.
  ///
  /// In en, this message translates to:
  /// **'Reset custom values'**
  String get resetCustomButton;

  /// No description provided for @mySchemesTitle.
  ///
  /// In en, this message translates to:
  /// **'My Schemes'**
  String get mySchemesTitle;

  /// No description provided for @noSavedSchemesDescription.
  ///
  /// In en, this message translates to:
  /// **'No personal schemes have been saved yet. Adjust the parameters first, then tap \"Save to My Schemes\".'**
  String get noSavedSchemesDescription;

  /// No description provided for @loadSchemeTooltip.
  ///
  /// In en, this message translates to:
  /// **'Load scheme'**
  String get loadSchemeTooltip;

  /// No description provided for @deleteSchemeTooltip.
  ///
  /// In en, this message translates to:
  /// **'Delete scheme'**
  String get deleteSchemeTooltip;

  /// No description provided for @pagePreviewTitle.
  ///
  /// In en, this message translates to:
  /// **'Page Preview'**
  String get pagePreviewTitle;

  /// No description provided for @pagePreviewSubtitle.
  ///
  /// In en, this message translates to:
  /// **'The original page stays on the left and the current effect appears on the right for easy comparison.'**
  String get pagePreviewSubtitle;

  /// No description provided for @pageCounterPreparing.
  ///
  /// In en, this message translates to:
  /// **'Preparing'**
  String get pageCounterPreparing;

  /// No description provided for @pageCounterUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Unavailable'**
  String get pageCounterUnavailable;

  /// No description provided for @previousPageButton.
  ///
  /// In en, this message translates to:
  /// **'Previous'**
  String get previousPageButton;

  /// No description provided for @nextPageButton.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get nextPageButton;

  /// No description provided for @jumpToPageButton.
  ///
  /// In en, this message translates to:
  /// **'Jump to Page'**
  String get jumpToPageButton;

  /// No description provided for @currentPageUnavailable.
  ///
  /// In en, this message translates to:
  /// **'The current page is not available right now.'**
  String get currentPageUnavailable;

  /// No description provided for @originalPageLabel.
  ///
  /// In en, this message translates to:
  /// **'Original'**
  String get originalPageLabel;

  /// No description provided for @assistedPreviewLabel.
  ///
  /// In en, this message translates to:
  /// **'Current Effect'**
  String get assistedPreviewLabel;

  /// No description provided for @viewLargeImage.
  ///
  /// In en, this message translates to:
  /// **'Open large view'**
  String get viewLargeImage;

  /// No description provided for @jumpToPageDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Jump to a page'**
  String get jumpToPageDialogTitle;

  /// No description provided for @pageNumberLabel.
  ///
  /// In en, this message translates to:
  /// **'Page number'**
  String get pageNumberLabel;

  /// No description provided for @pageNumberHint.
  ///
  /// In en, this message translates to:
  /// **'Enter 1 - {pageCount}'**
  String pageNumberHint(int pageCount);

  /// No description provided for @jumpButton.
  ///
  /// In en, this message translates to:
  /// **'Jump'**
  String get jumpButton;

  /// No description provided for @invalidPageNumber.
  ///
  /// In en, this message translates to:
  /// **'Enter a page number between 1 and {pageCount}'**
  String invalidPageNumber(int pageCount);

  /// No description provided for @previewDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'{title} · Page {pageNumber}'**
  String previewDialogTitle(Object title, int pageNumber);

  /// No description provided for @closeTooltip.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get closeTooltip;

  /// No description provided for @defaultSchemeGreenWeakName.
  ///
  /// In en, this message translates to:
  /// **'Green-weak Assist'**
  String get defaultSchemeGreenWeakName;

  /// No description provided for @defaultSchemeGreenWeakNote.
  ///
  /// In en, this message translates to:
  /// **'Adds a warm tone to help nearby greens and browns feel easier to separate.'**
  String get defaultSchemeGreenWeakNote;

  /// No description provided for @defaultSchemeRedWeakName.
  ///
  /// In en, this message translates to:
  /// **'Red-weak Assist'**
  String get defaultSchemeRedWeakName;

  /// No description provided for @defaultSchemeRedWeakNote.
  ///
  /// In en, this message translates to:
  /// **'Adds a cool tone that can make reddish areas easier to notice.'**
  String get defaultSchemeRedWeakNote;

  /// No description provided for @defaultSchemeBlueYellowWeakName.
  ///
  /// In en, this message translates to:
  /// **'Blue-yellow Assist'**
  String get defaultSchemeBlueYellowWeakName;

  /// No description provided for @defaultSchemeBlueYellowWeakNote.
  ///
  /// In en, this message translates to:
  /// **'Uses a soft magenta tone to make cool and warm areas feel more distinct.'**
  String get defaultSchemeBlueYellowWeakNote;

  /// No description provided for @defaultSchemeReplaceWarmName.
  ///
  /// In en, this message translates to:
  /// **'Warm Replace'**
  String get defaultSchemeReplaceWarmName;

  /// No description provided for @defaultSchemeReplaceWarmNote.
  ///
  /// In en, this message translates to:
  /// **'Replaces most colors with a warm tone so it is easier to focus on light and dark contrast.'**
  String get defaultSchemeReplaceWarmNote;

  /// No description provided for @defaultSchemeInvertName.
  ///
  /// In en, this message translates to:
  /// **'Invert Colors'**
  String get defaultSchemeInvertName;

  /// No description provided for @defaultSchemeInvertNote.
  ///
  /// In en, this message translates to:
  /// **'Turns the page into an inverted view for stronger contrast, especially under bright light.'**
  String get defaultSchemeInvertNote;

  /// No description provided for @defaultSchemeNoneName.
  ///
  /// In en, this message translates to:
  /// **'No Mask'**
  String get defaultSchemeNoneName;

  /// No description provided for @defaultSchemeNoneNote.
  ///
  /// In en, this message translates to:
  /// **'Turns off the effect and shows the original page.'**
  String get defaultSchemeNoneNote;

  /// No description provided for @blendModeSoftLight.
  ///
  /// In en, this message translates to:
  /// **'Soft light'**
  String get blendModeSoftLight;

  /// No description provided for @blendModeOverlay.
  ///
  /// In en, this message translates to:
  /// **'Overlay'**
  String get blendModeOverlay;

  /// No description provided for @blendModeMultiply.
  ///
  /// In en, this message translates to:
  /// **'Multiply'**
  String get blendModeMultiply;

  /// No description provided for @blendModeScreen.
  ///
  /// In en, this message translates to:
  /// **'Screen'**
  String get blendModeScreen;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'zh': return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
