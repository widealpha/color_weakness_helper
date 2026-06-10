import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:color_weakness_helper/data/default_mask_schemes.dart';
import 'package:color_weakness_helper/l10n/app_localizations.dart';
import 'package:color_weakness_helper/models/editor_mode.dart';
import 'package:color_weakness_helper/models/mask_scheme.dart';
import 'package:color_weakness_helper/theme/app_theme.dart';
import 'package:color_weakness_helper/widgets/mask_editor_panel.dart';

void main() {
  testWidgets('mask editor adapts to narrow viewport', (
    WidgetTester tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(320, 760));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      _ResponsiveHarness(
        childBuilder: (BuildContext context) {
          final schemes = localizedDefaultMaskSchemes(
            AppLocalizations.of(context)!,
          );
          return MaskEditorPanel(
            mode: EditorMode.custom,
            defaultSchemes: schemes,
            selectedDefaultSchemeIndex: 0,
            savedSchemes: _savedSchemes,
            isLoadingSavedSchemes: false,
            customColor: const Color(0xFF2A9D8F),
            customOpacity: 0.82,
            customRed: 42,
            customGreen: 157,
            customBlue: 143,
            customEffectMode: MaskEffectMode.redGreenReversePulse,
            customFirstMatrixPass: MaskMatrixPass.protanCompensation,
            customSecondMatrixPass: MaskMatrixPass.deutanReverse,
            customBlendMode: BlendMode.overlay,
            onModeChanged: (_) {},
            onDefaultSchemeSelected: (_) {},
            onStartCustomFromDefault: () {},
            onEffectModeChanged: (_) {},
            onFirstMatrixPassChanged: (_) {},
            onSecondMatrixPassChanged: (_) {},
            onBlendModeChanged: (_) {},
            onRedChanged: (_) {},
            onGreenChanged: (_) {},
            onBlueChanged: (_) {},
            onOpacityChanged: (_) {},
            onResetCustom: () {},
            onSaveCustomScheme: () {},
            onLoadSavedScheme: (_) {},
            onDeleteSavedScheme: (_) {},
          );
        },
      ),
    );

    await tester.pumpAndSettle();

    expect(find.byType(MaskEditorPanel), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('mask editor uses available room on wide viewport', (
    WidgetTester tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(1200, 900));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      _ResponsiveHarness(
        childBuilder: (BuildContext context) {
          final schemes = localizedDefaultMaskSchemes(
            AppLocalizations.of(context)!,
          );
          return MaskEditorPanel(
            mode: EditorMode.preset,
            defaultSchemes: schemes,
            selectedDefaultSchemeIndex: 0,
            savedSchemes: _savedSchemes,
            isLoadingSavedSchemes: false,
            customColor: const Color(0xFF2A9D8F),
            customOpacity: 0.82,
            customRed: 42,
            customGreen: 157,
            customBlue: 143,
            customEffectMode: MaskEffectMode.blend,
            customFirstMatrixPass: MaskMatrixPass.deutanCompensation,
            customSecondMatrixPass: MaskMatrixPass.protanCompensation,
            customBlendMode: BlendMode.overlay,
            onModeChanged: (_) {},
            onDefaultSchemeSelected: (_) {},
            onStartCustomFromDefault: () {},
            onEffectModeChanged: (_) {},
            onFirstMatrixPassChanged: (_) {},
            onSecondMatrixPassChanged: (_) {},
            onBlendModeChanged: (_) {},
            onRedChanged: (_) {},
            onGreenChanged: (_) {},
            onBlueChanged: (_) {},
            onOpacityChanged: (_) {},
            onResetCustom: () {},
            onSaveCustomScheme: () {},
            onLoadSavedScheme: (_) {},
            onDeleteSavedScheme: (_) {},
          );
        },
      ),
    );

    await tester.pumpAndSettle();

    expect(find.byType(MaskEditorPanel), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}

class _ResponsiveHarness extends StatelessWidget {
  const _ResponsiveHarness({required this.childBuilder});

  final WidgetBuilder childBuilder;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppTheme.build(Brightness.light),
      localizationsDelegates: const <LocalizationsDelegate<dynamic>>[
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      locale: const Locale('zh'),
      home: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(12),
            child: Builder(builder: childBuilder),
          ),
        ),
      ),
    );
  }
}

const List<MaskScheme> _savedSchemes = <MaskScheme>[
  MaskScheme(
    id: 'saved-wide-name',
    name: '夜间阅读柔光方案',
    note: '保存项用于验证窄屏下文本和操作按钮布局',
    color: Color(0xFF2A9D8F),
    opacity: 0.82,
    blendMode: BlendMode.overlay,
    effectMode: MaskEffectMode.redGreenReversePulse,
    firstMatrixPass: MaskMatrixPass.protanCompensation,
    secondMatrixPass: MaskMatrixPass.deutanReverse,
  ),
];
