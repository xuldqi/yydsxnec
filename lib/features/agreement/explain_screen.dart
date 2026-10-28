// 解释说明页 (ExplainActivity) - 通用图文说明模板

import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../l10n/app_localizations.dart';
import '../../l10n/app_l10n_ext.dart';

class ExplainScreen extends StatelessWidget {
  final String titleKey;
  final String contentKey;
  const ExplainScreen({super.key, required this.titleKey, required this.contentKey});

  @override
  Widget build(BuildContext context) {
    final l = AppL10n.of(context);
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        title: Text(_lookup(l, titleKey)),
        backgroundColor: AppColors.surface,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Text(_lookup(l, contentKey),
            style: const TextStyle(
              color: AppColors.textSecondary, fontSize: 15, height: 1.7,
            ),
          ),
        ),
      ),
    );
  }

  String _lookup(AppL10n l, String key) {
    switch (key) {
      case 'data_collect_desc': return l.s.dataCollectDesc;
      case 'device_sync_desc': return l.s.deviceSyncDesc;
      case 'third_party_desc': return l.s.thirdPartyDesc;
      case 'coin_rule_desc': return l.s.coinRuleDesc;
      case 'task_rule_desc': return l.s.taskRuleDesc;
      case 'invite_rule_desc': return l.s.inviteRuleDesc;
    }
    return key;
  }
}
