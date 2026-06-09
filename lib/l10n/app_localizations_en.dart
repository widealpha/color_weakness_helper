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
  String get retryOpenPdfButton => 'Retry opening';

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
  String get effectModeDeutanCompensation => 'Deutan Daltonize';

  @override
  String get effectModeProtanCompensation => 'Protan Daltonize';

  @override
  String get effectModeRedGreenPulse => 'Red-green Fast Blink';

  @override
  String get effectModeRedGreenReversePulse => 'Two-mode Static Combine';

  @override
  String get effectModeTritanCompensation => 'Tritan Daltonize';

  @override
  String get effectModeHighContrast => 'High-contrast Mono';

  @override
  String get effectModeBlend => 'Blend';

  @override
  String get effectModeReplace => 'Replace Color';

  @override
  String get effectModeInvert => 'Invert Colors';

  @override
  String get effectModeDeutanCompensationHint => 'Simulates green-channel loss first, then moves the lost difference into red and blue contrast for common red-green confusion.';

  @override
  String get effectModeProtanCompensationHint => 'Simulates red-channel loss first, then redirects red differences into green and blue cues when reds look dark or disappear.';

  @override
  String get effectModeRedGreenPulseHint => 'Hard-switches protan and deutan compensation every 0.4 seconds, using temporal contrast to reveal red-green differences.';

  @override
  String get effectModeRedGreenReversePulseHint => 'Statically combines any two weak-mode passes or reverse difference passes to test stronger spatial separation.';

  @override
  String get effectModeTritanCompensationHint => 'Simulates blue-channel loss first, then redirects blue-yellow differences into red-green cues.';

  @override
  String get effectModeHighContrastHint => 'Drops most color information and pushes black-white contrast harder when you only need clear shapes.';

  @override
  String get effectModeBlendHint => 'Adds a gentle color layer on top of the page for subtle adjustment.';

  @override
  String get effectModeReplaceHint => 'Replaces most page colors with your chosen color so light and dark contrast is easier to follow.';

  @override
  String get effectModeInvertHint => 'Directly inverts the page colors for a stronger contrast view.';

  @override
  String get matrixPassFirstLabel => 'First weak mode';

  @override
  String get matrixPassSecondLabel => 'Second weak mode';

  @override
  String get matrixPassDeutanCompensation => 'Deutan enhance';

  @override
  String get matrixPassProtanCompensation => 'Protan enhance';

  @override
  String get matrixPassTritanCompensation => 'Tritan enhance';

  @override
  String get matrixPassDeutanReverse => 'Reverse deutan difference';

  @override
  String get matrixPassProtanReverse => 'Reverse protan difference';

  @override
  String get matrixPassTritanReverse => 'Reverse tritan difference';

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
  String get defaultSchemeGreenWeakName => 'Deutan Enhance';

  @override
  String get defaultSchemeGreenWeakNote => 'Uses a daltonization-style pass: simulate green-channel loss, then move the lost difference into clearer red-blue contrast.';

  @override
  String get defaultSchemeRedWeakName => 'Protan Enhance';

  @override
  String get defaultSchemeRedWeakNote => 'Redistributes red-related differences into green-blue cues, useful when reds look dark or red-green details merge.';

  @override
  String get defaultSchemeRedGreenPulseName => 'Red-green Fast Blink';

  @override
  String get defaultSchemeRedGreenPulseNote => 'Hard-switches protan and deutan enhancement every 0.4 seconds so color changes become stronger temporal contrast.';

  @override
  String get defaultSchemeRedGreenReversePulseName => 'Red + Reverse Green';

  @override
  String get defaultSchemeRedGreenReversePulseNote => 'Statically combines protan enhancement with an inverse deutan difference pass to test stronger red-green separation.';

  @override
  String get defaultSchemeBlueYellowWeakName => 'Tritan Enhance';

  @override
  String get defaultSchemeBlueYellowWeakNote => 'Redirects blue-yellow differences into red-green cues so cool and warm blocks can separate more clearly.';

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
