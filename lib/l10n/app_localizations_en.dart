// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Color Vision Reader';

  @override
  String get homeShelfTitle => 'Color Weakness Bookshelf';

  @override
  String get homeHeroDescription => 'Pick an atlas to start viewing and find the display style that feels clearer and more comfortable.';

  @override
  String get homeConventionsTitle => 'Quick Start';

  @override
  String get homeConventionsBody => '1. Pick an atlas\n2. Open the reader\n3. Switch effects';

  @override
  String get homeShelfPanelTitle => 'PDF Shelf';

  @override
  String get homeShelfPanelSubtitle => 'Editions 1-6 are listed here. Ready items can be opened right away.';

  @override
  String bookCatalogLoadFailed(Object error) {
    return 'Failed to load the book catalog: $error';
  }

  @override
  String bookEditionSubtitle(int edition) {
    return 'Edition $edition Atlas';
  }

  @override
  String get bookAvailableDescription => 'This item is ready and can be opened right away.';

  @override
  String get bookReservedDescription => 'Prepare the matching file to open it.';

  @override
  String get bookReadyStatus => 'Ready';

  @override
  String get bookMissingStatus => 'Missing';

  @override
  String get bookReadyAction => 'Open and start reading';

  @override
  String get bookMissingAction => 'Prepare the file to unlock it';

  @override
  String get readerCustomBlendName => 'Custom Effect';

  @override
  String get readerCustomBlendNote => 'Adjust the color and display style to match what feels best for you.';

  @override
  String readerOpenPdfFailed(Object error) {
    return 'Failed to open the PDF: $error';
  }

  @override
  String get readerOpenPdfTimedOut => 'Opening the document is taking too long. Please go back and try again.';

  @override
  String readerRenderPageFailed(Object error) {
    return 'Failed to render the current page: $error';
  }

  @override
  String get readerRenderPageTimedOut => 'Loading this page is taking too long. Please try again shortly.';

  @override
  String readerSchemeSaved(Object name) {
    return 'Saved scheme: $name';
  }

  @override
  String get readerSchemeDeleted => 'Deleted saved scheme';

  @override
  String get readerSaveSchemeDialogTitle => 'Save to My Schemes';

  @override
  String get schemeNameLabel => 'Scheme name';

  @override
  String get schemeNameHint => 'For example: Evening soft light';

  @override
  String get cancelButton => 'Cancel';

  @override
  String get saveButton => 'Save';

  @override
  String readerCurrentSource(Object title) {
    return 'You are viewing $title. Compare different effects and keep the view that feels easiest to read.';
  }

  @override
  String get maskEditorTitle => 'Reading Effects';

  @override
  String get maskEditorSubtitle => 'Use a ready-made effect or fine-tune one that suits your eyes better.';

  @override
  String get presetModeLabel => 'Preset Mode';

  @override
  String get customBlendModeLabel => 'Custom Effect';

  @override
  String get effectModeFieldLabel => 'Effect mode';

  @override
  String get effectModeDeutanCompensation => 'Green-weak Compensation';

  @override
  String get effectModeProtanCompensation => 'Red-weak Compensation';

  @override
  String get effectModeTritanCompensation => 'Blue-yellow Compensation';

  @override
  String get effectModeSuppressBlue => 'Suppress Blue';

  @override
  String get effectModeHighContrast => 'High-contrast Mono';

  @override
  String get effectModeBlend => 'Blend';

  @override
  String get effectModeReplace => 'Replace Color';

  @override
  String get effectModeInvert => 'Invert Colors';

  @override
  String get effectModeDeutanCompensationHint => 'Re-maps confusing red-green ranges so nearby green, yellow, and brown details are easier to separate.';

  @override
  String get effectModeProtanCompensationHint => 'Shifts hard-to-see red information into channels that remain easier to notice.';

  @override
  String get effectModeTritanCompensationHint => 'Pulls blue and yellow ranges farther apart when cool and warm areas blur together.';

  @override
  String get effectModeSuppressBlueHint => 'Turns down blue-heavy areas across the page while keeping some brightness, useful when blue markings dominate the view.';

  @override
  String get effectModeHighContrastHint => 'Drops most color information and pushes black-white contrast harder when you only need clear shapes.';

  @override
  String get effectModeBlendHint => 'Adds a gentle color layer on top of the page for subtle adjustment.';

  @override
  String get effectModeReplaceHint => 'Replaces most page colors with your chosen color so light and dark contrast is easier to follow.';

  @override
  String get effectModeInvertHint => 'Directly inverts the page colors for a stronger contrast view.';

  @override
  String get schemeStatColor => 'Color';

  @override
  String get schemeStatIntensity => 'Strength';

  @override
  String get schemeStatMode => 'Style';

  @override
  String get schemeStatBlend => 'Blend';

  @override
  String get startCustomFromPresetButton => 'Start from this preset';

  @override
  String get blendModeFieldLabel => 'Blend style';

  @override
  String get redChannelLabel => 'Red channel';

  @override
  String get greenChannelLabel => 'Green channel';

  @override
  String get blueChannelLabel => 'Blue channel';

  @override
  String get maskOpacityLabel => 'Effect strength';

  @override
  String get saveMySchemeButton => 'Save to My Schemes';

  @override
  String get loadCurrentPresetButton => 'Load current preset';

  @override
  String get resetCustomButton => 'Reset custom values';

  @override
  String get mySchemesTitle => 'My Schemes';

  @override
  String get noSavedSchemesDescription => 'No personal schemes have been saved yet. Adjust the parameters first, then tap \"Save to My Schemes\".';

  @override
  String get loadSchemeTooltip => 'Load scheme';

  @override
  String get deleteSchemeTooltip => 'Delete scheme';

  @override
  String get pagePreviewTitle => 'Page Preview';

  @override
  String get pagePreviewSubtitle => 'The original page stays on the left and the current effect appears on the right for easy comparison.';

  @override
  String get pageCounterPreparing => 'Preparing';

  @override
  String get pageCounterUnavailable => 'Unavailable';

  @override
  String get previousPageButton => 'Previous';

  @override
  String get nextPageButton => 'Next';

  @override
  String get jumpToPageButton => 'Jump to Page';

  @override
  String get currentPageUnavailable => 'The current page is not available right now.';

  @override
  String get originalPageLabel => 'Original';

  @override
  String get assistedPreviewLabel => 'Current Effect';

  @override
  String get viewLargeImage => 'Open large view';

  @override
  String get jumpToPageDialogTitle => 'Jump to a page';

  @override
  String get pageNumberLabel => 'Page number';

  @override
  String pageNumberHint(int pageCount) {
    return 'Enter 1 - $pageCount';
  }

  @override
  String get jumpButton => 'Jump';

  @override
  String invalidPageNumber(int pageCount) {
    return 'Enter a page number between 1 and $pageCount';
  }

  @override
  String previewDialogTitle(Object title, int pageNumber) {
    return '$title · Page $pageNumber';
  }

  @override
  String get closeTooltip => 'Close';

  @override
  String get defaultSchemeGreenWeakName => 'Green-weak Compensation';

  @override
  String get defaultSchemeGreenWeakNote => 'Re-maps common red-green confusion so nearby greens, yellows, and browns separate more clearly.';

  @override
  String get defaultSchemeRedWeakName => 'Red-weak Compensation';

  @override
  String get defaultSchemeRedWeakNote => 'Moves red-heavy information into channels that are easier to notice.';

  @override
  String get defaultSchemeBlueYellowWeakName => 'Blue-yellow Compensation';

  @override
  String get defaultSchemeBlueYellowWeakNote => 'Re-balances blue and yellow ranges so cool and warm areas separate more clearly.';

  @override
  String get defaultSchemeSuppressBlueName => 'Suppress Blue';

  @override
  String get defaultSchemeSuppressBlueNote => 'Tones down blue-heavy regions when they are too dominant or distracting.';

  @override
  String get defaultSchemeHighContrastName => 'High-contrast Mono';

  @override
  String get defaultSchemeHighContrastNote => 'Reduce color distraction and keep stronger light-dark contrast when shape matters more than hue.';

  @override
  String get defaultSchemeInvertName => 'Invert Colors';

  @override
  String get defaultSchemeInvertNote => 'Turns the page into an inverted view for stronger contrast, especially under bright light.';

  @override
  String get defaultSchemeNoneName => 'No Mask';

  @override
  String get defaultSchemeNoneNote => 'Turns off the effect and shows the original page.';

  @override
  String get blendModeSoftLight => 'Soft light';

  @override
  String get blendModeOverlay => 'Overlay';

  @override
  String get blendModeMultiply => 'Multiply';

  @override
  String get blendModeScreen => 'Screen';
}
