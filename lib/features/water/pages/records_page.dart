import '../widgets/glassmorphic_wrapper.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../models/drink_record.dart';
import '../services/database_service.dart';
import '../services/session_service.dart';
import '../../../../core/theme/app_colors.dart';
import '../utils/navigation_helper.dart';
import '../widgets/price_glow_badge.dart';

enum _RecordSortMode {
  latest,
  earliest,
  caloriesHigh,
  caloriesLow,
  sugarHigh,
  sugarLow,
  caffeineHigh,
  caffeineLow,
  volumeHigh,
  volumeLow,
  priceHigh,
  priceLow,
}

class RecordsPage extends StatefulWidget {
  final bool showBackButton;
  final bool useWrapper;

  const RecordsPage({
    super.key,
    this.showBackButton = true,
    this.useWrapper = true,
  });

  @override
  State<RecordsPage> createState() => _RecordsPageState();
}

class _RecordFilterHeaderDelegate extends SliverPersistentHeaderDelegate {
  @override
  final double minExtent;

  @override
  final double maxExtent;

  final Widget child;

  _RecordFilterHeaderDelegate({
    required this.minExtent,
    required this.maxExtent,
    required this.child,
  });

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return child;
  }

  @override
  bool shouldRebuild(covariant _RecordFilterHeaderDelegate oldDelegate) {
    return minExtent != oldDelegate.minExtent ||
        maxExtent != oldDelegate.maxExtent ||
        child != oldDelegate.child;
  }
}

class _RecordsPageState extends State<RecordsPage> {
  final DatabaseService _db = DatabaseService();
  final TextEditingController _searchController = TextEditingController();

  bool _isLoading = true;
  String _userId = 'guest';
  List<DrinkRecord> _allRecords = [];
  List<DrinkRecord> _filteredRecords = [];
  int _selectedTab = 0; // 0: 全部, 1: 本周, 2: 本月, 3: 本年, 4: 自定义
  String _selectedCategoryFilter = '全部类型';
  String _selectedBrandFilter = '全部品牌';
  String _selectedPriceFilter = '全部消费';
  RangeValues _calorieRange = const RangeValues(0, 1000);
  RangeValues _sugarRange = const RangeValues(0, 120);
  RangeValues _caffeineRange = const RangeValues(0, 500);
  _RecordSortMode _sortMode = _RecordSortMode.latest;
  bool _galleryMode = false;

  DateTimeRange? _customDateRange;

