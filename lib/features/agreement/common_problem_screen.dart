// 常见问题页 (CommonProblemActivity)

import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../l10n/app_localizations.dart';
import '../../l10n/app_l10n_ext.dart';

class CommonProblemScreen extends StatelessWidget {
  const CommonProblemScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppL10n.of(context);
    final faqs = <_Faq>[
      _Faq(l.s.faq1q, l.s.faq1a),
      _Faq(l.s.faq2q, l.s.faq2a),
      _Faq(l.s.faq3q, l.s.faq3a),
      _Faq(l.s.faq4q, l.s.faq4a),
      _Faq(l.s.faq5q, l.s.faq5a),
      _Faq(l.s.faq6q, l.s.faq6a),
      _Faq(l.s.faq7q, l.s.faq7a),
      _Faq(l.s.faq8q, l.s.faq8a),
    ];
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(l.s.commonProblem),
        backgroundColor: AppColors.surface,
        elevation: 0,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(12),
        itemCount: faqs.length,
        separatorBuilder: (_, __) => const SizedBox(height: 10),
        itemBuilder: (_, i) {
          final f = faqs[i];
          return Container(
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Theme(
              data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
              child: ExpansionTile(
                title: Text(f.q,
                  style: const TextStyle(
                    color: AppColors.textPrimary, fontSize: 15, fontWeight: FontWeight.w600,
                  ),
                ),
                iconColor: AppColors.textHint,
                collapsedIconColor: AppColors.textHint,
                childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                children: [
                  Text(f.a,
                    style: const TextStyle(
                      color: AppColors.textSecondary, fontSize: 14, height: 1.6,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _Faq {
  final String q, a;
  const _Faq(this.q, this.a);
}
