import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:drift/drift.dart' hide Column;
import '../../core/services/database_provider.dart';
import '../../core/database/app_database.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimens.dart';
import '../../l10n/app_localizations.dart';
import '../../l10n/app_l10n_ext.dart';

// 食物 mock 数据库
class FoodItem {
  final String id, name, category;
  final double cal, protein, fat, carbs;
  final IconData icon;
  const FoodItem(this.id, this.name, this.category, this.cal, this.protein, this.fat, this.carbs, this.icon);
}

const _foods = <FoodItem>[
  // 主食
  FoodItem('rice', '米饭', '主食', 116, 2.6, 0.3, 25.6, Icons.rice_bowl_rounded),
  FoodItem('noodle', '面条', '主食', 138, 5.0, 0.9, 25.0, Icons.ramen_dining_rounded),
  FoodItem('bread', '面包', '主食', 80, 3.0, 1.0, 15.0, Icons.bakery_dining_rounded),
  FoodItem('mantou', '馒头', '主食', 88, 1.9, 0.2, 18.5, Icons.bakery_dining_rounded),
  // 肉类
  FoodItem('chicken', '鸡胸肉', '肉类', 165, 31.0, 3.6, 0, Icons.set_meal_rounded),
  FoodItem('beef', '牛肉', '肉类', 250, 26.0, 17.0, 0, Icons.set_meal_rounded),
  FoodItem('fish', '鱼肉', '肉类', 100, 20.0, 2.5, 0, Icons.set_meal_rounded),
  FoodItem('egg', '鸡蛋', '肉类', 78, 6.3, 5.3, 0.6, Icons.egg_rounded),
  // 蔬菜
  FoodItem('broccoli', '西兰花', '蔬菜', 34, 2.8, 0.4, 7.0, Icons.eco_rounded),
  FoodItem('tomato', '番茄', '蔬菜', 18, 0.9, 0.2, 3.9, Icons.eco_rounded),
  FoodItem('cucumber', '黄瓜', '蔬菜', 16, 0.7, 0.1, 3.6, Icons.eco_rounded),
  // 水果
  FoodItem('apple', '苹果', '水果', 52, 0.3, 0.2, 14.0, Icons.apple_rounded),
  FoodItem('banana', '香蕉', '水果', 89, 1.1, 0.3, 23.0, Icons.eco_rounded),
  FoodItem('orange', '橙子', '水果', 47, 0.9, 0.1, 12.0, Icons.eco_rounded),
  // 饮品
  FoodItem('milk', '牛奶', '饮品', 42, 3.4, 1.0, 5.0, Icons.local_drink_rounded),
  FoodItem('coffee', '咖啡', '饮品', 2, 0.3, 0, 0, Icons.local_cafe_rounded),
  FoodItem('cola', '可乐', '饮品', 42, 0, 0, 11.0, Icons.local_drink_rounded),
];

class DietEntry {
  final String id;
  final FoodItem food;
  final double servings;
  final DateTime time;
  final MealType meal;
  DietEntry({required this.id, required this.food, required this.servings, required this.time, required this.meal});
  double get cal => food.cal * servings;
  double get protein => food.protein * servings;
  double get fat => food.fat * servings;
  double get carbs => food.carbs * servings;
}

enum MealType { breakfast, lunch, dinner, snack }

extension MealTypeX on MealType {
  String get label {
    switch (this) {
      case MealType.breakfast: return '早餐';
      case MealType.lunch: return '午餐';
      case MealType.dinner: return '晚餐';
      case MealType.snack: return '加餐';
    }
  }
  IconData get icon {
    switch (this) {
      case MealType.breakfast: return Icons.wb_sunny_rounded;
      case MealType.lunch: return Icons.lunch_dining_rounded;
      case MealType.dinner: return Icons.nightlight_rounded;
      case MealType.snack: return Icons.cookie_rounded;
    }
  }
  Color get color {
    switch (this) {
      case MealType.breakfast: return AppColors.sportRun;
      case MealType.lunch: return AppColors.sportOther;
      case MealType.dinner: return AppColors.sportOther;
      case MealType.snack: return AppColors.sportOther;
    }
  }
}

class DietState {
  final List<DietEntry> entries;
  final double goal;
  DietState({this.entries = const [], this.goal = 2000});
  double get totalCal => entries.fold(0, (s, e) => s + e.cal);
  double get totalProtein => entries.fold(0, (s, e) => s + e.protein);
  double get totalFat => entries.fold(0, (s, e) => s + e.fat);
  double get totalCarbs => entries.fold(0, (s, e) => s + e.carbs);
  double get progress => (totalCal / goal).clamp(0.0, 1.0);
  int get remaining => (goal - totalCal).round().clamp(0, goal.round());
  List<DietEntry> byMeal(MealType m) => entries.where((e) => e.meal == m).toList();
  double mealCal(MealType m) => byMeal(m).fold(0, (s, e) => s + e.cal);
}

