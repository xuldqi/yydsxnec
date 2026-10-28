import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:steps_webu_flutter/core/theme/app_colors.dart';
import '../services/notification_service.dart';
import '../utils/app_toast.dart';
import '../utils/picker_utils.dart';
import 'package:flutter/cupertino.dart';
import '../components/modern_card.dart';

class NotificationSettingsPage extends ConsumerStatefulWidget {
  const NotificationSettingsPage({super.key});

  @override
  ConsumerState<NotificationSettingsPage> createState() =>
      _NotificationSettingsPageState();
}

class _NotificationSettingsPageState
    extends ConsumerState<NotificationSettingsPage> {
  final NotificationService _notificationService = NotificationService();

  bool _fastingStartEnabled = true;
  bool _fastingEndEnabled = true;
  bool _eatingWindowEnabled = true;
  bool _waterReminderEnabled = true;
  bool _weightReminderEnabled = false;

  TimeOfDay? _waterReminderTime;
  TimeOfDay? _weightReminderTime;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() {
      _fastingStartEnabled =
          prefs.getBool('notification_fasting_start') ?? true;
      _fastingEndEnabled = prefs.getBool('notification_fasting_end') ?? true;
      _eatingWindowEnabled =
          prefs.getBool('notification_eating_window') ?? true;
      _waterReminderEnabled =
          prefs.getBool('notification_water_reminder') ?? true;
      _weightReminderEnabled =
          prefs.getBool('notification_weight_reminder') ?? false;

      // 加载提醒时间
      final waterHour = prefs.getInt('water_reminder_hour') ?? 9;
      final waterMinute = prefs.getInt('water_reminder_minute') ?? 0;
      _waterReminderTime = TimeOfDay(hour: waterHour, minute: waterMinute);

      final weightHour = prefs.getInt('weight_reminder_hour') ?? 8;
      final weightMinute = prefs.getInt('weight_reminder_minute') ?? 0;
      _weightReminderTime = TimeOfDay(hour: weightHour, minute: weightMinute);
    });
  }

  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notification_fasting_start', _fastingStartEnabled);
    await prefs.setBool('notification_fasting_end', _fastingEndEnabled);
    await prefs.setBool('notification_eating_window', _eatingWindowEnabled);
    await prefs.setBool('notification_water_reminder', _waterReminderEnabled);
    await prefs.setBool('notification_weight_reminder', _weightReminderEnabled);

    if (_waterReminderTime != null) {
      await prefs.setInt('water_reminder_hour', _waterReminderTime!.hour);
      await prefs.setInt('water_reminder_minute', _waterReminderTime!.minute);
    }

    if (_weightReminderTime != null) {
      await prefs.setInt('weight_reminder_hour', _weightReminderTime!.hour);
      await prefs.setInt('weight_reminder_minute', _weightReminderTime!.minute);
    }

    // 更新通知计划
    await _updateNotificationSchedule();
  }

  Future<void> _updateNotificationSchedule() async {
    if (_waterReminderEnabled && _waterReminderTime != null) {
      await _notificationService.cancelWaterReminders();
      await _notificationService.scheduleWaterReminder(
        times: [
          _waterReminderTime!,
          const TimeOfDay(hour: 9, minute: 0),
          const TimeOfDay(hour: 12, minute: 0),
          const TimeOfDay(hour: 15, minute: 0),
          const TimeOfDay(hour: 18, minute: 0),
        ],
      );
    } else {
      await _notificationService.cancelWaterReminders();
    }

    if (_weightReminderEnabled && _weightReminderTime != null) {
      await _notificationService.cancelWeightReminder();
      await _notificationService.scheduleWeightReminder(
        time: _weightReminderTime!,
      );
    } else {
      await _notificationService.cancelWeightReminder();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('通知设置'),
        centerTitle: true,
        backgroundColor: AppColors.background,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '通知设置',
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16.0),
            Text(
              '管理应用通知，及时提醒您保持健康习惯',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 32.0),

            // 断食通知
            ModernCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '断食提醒',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  _buildSwitchTile(
                    '断食开始提醒',
                    '断食开始时发送通知',
                    _fastingStartEnabled,
                    (value) {
                      setState(() => _fastingStartEnabled = value);
                      _saveSettings();
                    },
                  ),
                  _buildSwitchTile(
                    '断食结束提醒',
                    '断食即将结束时发送通知',
                    _fastingEndEnabled,
                    (value) {
                      setState(() => _fastingEndEnabled = value);
                      _saveSettings();
                    },
                  ),
                  _buildSwitchTile(
                    '进食窗口提醒',
                    '进食窗口开启时发送通知',
                    _eatingWindowEnabled,
                    (value) {
                      setState(() => _eatingWindowEnabled = value);
                      _saveSettings();
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24.0),

            // 健康提醒
            ModernCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '健康提醒',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  _buildSwitchTile('饮水提醒', '定时提醒您喝水', _waterReminderEnabled, (
                    value,
                  ) {
                    setState(() => _waterReminderEnabled = value);
                    _saveSettings();
                  }),
                  if (_waterReminderEnabled) ...[
                    const SizedBox(height: 8.0),
                    ListTile(
                      leading: const Icon(Icons.access_time),
                      title: const Text('提醒时间'),
                      subtitle: Text(
                        _waterReminderTime != null
                            ? _waterReminderTime!.format(context)
                            : '未设置',
                      ),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () async {
                        final now = DateTime.now();
                        final initialTime =
                            _waterReminderTime ?? TimeOfDay.now();
                        final initialDateTime = DateTime(
                          now.year,
                          now.month,
                          now.day,
                          initialTime.hour,
                          initialTime.minute,
                        );

                        final result =
                            await PickerUtils.showCupertinoDateTimePicker(
                              context,
                              initialDateTime: initialDateTime,
                              mode: CupertinoDatePickerMode.time,
                            );

                        if (result != null) {
                          final time = TimeOfDay.fromDateTime(result);
                          setState(() => _waterReminderTime = time);
                          await _saveSettings();
                        }
                      },
                    ),
                  ],
                  const Divider(),
                  _buildSwitchTile(
                    '体重记录提醒',
                    '提醒您定期记录体重',
                    _weightReminderEnabled,
                    (value) {
                      setState(() => _weightReminderEnabled = value);
                      _saveSettings();
                    },
                  ),
                  if (_weightReminderEnabled) ...[
                    const SizedBox(height: 8.0),
                    ListTile(
                      leading: const Icon(Icons.access_time),
                      title: const Text('提醒时间'),
                      subtitle: Text(
                        _weightReminderTime != null
                            ? _weightReminderTime!.format(context)
                            : '未设置',
                      ),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () async {
                        final now = DateTime.now();
                        final initialTime =
                            _weightReminderTime ?? TimeOfDay.now();
                        final initialDateTime = DateTime(
                          now.year,
                          now.month,
                          now.day,
                          initialTime.hour,
                          initialTime.minute,
                        );

                        final result =
                            await PickerUtils.showCupertinoDateTimePicker(
                              context,
                              initialDateTime: initialDateTime,
                              mode: CupertinoDatePickerMode.time,
                            );

                        if (result != null) {
                          final time = TimeOfDay.fromDateTime(result);
                          setState(() => _weightReminderTime = time);
                          await _saveSettings();
                        }
                      },
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 32.0),

            // 测试通知按钮
            ElevatedButton.icon(
              onPressed: () async {
                await _notificationService.showNotification(
                  id: 9999,
                  title: '测试通知',
                  body: '这是一条测试通知，通知功能正常工作！',
                );
                if (context.mounted) {
                  showAppToast(context, '测试通知已发送', type: AppToastType.success);
                }
              },
              icon: const Icon(Icons.notifications_active),
              label: const Text('发送测试通知'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32.0,
                  vertical: 16.0,
                ),
                minimumSize: const Size(double.infinity, 50),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSwitchTile(
    String title,
    String subtitle,
    bool value,
    ValueChanged<bool> onChanged,
  ) {
    return SwitchListTile(
      title: Text(title),
      subtitle: Text(
        subtitle,
        style: Theme.of(
          context,
        ).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
      ),
      value: value,
      onChanged: onChanged,
      activeThumbColor: AppColors.primary,
      activeTrackColor: AppColors.primary.withValues(alpha: 0.28),
    );
  }
}
