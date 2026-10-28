import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:steps_webu_flutter/core/theme/app_colors.dart';
import '../models/user_profile.dart';
import '../providers/user_settings_provider.dart';
import '../providers/fasting_provider.dart';
import '../providers/weight_provider.dart';
import 'main_screen.dart';
import '../models/fasting_plan.dart';
import 'package:flutter/cupertino.dart';

class OnboardingPage extends ConsumerStatefulWidget {
  const OnboardingPage({super.key});

  @override
  ConsumerState<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends ConsumerState<OnboardingPage> {
  final PageController _pageController = PageController();
  static const int _pageCount = 6;
  int _currentPage = 0;

  // Form states
  String _goal = '减重'; // 减重, 健康, 精力
  bool _hasHealthRisk = false;
  bool _riskAcknowledged = false;
  String _gender = 'M';
  int _birthYear = 1990;
  double _height = 170.0;
  double _weight = 70.0;
  double _targetWeight = 65.0;
  TimeOfDay _wakeTime = const TimeOfDay(hour: 7, minute: 0);
  TimeOfDay _sleepTime = const TimeOfDay(hour: 23, minute: 0);

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (!_canContinue) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('请先确认健康风险提示')));
      return;
    }

    if (_currentPage < _pageCount - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _completeOnboarding();
    }
  }

  bool get _canContinue {
    if (_currentPage == 1 && _hasHealthRisk && !_riskAcknowledged) {
      return false;
    }
    return true;
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  Future<void> _completeOnboarding() async {
    // 1. Create Profile
    final profile = UserProfile(
      gender: _gender,
      heightCm: _height,
      targetWeightKg: _targetWeight,
      birthDate: DateTime(_birthYear, 1, 1),
    );
    await ref.read(userProfileProvider.notifier).updateUserProfile(profile);

    // 2. Add Initial Weight Record
    try {
      await ref.read(weightRecordsProvider.notifier).addRecord(weight: _weight);
    } catch (_) {}

    // 3. Mark complete
    await ref
        .read(hasCompletedOnboardingProvider.notifier)
        .completeOnboarding();

    // 4. Recommended plan based on goals
    final plansAsync = ref.read(fastingPlansProvider);
    final plans = plansAsync.valueOrNull ?? FastingPlan.presetPlans;
    if (plans.isNotEmpty) {
      final recommended = _goal == '减重' ? 'preset_16_8' : 'preset_14_10';
      final plan = plans.firstWhere(
        (p) => p.id == recommended,
        orElse: () => plans.first,
      );
      ref.read(currentFastingPlanProvider.notifier).state = plan;
    }

    if (mounted) {
      Navigator.of(
        context,
      ).pushReplacement(MaterialPageRoute(builder: (_) => const MainScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildProgressIndicator(),
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                onPageChanged: (idx) {
                  setState(() {
                    _currentPage = idx;
                  });
                },
                children: [
                  _buildGoalPage(),
                  _buildHealthSafetyPage(),
                  _buildBodyProfilePage(),
                  _buildWeightPage(),
                  _buildTimePage(),
                  _buildRecommendationPage(),
                ],
              ),
            ),
            _buildBottomControls(),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
      child: Row(
        children: List.generate(_pageCount, (index) {
          return Expanded(
            child: Container(
              height: 4,
              margin: const EdgeInsets.symmetric(horizontal: 2),
              decoration: BoxDecoration(
                color: index <= _currentPage
                    ? AppColors.primary
                    : AppColors.primary.withValues(alpha: 0.18),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildBottomControls() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (_currentPage > 0)
            TextButton(
              onPressed: _previousPage,
              style: TextButton.styleFrom(
                minimumSize: const Size(80, 48),
                foregroundColor: AppColors.textSecondary,
              ),
              child: const Text('上一步'),
            )
          else
            const SizedBox(width: 80),
          ElevatedButton(
            onPressed: _canContinue ? _nextPage : null,
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(120, 48),
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24.0),
              ),
              elevation: 0,
            ),
            child: Text(
              _currentPage == _pageCount - 1 ? '开始我的轻断食' : '下一步',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHealthSafetyPage() {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            '开始前，先确认身体状况',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          const Text(
            '轻断食不适合所有人。以下情况建议先咨询医生。',
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
          ),
          const SizedBox(height: 28),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.warning.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(24.0),
              border: Border.all(
                color: AppColors.warning.withValues(alpha: 0.28),
              ),
            ),
            child: const Text(
              '孕期或哺乳期、未成年人、糖尿病或低血糖、进食障碍史、慢性疾病、正在服药、BMI 过低或近期身体不适。',
              style: TextStyle(
                color: AppColors.textPrimary,
                height: 1.5,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(height: 24),
          _SelectionCard(
            title: '没有以上情况',
            subtitle: '我会根据身体反应调整计划',
            isSelected: !_hasHealthRisk,
            onTap: () => setState(() {
              _hasHealthRisk = false;
              _riskAcknowledged = false;
            }),
          ),
          const SizedBox(height: 14),
          _SelectionCard(
            title: '有或不确定',
            subtitle: '继续前需要确认风险提示',
            isSelected: _hasHealthRisk,
            onTap: () => setState(() => _hasHealthRisk = true),
          ),
          if (_hasHealthRisk) ...[
            const SizedBox(height: 16),
            CheckboxListTile(
              value: _riskAcknowledged,
              onChanged: (value) {
                setState(() => _riskAcknowledged = value ?? false);
              },
              controlAffinity: ListTileControlAffinity.leading,
              contentPadding: EdgeInsets.zero,
              title: const Text(
                '我知道本应用不能替代医疗建议，会先咨询医生或选择更温和的健康记录方式。',
                style: TextStyle(fontSize: 14, height: 1.4),
              ),
            ),
          ],
        ],
      ),
    );
  }

  // --- Pages ---

  Widget _buildGoalPage() {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            '你最想通过断食达成什么？',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          const Text(
            '我们会为你定制最合适的专属计划',
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
          ),
          const SizedBox(height: 48),
          _SelectionCard(
            title: '减重燃脂',
            subtitle: '消耗多余脂肪，塑造理想体型',
            isSelected: _goal == '减重',
            onTap: () => setState(() => _goal = '减重'),
          ),
          const SizedBox(height: 16),
          _SelectionCard(
            title: '保持健康',
            subtitle: '提升免疫力，重置身体代谢',
            isSelected: _goal == '健康',
            onTap: () => setState(() => _goal = '健康'),
          ),
          const SizedBox(height: 16),
          _SelectionCard(
            title: '精力管理',
            subtitle: '让大脑更清晰，工作更高效',
            isSelected: _goal == '精力',
            onTap: () => setState(() => _goal = '精力'),
          ),
        ],
      ),
    );
  }

  Widget _buildBodyProfilePage() {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '让我们更好地了解你',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          const Text(
            '用于计算您的 BMI 和推荐饮水量',
            style: TextStyle(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 40),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _GenderCard(
                icon: Icons.male,
                title: '男性',
                isSelected: _gender == 'M',
                onTap: () => setState(() => _gender = 'M'),
              ),
              _GenderCard(
                icon: Icons.female,
                title: '女性',
                isSelected: _gender == 'F',
                onTap: () => setState(() => _gender = 'F'),
              ),
            ],
          ),
          const SizedBox(height: 40),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  const Text(
                    '出生年份',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 120,
                    width: 100,
                    child: CupertinoPicker(
                      itemExtent: 40,
                      scrollController: FixedExtentScrollController(
                        initialItem: _birthYear - 1950,
                      ),
                      selectionOverlay: Container(
                        decoration: BoxDecoration(
                          border: Border(
                            top: BorderSide(
                              color: AppColors.primary.withValues(
                                alpha: 0.3,
                              ),
                            ),
                            bottom: BorderSide(
                              color: AppColors.primary.withValues(
                                alpha: 0.3,
                              ),
                            ),
                          ),
                        ),
                      ),
                      onSelectedItemChanged: (idx) =>
                          setState(() => _birthYear = idx + 1950),
                      children: List.generate(
                        70,
                        (i) => Center(
                          child: Text(
                            '${i + 1950}',
                            style: const TextStyle(fontSize: 20),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  const Text(
                    '身高 (cm)',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 120,
                    width: 100,
                    child: CupertinoPicker(
                      itemExtent: 40,
                      scrollController: FixedExtentScrollController(
                        initialItem: _height.toInt() - 100,
                      ),
                      selectionOverlay: Container(
                        decoration: BoxDecoration(
                          border: Border(
                            top: BorderSide(
                              color: AppColors.primary.withValues(
                                alpha: 0.3,
                              ),
                            ),
                            bottom: BorderSide(
                              color: AppColors.primary.withValues(
                                alpha: 0.3,
                              ),
                            ),
                          ),
                        ),
                      ),
                      onSelectedItemChanged: (idx) =>
                          setState(() => _height = (idx + 100).toDouble()),
                      children: List.generate(
                        120,
                        (i) => Center(
                          child: Text(
                            '${i + 100}',
                            style: const TextStyle(fontSize: 20),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWeightPage() {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '记录你的体重目标',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 48),
          const Text(
            '当前体重 (kg)',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 140,
            child: CupertinoPicker(
              itemExtent: 48,
              scrollController: FixedExtentScrollController(
                initialItem: (_weight * 10).toInt() - 300,
              ),
              selectionOverlay: Container(
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      color: AppColors.primary.withValues(alpha: 0.3),
                    ),
                    bottom: BorderSide(
                      color: AppColors.primary.withValues(alpha: 0.3),
                    ),
                  ),
                ),
              ),
              onSelectedItemChanged: (idx) =>
                  setState(() => _weight = (idx + 300) / 10),
              children: List.generate(
                1200,
                (i) => Center(
                  child: Text(
                    '${(i + 300) / 10}',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 40),
          const Text(
            '目标体重 (kg)',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 140,
            child: CupertinoPicker(
              itemExtent: 48,
              scrollController: FixedExtentScrollController(
                initialItem: (_targetWeight * 10).toInt() - 300,
              ),
              selectionOverlay: Container(
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      color: AppColors.primary.withValues(alpha: 0.3),
                    ),
                    bottom: BorderSide(
                      color: AppColors.primary.withValues(alpha: 0.3),
                    ),
                  ),
                ),
              ),
              onSelectedItemChanged: (idx) =>
                  setState(() => _targetWeight = (idx + 300) / 10),
              children: List.generate(
                1200,
                (i) => Center(
                  child: Text(
                    '${(i + 300) / 10}',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimePage() {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '你的日常作息是？',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            '我们将据此为你推荐进食窗口',
            style: TextStyle(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 48),

          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(24.0),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Row(
                  children: [
                    Icon(Icons.wb_sunny_outlined, color: AppColors.warning),
                    SizedBox(width: 12),
                    Text('平时几点起床', style: TextStyle(fontSize: 16)),
                  ],
                ),
                GestureDetector(
                  onTap: () async {
                    final t = await showTimePicker(
                      context: context,
                      initialTime: _wakeTime,
                    );
                    if (t != null) setState(() => _wakeTime = t);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '${_wakeTime.hour.toString().padLeft(2, '0')}:${_wakeTime.minute.toString().padLeft(2, '0')}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(24.0),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Row(
                  children: [
                    Icon(
                      Icons.nightlight_outlined,
                      color: AppColors.primary,
                    ),
                    SizedBox(width: 12),
                    Text('平时几点睡觉', style: TextStyle(fontSize: 16)),
                  ],
                ),
                GestureDetector(
                  onTap: () async {
                    final t = await showTimePicker(
                      context: context,
                      initialTime: _sleepTime,
                    );
                    if (t != null) setState(() => _sleepTime = t);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '${_sleepTime.hour.toString().padLeft(2, '0')}:${_sleepTime.minute.toString().padLeft(2, '0')}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendationPage() {
    final recommended = _goal == '减重' ? '16:8 断食法' : '14:10 断食法';
    final desc = _goal == '减重'
        ? '最经典的燃脂计划。建议在 ${_wakeTime.hour + 4}:00 - ${_wakeTime.hour + 12}:00 之间进食。'
        : '温和的健康计划。建议在 ${_wakeTime.hour + 2}:00 - ${_wakeTime.hour + 12}:00 之间进食。';

    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.auto_awesome,
            size: 60,
            color: AppColors.warning,
          ),
          const SizedBox(height: 24),
          Text(
            '为你量身定制',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 48),
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(16.0),
              border: Border.all(
                color: AppColors.primary.withValues(alpha: 0.22),
              ),
            ),
            child: Column(
              children: [
                Text(
                  recommended,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  desc,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16, height: 1.5),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          const Text(
            '开始后，你依然可以在“计划”页面随时更换其他方案。',
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}

class _GenderCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const _GenderCard({
    required this.icon,
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 120,
        height: 120,
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withValues(alpha: 0.08)
              : AppColors.surface,
          borderRadius: BorderRadius.circular(16.0),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.divider,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 40,
              color: isSelected
                  ? AppColors.primary
                  : AppColors.textSecondary,
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: TextStyle(
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected
                    ? AppColors.primary
                    : AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SelectionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool isSelected;
  final VoidCallback onTap;

  const _SelectionCard({
    required this.title,
    required this.subtitle,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withValues(alpha: 0.08)
              : AppColors.surface,
          borderRadius: BorderRadius.circular(24.0),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.divider,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isSelected
                          ? AppColors.primary
                          : AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              const Icon(Icons.check_circle, color: AppColors.primary),
          ],
        ),
      ),
    );
  }
}
