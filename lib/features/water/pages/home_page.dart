import 'dart:async';
import 'dart:io';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../models/drink_record.dart';
import '../services/database_service.dart';
import '../services/record_change_notifier.dart';
import '../services/session_service.dart';
import '../../../../core/theme/app_colors.dart';
import '../widgets/glassmorphic_wrapper.dart';
import 'profile_page.dart';
import 'records_page.dart';
import 'statistics_page.dart';

class HomePage extends StatefulWidget {
  final int initialTab;

  const HomePage({super.key, this.initialTab = 0});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  static const String _waterAssetDir = 'assets/images/water_ui';
  static const List<_QuickRecordOption> _defaultQuickRecordOptions = [
    _QuickRecordOption(
      name: '水',
      category: '白开水',
      volume: 100,
      size: '100ml',
      imageAsset: '$_waterAssetDir/cup_small_style.png',
    ),
    _QuickRecordOption(
      name: '水',
      category: '白开水',
      volume: 200,
      size: '200ml',
      imageAsset: '$_waterAssetDir/cup_medium_style.png',
    ),
    _QuickRecordOption(
      name: '水',
      category: '白开水',
      volume: 300,
      size: '300ml',
      imageAsset: '$_waterAssetDir/cup_large_style.png',
    ),
    _QuickRecordOption(
      name: '瓶装水',
      category: '白开水',
      volume: 500,
      size: '500ml',
      imageAsset: '$_waterAssetDir/bottle_style.png',
    ),
  ];