  @override
  void initState() {
    super.initState();
    _loadRecords();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadRecords() async {
    try {
      _userId = await SessionService.getCurrentUserId() ?? 'guest';
      final records = await _db.getDrinkRecords(userId: _userId);
      setState(() {
        _allRecords = records;
        _isLoading = false;
        _applyFilters(notify: false);
      });
    } catch (_) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _onSearchChanged() {
    _applyFilters();
  }

  void _applyFilters({bool notify = true}) {
    final query = _searchController.text.trim().toLowerCase();
    var temp = List<DrinkRecord>.from(_allRecords);

    // 1. 按搜索词过滤
    if (query.isNotEmpty) {
      temp = temp.where((r) {
        final nameMatch = r.name.toLowerCase().contains(query);
        final brandMatch =
            r.brand != null && r.brand!.toLowerCase().contains(query);
        return nameMatch || brandMatch;
      }).toList();
    }

    // 2. 按时间范围过滤
    final now = DateTime.now();
    if (_selectedTab == 1) {
      // 本周 (以星期一为第一天)
      final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
      final start = DateTime(
        startOfWeek.year,
        startOfWeek.month,
        startOfWeek.day,
      );
      final end = DateTime(now.year, now.month, now.day, 23, 59, 59);
      temp = temp
          .where((r) => _isWithinRange(r.recordTime, start, end))
          .toList();
    } else if (_selectedTab == 2) {
      // 本月
      final start = DateTime(now.year, now.month, 1);
      final end = DateTime(
        now.year,
        now.month + 1,
        1,
      ).subtract(const Duration(seconds: 1));
      temp = temp
          .where((r) => _isWithinRange(r.recordTime, start, end))
          .toList();
    } else if (_selectedTab == 3) {
      // 本年
      final start = DateTime(now.year, 1, 1);
      final end = DateTime(
        now.year + 1,
        1,
        1,
      ).subtract(const Duration(seconds: 1));
      temp = temp
          .where((r) => _isWithinRange(r.recordTime, start, end))
          .toList();
    } else if (_selectedTab == 4 && _customDateRange != null) {
      // 自定义
      final start = DateTime(
        _customDateRange!.start.year,
        _customDateRange!.start.month,
        _customDateRange!.start.day,
      );
      final end = DateTime(
        _customDateRange!.end.year,
        _customDateRange!.end.month,
        _customDateRange!.end.day,
        23,
        59,
        59,
      );
      temp = temp
          .where((r) => _isWithinRange(r.recordTime, start, end))
          .toList();
    }

    if (_selectedCategoryFilter != '全部类型') {
      temp = temp.where((r) => r.category == _selectedCategoryFilter).toList();
    }

    if (_selectedBrandFilter != '全部品牌') {
      temp = temp.where((r) {
        final brand = (r.brand == null || r.brand!.trim().isEmpty)
            ? '无品牌'
            : r.brand!.trim();
        return brand == _selectedBrandFilter;
      }).toList();
    }

    if (_selectedPriceFilter == '免费') {
      temp = temp.where((r) => r.price == null || r.price! <= 0).toList();
    } else if (_selectedPriceFilter == '付费') {
      temp = temp.where((r) => r.price != null && r.price! > 0).toList();
    }

    if (_calorieRange.start > 0 || _calorieRange.end < 1000) {
      temp = temp.where((r) {
        return r.calories >= _calorieRange.start &&
            r.calories <= _calorieRange.end;
      }).toList();
    }

    if (_sugarRange.start > 0 || _sugarRange.end < 120) {
      temp = temp.where((r) {
        return r.sugar >= _sugarRange.start && r.sugar <= _sugarRange.end;
      }).toList();
    }

    if (_caffeineRange.start > 0 || _caffeineRange.end < 500) {
      temp = temp.where((r) {
        return r.caffeine >= _caffeineRange.start &&
            r.caffeine <= _caffeineRange.end;
      }).toList();
    }

    temp.sort(_compareRecords);

    if (!notify) {
      _filteredRecords = temp;
      return;
    }
    setState(() {
      _filteredRecords = temp;
    });
  }

  bool _isWithinRange(DateTime value, DateTime start, DateTime end) {
    return !value.isBefore(start) && !value.isAfter(end);
  }

  int _compareRecords(DrinkRecord a, DrinkRecord b) {
    int result;
    switch (_sortMode) {
      case _RecordSortMode.earliest:
        result = a.recordTime.compareTo(b.recordTime);
        break;
      case _RecordSortMode.caloriesHigh:
        result = b.calories.compareTo(a.calories);
        break;
      case _RecordSortMode.caloriesLow:
        result = a.calories.compareTo(b.calories);
        break;
      case _RecordSortMode.sugarHigh:
        result = b.sugar.compareTo(a.sugar);
        break;
      case _RecordSortMode.sugarLow:
        result = a.sugar.compareTo(b.sugar);
        break;
      case _RecordSortMode.caffeineHigh:
        result = b.caffeine.compareTo(a.caffeine);
        break;
      case _RecordSortMode.caffeineLow:
        result = a.caffeine.compareTo(b.caffeine);
        break;
      case _RecordSortMode.volumeHigh:
        result = b.volume.compareTo(a.volume);
        break;
      case _RecordSortMode.volumeLow:
        result = a.volume.compareTo(b.volume);
        break;
      case _RecordSortMode.priceHigh:
        result = (b.price ?? 0).compareTo(a.price ?? 0);
        break;
      case _RecordSortMode.priceLow:
        result = (a.price ?? 0).compareTo(b.price ?? 0);
        break;
      case _RecordSortMode.latest:
        result = b.recordTime.compareTo(a.recordTime);
        break;
    }
    if (result != 0) return result;

    final timeFallback = b.recordTime.compareTo(a.recordTime);
    if (timeFallback != 0) return timeFallback;
    return (b.id ?? 0).compareTo(a.id ?? 0);
  }

  // 选择自定义时间段
  Future<void> _selectCustomDateRange() async {
    final pickedRange = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 1)),
      initialDateRange:
          _customDateRange ??
          DateTimeRange(
            start: DateTime.now().subtract(const Duration(days: 7)),
            end: DateTime.now(),
          ),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            dialogTheme: const DialogThemeData(
              backgroundColor: Colors.white,
              surfaceTintColor: Colors.transparent,
            ),
            colorScheme: Theme.of(context).colorScheme.copyWith(
              surface: Colors.white,
              primary: AppColors.primary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedRange != null) {
      setState(() {
        _customDateRange = pickedRange;
        _applyFilters(notify: false);
      });
    }
  }

