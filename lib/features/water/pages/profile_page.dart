import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../models/user.dart';
import '../services/calendar_reminder_service.dart';
import '../services/database_service.dart';
import '../services/personalization_service.dart';
import '../services/session_service.dart';
import '../../../../core/theme/app_colors.dart';
import '../utils/navigation_helper.dart';
import '../widgets/glassmorphic_wrapper.dart';
import '../widgets/wheel_time_picker_sheet.dart';

class ProfilePage extends StatefulWidget {
  final bool showBackButton;
  final bool useWrapper;

  const ProfilePage({
    super.key,
    this.showBackButton = true,
    this.useWrapper = true,
  });

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final DatabaseService _databaseService = DatabaseService();

  String _userName = '小鹿用户';
  int _totalDays = 0;
  int _totalRecords = 0;
  double _totalVolume = 0;
  double _dailyWaterGoal = 2000;
  double _maxSugarIntake = 50;
  double _maxCaffeineIntake = 400;

  @override
  void initState() {
    super.initState();
    _loadProfileData();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _loadPreferenceData();
      }
    });
  }

  Future<void> _loadProfileData() async {
    final userId = await SessionService.getCurrentUserId();
    if (userId == null) return;

    final user = await _databaseService.getUser(userId);
    final records = await _databaseService.getDrinkRecords(userId: userId);
    if (!mounted) return;

    final uniqueDays = records
        .map(
          (record) => DateTime(
            record.recordTime.year,
            record.recordTime.month,
            record.recordTime.day,
          ),
        )
        .toSet();
    final totalVolumeMl = records.fold<double>(
      0,
      (sum, record) => sum + record.volume,
    );
    final rawName = user?.name?.trim() ?? '';

    setState(() {
      _userName = rawName.isEmpty || rawName == '奶茶爱好者' ? '小鹿用户' : rawName;
      _totalRecords = records.length;
      _totalVolume = totalVolumeMl / 1000;
      _totalDays = uniqueDays.length;
    });
  }

  Future<void> _loadPreferenceData() async {
    final preferences = context.read<PersonalizationProvider>().preferences;
    if (!mounted) return;

    setState(() {
      _dailyWaterGoal = preferences.dailyWaterGoal;
      _maxSugarIntake = preferences.maxDailySugar;
      _maxCaffeineIntake = preferences.maxDailyCaffeine;
    });
  }

  Future<void> _savePreferenceData() async {
    final provider = context.read<PersonalizationProvider>();
    final currentPrefs = provider.preferences;
    final newPrefs = currentPrefs.copyWith(
      dailyWaterGoal: _dailyWaterGoal,
      maxDailySugar: _maxSugarIntake,
      maxDailyCaffeine: _maxCaffeineIntake,
    );

    await provider.updatePreferences(newPrefs);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: widget.showBackButton
          ? AppBar(
              title: const Text('我的'),
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_rounded),
                onPressed: () => goBackOr(context, '/home'),
              ),
            )
          : null,
      body: SafeArea(
        top: !widget.showBackButton,
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(
            16,
            widget.showBackButton ? 4 : 14,
            16,
            16,
          ),
          child: Column(
            children: [
              _buildUserProfile(),
              const SizedBox(height: 16),
              _buildFeatureEntries(),
              if (!widget.useWrapper) const SizedBox(height: 90),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUserProfile() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(2, 8, 2, 0),
      child: Column(
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(32),
                child: Image.asset(
                  'assets/images/app_icon_cup_1024.png',
                  width: 64,
                  height: 64,
                  fit: BoxFit.cover,
                  filterQuality: FilterQuality.high,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _userName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 5),
                    const Text(
                      '小鹿喝水本地账号',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                tooltip: '编辑资料',
                onPressed: _editProfile,
                icon: const Icon(
                  Icons.edit_rounded,
                  color: AppColors.textPrimary,
                  size: 21,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildProfileMetric(
                  '记录天数',
                  '$_totalDays',
                  '天',
                  AppColors.primary,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildProfileMetric(
                  '累计喝水',
                  _totalVolume.toStringAsFixed(1),
                  'L',
                  Colors.blue,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildProfileMetric(
                  '记录次数',
                  '$_totalRecords',
                  '次',
                  AppColors.primaryDark,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProfileMetric(
    String label,
    String value,
    String unit,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          FittedBox(
            fit: BoxFit.scaleDown,
            child: RichText(
              maxLines: 1,
              text: TextSpan(
                children: [
                  TextSpan(
                    text: value,
                    style: TextStyle(
                      color: color,
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  TextSpan(
                    text: unit,
                    style: TextStyle(
                      color: color.withValues(alpha: 0.8),
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureEntries() {
    return Column(
      children: [
        _buildEntrySection(
          title: '常用偏好',
          children: [
            _buildEntryTile(
              icon: Icons.water_drop_rounded,
              color: AppColors.primary,
              title: '每日饮水目标',
              subtitle: '${_dailyWaterGoal.toInt()} ml',
              onTap: _showGoalSheet,
            ),
            _buildEntryTile(
              icon: Icons.calendar_month_rounded,
              color: AppColors.primary,
              title: '日历提醒',
              subtitle: _calendarReminderSubtitle(
                context.watch<PersonalizationProvider>().preferences,
              ),
              onTap: _showCalendarReminderSheet,
            ),
            _buildEntryTile(
              icon: Icons.health_and_safety_rounded,
              color: AppColors.primaryDark,
              title: '饮品健康上限',
              subtitle:
                  '糖 ${_maxSugarIntake.toInt()} g · 咖啡因 ${_maxCaffeineIntake.toInt()} mg',
              onTap: _showLimitSheet,
            ),
          ],
        ),
        const SizedBox(height: 12),
        _buildEntrySection(
          title: '饮品库',
          children: [
            _buildEntryTile(
              icon: Icons.storefront,
              color: Colors.blue,
              title: '饮品管理',
              subtitle: '管理品牌、预设饮品和自定义模板',
              onTap: () => context.push('/brands'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        _buildEntrySection(
          title: '成长记录',
          children: [
            _buildEntryTile(
              icon: Icons.emoji_events,
              color: AppColors.warning,
              title: '勋章墙',
              subtitle: '查看已解锁和待完成的勋章',
              onTap: () => context.push('/achievements'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        _buildEntrySection(
          title: '系统',
          children: [
            _buildEntryTile(
              icon: Icons.settings,
              color: Colors.blueGrey,
              title: '设置',
              subtitle: '本地数据、关于与协议',
              onTap: () => context.push('/settings'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildEntrySection({
    required String title,
    required List<Widget> children,
  }) {
    return GlassmorphicCard(
      padding: const EdgeInsets.fromLTRB(10, 12, 10, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 6),
            child: Text(
              title,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 12,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          ...children,
        ],
      ),
    );
  }

  Future<void> _showGoalSheet() async {
    var waterGoal = _dailyWaterGoal;

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return _buildPreferenceSheet(
              icon: Icons.water_drop_rounded,
              color: AppColors.primary,
              title: '每日饮水目标',
              subtitle: '调整首页目标完成度',
              children: [
                _buildSheetSlider(
                  title: '每日饮水目标',
                  value: waterGoal,
                  valueText: '${waterGoal.toInt()} ml',
                  min: 1000,
                  max: 3000,
                  step: 100,
                  color: AppColors.primary,
                  onChanged: (value) {
                    setSheetState(() => waterGoal = value);
                    setState(() => _dailyWaterGoal = value);
                    _savePreferenceData();
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _showLimitSheet() async {
    var sugarLimit = _maxSugarIntake;
    var caffeineLimit = _maxCaffeineIntake;
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return _buildPreferenceSheet(
              icon: Icons.health_and_safety_rounded,
              color: AppColors.primaryDark,
              title: '饮品健康上限',
              subtitle: '用于统计页提醒糖分和咖啡因摄入',
              children: [
                _buildSheetSlider(
                  title: '每日糖分上限',
                  value: sugarLimit,
                  valueText: '${sugarLimit.toInt()} g',
                  min: 20,
                  max: 100,
                  step: 5,
                  color: AppColors.primaryDark,
                  onChanged: (value) {
                    setSheetState(() => sugarLimit = value);
                    setState(() => _maxSugarIntake = value);
                    _savePreferenceData();
                  },
                ),
                const Divider(height: 1),
                _buildSheetSlider(
                  title: '每日咖啡因上限',
                  value: caffeineLimit,
                  valueText: '${caffeineLimit.toInt()} mg',
                  min: 100,
                  max: 600,
                  step: 50,
                  color: AppColors.primaryDark,
                  onChanged: (value) {
                    setSheetState(() => caffeineLimit = value);
                    setState(() => _maxCaffeineIntake = value);
                    _savePreferenceData();
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  String _calendarReminderSubtitle(UserPreferences preferences) {
    final reminders = preferences.reminderTimes
        .where((reminder) => reminder.enabled)
        .toList();
    if (!preferences.enableReminders || reminders.isEmpty) {
      return '未开启';
    }
    return reminders.map((reminder) => reminder.timeString).join('、');
  }

  Future<void> _showCalendarReminderSheet() async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return Consumer<PersonalizationProvider>(
          builder: (context, provider, _) {
            final preferences = provider.preferences;
            final reminders = preferences.reminderTimes
                .where((reminder) => reminder.enabled)
                .toList();
            final enabled = preferences.enableReminders && reminders.isNotEmpty;

            return _buildPreferenceSheet(
              icon: Icons.calendar_month_rounded,
              color: AppColors.primary,
              title: '日历提醒',
              subtitle: '由系统日历每日提醒',
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8F4F1),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(
                    children: [
                      const Expanded(
                        child: Text(
                          '开启日历提醒',
                          style: TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      Switch.adaptive(
                        value: enabled,
                        activeThumbColor: AppColors.primary,
                        activeTrackColor: AppColors.primaryLight,
                        onChanged: (value) async {
                          if (value) {
                            await _addCalendarReminder();
                          } else {
                            await _disableCalendarReminders();
                          }
                        },
                      ),
                    ],
                  ),
                ),
                if (reminders.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  ...reminders.map(
                    (reminder) => _buildCalendarReminderRow(reminder),
                  ),
                ],
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: _addCalendarReminder,
                    icon: const Icon(Icons.add_rounded, size: 18),
                    label: const Text('添加提醒时间'),
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 13),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildCalendarReminderRow(ReminderTime reminder) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFFCFAF8),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              reminder.timeString,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 17,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          IconButton(
            tooltip: '删除提醒',
            onPressed: () => _deleteCalendarReminder(reminder),
            icon: const Icon(
              Icons.delete_outline_rounded,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _addCalendarReminder() async {
    final picked = await showWheelTimePickerSheet(
      context: context,
      initialTime: const TimeOfDay(hour: 9, minute: 0),
      title: '添加日历提醒',
    );
    if (picked == null) return;

    final result = await CalendarReminderService.createDailyWaterReminder(
      hour: picked.hour,
      minute: picked.minute,
    );
    if (!mounted) return;

    if (result.success && result.eventId != null) {
      final provider = context.read<PersonalizationProvider>();
      final currentPrefs = provider.preferences;
      final nextReminder = ReminderTime(
        hour: picked.hour,
        minute: picked.minute,
        enabled: true,
        message: '该喝水了，补一杯水再继续。',
        calendarEventId: result.eventId,
      );
      await provider.updatePreferences(
        currentPrefs.copyWith(
          enableReminders: true,
          reminderTimes: [...currentPrefs.reminderTimes, nextReminder],
        ),
      );
      if (!mounted) return;
    }

    final message = result.success && result.eventId != null
        ? '已添加到系统日历'
        : (result.message ?? '日历提醒创建失败');
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _deleteCalendarReminder(ReminderTime reminder) async {
    final eventId = reminder.calendarEventId;
    if (eventId == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('这个提醒没有日历事件ID，无法同步删除')));
      return;
    }

    final result = await CalendarReminderService.deleteCalendarReminder(
      eventId: eventId,
    );
    if (!mounted) return;

    if (result.success) {
      final provider = context.read<PersonalizationProvider>();
      final currentPrefs = provider.preferences;
      final nextReminders = currentPrefs.reminderTimes
          .where((item) => item.calendarEventId != eventId)
          .toList();
      await provider.updatePreferences(
        currentPrefs.copyWith(
          enableReminders: nextReminders.isNotEmpty,
          reminderTimes: nextReminders,
        ),
      );
      if (!mounted) return;
    }

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(result.message ?? '已删除日历提醒')));
  }

  Future<void> _disableCalendarReminders() async {
    final provider = context.read<PersonalizationProvider>();
    final currentPrefs = provider.preferences;
    final reminders = currentPrefs.reminderTimes.toList();
    final missingEventId = reminders.any(
      (reminder) => reminder.calendarEventId == null,
    );
    if (missingEventId) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('有提醒缺少日历事件ID，无法确认已从日历删除')));
      return;
    }

    for (final reminder in reminders) {
      final result = await CalendarReminderService.deleteCalendarReminder(
        eventId: reminder.calendarEventId!,
      );
      if (!mounted) return;
      if (!result.success) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(result.message ?? '日历提醒删除失败')));
        return;
      }
    }

    await provider.updatePreferences(
      currentPrefs.copyWith(
        enableReminders: false,
        reminderTimes: const <ReminderTime>[],
      ),
    );
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('已关闭并删除日历提醒')));
  }

  Widget _buildPreferenceSheet({
    required IconData icon,
    required Color color,
    required String title,
    required String subtitle,
    required List<Widget> children,
  }) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 18),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8D8CC),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              Row(
                children: [
                  Container(
                    width: 34,
                    height: 34,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(icon, color: color, size: 20),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          subtitle,
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ...children,
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSheetSlider({
    required String title,
    required double value,
    required String valueText,
    required double min,
    required double max,
    required double step,
    required Color color,
    required ValueChanged<double> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 12, 4, 14),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              Text(
                valueText,
                style: TextStyle(
                  color: color,
                  fontSize: 15,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: color,
              inactiveTrackColor: color.withValues(alpha: 0.2),
              thumbColor: color,
              overlayColor: color.withValues(alpha: 0.14),
            ),
            child: Slider(
              value: value.clamp(min, max),
              min: min,
              max: max,
              divisions: ((max - min) / step).round(),
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEntryTile({
    required IconData icon,
    required Color color,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Row(
              children: [
                Container(
                  width: 34,
                  height: 34,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: color, size: 21),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        subtitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.chevron_right_rounded,
                  color: AppColors.textHint,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _editProfile() async {
    var draftName = _userName;
    final newName = await showDialog<String>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        title: const Text('编辑个人信息'),
        content: TextFormField(
          initialValue: _userName,
          autofocus: true,
          decoration: const InputDecoration(
            labelText: '昵称',
            border: OutlineInputBorder(),
          ),
          maxLength: 16,
          onChanged: (value) => draftName = value,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('取消'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(draftName.trim()),
            child: const Text('保存'),
          ),
        ],
      ),
    );

    if (newName == null || newName.isEmpty) return;

    final existingUser = await SessionService.ensureLocalUser();
    await _databaseService.updateUser(
      existingUser.copyWith(name: newName, updatedAt: DateTime.now()),
    );

    if (!mounted) return;
    setState(() => _userName = newName);
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('个人信息已更新')));
  }
}