  int _selectedIndex = 0;
  bool _isLoading = true;
  int _todayWaterIntake = 0;
  int _waterGoal = 2000;
  int _consecutiveDays = 0;
  List<DrinkRecord> _todayRecords = [];
  DateTime? _loadedDay;
  Timer? _dayRolloverTimer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    RecordChangeNotifier.changes.addListener(_handleRecordDataChanged);
    _selectedIndex = widget.initialTab.clamp(0, 3).toInt();
    _loadHomeData();
    _dayRolloverTimer = Timer.periodic(
      const Duration(minutes: 1),
      (_) => _refreshHomeDataIfDateChanged(),
    );
  }

  @override
  void didUpdateWidget(covariant HomePage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialTab != widget.initialTab) {
      _selectedIndex = widget.initialTab.clamp(0, 3).toInt();
      if (_selectedIndex == 0) {
        _refreshHomeDataIfDateChanged();
      }
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _refreshHomeDataIfDateChanged(force: true);
    }
  }

  @override
  void dispose() {
    _dayRolloverTimer?.cancel();
    RecordChangeNotifier.changes.removeListener(_handleRecordDataChanged);
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void _handleRecordDataChanged() {
    if (!mounted) return;
    _loadHomeData(showLoading: false);
  }

  DateTime _startOfDay(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  Future<void> _refreshHomeDataIfDateChanged({bool force = false}) async {
    if (!mounted) return;
    final today = _startOfDay(DateTime.now());
    final shouldRefresh =
        force || _loadedDay == null || !_isSameDay(_loadedDay!, today);
    if (shouldRefresh) {
      await _loadHomeData(showLoading: false);
    }
  }

  Future<void> _loadHomeData({bool showLoading = true}) async {
    if (showLoading && mounted) {
      setState(() => _isLoading = true);
    }
    try {
      final userId = await SessionService.getCurrentUserId();
      if (userId == null) {
        if (mounted) {
          setState(() => _isLoading = false);
        }
        return;
      }

      final database = DatabaseService();
      final now = DateTime.now();
      final startOfDay = _startOfDay(now);
      final endOfDay = startOfDay.add(const Duration(days: 1));
      final preferences = await database.getUserPreferences(userId);
      final stats = await database.getDailyStats(userId, now);
      final records = await database.getDrinkRecords(
        userId: userId,
        startDate: startOfDay,
        endDate: endOfDay.subtract(const Duration(milliseconds: 1)),
        limit: 4,
      );
      final allRecords = await database.getDrinkRecords(userId: userId);

      if (!mounted) return;
      setState(() {
        _todayWaterIntake = stats.totalVolume.round();
        _waterGoal = preferences.dailyWaterGoal.round();
        _consecutiveDays = _calculateConsecutiveRecordDays(allRecords);
        _todayRecords = records;
        _loadedDay = startOfDay;
        _isLoading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _isLoading = false);
    }
  }

  int _calculateConsecutiveRecordDays(List<DrinkRecord> records) {
    if (records.isEmpty) return 0;

    final activeDates = <String>{};
    for (final record in records) {
      final day = _startOfDay(record.recordTime);
      activeDates.add('${day.year}-${day.month}-${day.day}');
    }

    var consecutive = 0;
    final today = _startOfDay(DateTime.now());
    for (var i = 0; i < 365; i++) {
      final day = today.subtract(Duration(days: i));
      if (!activeDates.contains('${day.year}-${day.month}-${day.day}')) {
        break;
      }
      consecutive++;
    }

    return consecutive;
  }

  Future<void> _quickSaveOption(_QuickRecordOption option) async {
    try {
      var userId = await SessionService.getCurrentUserId();
      userId ??= (await SessionService.ensureLocalUser()).id;

      final record = DrinkRecord(
        name: option.name,
        category: option.category,
        volume: option.volume.toDouble(),
        size: option.size,
        sugar: 0,
        fat: 0,
        protein: 0,
        caffeine: 0,
        calories: 0,
        recordTime: DateTime.now(),
        userId: userId,
      );

      await DatabaseService().insertDrinkRecord(record);
      RecordChangeNotifier.notifyChanged();
      await _loadHomeData(showLoading: false);
      if (!mounted) return;
      _showBottomPill('已记录 ${option.name} ${option.volume} ml');
    } catch (_) {
      if (!mounted) return;
      _showBottomPill('记录失败');
    }
  }

  void _showBottomPill(String message) {
    final messenger = ScaffoldMessenger.of(context);
    messenger.clearSnackBars();
    messenger.showSnackBar(
      SnackBar(
        content: Text(
          message,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 13,
            fontWeight: FontWeight.w800,
          ),
        ),
        width: 172,
        behavior: SnackBarBehavior.floating,
        backgroundColor: const Color(0xFFFFFEFC),
        elevation: 8,
        duration: const Duration(milliseconds: 1400),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      ),
    );
  }

  AppBar _buildHomeAppBar() {
    return AppBar(
      title: const Text(
        '小鹿喝水',
        style: TextStyle(
          color: AppColors.textPrimary,
          fontSize: 22,
          fontWeight: FontWeight.w900,
        ),
      ),
      centerTitle: false,
      backgroundColor: Colors.transparent,
      elevation: 0,
      actions: [
        if (_consecutiveDays > 0)
          Padding(
            padding: const EdgeInsets.only(right: 4),
            child: Chip(
              label: Text(
                '连续 $_consecutiveDays 天',
                style: const TextStyle(
                  color: Color(0xFFD97706),
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                ),
              ),
              backgroundColor: const Color(0xFFFFF3D8),
              side: BorderSide.none,
              visualDensity: VisualDensity.compact,
            ),
          ),
      ],
    );
  }

  Widget _buildHomeContent() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      );
    }

    return RefreshIndicator(
      color: AppColors.primary,
      onRefresh: _loadHomeData,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(18, 0, 18, 110),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildProgressCard(),
                const SizedBox(height: 14),
                _buildQuickRecordCard(),
                const SizedBox(height: 14),
                _buildTodayRecordsCard(),
                const SizedBox(height: 12),
                _buildInfoGrid(),
                const SizedBox(height: 12),
                _buildTipCard(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      _buildHomeContent(),
      const RecordsPage(showBackButton: false, useWrapper: false),
      const StatisticsPage(showBackButton: false, useWrapper: false),
      const ProfilePage(showBackButton: false, useWrapper: false),
    ];

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
        systemNavigationBarColor: AppColors.background,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        extendBody: true,
        appBar: _selectedIndex == 0 ? _buildHomeAppBar() : null,
        body: IndexedStack(index: _selectedIndex, children: pages),
        floatingActionButton: _selectedIndex == 0
            ? Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildHomeFab(
                    heroTag: 'photo_ocr_fab',
                    tooltip: '拍照记录',
                    icon: Icons.photo_camera_rounded,
                    size: 58,
                    iconSize: 27,
                    backgroundColor: const Color(0xFF58BFD1),
                    onPressed: () => context.push('/photo-ocr'),
                  ),
                  const SizedBox(height: 10),
                  _buildHomeFab(
                    heroTag: 'manual_record_fab',
                    tooltip: '记录喝水',
                    icon: Icons.add_rounded,
                    size: 58,
                    iconSize: 32,
                    backgroundColor: AppColors.primary,
                    onPressed: () => context.push('/record'),
                  ),
                ],
              )
            : null,
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        bottomNavigationBar: SafeArea(
          top: false,
          child: Container(
            height: 72,
            margin: const EdgeInsets.fromLTRB(8, 0, 8, 10),
            decoration: BoxDecoration(
              color: const Color(0xFFFFFEFC).withValues(alpha: 0.96),
              borderRadius: BorderRadius.circular(26),
              border: Border.all(color: const Color(0xFFF1E3D7)),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x1A7C4A32),
                  blurRadius: 18,
                  offset: Offset(0, 8),
                ),
              ],
            ),
            child: Row(
              children: [
                _buildTabItem(icon: Icons.home_rounded, label: '首页', index: 0),
                _buildTabItem(
                  icon: Icons.calendar_today_rounded,
                  label: '记录',
                  index: 1,
                ),
                _buildTabItem(
                  icon: Icons.bar_chart_rounded,
                  label: '统计',
                  index: 2,
                ),
                _buildTabItem(
                  icon: Icons.person_rounded,
                  label: '我的',
                  index: 3,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHomeFab({
    required String heroTag,
    required String tooltip,
    required IconData icon,
    required double size,
    required double iconSize,
    required Color backgroundColor,
    required VoidCallback onPressed,
  }) {
    return Semantics(
      button: true,
      label: tooltip,
      child: Tooltip(
        message: tooltip,
        child: SizedBox(
          width: size,
          height: size,
          child: FloatingActionButton(
            heroTag: heroTag,
            onPressed: onPressed,
            backgroundColor: backgroundColor,
            foregroundColor: Colors.white,
            elevation: 3,
            highlightElevation: 4,
            shape: const CircleBorder(),
            child: Icon(icon, size: iconSize),
          ),
        ),
      ),
    );
  }

  Widget _buildTabItem({
    required IconData icon,
    required String label,
    required int index,
  }) {
    final isSelected = _selectedIndex == index;
    final color = isSelected ? AppColors.primary : AppColors.textHint;

    return Expanded(
      child: InkWell(
        onTap: () {
          setState(() => _selectedIndex = index);
          if (index == 0) {
            _refreshHomeDataIfDateChanged(force: true);
          }
        },
        borderRadius: BorderRadius.circular(18),
        child: SizedBox(
          height: 58,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: color, size: 23),
              const SizedBox(height: 3),
              Text(
                label,
                style: TextStyle(
                  color: color,
                  fontSize: 11,
                  fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProgressCard() {
    final progress = _waterGoal > 0
        ? (_todayWaterIntake / _waterGoal).clamp(0.0, 1.0)
        : 0.0;
    final progressLabel = '${(progress * 100).round()}%';
    final remaining = (_waterGoal - _todayWaterIntake).clamp(0, _waterGoal);

    return SizedBox(
      width: double.infinity,
      height: 254,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            top: 12,
            right: 48,
            child: Icon(
              Icons.auto_awesome_rounded,
              size: 14,
              color: const Color(0xFFFFDFA1).withValues(alpha: 0.9),
            ),
          ),
          Positioned(
            top: 62,
            left: 42,
            child: Icon(
              Icons.favorite_rounded,
              size: 12,
              color: AppColors.primary.withValues(alpha: 0.72),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            top: 0,
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 220,
                  height: 220,
                  child: CustomPaint(
                    painter: _OpenRingProgressPainter(
                      progress: progress,
                      trackColor: const Color(0xFFFFEDF0),
                      progressColor: AppColors.primary,
                      strokeWidth: 18,
                    ),
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      '今日已喝',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '$_todayWaterIntake',
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 42,
                        fontWeight: FontWeight.w800,
                        height: 1.08,
                      ),
                    ),
                    Text(
                      '/$_waterGoal ml',
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
                Positioned(
                  bottom: 12,
                  child: Text(
                    progressLabel,
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontSize: 12.5,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 10,
            left: 0,
            right: 0,
            child: Align(
              alignment: Alignment.center,
              child: Text(
                remaining == 0 ? '今日目标已达成' : '还差 $remaining ml 达成目标',
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 12.5,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: -18,
            child: Image.asset(
              '$_waterAssetDir/deer_cartoon.png',
              width: 108,
              height: 130,
              fit: BoxFit.contain,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickRecordCard() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(2, 2, 2, 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.water_drop_rounded, color: AppColors.primary),
              SizedBox(width: 7),
              Text(
                '快速记录',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              for (var i = 0; i < _defaultQuickRecordOptions.length; i++)
                _buildCupOption(
                  label: _defaultQuickRecordOptions[i].displayLabel,
                  imageAsset: _defaultQuickRecordOptions[i].imageAsset,
                  isSuggested: i == 2,
                  onTap: () => _quickSaveOption(_defaultQuickRecordOptions[i]),
                ),
              _buildCupOption(
                label: '自定义',
                imageAsset: '$_waterAssetDir/custom_cup_style.png',
                onTap: () => context.push('/record'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCupOption({
    required String label,
    required String imageAsset,
    required VoidCallback onTap,
    bool isSuggested = false,
  }) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Column(
          children: [
            Container(
              height: 70,
              margin: const EdgeInsets.symmetric(horizontal: 3),
              decoration: BoxDecoration(
                color: isSuggested
                    ? const Color(0xFFFFF4F6)
                    : const Color(0xFFFFFCF8),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isSuggested
                      ? AppColors.primary
                      : const Color(0xFFF2E4D8),
                  width: isSuggested ? 1.4 : 1,
                ),
              ),
              child: Stack(
                children: [
                  Center(
                    child: Image.asset(
                      imageAsset,
                      width: 50,
                      height: 50,
                      fit: BoxFit.contain,
                    ),
                  ),
                  if (isSuggested)
                    Positioned(
                      top: 6,
                      right: 6,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 5,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          '常用',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 8,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 6),
            Text(
              label,
              maxLines: 1,
              style: TextStyle(
                color: isSuggested
                    ? AppColors.primary
                    : AppColors.textSecondary,
                fontSize: 11.5,
                fontWeight: isSuggested ? FontWeight.w800 : FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTodayRecordsCard() {
    return GlassmorphicCard(
      padding: const EdgeInsets.fromLTRB(18, 16, 18, 10),
      color: const Color(0xFFFFFEFC),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(
                Icons.receipt_long_rounded,
                color: AppColors.primary,
                size: 19,
              ),
              const SizedBox(width: 8),
              const Text(
                '今日喝水记录',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 15.5,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const Spacer(),
              InkWell(
                onTap: () => setState(() => _selectedIndex = 1),
                borderRadius: BorderRadius.circular(14),
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                  child: Row(
                    children: [
                      Text(
                        '更多',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Icon(
                        Icons.chevron_right_rounded,
                        size: 16,
                        color: AppColors.textSecondary,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (_todayRecords.isEmpty)
            _buildEmptyRecords()
          else
            ..._todayRecords.map(_buildTimelineRecordItem),
        ],
      ),
    );
  }

  Widget _buildEmptyRecords() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 8, 4, 14),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFFE7F8FC),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(
              Icons.local_drink_rounded,
              color: Color(0xFF45B7D1),
              size: 22,
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              '今天还没有喝水记录，先从一杯 200 ml 开始。',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 13,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineRecordItem(DrinkRecord record) {
    final timeStr =
        '${record.recordTime.hour.toString().padLeft(2, '0')}:${record.recordTime.minute.toString().padLeft(2, '0')}';
    final drinkName = _displayTimelineRecordName(record);

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.45),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          if (record.imagePath != null && record.imagePath!.isNotEmpty)
            Image.file(
              File(record.imagePath!),
              width: 24,
              height: 24,
              fit: BoxFit.contain,
            )
          else
            Image.asset(
              record.volume >= 500
                  ? '$_waterAssetDir/bottle_style.png'
                  : '$_waterAssetDir/cup_small_style.png',
              width: 22,
              height: 22,
              fit: BoxFit.contain,
            ),
          const SizedBox(width: 12),
          Text(
            timeStr,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 14,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              drinkName,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Text(
            '${record.volume.round()} ml',
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 14,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }

  String _displayTimelineRecordName(DrinkRecord record) {
    final name = record.name.trim();
    if (name.isNotEmpty) {
      return name == '白开水' ? '水' : name;
    }

    final category = record.category.trim();
    return category.isEmpty || category == '白开水' ? '水' : category;
  }

  Widget _buildInfoGrid() {
    return Row(
      children: [
        Expanded(
          child: _buildSmallInfoCard(
            title: '连续喝水',
            value: '$_consecutiveDays 天',
            subtitle: _consecutiveDays == 0 ? '今天开始记录' : '继续保持节奏',
            color: const Color(0xFF4CAF50),
            backgroundColor: const Color(0xFFF4FBED),
            assetPath: '$_waterAssetDir/cactus_cartoon.png',
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildSmallInfoCard(
            title: '目标水量',
            value: '$_waterGoal ml',
            subtitle: '可在设置调整',
            color: const Color(0xFFD97706),
            backgroundColor: const Color(0xFFFFF6ED),
            assetPath: '$_waterAssetDir/bell_cartoon.png',
          ),
        ),
      ],
    );
  }

  Widget _buildSmallInfoCard({
    required String title,
    required String value,
    required String subtitle,
    required Color color,
    required Color backgroundColor,
    required String assetPath,
  }) {
    return GlassmorphicCard(
      padding: const EdgeInsets.all(14),
      color: backgroundColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FittedBox(
                      alignment: Alignment.centerLeft,
                      fit: BoxFit.scaleDown,
                      child: Text(
                        value,
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
              Image.asset(
                assetPath,
                width: 48,
                height: 48,
                fit: BoxFit.contain,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTipCard() {
    return GlassmorphicCard(
      padding: const EdgeInsets.fromLTRB(20, 20, 0, 20),
      color: const Color(0xFFFFF8F5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '小贴士',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  '充足的水分摄入有助于新陈代谢，改善皮肤状态，也能提升专注力。',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                    height: 1.6,
                  ),
                ),
              ],
            ),
          ),
          Image.asset(
            '$_waterAssetDir/tip_bunny_cartoon.png',
            width: 94,
            height: 104,
            fit: BoxFit.contain,
          ),
        ],
      ),
    );
  }
}

class _OpenRingProgressPainter extends CustomPainter {
  final double progress;
  final Color trackColor;
  final Color progressColor;
  final double strokeWidth;

  const _OpenRingProgressPainter({
    required this.progress,
    required this.trackColor,
    required this.progressColor,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final inset = strokeWidth / 2;
    final arcRect = rect.deflate(inset);
    const gapAngle = math.pi / 3;
    final sweepAngle = (math.pi * 2) - gapAngle;
    final startAngle = (math.pi / 2) + (gapAngle / 2);

    final trackPaint = Paint()
      ..color = trackColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(arcRect, startAngle, sweepAngle, false, trackPaint);

    final progressPaint = Paint()
      ..color = progressColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      arcRect,
      startAngle,
      sweepAngle * progress.clamp(0.0, 1.0),
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _OpenRingProgressPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.trackColor != trackColor ||
        oldDelegate.progressColor != progressColor ||
        oldDelegate.strokeWidth != strokeWidth;
  }
}

class _QuickRecordOption {
  final String name;
  final String category;
  final int volume;
  final String size;
  final String imageAsset;

  const _QuickRecordOption({
    required this.name,
    required this.category,
    required this.volume,
    required this.size,
    required this.imageAsset,
  });

  String get displayLabel => '$volume ml';
}