class DietNotifier extends AsyncNotifier<DietState> {
  @override
  Future<DietState> build() async {
    return _loadFromDb();
  }

  Future<DietState> _loadFromDb() async {
    final db = ref.read(databaseProvider);
    final today = DateTime.now();
    final start = DateTime(today.year, today.month, today.day);
    final records = await (db.select(db.dietRecords)..where((t) => t.time.isBiggerOrEqualValue(start))).get();
    
    List<DietEntry> entries = [];
    for (var r in records) {
      if (r.note != null && r.note!.isNotEmpty) {
        try {
           final map = jsonDecode(r.note!);
           final food = FoodItem(
             map['id'] ?? '',
             r.foodName ?? '',
             map['category'] ?? '',
             (map['cal'] ?? 0.0).toDouble(),
             (map['protein'] ?? 0.0).toDouble(),
             (map['fat'] ?? 0.0).toDouble(),
             (map['carbs'] ?? 0.0).toDouble(),
             Icons.fastfood_rounded, // fallback icon
           );
           entries.add(DietEntry(
             id: r.id.toString(),
             food: food,
             servings: (map['servings'] ?? 1.0).toDouble(),
             time: r.time,
             meal: MealType.values[r.mealType],
           ));
        } catch (e) {
          debugPrint('parse diet error: $e');
        }
      }
    }
    return DietState(entries: entries, goal: 2000);
  }

  Future<void> addEntry(FoodItem food, double servings, MealType meal, {DateTime? time}) async {
    final db = ref.read(databaseProvider);
    final map = {
      'id': food.id,
      'category': food.category,
      'cal': food.cal,
      'protein': food.protein,
      'fat': food.fat,
      'carbs': food.carbs,
      'servings': servings,
    };
    final now = time ?? DateTime.now();
    await db.into(db.dietRecords).insert(DietRecordsCompanion.insert(
      time: now,
      calories: Value((food.cal * servings).round()),
      foodName: Value(food.name),
      note: Value(jsonEncode(map)),
      mealType: Value(meal.index),
    ));
    state = AsyncValue.data(await _loadFromDb());
  }

  Future<void> removeEntry(String id) async {
    final db = ref.read(databaseProvider);
    final recordId = int.tryParse(id);
    if (recordId != null) {
      await (db.delete(db.dietRecords)..where((t) => t.id.equals(recordId))).go();
      state = AsyncValue.data(await _loadFromDb());
    }
  }

  void setGoal(double g) {
    if (state.hasValue) {
      state = AsyncValue.data(DietState(entries: state.value!.entries, goal: g));
    }
  }
}

final dietProvider = AsyncNotifierProvider<DietNotifier, DietState>(DietNotifier.new);


class DietScreen extends ConsumerWidget {
  const DietScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppL10n.of(context).s;
    final stateAsync = ref.watch(dietProvider);
    final state = stateAsync.valueOrNull ?? DietState();
    
