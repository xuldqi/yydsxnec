// 健康 Tab - 1:1 对齐 Android fragment_main.xml
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';

class HealthScreen extends StatefulWidget {
  const HealthScreen({super.key});
  @override
  State<HealthScreen> createState() => _HealthScreenState();
}

class _HealthScreenState extends State<HealthScreen> {
  int _viewIndex = 0; // 0=步数, 1=活动

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(18, 14, 18, 40),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            // 标题行
            Text('健康', style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
            const SizedBox(height: 14),

            // 今日活动卡片
            _todayStepsCard(),
            const SizedBox(height: 14),

            // 快捷操作
            _quickActionsCard(),
            const SizedBox(height: 14),

    // 健康中心 + 扫描入口
    _healthCenterCard(),
    const SizedBox(height: 14),

    // 身体成分总结
    _bodyCompSummaryCard(),
            const SizedBox(height: 14),

            // 健康记录
            _healthRecordCard('饮水 / 饮食', '', () => context.push('/water')),
            const SizedBox(height: 8),
            _healthRecordCard('睡眠 / 心情', '', () => context.push('/sleep')),
            const SizedBox(height: 8),
            _healthRecordCard('断食 / 运动', '', () => context.push('/fasting')),
            const SizedBox(height: 14),

            // 健康总结
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(20)),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('健康评分', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.textPrimary)),
                const SizedBox(height: 8),
                Row(children: [
                  const Text('82', style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: AppColors.primary)),
                  const SizedBox(width: 8),
                  const Text('/100', style: TextStyle(color: AppColors.textHint, fontSize: 14)),
                  const Spacer(),
                  Text('状态良好，继续坚持', style: const TextStyle(color: AppColors.textHint, fontSize: 12)),
                ]),
                const SizedBox(height: 8),
                LinearProgressIndicator(value: 0.82, minHeight: 4, backgroundColor: AppColors.divider, valueColor: const AlwaysStoppedAnimation(AppColors.primary)),
              ]),
            ),
          ]),
        ),
      ),
    );
  }

  // ========== 今日步数卡片 ==========
  Widget _todayStepsCard() {
    return Container(
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(24)),
      child: Column(children: [
        // Tab 切换栏
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 15, 18, 4),
          child: Row(children: [
            _tab('步数', 0), const SizedBox(width: 14), _tab('活动', 1),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 6),
              decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(15)),
              child: const Text('每日目标', style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
            ),
          ]),
        ),
        // ViewFlipper 内容区
        SizedBox(height: _viewIndex == 0 ? null : 138, child: IndexedStack(index: _viewIndex, children: [
          _stepsView(), _goalsView(),
        ])),
      ]),
    );
  }

  // 步数视图 (Slide 1)
  Widget _stepsView() {
    return SizedBox(
      height: 138,
      child: Stack(children: [
        Positioned(
          right: 0, bottom: 6,
          child: Container(
            width: 232, height: 126,
            decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(12)),
            child: const Icon(Icons.directions_run_rounded, size: 80, color: AppColors.sportRun),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20, top: 22),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
            Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
              const Text('8,256', style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
              const SizedBox(width: 4),
              const Padding(
                padding: EdgeInsets.only(bottom: 6),
                child: Text('目标 10,000', style: TextStyle(fontSize: 16, color: AppColors.textHint)),
              ),
            ]),
            const SizedBox(height: 12),
            const Text('卡路里 312 千卡 · 时长 48 分钟 · 次数 3 次', style: TextStyle(fontSize: 13, color: AppColors.textHint)),
          ]),
        ),
      ]),
    );
  }

  // 活动视图 (Slide 2) - 3个进度环
  Widget _goalsView() {
    return Row(children: [
      _goalRing('卡路里', '312', '千卡', AppColors.warning, 0.35),
      _goalRing('时间', '48', '分钟', AppColors.primary, 0.52),
      _goalRing('次数', '3', '次', AppColors.sportOther, 0.83),
    ]);
  }

  Widget _goalRing(String label, String value, String unit, Color color, double pct) {
    return Expanded(child: Column(children: [
      Stack(alignment: Alignment.center, children: [
        SizedBox(width: 74, height: 74, child: CircularProgressIndicator(value: pct, strokeWidth: 8, color: color, backgroundColor: color.withValues(alpha: 0.12))),
        Text(label, style: const TextStyle(fontSize: 11, color: AppColors.textPrimary)),
      ]),
      const SizedBox(height: 6),
      Text(value, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
      Text(unit, style: const TextStyle(fontSize: 10, color: AppColors.textHint)),
    ]));
  }

  Widget _tab(String text, int idx) {
    final sel = _viewIndex == idx;
    return GestureDetector(
      onTap: () => setState(() => _viewIndex = idx),
      child: Text(text, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: sel ? AppColors.textPrimary : AppColors.textHint)),
    );
  }

  // ========== 快捷操作卡片 ==========
  Widget _quickActionsCard() {
    return Container(
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(20)),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 13),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
        _quickItem('健身动作', Icons.fitness_center_rounded, AppColors.sportOther, '/movement-library'),
        _quickItem('呼吸放松', Icons.self_improvement_rounded, AppColors.sportOther, '/meditation'),
        _quickItem('助眠音', Icons.headphones_rounded, AppColors.sportOther, '/white-noise'),
        _quickItem('训练计划', Icons.assignment_rounded, AppColors.sportWalk, '/training-plan'),
        _quickItem('时间计时', Icons.timer_rounded, AppColors.primary, '/count-time'),
      ]),
    );
  }

  Widget _quickItem(String label, IconData icon, Color color, String route) {
    return GestureDetector(
      onTap: () => context.push(route),
      child: Column(children: [
        Container(width: 58, height: 58, decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(16)), child: Icon(icon, color: color, size: 28)),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
      ]),
    );
  }

  // ========== 健康中心卡片 ==========
  Widget _healthCenterCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(20)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('健康中心', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.textPrimary)),
        const SizedBox(height: 8),
        const Text('82 / 100', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppColors.primary)),
      ]),
    );
  }

  // ========== 身体成分总结 ==========
  Widget _bodyCompSummaryCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(20)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Text('身体成分', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.textPrimary)),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
            child: GestureDetector(
              onTap: () => context.push('/body-record'),
              child: Text('快速记录', style: const TextStyle(fontSize: 12, color: AppColors.primary, fontWeight: FontWeight.w600)),
            ),
          ),
        ]),
        const SizedBox(height: 10),
        Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
          _compStat('体重', '65.0 kg'),
          _compStat('BMI', '22.3'),
          _compStat('体脂', '18.5%'),
          _compStat('腰围', '78 cm'),
        ]),
        const SizedBox(height: 8),
        Text('体重正常，BMI 22.3', style: const TextStyle(fontSize: 12, color: AppColors.textHint)),
      ]),
    );
  }

  Widget _compStat(String label, String value) {
    return Column(children: [
      Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: AppColors.textPrimary)),
      Text(label, style: const TextStyle(fontSize: 11, color: AppColors.textHint)),
    ]);
  }

  // ========== 健康记录卡片 ==========
  Widget _healthRecordCard(String title, String subtitle, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(16)),
        child: Row(children: [
          Expanded(child: Text(title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: AppColors.textPrimary))),
          const Icon(Icons.chevron_right_rounded, color: AppColors.textHint, size: 20),
        ]),
      ),
    );
  }
}

// 缺少的 l10n key
