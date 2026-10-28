// 协议页 (YSXYActivity) - 通用隐私/用户协议展示

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/theme/app_colors.dart';
import '../../l10n/app_localizations.dart';
import '../../l10n/app_l10n_ext.dart';

class AgreementScreen extends StatelessWidget {
  final bool isPrivacy;
  const AgreementScreen({super.key, this.isPrivacy = true});

  @override
  Widget build(BuildContext context) {
    final l = AppL10n.of(context);
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        title: Text(isPrivacy ? l.s.privacyPolicy : l.s.userAgreement),
        backgroundColor: AppColors.surface,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isPrivacy ? l.s.privacyPolicy : l.s.userAgreement,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 24, fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                isPrivacy ? l.s.privacyUpdateTime : l.s.agreementUpdateTime,
                style: const TextStyle(color: AppColors.textHint, fontSize: 12),
              ),
              const SizedBox(height: 24),
              if (isPrivacy) _privacyContent(l) else _agreementContent(l),
            ],
          ),
        ),
      ),
    );
  }

  Widget _privacyContent(AppL10n l) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _h(l.s.privacyIntro),
        _p(l.s.privacyIntroContent),
        _h(l.s.privacyInfoCollect),
        _p(l.s.privacyInfoCollectContent),
        _h(l.s.privacyInfoUse),
        _p(l.s.privacyInfoUseContent),
        _h(l.s.privacyInfoShare),
        _p(l.s.privacyInfoShareContent),
        _h(l.s.privacyInfoStorage),
        _p(l.s.privacyInfoStorageContent),
        _h(l.s.privacyContact),
        _p(l.s.privacyContactContent),
      ],
    );
  }

  Widget _agreementContent(AppL10n l) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _h(l.s.agreementIntro),
        _p(l.s.agreementIntroContent),
        _h(l.s.agreementService),
        _p(l.s.agreementServiceContent),
        _h(l.s.agreementUserRights),
        _p(l.s.agreementUserRightsContent),
        _h(l.s.agreementDisclaimer),
        _p(l.s.agreementDisclaimerContent),
        _h(l.s.agreementChange),
        _p(l.s.agreementChangeContent),
      ],
    );
  }

  Widget _h(String s) => Padding(
    padding: const EdgeInsets.only(top: 16, bottom: 8),
    child: Text(s,
      style: const TextStyle(color: AppColors.textPrimary, fontSize: 16, fontWeight: FontWeight.bold)),
  );

  Widget _p(String s) => Text(s,
    style: const TextStyle(color: AppColors.textSecondary, fontSize: 14, height: 1.7),
  );
}