  List<String> get _availableCategories {
    final values = _allRecords
        .map((r) => r.category)
        .where((v) => v.isNotEmpty)
        .toSet()
        .toList();
    values.sort();
    return ['全部类型', ...values];
  }

  List<String> get _availableBrands {
    final values = _allRecords
        .map(
          (r) => (r.brand == null || r.brand!.trim().isEmpty)
              ? '无品牌'
              : r.brand!.trim(),
        )
        .toSet()
        .toList();
    values.sort((a, b) {
      if (a == '无品牌') return -1;
      if (b == '无品牌') return 1;
      return a.compareTo(b);
    });
    return ['全部品牌', ...values];
  }

  bool get _hasAdvancedFilters {
    return _selectedCategoryFilter != '全部类型' ||
        _selectedBrandFilter != '全部品牌' ||
        _selectedPriceFilter != '全部消费' ||
        _calorieRange.start > 0 ||
        _calorieRange.end < 1000 ||
        _sugarRange.start > 0 ||
        _sugarRange.end < 120 ||
        _caffeineRange.start > 0 ||
        _caffeineRange.end < 500 ||
        _sortMode != _RecordSortMode.latest;
  }

  String get _sortLabel {
    switch (_sortMode) {
      case _RecordSortMode.latest:
        return '最新优先';
      case _RecordSortMode.earliest:
        return '最早优先';
      case _RecordSortMode.caloriesHigh:
        return '热量高到低';
      case _RecordSortMode.caloriesLow:
        return '热量低到高';
      case _RecordSortMode.sugarHigh:
        return '糖分高到低';
      case _RecordSortMode.sugarLow:
        return '糖分低到高';
      case _RecordSortMode.caffeineHigh:
        return '咖啡因高到低';
      case _RecordSortMode.caffeineLow:
        return '咖啡因低到高';
      case _RecordSortMode.volumeHigh:
        return '容量大到小';
      case _RecordSortMode.volumeLow:
        return '容量小到大';
      case _RecordSortMode.priceHigh:
        return '价格高到低';
      case _RecordSortMode.priceLow:
        return '价格低到高';
    }
  }

  String _displayRecordName(DrinkRecord record) {
    return record.name == '白开水' ? '水' : record.name;
  }

  void _resetAdvancedFilters() {
    setState(() {
      _selectedCategoryFilter = '全部类型';
      _selectedBrandFilter = '全部品牌';
      _selectedPriceFilter = '全部消费';
      _calorieRange = const RangeValues(0, 1000);
      _sugarRange = const RangeValues(0, 120);
      _caffeineRange = const RangeValues(0, 500);
      _sortMode = _RecordSortMode.latest;
      _applyFilters(notify: false);
    });
  }

