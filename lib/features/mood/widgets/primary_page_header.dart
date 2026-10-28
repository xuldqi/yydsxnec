import 'package:flutter/material.dart';

class PrimaryPageLayout {
  static const double horizontalPadding = 20;
  static const double titleTopOffset = 8;
  static const double headerHeightOffset = 88;
  static const double titleSubtitleGap = 8;
}

class PrimaryPageHeader extends StatelessWidget {
  const PrimaryPageHeader({
    super.key,
    required this.safeTop,
    required this.title,
    required this.subtitle,
    required this.titleColor,
    required this.subtitleColor,
    this.trailing,
    this.leadingWidth = 0,
  });

  final double safeTop;
  final String title;
  final String subtitle;
  final Color titleColor;
  final Color subtitleColor;
  final Widget? trailing;
  final double leadingWidth;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          left: PrimaryPageLayout.horizontalPadding + leadingWidth,
          top: safeTop + PrimaryPageLayout.titleTopOffset,
          right: trailing == null ? PrimaryPageLayout.horizontalPadding : 88,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.w900,
                  color: titleColor,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: PrimaryPageLayout.titleSubtitleGap),
              Text(
                subtitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 15, color: subtitleColor),
              ),
            ],
          ),
        ),
        if (trailing != null)
          Positioned(
            top: safeTop + PrimaryPageLayout.titleTopOffset,
            right: PrimaryPageLayout.horizontalPadding,
            child: trailing!,
          ),
      ],
    );
  }
}
