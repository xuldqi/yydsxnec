// 日历汇总 + 扫描历史 + 版本说明
import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimens.dart';

class CalenderScreen extends StatefulWidget {
  const CalenderScreen({super.key});
  @override
  State<CalenderScreen> createState() => _CalenderScreenState();
}

class _CalenderScreenState extends State<CalenderScreen> {
  DateTime _month = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final daysInMonth = DateTime(_month.year, _month.month + 1, 0).day;
    return Scaffold(
      appBar: AppBar(
        title: Text('${_month.year}年${_month.month}月'),
        actions: [
          IconButton(icon: const Icon(Icons.chevron_left), onPressed: () => setState(() => _month = DateTime(_month.year, _month.month - 1, 1))),
          IconButton(icon: const Icon(Icons.chevron_right), onPressed: () => setState(() => _month = DateTime(_month.year, _month.month + 1, 1))),
        ],
      ),
      body: Column(children: [
        Padding(
          padding: const EdgeInsets.all(AppDimens.spacingMd),
          child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: const [
            Text('一', style: TextStyle(color: AppColors.textHint, fontSize: 12)),
            Text('二', style: TextStyle(color: AppColors.textHint, fontSize: 12)),
            Text('三', style: TextStyle(color: AppColors.textHint, fontSize: 12)),
            Text('四', style: TextStyle(color: AppColors.textHint, fontSize: 12)),
            Text('五', style: TextStyle(color: AppColors.textHint, fontSize: 12)),
            Text('六', style: TextStyle(color: AppColors.textHint, fontSize: 12)),
            Text('日', style: TextStyle(color: AppColors.textHint, fontSize: 12)),
          ]),
        ),
        Expanded(child: GridView.builder(
          padding: const EdgeInsets.symmetric(horizontal: AppDimens.spacingMd),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 7, mainAxisSpacing: 4, crossAxisSpacing: 4),
          itemCount: daysInMonth + (DateTime(_month.year, _month.month, 1).weekday - 1),
          itemBuilder: (c, i) {
            final day = i - DateTime(_month.year, _month.month, 1).weekday + 2;
            if (day < 1 || day > daysInMonth) return const SizedBox.shrink();
            final hasRecord = day % 3 == 0 || day % 5 == 0;
            return Container(
              decoration: BoxDecoration(
                color: hasRecord ? AppColors.primary.withValues(alpha: 0.15) : AppColors.surface,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                Text('$day', style: TextStyle(color: hasRecord ? AppColors.primary : AppColors.textPrimary, fontWeight: FontWeight.w600)),
                if (hasRecord) Container(width: 4, height: 4, decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle)),
              ]),
            );
          },
        )),
        Container(
          padding: const EdgeInsets.all(AppDimens.spacingMd),
          decoration: const BoxDecoration(color: AppColors.surface),
          child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: const [
            _Legend(color: AppColors.primary, label: '运动'),
            _Legend(color: AppColors.warning, label: '饮食'),
            _Legend(color: AppColors.sportOther, label: '睡眠'),
            _Legend(color: AppColors.info, label: '饮水'),
          ]),
        ),
      ]),
    );
  }
}

class _Legend extends StatelessWidget {
  final Color color; final String label;
  const _Legend({required this.color, required this.label});
  @override
  Widget build(BuildContext context) {
    return Row(mainAxisSize: MainAxisSize.min, children: [
      Container(width: 8, height: 8, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
      const SizedBox(width: 4),
      Text(label, style: const TextStyle(color: AppColors.textHint, fontSize: 12)),
    ]);
  }
}

class HealthScanHistoryScreen extends StatelessWidget {
  const HealthScanHistoryScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('扫描历史')),
      body: ListView.separated(
        padding: const EdgeInsets.all(AppDimens.spacingMd),
        itemCount: 3, separatorBuilder: (_, __) => const SizedBox(height: 8),
        itemBuilder: (_, i) {
          return Container(
            padding: const EdgeInsets.all(AppDimens.spacingMd),
            decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12)),
            child: Row(children: [
              Container(width: 48, height: 48, decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(12)), child: const Icon(Icons.favorite_rounded, color: AppColors.primary)),
              const SizedBox(width: 12),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(['健康扫描', '食物识别', '心率检测'][i], style: const TextStyle(fontWeight: FontWeight.bold)),
                Text(['06-18 14:30', '06-17 12:15', '06-15 09:00'][i], style: const TextStyle(color: AppColors.textHint, fontSize: 12)),
              ])),
              Text(['正常', '识别成功', '正常'][i], style: const TextStyle(color: AppColors.success, fontWeight: FontWeight.w600)),
            ]),
          );
        },
      ),
    );
  }
}

class NewVerScreen extends StatelessWidget {
  const NewVerScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('版本更新')),
      body: ListView(padding: const EdgeInsets.all(AppDimens.spacingMd), children: [
        Container(
          padding: const EdgeInsets.all(AppDimens.spacingLg),
          decoration: BoxDecoration(gradient: const LinearGradient(colors: [AppColors.primary, AppColors.sportWalk]), borderRadius: BorderRadius.circular(AppDimens.radiusCard)),
          child: const Column(children: [
            Icon(Icons.system_update_rounded, color: Colors.white, size: 48),
            SizedBox(height: 12),
            Text('v1.2.0', style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
            SizedBox(height: 4),
            Text('最新版本', style: TextStyle(color: Colors.white70)),
          ]),
        ),
        const SizedBox(height: 16),
        Container(padding: const EdgeInsets.all(AppDimens.spacingMd), decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12)), child: const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('更新内容', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          SizedBox(height: 12),
          _Log('1. 新增轻断食模块，支持 14:10/16:8/18:6/20:4 四种模式'),
          _Log('2. 新增心情记录，支持 5 级情绪 + 标签 + 日记'),
          _Log('3. 新增经期管理，周期预测与提醒'),
          _Log('4. 身体记录全面升级，支持体重/BMI/体脂/围度'),
          _Log('5. 优化训练体验，新增指导训练与计时器'),
          _Log('6. 修复若干已知问题'),
        ])),
        const SizedBox(height: 24),
        const Center(child: Text('已是最新版本', style: TextStyle(color: AppColors.textHint))),
      ]),
    );
  }
}

class _Log extends StatelessWidget {
  final String text;
  const _Log(this.text);
  @override
  Widget build(BuildContext context) {
    return Padding(padding: const EdgeInsets.only(bottom: 6), child: Text(text, style: const TextStyle(fontSize: 14)));
  }
}