  Future<void> _showFilterSheet() async {
    var category = _selectedCategoryFilter;
    var brand = _selectedBrandFilter;
    var price = _selectedPriceFilter;
    var calories = _calorieRange;
    var sugar = _sugarRange;
    var caffeine = _caffeineRange;
    var sortMode = _sortMode;

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.86,
              ),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: SafeArea(
                top: false,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(18, 12, 18, 8),
                      child: Row(
                        children: [
                          Container(
                            width: 38,
                            height: 4,
                            decoration: BoxDecoration(
                              color: const Color(0xFFE8D8CC),
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                          const Spacer(),
                          TextButton(
                            onPressed: () {
                              setModalState(() {
                                category = '全部类型';
                                brand = '全部品牌';
                                price = '全部消费';
                                calories = const RangeValues(0, 1000);
                                sugar = const RangeValues(0, 120);
                                caffeine = const RangeValues(0, 500);
                                sortMode = _RecordSortMode.latest;
                              });
                            },
                            child: const Text('重置'),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: ListView(
                        padding: const EdgeInsets.fromLTRB(18, 4, 18, 18),
                        children: [
                          const Text(
                            '筛选与排序',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w900,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 18),
                          _buildSheetSection(
                            title: '排序',
                            child: _buildChoiceWrap<_RecordSortMode>(
                              values: _RecordSortMode.values,
                              selected: sortMode,
                              label: _sortModeLabel,
                              onSelected: (value) {
                                setModalState(() => sortMode = value);
                              },
                            ),
                          ),
                          _buildSheetSection(
                            title: '类型',
                            child: _buildChoiceWrap<String>(
                              values: _availableCategories,
                              selected: category,
                              label: (value) => value == '白开水' ? '水' : value,
                              onSelected: (value) {
                                setModalState(() => category = value);
                              },
                            ),
                          ),
                          _buildSheetSection(
                            title: '品牌',
                            child: _buildChoiceWrap<String>(
                              values: _availableBrands,
                              selected: brand,
                              label: (value) => value,
                              onSelected: (value) {
                                setModalState(() => brand = value);
                              },
                            ),
                          ),
                          _buildSheetSection(
                            title: '消费',
                            child: _buildChoiceWrap<String>(
                              values: const ['全部消费', '免费', '付费'],
                              selected: price,
                              label: (value) => value,
                              onSelected: (value) {
                                setModalState(() => price = value);
                              },
                            ),
                          ),
                          _buildRangeSection(
                            title: '热量',
                            unit: 'kcal',
                            value: calories,
                            min: 0,
                            max: 1000,
                            divisions: 20,
                            onChanged: (value) {
                              setModalState(() => calories = value);
                            },
                          ),
                          _buildRangeSection(
                            title: '糖分',
                            unit: 'g',
                            value: sugar,
                            min: 0,
                            max: 120,
                            divisions: 24,
                            onChanged: (value) {
                              setModalState(() => sugar = value);
                            },
                          ),
                          _buildRangeSection(
                            title: '咖啡因',
                            unit: 'mg',
                            value: caffeine,
                            min: 0,
                            max: 500,
                            divisions: 20,
                            onChanged: (value) {
                              setModalState(() => caffeine = value);
                            },
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(18, 10, 18, 16),
                      child: SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _selectedCategoryFilter = category;
                              _selectedBrandFilter = brand;
                              _selectedPriceFilter = price;
                              _calorieRange = calories;
                              _sugarRange = sugar;
                              _caffeineRange = caffeine;
                              _sortMode = sortMode;
                              _applyFilters(notify: false);
                            });
                            Navigator.pop(context);
                          },
                          child: const Text('应用筛选'),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  String _sortModeLabel(_RecordSortMode mode) {
    switch (mode) {
      case _RecordSortMode.latest:
        return '最新';
      case _RecordSortMode.earliest:
        return '最早';
      case _RecordSortMode.caloriesHigh:
        return '热量高';
      case _RecordSortMode.caloriesLow:
        return '热量低';
      case _RecordSortMode.sugarHigh:
        return '糖分高';
      case _RecordSortMode.sugarLow:
        return '糖分低';
      case _RecordSortMode.caffeineHigh:
        return '咖啡因高';
      case _RecordSortMode.caffeineLow:
        return '咖啡因低';
      case _RecordSortMode.volumeHigh:
        return '容量大';
      case _RecordSortMode.volumeLow:
        return '容量小';
      case _RecordSortMode.priceHigh:
        return '价格高';
      case _RecordSortMode.priceLow:
        return '价格低';
    }
  }

  Widget _buildSheetSection({required String title, required Widget child}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 10),
          child,
        ],
      ),
    );
  }

  Widget _buildChoiceWrap<T>({
    required List<T> values,
    required T selected,
    required String Function(T value) label,
    required ValueChanged<T> onSelected,
  }) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: values.map((value) {
        final isSelected = value == selected;
        return ChoiceChip(
          label: Text(label(value)),
          selected: isSelected,
          onSelected: (_) => onSelected(value),
          showCheckmark: false,
          selectedColor: AppColors.primaryLight,
          backgroundColor: Colors.white,
          labelStyle: TextStyle(
            color: isSelected ? AppColors.primaryDark : Colors.black87,
            fontWeight: isSelected ? FontWeight.w800 : FontWeight.w500,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
            side: BorderSide(
              color: isSelected
                  ? AppColors.primary
                  : const Color(0xFFE8D8CC),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildRangeSection({
    required String title,
    required String unit,
    required RangeValues value,
    required double min,
    required double max,
    required int divisions,
    required ValueChanged<RangeValues> onChanged,
  }) {
    return _buildSheetSection(
      title: '$title ${value.start.round()}-${value.end.round()}$unit',
      child: RangeSlider(
        values: value,
        min: min,
        max: max,
        divisions: divisions,
        activeColor: AppColors.primary,
        inactiveColor: AppColors.primaryLight,
        labels: RangeLabels(
          '${value.start.round()}$unit',
          '${value.end.round()}$unit',
        ),
        onChanged: onChanged,
      ),
    );
  }

  // 分组记录：Map<日期, List<DrinkRecord>>
  Map<String, List<DrinkRecord>> _groupRecordsByDate() {
    final Map<String, List<DrinkRecord>> grouped = {};

    for (var record in _filteredRecords) {
      final date = record.recordTime;
      final weekday = _getWeekdayString(date.weekday);
      final key = '${date.year}年${date.month}月${date.day}日 $weekday';

      if (!grouped.containsKey(key)) {
        grouped[key] = [];
      }
      grouped[key]!.add(record);
    }
    return grouped;
  }

  List<DrinkRecord> get _photoRecords => _filteredRecords.where((record) {
    final imagePath = record.imagePath?.trim();
    return imagePath != null && imagePath.isNotEmpty;
  }).toList();

  String _getWeekdayString(int day) {
    if (day >= 1 && day <= 7) {
      const daysMapping = {
        1: '星期一',
        2: '星期二',
        3: '星期三',
        4: '星期四',
        5: '星期五',
        6: '星期六',
        7: '星期日',
      };
      return daysMapping[day]!;
    }
    return '';
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case '奶茶':
      case '果茶':
        return Icons.local_drink;
      case '咖啡':
        return Icons.coffee;
      case '白开水':
        return Icons.water_drop;
      case '瓶装饮品':
        return Icons.takeout_dining;
      default:
        return Icons.local_cafe;
    }
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case '奶茶':
        return const Color(0xFFFCD34D); // amber
      case '果茶':
        return const Color(0xFFF472B6); // pink
      case '咖啡':
        return const Color(0xFF8B5CF6); // purple
      case '白开水':
        return const Color(0xFF60A5FA); // blue
      default:
        return const Color(0xFFA7F3D0); // green
    }
  }

  // 删除单条记录
  Future<void> _deleteRecord(DrinkRecord record) async {
    if (record.id == null) return;

    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          '删除记录',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Text('您确定要删除这一条「${_displayRecordName(record)}」的喝水记录吗？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('删除'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await _db.deleteDrinkRecord(record.id!);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('已删除「${_displayRecordName(record)}」的记录')),
      );
      _loadRecords();
    }
  }

  @override
  Widget build(BuildContext context) {
    final groupedRecords = _groupRecordsByDate();

    final scaffold = Scaffold(
      backgroundColor: widget.useWrapper
          ? AppColors.background
          : Colors.transparent,
      appBar: widget.showBackButton
          ? AppBar(
              title: const Text(
                '喝水记录',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  height: 1.2,
                ),
              ),
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
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _buildRecordScrollView(groupedRecords),
      ),
    );

    return scaffold;
  }

  Widget _buildRecordScrollView(Map<String, List<DrinkRecord>> groupedRecords) {
    final bottomPadding = widget.useWrapper ? 24.0 : 98.0;
    return CustomScrollView(
      slivers: [
        if (!widget.showBackButton)
          SliverToBoxAdapter(child: _buildTopLevelHeader('喝水记录')),
        SliverToBoxAdapter(child: _buildSearchField()),
        SliverPersistentHeader(
          pinned: true,
          delegate: _RecordFilterHeaderDelegate(
            minExtent: _hasAdvancedFilters ? 112 : 102,
            maxExtent: _hasAdvancedFilters ? 112 : 102,
            child: _buildPinnedFilterHeader(),
          ),
        ),
        if (_selectedTab == 4) SliverToBoxAdapter(child: _buildDateRangeCard()),
        if (_filteredRecords.isEmpty)
          SliverFillRemaining(
            hasScrollBody: false,
            child: _buildEmptyRecordsState(bottomPadding),
          )
        else if (_galleryMode)
          _buildGallerySliver(bottomPadding)
        else
          SliverPadding(
            padding: EdgeInsets.fromLTRB(16, 8, 16, bottomPadding),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                final dateKey = groupedRecords.keys.elementAt(index);
                final records = groupedRecords[dateKey]!;
                return _buildRecordDateGroup(dateKey, records);
              }, childCount: groupedRecords.length),
            ),
          ),
      ],
    );
  }

