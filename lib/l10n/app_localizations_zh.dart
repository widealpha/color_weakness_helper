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
  String get effectModeDeutanCompensation => '绿弱补偿增强';

  @override
  String get effectModeProtanCompensation => '红弱补偿增强';

  @override
  String get effectModeRedGreenPulse => '红绿快速交替';

  @override
  String get effectModeRedGreenReversePulse => '双弱静态组合';

  @override
  String get effectModeTritanCompensation => '蓝黄补偿增强';

  @override
  String get effectModeHighContrast => '高对比黑白';

  @override
  String get effectModeBlend => '柔和叠加';

  @override
  String get effectModeReplace => '替换颜色';

  @override
  String get effectModeInvert => '反色查看';

  @override
  String get effectModeDeutanCompensationHint => '先模拟绿色通道缺失，再把丢失的差异转移到红色和蓝色对比里，适合常见红绿混淆先试。';

  @override
  String get effectModeProtanCompensationHint => '先模拟红色通道缺失，再把红色差异转移到绿色和蓝色线索里，适合红色偏暗或消失时使用。';

  @override
  String get effectModeRedGreenPulseHint => '每 0.4 秒在红弱增强和绿弱增强之间硬切换，利用时间对比帮助看出红绿差异。';

  @override
  String get effectModeRedGreenReversePulseHint => '静态叠加任意两个弱模式或反向差分，用更强的空间反差测试色块区域是否更容易分离。';

  @override
  String get effectModeTritanCompensationHint => '先模拟蓝色通道缺失，再把蓝黄差异转移到红绿线索里，适合蓝黄区域难分时使用。';

  @override
  String get effectModeHighContrastHint => '尽量丢掉颜色干扰，只强化黑白明暗和轮廓，适合先看形状和数字。';

  @override
  String get effectModeBlendHint => '在原页上柔和叠加一层颜色，适合做细微调整。';

  @override
  String get effectModeReplaceHint => '把页面主要颜色换成你选的颜色，更容易专注看明暗。';

  @override
  String get effectModeInvertHint => '直接反转页面颜色，适合需要更强反差时使用。';

  @override
  String get matrixPassFirstLabel => '第一弱模式';

  @override
  String get matrixPassSecondLabel => '第二弱模式';

  @override
  String get matrixPassDeutanCompensation => '绿弱增强';

  @override
  String get matrixPassProtanCompensation => '红弱增强';

  @override
  String get matrixPassTritanCompensation => '蓝黄增强';

  @override
  String get matrixPassDeutanReverse => '反向绿弱差分';

  @override
  String get matrixPassProtanReverse => '反向红弱差分';

  @override
  String get matrixPassTritanReverse => '反向蓝黄差分';

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
  String get defaultSchemeGreenWeakName => '绿弱增强';

  @override
  String get defaultSchemeGreenWeakNote => '使用 Daltonization 思路：模拟绿色通道损失，并把丢失差异转移到更容易分辨的红蓝对比。';

  @override
  String get defaultSchemeRedWeakName => '红弱增强';

  @override
  String get defaultSchemeRedWeakNote => '把红色相关差异重分配到绿蓝线索，适合红色偏暗、红绿难分时优先尝试。';

  @override
  String get defaultSchemeRedGreenPulseName => '红绿快速交替';

  @override
  String get defaultSchemeRedGreenPulseNote => '每 0.4 秒硬切一次红弱增强和绿弱增强，让色块变化变成更明显的时间对比。';

  @override
  String get defaultSchemeRedGreenReversePulseName => '红弱+反向绿弱';

  @override
  String get defaultSchemeRedGreenReversePulseNote => '静态叠加红弱增强和绿弱反向差分，适合测试更强红绿分离是否更清楚。';

  @override
  String get defaultSchemeBlueYellowWeakName => '蓝黄增强';

  @override
  String get defaultSchemeBlueYellowWeakNote => '把蓝黄色差转移到红绿线索，帮助冷暖色块和图谱数字更容易分离。';

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
