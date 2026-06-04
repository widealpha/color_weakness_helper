// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => '色弱阅读助手';

  @override
  String get homeShelfTitle => '色弱辅助书架';

  @override
  String get homeHeroDescription => '选择一本图谱开始查看，找到更清晰、更舒服的显示方式。';

  @override
  String get homeConventionsTitle => '快速开始';

  @override
  String get homeConventionsBody => '1. 选择图谱\n2. 进入阅读\n3. 切换效果';

  @override
  String get homeShelfPanelTitle => 'PDF 书架';

  @override
  String get homeShelfPanelSubtitle => '这里展示 1-6 版图谱，准备好的内容可以直接打开。';

  @override
  String bookCatalogLoadFailed(Object error) {
    return '书籍目录读取失败：$error';
  }

  @override
  String bookEditionSubtitle(int edition) {
    return '第 $edition 版图谱';
  }

  @override
  String get bookAvailableDescription => '当前已准备好，可直接开始阅读。';

  @override
  String get bookReservedDescription => '准备好对应文件后即可阅读。';

  @override
  String get bookReadyStatus => '已就绪';

  @override
  String get bookMissingStatus => '待放入';

  @override
  String get bookReadyAction => '打开并开始阅读';

  @override
  String get bookMissingAction => '准备好文件后即可打开';

  @override
  String get readerCustomBlendName => '自定义效果';

  @override
  String get readerCustomBlendNote => '按你的习惯调整颜色和显示方式。';

  @override
  String readerOpenPdfFailed(Object error) {
    return 'PDF 打开失败：$error';
  }

  @override
  String get readerOpenPdfTimedOut => '打开时间过长，请返回后重试。';

  @override
  String readerRenderPageFailed(Object error) {
    return '当前页渲染失败：$error';
  }

  @override
  String get readerRenderPageTimedOut => '当前页加载时间过长，请稍后再试。';

  @override
  String readerSchemeSaved(Object name) {
    return '已保存方案：$name';
  }

  @override
  String get readerSchemeDeleted => '已删除个人方案';

  @override
  String get readerSaveSchemeDialogTitle => '保存到我的方案';

  @override
  String get schemeNameLabel => '方案名称';

  @override
  String get schemeNameHint => '例如：晚间阅读柔光';

  @override
  String get cancelButton => '取消';

  @override
  String get saveButton => '保存';

  @override
  String readerCurrentSource(Object title) {
    return '正在查看 $title。对比不同效果，找到更适合你的查看方式。';
  }

  @override
  String get maskEditorTitle => '阅读效果';

  @override
  String get maskEditorSubtitle => '可以直接使用现成效果，也可以按你的习惯自定义。';

  @override
  String get presetModeLabel => '默认模式';

  @override
  String get customBlendModeLabel => '自定义效果';

  @override
  String get effectModeFieldLabel => '效果模式';

  @override
  String get effectModeDeutanCompensation => '绿弱补偿';

  @override
  String get effectModeProtanCompensation => '红弱补偿';

  @override
  String get effectModeTritanCompensation => '蓝黄补偿';

  @override
  String get effectModeSuppressBlue => '抑制蓝色';

  @override
  String get effectModeHighContrast => '高对比黑白';

  @override
  String get effectModeBlend => '柔和叠加';

  @override
  String get effectModeReplace => '替换颜色';

  @override
  String get effectModeInvert => '反色查看';

  @override
  String get effectModeDeutanCompensationHint => '把容易混在一起的红绿信息重新映射，适合绿色弱或绿色盲用户先试。';

  @override
  String get effectModeProtanCompensationHint => '把难分开的偏红信息挪到更容易察觉的通道里，适合红色弱或红色盲用户先试。';

  @override
  String get effectModeTritanCompensationHint => '重新拉开蓝色和黄色的差异，适合蓝黄辨识困难时使用。';

  @override
  String get effectModeSuppressBlueHint => '整体压低页面里的蓝色成分，并保留一部分亮度，适合蓝色区域太抢眼时使用。';

  @override
  String get effectModeHighContrastHint => '尽量丢掉颜色干扰，只强化黑白明暗和轮廓，适合先看形状和数字。';

  @override
  String get effectModeBlendHint => '在原页上柔和叠加一层颜色，适合做细微调整。';

  @override
  String get effectModeReplaceHint => '把页面主要颜色换成你选的颜色，更容易专注看明暗。';

  @override
  String get effectModeInvertHint => '直接反转页面颜色，适合需要更强反差时使用。';

  @override
  String get schemeStatColor => '颜色';

  @override
  String get schemeStatIntensity => '强度';

  @override
  String get schemeStatMode => '方式';

  @override
  String get schemeStatBlend => '混合';

  @override
  String get startCustomFromPresetButton => '从当前预设开始调整';

  @override
  String get blendModeFieldLabel => '叠加方式';

  @override
  String get redChannelLabel => '红色通道';

  @override
  String get greenChannelLabel => '绿色通道';

  @override
  String get blueChannelLabel => '蓝色通道';

  @override
  String get maskOpacityLabel => '效果强度';

  @override
  String get saveMySchemeButton => '保存到我的方案';

  @override
  String get loadCurrentPresetButton => '载入当前预设';

  @override
  String get resetCustomButton => '重置自定义';

  @override
  String get mySchemesTitle => '我的方案';

  @override
  String get noSavedSchemesDescription => '还没有保存的个人方案。先调节参数，再点“保存到我的方案”。';

  @override
  String get loadSchemeTooltip => '载入方案';

  @override
  String get deleteSchemeTooltip => '删除方案';

  @override
  String get pagePreviewTitle => '页面预览';

  @override
  String get pagePreviewSubtitle => '左侧保留原页，右侧显示当前效果，方便直接对比。';

  @override
  String get pageCounterPreparing => '准备中';

  @override
  String get pageCounterUnavailable => '不可用';

  @override
  String get previousPageButton => '上一页';

  @override
  String get nextPageButton => '下一页';

  @override
  String get jumpToPageButton => '跳转页码';

  @override
  String get currentPageUnavailable => '当前页面暂时不可用。';

  @override
  String get originalPageLabel => '原页';

  @override
  String get assistedPreviewLabel => '当前效果';

  @override
  String get viewLargeImage => '查看大图';

  @override
  String get jumpToPageDialogTitle => '跳转到指定页';

  @override
  String get pageNumberLabel => '页码';

  @override
  String pageNumberHint(int pageCount) {
    return '输入 1 - $pageCount';
  }

  @override
  String get jumpButton => '跳转';

  @override
  String invalidPageNumber(int pageCount) {
    return '请输入 1 - $pageCount 之间的页码';
  }

  @override
  String previewDialogTitle(Object title, int pageNumber) {
    return '$title · 第 $pageNumber 页';
  }

  @override
  String get closeTooltip => '关闭';

  @override
  String get defaultSchemeGreenWeakName => '绿色弱补偿';

  @override
  String get defaultSchemeGreenWeakNote => '针对常见红绿混淆做颜色重映射，让接近的绿色、黄色和棕色更容易分开。';

  @override
  String get defaultSchemeRedWeakName => '红色弱补偿';

  @override
  String get defaultSchemeRedWeakNote => '把偏红信息转到更容易察觉的颜色通道，适合红色弱先试。';

  @override
  String get defaultSchemeBlueYellowWeakName => '蓝黄补偿';

  @override
  String get defaultSchemeBlueYellowWeakNote => '重新拉开蓝色和黄色区域的差异，适合冷暖色块分不清时使用。';

  @override
  String get defaultSchemeSuppressBlueName => '抑制蓝色';

  @override
  String get defaultSchemeSuppressBlueNote => '整体压低偏蓝区域的存在感，适合蓝色标记过强、分散注意力时试用。';

  @override
  String get defaultSchemeHighContrastName => '高对比黑白';

  @override
  String get defaultSchemeHighContrastNote => '弱化颜色本身，只保留更强的明暗和轮廓，适合先看数字和形状。';

  @override
  String get defaultSchemeInvertName => '反色查看';

  @override
  String get defaultSchemeInvertNote => '把页面变成反色显示，适合在强光下或需要更高反差时查看。';

  @override
  String get defaultSchemeNoneName => '无遮罩';

  @override
  String get defaultSchemeNoneNote => '关闭效果，直接查看原页。';

  @override
  String get blendModeSoftLight => '柔光';

  @override
  String get blendModeOverlay => '叠加';

  @override
  String get blendModeMultiply => '正片叠底';

  @override
  String get blendModeScreen => '滤色';
}