  Widget _buildSearchField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: '搜索饮品名称或品牌...',
          prefixIcon: const Icon(Icons.search, color: Colors.grey),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear, color: Colors.grey),
                  onPressed: () {
                    _searchController.clear();
                    _applyFilters();
                  },
                )
              : null,
          filled: true,
          fillColor: Colors.white.withValues(alpha: 0.8),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(
              color: Colors.black.withValues(alpha: 0.08),
              width: 1.5,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(
              color: Colors.black.withValues(alpha: 0.08),
              width: 1.5,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Colors.black45, width: 1.5),
          ),
        ),
      ),
    );
  }

  Widget _buildPinnedFilterHeader() {
    final visibleCount = _galleryMode
        ? _photoRecords.length
        : _filteredRecords.length;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: widget.useWrapper ? AppColors.background : Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
            child: Row(
              children: [
                _buildTabButton('全部', 0),
                _buildTabButton('本周', 1),
                _buildTabButton('本月', 2),
                _buildTabButton('本年', 3),
                _buildTabButton('自定义范围', 4),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 6),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    '$visibleCount 条 · $_sortLabel',
                    style: const TextStyle(
                      color: Colors.black54,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                _buildViewModeButton(
                  icon: Icons.view_agenda_outlined,
                  selected: !_galleryMode,
                  tooltip: '列表',
                  onTap: () => setState(() => _galleryMode = false),
                ),
                const SizedBox(width: 6),
                _buildViewModeButton(
                  icon: Icons.grid_view_rounded,
                  selected: _galleryMode,
                  tooltip: '相册',
                  onTap: () => setState(() => _galleryMode = true),
                ),
                const SizedBox(width: 8),
                TextButton.icon(
                  onPressed: _showFilterSheet,
                  icon: Icon(
                    _hasAdvancedFilters
                        ? Icons.filter_alt
                        : Icons.filter_alt_outlined,
                    size: 18,
                  ),
                  label: Text(_hasAdvancedFilters ? '筛选中' : '筛选'),
                  style: TextButton.styleFrom(
                    foregroundColor: _hasAdvancedFilters
                        ? AppColors.primaryDark
                        : Colors.black87,
                    backgroundColor: _hasAdvancedFilters
                        ? AppColors.primaryLight
                        : const Color(0xFFF9FAFB),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 8,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: BorderSide(
                        color: _hasAdvancedFilters
                            ? AppColors.primary
                            : Colors.black.withValues(alpha: 0.08),
                      ),
                    ),
                  ),
                ),
                if (_hasAdvancedFilters) ...[
                  const SizedBox(width: 8),
                  IconButton(
                    onPressed: _resetAdvancedFilters,
                    icon: const Icon(Icons.restart_alt_rounded),
                    tooltip: '重置筛选',
                    color: Colors.black54,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildViewModeButton({
    required IconData icon,
    required bool selected,
    required String tooltip,
    required VoidCallback onTap,
  }) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: selected ? AppColors.primaryLight : const Color(0xFFF9FAFB),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: selected
                  ? AppColors.primary
                  : Colors.black.withValues(alpha: 0.08),
            ),
          ),
          child: Icon(
            icon,
            size: 18,
            color: selected ? AppColors.primary : Colors.black54,
          ),
        ),
      ),
    );
  }

  Widget _buildGallerySliver(double bottomPadding) {
    final photoRecords = _photoRecords;
    if (photoRecords.isEmpty) {
      return SliverFillRemaining(
        hasScrollBody: false,
        child: _buildEmptyGalleryState(bottomPadding),
      );
    }

    return SliverPadding(
      padding: EdgeInsets.fromLTRB(16, 12, 16, bottomPadding),
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 6,
          crossAxisSpacing: 6,
          childAspectRatio: 0.78,
        ),
        delegate: SliverChildBuilderDelegate((context, index) {
          return _buildGalleryTile(photoRecords[index]);
        }, childCount: photoRecords.length),
      ),
    );
  }

  Widget _buildGalleryTile(DrinkRecord record) {
    final imagePath = record.imagePath!.trim();
    final name = _displayRecordName(record);
    final timeText =
        '${record.recordTime.month}/${record.recordTime.day} ${record.recordTime.hour.toString().padLeft(2, '0')}:${record.recordTime.minute.toString().padLeft(2, '0')}';

    return InkWell(
      onTap: () => context.push('/records/${record.id}'),
      borderRadius: BorderRadius.circular(8),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Hero(
              tag: 'record_image_${record.id ?? record.hashCode}',
              child: Image.file(
              File(imagePath),
              fit: BoxFit.cover,
              filterQuality: FilterQuality.high,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: const Color(0xFFF1F0EC),
                  child: Icon(
                    _getCategoryIcon(record.category),
                    color: AppColors.textSecondary,
                  ),
                );
              },
            ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                padding: const EdgeInsets.fromLTRB(8, 22, 8, 8),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withValues(alpha: 0),
                      Colors.black.withValues(alpha: 0.48),
                    ],
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      timeText,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.86),
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyGalleryState(double bottomPadding) {
    return Padding(
      padding: EdgeInsets.only(bottom: bottomPadding),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.photo_library_outlined,
            size: 60,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 12),
          Text(
            '还没有带照片的记录',
            style: TextStyle(fontSize: 16, color: Colors.grey.shade500),
          ),
        ],
      ),
    );
  }

  Widget _buildDateRangeCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        onTap: _selectCustomDateRange,
        child: GlassmorphicCard(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          borderRadius: 12,
          child: Row(
            children: [
              const Icon(Icons.calendar_month, color: Colors.black54),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  _customDateRange == null
                      ? '点击选择起止日期...'
                      : '${_customDateRange!.start.year}/${_customDateRange!.start.month}/${_customDateRange!.start.day} - ${_customDateRange!.end.year}/${_customDateRange!.end.month}/${_customDateRange!.end.day}',
                  style: const TextStyle(fontSize: 14, color: Colors.black87),
                ),
              ),
              const Icon(Icons.chevron_right, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyRecordsState(double bottomPadding) {
    return Padding(
      padding: EdgeInsets.only(bottom: bottomPadding),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.local_drink_outlined,
            size: 64,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 12),
          Text(
            '没有任何喝水记录',
            style: TextStyle(fontSize: 16, color: Colors.grey.shade500),
          ),
        ],
      ),
    );
  }

  Widget _buildRecordDateGroup(String dateKey, List<DrinkRecord> records) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, top: 12, bottom: 8),
          child: Text(
            dateKey,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.black54,
            ),
          ),
        ),
        ...records.map(_buildRecordListItem),
      ],
    );
  }

  Widget _buildRecordListItem(DrinkRecord record) {
    final timeStr =
        '${record.recordTime.hour.toString().padLeft(2, '0')}:${record.recordTime.minute.toString().padLeft(2, '0')}';
    final displayName = _displayRecordName(record);
    final brandLabel = record.brand != null && record.brand!.isNotEmpty
        ? '${record.brand} · '
        : '';
    final nutritionText =
        '${record.calories.round()}kcal · ${record.caffeine.round()}mg';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Dismissible(
        key: Key('record_${record.id}'),
        background: Container(
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: 20),
          decoration: BoxDecoration(
            color: AppColors.error,
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Icon(Icons.delete, color: Colors.white),
        ),
        direction: DismissDirection.endToStart,
        confirmDismiss: (_) async {
          await _deleteRecord(record);
          return false;
        },
        child: InkWell(
          onTap: () => context.push('/records/${record.id}'),
          borderRadius: BorderRadius.circular(16),
          child: GlassmorphicCard(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                _buildRecordLeadingIcon(record),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '$brandLabel$displayName',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        nutritionText,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.black45,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      timeStr,
                      style: const TextStyle(
                        fontSize: 15,
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      '${record.volume.round()}ml',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    if (record.price != null && record.price! > 0) ...[
                      const SizedBox(height: 6),
                      PriceGlowBadge(price: record.price, compact: true),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTopLevelHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 8, 18, 8),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 22,
            fontWeight: FontWeight.w900,
            height: 1.15,
          ),
        ),
      ),
    );
  }

  Widget _buildRecordLeadingIcon(DrinkRecord record) {
    final imagePath = record.imagePath?.trim();
    if (imagePath != null && imagePath.isNotEmpty) {
      return Container(
        width: 44,
        height: 44,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: const Color(0xFFF1F0EC),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFE8E1D8)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(3),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Hero(
              tag: 'record_image_${record.id ?? record.hashCode}',
              child: Image.file(
                File(imagePath),
                fit: BoxFit.cover,
                filterQuality: FilterQuality.high,
                errorBuilder: (context, error, stackTrace) =>
                    _buildCategoryLeadingIcon(record),
              ),
            ),
          ),
        ),
      );
    }

    return _buildCategoryLeadingIcon(record);
  }

  Widget _buildCategoryLeadingIcon(DrinkRecord record) {
    final color = _getCategoryColor(record.category);
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        shape: BoxShape.circle,
      ),
      child: Icon(_getCategoryIcon(record.category), color: color, size: 22),
    );
  }

  Widget _buildTabButton(String title, int tabIndex) {
    final isSelected = _selectedTab == tabIndex;

    return Padding(
      padding: const EdgeInsets.only(right: 18),
      child: InkWell(
        onTap: () {
          setState(() {
            _selectedTab = tabIndex;
            _applyFilters(notify: false);
          });
          if (tabIndex == 4 && _customDateRange == null) {
            _selectCustomDateRange();
          }
        },
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 160),
                width: isSelected ? 6 : 0,
                height: 6,
                margin: EdgeInsets.only(right: isSelected ? 6 : 0),
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
              ),
              Text(
                title,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: isSelected ? FontWeight.w800 : FontWeight.w500,
                  color: isSelected ? AppColors.primaryDark : Colors.black54,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