    final percent = state.goal > 0 ? (state.totalCal / state.goal).clamp(0.0, 1.0) : 0.0;
    
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(l.dietRecord, style: const TextStyle(color: AppColors.textPrimary, fontSize: 18, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textPrimary, size: 20),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_month_rounded, color: AppColors.textPrimary),
            onPressed: () {}, // TODO: Calendar
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 80),
        children: [
          // 顶部环形进度区域
          Container(
            margin: const EdgeInsets.all(15),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                )
              ],
            ),
            child: Row(
              children: [
                // 环形进度条
                SizedBox(
                  width: 120,
                  height: 120,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      CircularPercentIndicator(
                        radius: 60.0,
                        lineWidth: 10.0,
                        animation: true,
                        percent: percent,
                        circularStrokeCap: CircularStrokeCap.round,
                        progressColor: AppColors.primary,
                        backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text('还可以吃', style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                          Text('${state.remaining}', style: const TextStyle(color: AppColors.textPrimary, fontSize: 28, fontWeight: FontWeight.bold)),
                          const Text('kcal', style: TextStyle(color: AppColors.textHint, fontSize: 12)),
                        ],
                      )
                    ],
                  ),
                ),
                const SizedBox(width: 24),
                // 右侧营养素指标
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildNutriRow('碳水化合物', state.totalCarbs, AppColors.sportRun),
                      const SizedBox(height: 12),
                      _buildNutriRow('蛋白质', state.totalProtein, AppColors.primary),
                      const SizedBox(height: 12),
                      _buildNutriRow('脂肪', state.totalFat, AppColors.sportOther),
                    ],
                  ),
                )
              ],
            ),
          ),
          const SizedBox(height: 10),
          // 4 个餐别
          ...MealType.values.map((meal) => _MealSection(
            meal: meal,
            entries: state.byMeal(meal),
            onAdd: () => _showFoodPicker(context, ref, meal),
            onRemove: (id) => ref.read(dietProvider.notifier).removeEntry(id),
          )),
          const SizedBox(height: 80),
        ],
      ),
    );
  }

  void _showFoodPicker(BuildContext context, WidgetRef ref, MealType meal) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.75,
        minChildSize: 0.4,
        maxChildSize: 0.95,
        builder: (ctx, scroll) => _FoodPicker(meal: meal, scroll: scroll),
      ),
    );
  }

  Widget _buildNutriRow(String label, double val, Color color) {
    return Row(
      children: [
        Container(width: 8, height: 8, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 6),
        Text(label, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
        const Spacer(),
        Text('${val.toStringAsFixed(0)} g', style: const TextStyle(color: AppColors.textPrimary, fontSize: 12, fontWeight: FontWeight.bold)),
      ],
    );
  }
}

class _MealSection extends StatelessWidget {
  final MealType meal;
  final List<DietEntry> entries;
  final VoidCallback onAdd;
  final ValueChanged<String> onRemove;
  const _MealSection({required this.meal, required this.entries, required this.onAdd, required this.onRemove});
  @override
  Widget build(BuildContext context) {
    final cal = entries.fold(0.0, (s, e) => s + e.cal);
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(AppDimens.spacingSm),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimens.radiusCard),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36, height: 36,
                decoration: BoxDecoration(
                  color: meal.color.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(meal.icon, color: meal.color, size: 20),
              ),
              const SizedBox(width: 10),
              Text(meal.label, style: const TextStyle(color: AppColors.textPrimary, fontSize: 16, fontWeight: FontWeight.w600)),
              const Spacer(),
              Text('${cal.toStringAsFixed(0)} kcal',
                style: TextStyle(color: meal.color, fontSize: 14, fontWeight: FontWeight.w600)),
              const SizedBox(width: 8),
              IconButton(
                icon: const Icon(Icons.add_circle_rounded, color: AppColors.primary),
                onPressed: onAdd,
                visualDensity: VisualDensity.compact,
              ),
            ],
          ),
          if (entries.isEmpty) Padding(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
            child: Text(AppL10n.of(context).s.tapToAdd,
              style: const TextStyle(color: AppColors.textHint, fontSize: 12)),
          ) else ...entries.map((e) => Container(
            margin: const EdgeInsets.only(top: 8),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: meal.color.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(e.food.icon, color: meal.color, size: 18),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(e.food.name, style: const TextStyle(color: AppColors.textPrimary, fontSize: 14, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          Icon(Icons.access_time_rounded, size: 12, color: AppColors.textHint),
                          const SizedBox(width: 4),
                          Text(DateFormat('HH:mm').format(e.time), style: const TextStyle(color: AppColors.textHint, fontSize: 11)),
                          const SizedBox(width: 8),
                          Text('${e.servings.toStringAsFixed(1)} 份', style: const TextStyle(color: AppColors.textHint, fontSize: 11)),
                        ],
                      ),
                    ],
                  ),
                ),
                Text('${e.cal.toStringAsFixed(0)} kcal',
                  style: const TextStyle(color: AppColors.textPrimary, fontSize: 14, fontWeight: FontWeight.bold)),
                const SizedBox(width: 8),
                InkWell(
                  onTap: () => onRemove(e.id),
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(color: Colors.red.withOpacity(0.1), borderRadius: BorderRadius.circular(6)),
                    child: const Icon(Icons.delete_outline, size: 16, color: Colors.red),
                  ),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }
}

// 食物选择器
class _FoodPicker extends ConsumerStatefulWidget {
  final MealType meal;
  final ScrollController scroll;
  const _FoodPicker({required this.meal, required this.scroll});
  @override
  ConsumerState<_FoodPicker> createState() => _FoodPickerState();
}

class _FoodPickerState extends ConsumerState<_FoodPicker> {
  String _keyword = '';
  String _category = '全部';
  final _categories = ['全部', '主食', '肉类', '蔬菜', '水果', '饮品'];

