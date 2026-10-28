import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../emoon_entry.dart';


import '../services/database_service.dart';
import '../services/daily_reminder_service.dart';

class RetestRemindersPage extends StatefulWidget {
  const RetestRemindersPage({super.key});

  @override
  State<RetestRemindersPage> createState() => _RetestRemindersPageState();
}

class _RetestRemindersPageState extends State<RetestRemindersPage> {
  final DatabaseService _dbService = DatabaseService();

  bool _loading = true;
  List<_RetestReminderEntry> _reminders = [];

  @override
  void initState() {
    super.initState();
    _loadReminders();
  }

  Future<void> _loadReminders() async {
    final rawEntries = await _dbService.getDataEntriesByPrefix(
      'retest_reminder_',
    );
    final reminders = <_RetestReminderEntry>[];
    for (final entry in rawEntries.entries) {
      final value = entry.value;
      if (value is! Map) continue;
      final reminder = _RetestReminderEntry.fromMap(
        Map<String, dynamic>.from(value),
      );
      if (reminder.scheduledAt.isAfter(DateTime.now())) {
        reminders.add(reminder);
      } else {
        await _dbService.removeData(reminder.key);
      }
    }
    reminders.sort((a, b) => a.scheduledAt.compareTo(b.scheduledAt));

    if (!mounted) return;
    setState(() {
      _reminders = reminders;
      _loading = false;
    });
  }

  Future<void> _cancelReminder(_RetestReminderEntry reminder) async {
    await DailyReminderService.cancelNotification(reminder.notificationId);
    await _dbService.removeData(reminder.key);
    if (!mounted) return;
    setState(() {
      _reminders.removeWhere((item) => item.key == reminder.key);
    });
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('已取消复测提醒')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppTheme.backgroundColor,
        elevation: 0,
        title: Text('复测提醒'),
      ),
      body: _loading
          ? Center(child: CircularProgressIndicator())
          : _reminders.isEmpty
          ? Center(
              child: Padding(
                padding: EdgeInsets.all(32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Icon(
                        Icons.notifications_none_rounded,
                        size: 36,
                        color: AppTheme.primaryColor,
                      ),
                    ),
                    SizedBox(height: 18),
                    Text(
                      '还没有设置复测提醒',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      '做完标准化筛查后，可以在结果页里设置“7 天后提醒我复测”。',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 13,
                        color: AppTheme.textSecondary,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            )
          : ListView.builder(
              padding: EdgeInsets.fromLTRB(
                AppTheme.pageHorizontalPadding,
                16,
                AppTheme.pageHorizontalPadding,
                24,
              ),
              itemCount: _reminders.length,
              itemBuilder: (context, index) {
                final reminder = _reminders[index];
                return Container(
                  margin: EdgeInsets.only(bottom: 12),
                  padding: EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        reminder.assessmentName,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                      SizedBox(height: 6),
                      Text(
                        _formatReminderTime(reminder.scheduledAt),
                        style: TextStyle(
                          fontSize: 13,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                      SizedBox(height: 14),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => EmotionTestPage(
                                      initialAssessmentId:
                                          reminder.assessmentId,
                                    ),
                                  ),
                                );
                              },
                              style: OutlinedButton.styleFrom(
                                foregroundColor: AppTheme.primaryColor,
                                side: const BorderSide(
                                  color: AppTheme.primaryColor,
                                ),
                                padding: EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
                              child: Text('立即复测'),
                            ),
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () => _cancelReminder(reminder),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppTheme.primaryColor,
                                foregroundColor: Colors.white,
                                padding: EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
                              child: Text('取消提醒'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }

  String _formatReminderTime(DateTime time) {
    return '${time.year}年${time.month}月${time.day}日 '
        '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }
}

class _RetestReminderEntry {
  final String key;
  final String assessmentId;
  final String assessmentName;
  final DateTime scheduledAt;
  final int notificationId;

  const _RetestReminderEntry({
    required this.key,
    required this.assessmentId,
    required this.assessmentName,
    required this.scheduledAt,
    required this.notificationId,
  });

  factory _RetestReminderEntry.fromMap(Map<String, dynamic> map) {
    return _RetestReminderEntry(
      key: map['key']?.toString() ?? '',
      assessmentId: map['assessmentId']?.toString() ?? '',
      assessmentName: map['assessmentName']?.toString() ?? '',
      scheduledAt:
          DateTime.tryParse(map['scheduledAt']?.toString() ?? '') ??
          DateTime.now(),
      notificationId:
          int.tryParse(map['notificationId']?.toString() ?? '') ?? 0,
    );
  }
}
