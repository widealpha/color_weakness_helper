import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class AppPanel extends StatelessWidget {
  const AppPanel({
    super.key,
    required this.title,
    required this.subtitle,
    required this.child,
    this.trailing,
    this.expandChild = false,
  });

  final String title;
  final String subtitle;
  final Widget child;
  final Widget? trailing;
  final bool expandChild;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final compact = constraints.maxWidth < 420;
        final padding = compact ? 14.0 : 20.0;
        final radius = compact ? 20.0 : 28.0;

        return Container(
          width: double.infinity,
          padding: EdgeInsets.all(padding),
          decoration: BoxDecoration(
            color: AppTheme.panelBackground(context),
            borderRadius: BorderRadius.circular(radius),
            border: Border.all(color: AppTheme.panelBorder(context)),
            boxShadow: AppTheme.panelShadows(context),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              if (compact)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    _PanelHeading(
                      title: title,
                      subtitle: subtitle,
                      colorScheme: colorScheme,
                    ),
                    if (trailing != null) ...<Widget>[
                      const SizedBox(height: 12),
                      Align(alignment: Alignment.centerLeft, child: trailing!),
                    ],
                  ],
                )
              else
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      child: _PanelHeading(
                        title: title,
                        subtitle: subtitle,
                        colorScheme: colorScheme,
                      ),
                    ),
                    if (trailing != null) ...<Widget>[
                      const SizedBox(width: 16),
                      Flexible(child: trailing!),
                    ],
                  ],
                ),
              SizedBox(height: subtitle.isEmpty ? 14 : 18),
              if (expandChild) Expanded(child: child) else child,
            ],
          ),
        );
      },
    );
  }
}

class _PanelHeading extends StatelessWidget {
  const _PanelHeading({
    required this.title,
    required this.subtitle,
    required this.colorScheme,
  });

  final String title;
  final String subtitle;
  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          title,
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
        ),
        if (subtitle.isNotEmpty) ...<Widget>[
          const SizedBox(height: 6),
          Text(
            subtitle,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
              height: 1.45,
            ),
          ),
        ],
      ],
    );
  }
}