  @override
  Widget build(BuildContext context) {
    final l = AppL10n.of(context).s;
    final filtered = _foods.where((f) {
      if (_category != '全部' && f.category != _category) return false;
      if (_keyword.isNotEmpty && !f.name.contains(_keyword)) return false;
      return true;
    }).toList();

    return Padding(
      padding: const EdgeInsets.all(AppDimens.spacingMd),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(widget.meal.icon, color: widget.meal.color),
              const SizedBox(width: 8),
              Text(widget.meal.label, style: const TextStyle(color: AppColors.textPrimary, fontSize: 18, fontWeight: FontWeight.bold)),
              const Spacer(),
              IconButton(icon: const Icon(Icons.close_rounded), onPressed: () => Navigator.pop(context)),
            ],
          ),
          const SizedBox(height: 12),
          TextField(
            decoration: const InputDecoration(
              hintText: '搜索食物...',
              prefixIcon: Icon(Icons.search_rounded, color: AppColors.textHint),
            ),
            onChanged: (v) => setState(() => _keyword = v),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 36,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: _categories.map((c) {
                final sel = c == _category;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(c),
                    selected: sel,
                    onSelected: (_) => setState(() => _category = c),
                    selectedColor: widget.meal.color,
                    labelStyle: TextStyle(
                      color: sel ? Colors.white : AppColors.textPrimary,
                      fontSize: 12,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: filtered.isEmpty
              ? Center(child: Text(l.empty, style: const TextStyle(color: AppColors.textHint)))
              : ListView.separated(
                  controller: widget.scroll,
                  itemCount: filtered.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (_, i) => _FoodTile(
                    food: filtered[i],
                    color: widget.meal.color,
                    onTap: () => _addWithServings(filtered[i]),
                  ),
                ),
          ),
        ],
      ),
    );
  }

  Future<void> _addWithServings(FoodItem food) async {
    double servings = 1.0;
    DateTime selectedTime = DateTime.now();

    final result = await showModalBottomSheet<Map<String, dynamic>>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => StatefulBuilder(
        builder: (ctx, setS) => Container(
          decoration: const BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
            top: 24, left: 24, right: 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Icon(food.icon, color: widget.meal.color, size: 28),
                  const SizedBox(width: 12),
                  Text(food.name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                ],
              ),
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerLeft,
                child: Text('${food.cal.toStringAsFixed(0)} kcal / 份',
                  style: const TextStyle(color: AppColors.textHint, fontSize: 14)),
              ),
              const SizedBox(height: 24),
              // Time picker
              Container(
                height: 120,
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.time,
                  initialDateTime: selectedTime,
                  onDateTimeChanged: (val) {
                    setS(() => selectedTime = val);
                  },
                ),
              ),
              const SizedBox(height: 24),
              // Servings adjustment
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.remove_circle_rounded, size: 36),
                    color: AppColors.textHint,
                    onPressed: servings > 0.5 ? () => setS(() => servings = (servings - 0.5).clamp(0.5, 10)) : null,
                  ),
                  Container(
                    width: 100, padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(child: Text('${servings.toStringAsFixed(1)} 份',
                      style: const TextStyle(color: AppColors.textPrimary, fontSize: 20, fontWeight: FontWeight.bold))),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add_circle_rounded, size: 36),
                    color: widget.meal.color,
                    onPressed: () => setS(() => servings = (servings + 0.5).clamp(0.5, 10)),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text('合计: ${(food.cal * servings).toStringAsFixed(0)} kcal',
                style: TextStyle(color: widget.meal.color, fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(ctx),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                      child: const Text('取消', style: TextStyle(color: AppColors.textHint)),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(ctx, {'servings': servings, 'time': selectedTime}),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: widget.meal.color,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                      child: const Text('添加', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
    if (result != null) {
      ref.read(dietProvider.notifier).addEntry(food, result['servings'], widget.meal, time: result['time']);
      if (mounted) Navigator.pop(context);
    }
  }
}

class _FoodTile extends StatelessWidget {
  final FoodItem food;
  final Color color;
  final VoidCallback onTap;
  const _FoodTile({required this.food, required this.color, required this.onTap});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Container(
              width: 40, height: 40,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(food.icon, color: color, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(food.name, style: const TextStyle(color: AppColors.textPrimary, fontSize: 14, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 2),
                  Text('蛋白质 ${food.protein}g · 脂肪 ${food.fat}g · 碳水 ${food.carbs}g',
                    style: const TextStyle(color: AppColors.textHint, fontSize: 11)),
                ],
              ),
            ),
            Text('${food.cal.round()} kcal',
              style: TextStyle(color: color, fontSize: 14, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
