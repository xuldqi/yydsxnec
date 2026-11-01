import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'capybara_expedition_card.dart';

/// 水豚主角探索卡片（复刻 Yoomy 动态探索山景画卷）
class CapybaraHeroCard extends ConsumerWidget {
  final bool showHeader;
  const CapybaraHeroCard({super.key, this.showHeader = true});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CapybaraExpeditionCard(showHeader: showHeader);
  }
}
