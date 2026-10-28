import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:drift/drift.dart' hide Column;

import '../../core/services/database_provider.dart';
import '../../core/services/daily_health_provider.dart';
import '../../core/services/step_provider.dart' as step_svc;
import '../../core/database/app_database.dart';
import '../../core/theme/app_colors.dart';

// ─── Food Item Model ────────────────────────────────────────────────────────
class FoodItem {
  final String id, name, category;
  final double cal, protein, fat, carbs;
  final IconData icon;
  final String unitDesc;
  const FoodItem(
    this.id,
    this.name,
    this.category,
    this.cal,
    this.protein,
    this.fat,
    this.carbs,
    this.icon, {
    this.unitDesc = '100g/份',
  });
}

// ─── Comprehensive Food Database (60+ Common Foods) ─────────────────────────
const _foods = <FoodItem>[
  // 主食谷薯
  FoodItem('rice', '白米饭', '主食', 116, 2.6, 0.3, 25.6, Icons.rice_bowl_rounded, unitDesc: '1小碗(100g)'),
  FoodItem('brown_rice', '糙米饭', '主食', 111, 2.6, 0.9, 23.0, Icons.rice_bowl_rounded, unitDesc: '1小碗(100g)'),
  FoodItem('oats', '燕麦片', '主食', 367, 15.0, 6.7, 61.6, Icons.grain_rounded, unitDesc: '1份(50g干燕麦)'),
  FoodItem('whole_bread', '全麦吐司', '主食', 82, 4.0, 1.2, 14.5, Icons.bakery_dining_rounded, unitDesc: '1片(35g)'),
  FoodItem('purple_potato', '蒸紫薯', '主食', 106, 1.6, 0.2, 25.1, Icons.grass_rounded, unitDesc: '1个(120g)'),
  FoodItem('corn', '甜玉米', '主食', 112, 4.0, 1.2, 22.8, Icons.eco_rounded, unitDesc: '半根(100g)'),
  FoodItem('buckwheat', '荞麦面', '主食', 135, 5.2, 0.7, 27.5, Icons.ramen_dining_rounded, unitDesc: '1碗熟面(150g)'),
  FoodItem('dumpling', '手工水饺', '主食', 210, 8.5, 7.2, 28.0, Icons.dinner_dining_rounded, unitDesc: '6个(120g)'),
  FoodItem('beef_bun', '牛肉大包', '主食', 230, 8.8, 6.5, 34.0, Icons.breakfast_dining_rounded, unitDesc: '1只(100g)'),
  FoodItem('sweet_potato', '蒸红薯', '主食', 99, 1.1, 0.2, 23.1, Icons.grass_rounded, unitDesc: '1个(150g)'),

  // 肉蛋水产
  FoodItem('chicken_breast', '香煎鸡胸肉', '肉类', 165, 31.0, 3.6, 0.0, Icons.set_meal_rounded, unitDesc: '1块(120g)'),
  FoodItem('beef_steak', '精瘦牛排', '肉类', 215, 26.5, 12.0, 0.0, Icons.set_meal_rounded, unitDesc: '1块(150g)'),
  FoodItem('salmon', '清蒸三文鱼', '肉类', 142, 20.0, 6.8, 0.0, Icons.set_meal_rounded, unitDesc: '1块(100g)'),
  FoodItem('shrimp', '白灼鲜虾', '肉类', 93, 18.6, 1.4, 1.5, Icons.set_meal_rounded, unitDesc: '8只虾仁(100g)'),
  FoodItem('egg_boiled', '水煮鸡蛋', '肉类', 75, 6.5, 5.0, 0.6, Icons.egg_rounded, unitDesc: '1枚(55g)'),
  FoodItem('egg_fried', '荷包煎蛋', '肉类', 118, 6.3, 9.8, 0.8, Icons.egg_rounded, unitDesc: '1枚(60g)'),
  FoodItem('bass', '清蒸鲈鱼', '肉类', 105, 18.6, 3.4, 0.0, Icons.set_meal_rounded, unitDesc: '1份净肉(120g)'),
  FoodItem('spiced_beef', '酱卤牛肉', '肉类', 170, 31.4, 4.2, 1.2, Icons.set_meal_rounded, unitDesc: '1小盘(100g)'),
  FoodItem('pork_tenderloin', '精瘦猪肉', '肉类', 143, 20.3, 6.2, 1.5, Icons.set_meal_rounded, unitDesc: '1份(100g)'),
  FoodItem('tofu', '北豆腐/老豆腐', '肉类', 98, 12.2, 4.8, 1.5, Icons.crop_square_rounded, unitDesc: '1块(100g)'),

  // 蔬菜菌藻
  FoodItem('broccoli', '水煮西兰花', '蔬菜', 34, 2.8, 0.4, 4.5, Icons.eco_rounded, unitDesc: '1小盘(150g)'),
  FoodItem('tomato', '新鲜小番茄', '蔬菜', 22, 1.0, 0.2, 4.1, Icons.eco_rounded, unitDesc: '8颗(100g)'),
  FoodItem('cucumber', '脆黄瓜', '蔬菜', 16, 0.8, 0.2, 2.9, Icons.eco_rounded, unitDesc: '1根(150g)'),
  FoodItem('spinach', '清炒菠菜', '蔬菜', 45, 2.6, 2.0, 3.2, Icons.eco_rounded, unitDesc: '1小碗(150g)'),
  FoodItem('lettuce_salad', '生菜蔬菜沙拉', '蔬菜', 38, 1.5, 1.8, 4.0, Icons.eco_rounded, unitDesc: '1大碗(200g)'),
  FoodItem('enoki', '金针菇', '蔬菜', 37, 2.4, 0.4, 6.0, Icons.eco_rounded, unitDesc: '1把(100g)'),
  FoodItem('mushroom', '鲜香菇', '蔬菜', 26, 2.2, 0.3, 5.2, Icons.eco_rounded, unitDesc: '4朵(100g)'),
  FoodItem('kelp', '凉拌海带丝', '蔬菜', 36, 1.4, 0.8, 6.8, Icons.eco_rounded, unitDesc: '1碟(100g)'),
  FoodItem('carrot', '脆甜胡萝卜', '蔬菜', 39, 1.0, 0.2, 8.8, Icons.eco_rounded, unitDesc: '1根(120g)'),
  FoodItem('cabbage', '手撕包菜', '蔬菜', 42, 1.5, 1.8, 5.0, Icons.eco_rounded, unitDesc: '1盘(180g)'),

  // 新鲜水果
  FoodItem('apple', '红富士苹果', '水果', 52, 0.3, 0.2, 13.5, Icons.apple_rounded, unitDesc: '1个中等(160g)'),
  FoodItem('banana', '熟香蕉', '水果', 89, 1.1, 0.3, 22.0, Icons.eco_rounded, unitDesc: '1根(120g)'),
  FoodItem('blueberry', '鲜蓝莓', '水果', 57, 0.7, 0.3, 14.5, Icons.grain_rounded, unitDesc: '1盒(125g)'),
  FoodItem('avocado', '成熟牛油果', '水果', 160, 2.0, 14.7, 8.5, Icons.eco_rounded, unitDesc: '半个(80g)'),
  FoodItem('grape', '阳光玫瑰葡萄', '水果', 45, 0.5, 0.2, 11.2, Icons.bubble_chart_rounded, unitDesc: '1串(150g)'),
  FoodItem('kiwi', '奇异果/猕猴桃', '水果', 61, 1.1, 0.5, 14.7, Icons.eco_rounded, unitDesc: '1个(100g)'),
  FoodItem('orange', '新奇士鲜橙', '水果', 47, 0.9, 0.1, 11.8, Icons.eco_rounded, unitDesc: '1个(180g)'),
  FoodItem('grapefruit', '红心西柚', '水果', 42, 0.8, 0.1, 10.6, Icons.eco_rounded, unitDesc: '半个(150g)'),
  FoodItem('strawberry', '甜草莓', '水果', 32, 1.0, 0.3, 7.1, Icons.eco_rounded, unitDesc: '8颗(120g)'),
  FoodItem('watermelon', '鲜切西瓜', '水果', 31, 0.6, 0.1, 7.5, Icons.eco_rounded, unitDesc: '1角(250g)'),

  // 乳品冲调
  FoodItem('milk_whole', '纯牛奶', '饮品', 65, 3.4, 3.6, 4.8, Icons.local_drink_rounded, unitDesc: '1盒(250ml)'),
  FoodItem('milk_skim', '脱脂低卡牛奶', '饮品', 38, 3.4, 0.5, 4.9, Icons.local_drink_rounded, unitDesc: '1盒(250ml)'),
  FoodItem('greek_yogurt', '希腊无糖酸奶', '饮品', 72, 9.5, 3.0, 3.6, Icons.local_cafe_rounded, unitDesc: '1杯(120g)'),
  FoodItem('black_coffee', '美式黑咖啡', '饮品', 2, 0.3, 0.0, 0.3, Icons.local_cafe_rounded, unitDesc: '1大杯(350ml)'),
  FoodItem('latte', '无糖鲜奶拿铁', '饮品', 135, 7.5, 7.0, 10.0, Icons.local_cafe_rounded, unitDesc: '1杯(300ml)'),
  FoodItem('soy_milk', '无糖纯豆浆', '饮品', 35, 3.2, 1.8, 1.5, Icons.local_drink_rounded, unitDesc: '1碗(300ml)'),
  FoodItem('protein_powder', '乳清蛋白粉冲饮', '饮品', 120, 24.0, 1.5, 2.5, Icons.fitness_center_rounded, unitDesc: '1勺(30g)'),
  FoodItem('green_tea', '现泡绿茶/清茶', '饮品', 1, 0.1, 0.0, 0.2, Icons.emoji_food_beverage_rounded, unitDesc: '1杯(400ml)'),

  // 坚果零食
  FoodItem('mixed_nuts', '原味混合坚果', '坚果', 160, 5.0, 14.0, 6.0, Icons.egg_rounded, unitDesc: '1包(25g)'),
  FoodItem('almonds', '烘焙巴旦木', '坚果', 148, 5.5, 13.0, 5.0, Icons.egg_rounded, unitDesc: '15颗(25g)'),
  FoodItem('dark_chocolate', '85%高纯黑巧克力', '坚果', 135, 2.2, 11.5, 5.8, Icons.cookie_rounded, unitDesc: '2小块(20g)'),
  FoodItem('peanut_butter', '无糖花生酱', '坚果', 95, 4.0, 8.0, 3.0, Icons.soup_kitchen_rounded, unitDesc: '1大勺(15g)'),
  FoodItem('konjac', '魔芋低卡零食', '坚果', 18, 0.5, 0.2, 3.5, Icons.bakery_dining_rounded, unitDesc: '1包(50g)'),
];

// ─── Diet Entry Model ────────────────────────────────────────────────────────
class DietEntry {
  final String id;
  final FoodItem food;
  final double servings;
  final DateTime time;
  final MealType meal;
  DietEntry({
    required this.id,
    required this.food,
    required this.servings,
    required this.time,
    required this.meal,
  });

  double get cal => food.cal * servings;
  double get protein => food.protein * servings;
  double get fat => food.fat * servings;
  double get carbs => food.carbs * servings;
}

enum MealType { breakfast, lunch, dinner, snack }

extension MealTypeX on MealType {
  String get label {
    switch (this) {
      case MealType.breakfast:
        return '早餐';
      case MealType.lunch:
        return '午餐';
      case MealType.dinner:
        return '晚餐';
      case MealType.snack:
        return '加餐/零食';
    }
  }

  String get suggestion {
    switch (this) {
      case MealType.breakfast:
        return '建议 400 ~ 500 kcal · 优质蛋白唤醒代谢';
      case MealType.lunch:
        return '建议 650 ~ 750 kcal · 营养均衡充沛精力';
      case MealType.dinner:
        return '建议 500 ~ 600 kcal · 清淡低脂少负担';
      case MealType.snack:
        return '建议 100 ~ 200 kcal · 控糖坚果/水果';
    }
  }

  IconData get icon {
    switch (this) {
      case MealType.breakfast:
        return Icons.wb_sunny_rounded;
      case MealType.lunch:
        return Icons.lunch_dining_rounded;
      case MealType.dinner:
        return Icons.nightlight_rounded;
      case MealType.snack:
        return Icons.cookie_rounded;
    }
  }

  Color get color {
    switch (this) {
      case MealType.breakfast:
        return const Color(0xFFF59E0B); // Amber
      case MealType.lunch:
        return const Color(0xFF6366F1); // Indigo
      case MealType.dinner:
        return const Color(0xFF0EA5E9); // Sky
      case MealType.snack:
        return const Color(0xFF10B981); // Emerald
    }
  }
}

// ─── Diet State & Notifier ───────────────────────────────────────────────────
class DietState {
  final List<DietEntry> entries;
  final double goal;
  DietState({this.entries = const [], this.goal = 2000});

  double get totalCal => entries.fold(0.0, (s, e) => s + e.cal);
  double get totalProtein => entries.fold(0.0, (s, e) => s + e.protein);
  double get totalFat => entries.fold(0.0, (s, e) => s + e.fat);
  double get totalCarbs => entries.fold(0.0, (s, e) => s + e.carbs);

  double get progress => (totalCal / (goal > 0 ? goal : 2000)).clamp(0.0, 1.0);
  int get remaining => ((goal > 0 ? goal : 2000) - totalCal).round();

  // Target macronutrient breakdown: 50% carbs (4kcal/g), 25% protein (4kcal/g), 25% fat (9kcal/g)
  double get targetCarbs => (goal * 0.50) / 4.0;
  double get targetProtein => (goal * 0.25) / 4.0;
  double get targetFat => (goal * 0.25) / 9.0;

  List<DietEntry> byMeal(MealType m) => entries.where((e) => e.meal == m).toList();
  double mealCal(MealType m) => byMeal(m).fold(0.0, (s, e) => s + e.cal);
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
    final records = await (db.select(db.dietRecords)
          ..where((t) => t.time.isBiggerOrEqualValue(start))
          ..orderBy([(t) => OrderingTerm(expression: t.time, mode: OrderingMode.asc)]))
        .get();

    List<DietEntry> entries = [];
    for (var r in records) {
      if (r.note != null && r.note!.isNotEmpty) {
        try {
          final map = jsonDecode(r.note!);
          final foodId = map['id'] ?? '';
          final preset = _foods.firstWhere(
            (f) => f.id == foodId,
            orElse: () => FoodItem(
              foodId,
              r.foodName ?? '自选食物',
              map['category'] ?? '其他',
              (map['cal'] ?? 100.0).toDouble(),
              (map['protein'] ?? 5.0).toDouble(),
              (map['fat'] ?? 3.0).toDouble(),
              (map['carbs'] ?? 15.0).toDouble(),
              Icons.restaurant_rounded,
            ),
          );

          entries.add(DietEntry(
            id: r.id.toString(),
            food: preset,
            servings: (map['servings'] ?? 1.0).toDouble(),
            time: r.time,
            meal: MealType.values[r.mealType.clamp(0, MealType.values.length - 1)],
          ));
        } catch (e) {
          debugPrint('parse diet error: $e');
        }
      }
    }

    final totalCalories = entries.fold(0.0, (s, e) => s + e.cal).round();
    try {
      ref.read(dailyHealthProvider.notifier).setDietCalories(totalCalories);
    } catch (_) {}

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

// ─── Main Diet Screen (OtterLife Light Unified) ──────────────────────────────
class DietScreen extends ConsumerWidget {
  const DietScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stateAsync = ref.watch(dietProvider);
    final state = stateAsync.valueOrNull ?? DietState();
    final stepAsync = ref.watch(step_svc.stepProvider);
    final burnedCal = stepAsync.valueOrNull?.calories ?? 0.0;

    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F8),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFEFEBFA), Color(0xFFF3F4F8), Color(0xFFEBEFF9)],
          ),
        ),
        child: SafeArea(
          bottom: false,
          child: Column(
            children: [
              _buildHeader(context, ref, state),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(16, 6, 16, 110),
                  children: [
                    _buildCalorieBudgetHero(state, burnedCal),
                    const SizedBox(height: 18),
                    _buildMacroNutrientCards(state),
                    const SizedBox(height: 22),
                    _buildSectionHeader('今日四餐记录'),
                    const SizedBox(height: 12),
                    ...MealType.values.map((meal) => _MealCard(
                          meal: meal,
                          entries: state.byMeal(meal),
                          onAdd: () => _showFoodPicker(context, ref, meal),
                          onAiScan: () => context.push('/ai-scan'),
                          onRemove: (id) => ref.read(dietProvider.notifier).removeEntry(id),
                        )),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Header ──────────────────────────────────────────────────────────────────
  Widget _buildHeader(BuildContext context, WidgetRef ref, DietState state) {
    final todayStr = DateFormat('MM月dd日 EEEE', 'zh_CN').format(DateTime.now());

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back_ios_rounded, color: Color(0xFF1E1B4B), size: 20),
                onPressed: () {
                  if (context.canPop()) {
                    context.pop();
                  } else {
                    context.go('/home');
                  }
                },
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '饮食与热量',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF1E1B4B),
                      letterSpacing: -0.5,
                    ),
                  ),
                  Text(
                    todayStr,
                    style: const TextStyle(fontSize: 11, color: Color(0xFF64748B), fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ],
          ),
          Row(
            children: [
              // AI Scan Shortcut Button
              GestureDetector(
                onTap: () => context.push('/ai-scan'),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFF10B981).withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.camera_alt_rounded, size: 16, color: Color(0xFF059669)),
                      SizedBox(width: 4),
                      Text('AI识图', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: Color(0xFF059669))),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8),
              // Target Goal Setting
              IconButton(
                icon: const Icon(Icons.tune_rounded, color: Color(0xFF1E1B4B), size: 22),
                tooltip: '热量目标设置',
                onPressed: () => _showGoalSettingDialog(context, ref, state.goal),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── Hero Calorie Budget Card ────────────────────────────────────────────────
  Widget _buildCalorieBudgetHero(DietState state, double burnedCal) {
    final remaining = (state.goal - state.totalCal + burnedCal).round();
    final progress = (state.totalCal / (state.goal > 0 ? state.goal : 2000)).clamp(0.0, 1.0);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A1E1B4B),
            blurRadius: 20,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              // Circular Indicator
              SizedBox(
                width: 120,
                height: 120,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    CircularPercentIndicator(
                      radius: 56.0,
                      lineWidth: 10.0,
                      animation: true,
                      percent: progress,
                      circularStrokeCap: CircularStrokeCap.round,
                      progressColor: remaining >= 0 ? const Color(0xFF6366F1) : const Color(0xFFEF4444),
                      backgroundColor: const Color(0xFFF1F5F9),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          remaining >= 0 ? '还可摄入' : '已超标',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: remaining >= 0 ? const Color(0xFF64748B) : const Color(0xFFEF4444),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${remaining.abs()}',
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w900,
                            color: remaining >= 0 ? const Color(0xFF1E1B4B) : const Color(0xFFEF4444),
                            height: 1.1,
                          ),
                        ),
                        const Text(
                          'kcal',
                          style: TextStyle(fontSize: 10, color: Color(0xFF94A3B8), fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 22),
              // Right Column Breakdown
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildBudgetMetricRow('🎯 预算目标', '${state.goal.toInt()} kcal', const Color(0xFF1E1B4B)),
                    const SizedBox(height: 10),
                    _buildBudgetMetricRow('🍽️ 今日已摄入', '${state.totalCal.toInt()} kcal', const Color(0xFF6366F1)),
                    const SizedBox(height: 10),
                    _buildBudgetMetricRow('🔥 运动消耗', '${burnedCal.toInt()} kcal', const Color(0xFFF97316)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBudgetMetricRow(String label, String value, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 13, color: Color(0xFF64748B), fontWeight: FontWeight.w600)),
        Text(value, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: color)),
      ],
    );
  }

  // ── Macronutrient Triad Breakdown ──────────────────────────────────────────
  Widget _buildMacroNutrientCards(DietState state) {
    final carbsProgress = (state.totalCarbs / (state.targetCarbs > 0 ? state.targetCarbs : 1)).clamp(0.0, 1.0);
    final proteinProgress = (state.totalProtein / (state.targetProtein > 0 ? state.targetProtein : 1)).clamp(0.0, 1.0);
    final fatProgress = (state.totalFat / (state.targetFat > 0 ? state.targetFat : 1)).clamp(0.0, 1.0);

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: const [
          BoxShadow(color: Color(0x061E1B4B), blurRadius: 16, offset: Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('三大宏量营养素', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: Color(0xFF1E1B4B))),
              Text('科学能量配比 50:25:25', style: TextStyle(fontSize: 11, color: Color(0xFF94A3B8), fontWeight: FontWeight.w600)),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _buildMacroItem(
                  '🥖 碳水',
                  '${state.totalCarbs.toInt()}g',
                  '目标 ${state.targetCarbs.toInt()}g',
                  carbsProgress,
                  const Color(0xFFF59E0B),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildMacroItem(
                  '🥩 蛋白质',
                  '${state.totalProtein.toInt()}g',
                  '目标 ${state.targetProtein.toInt()}g',
                  proteinProgress,
                  const Color(0xFF6366F1),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildMacroItem(
                  '🥑 脂肪',
                  '${state.totalFat.toInt()}g',
                  '目标 ${state.targetFat.toInt()}g',
                  fatProgress,
                  const Color(0xFF10B981),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMacroItem(String name, String value, String target, double progress, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(name, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: color)),
          const SizedBox(height: 6),
          Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: Color(0xFF1E1B4B))),
          const SizedBox(height: 2),
          Text(target, style: const TextStyle(fontSize: 10, color: Color(0xFF94A3B8))),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 5,
              backgroundColor: color.withValues(alpha: 0.15),
              valueColor: AlwaysStoppedAnimation(color),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 16,
            decoration: BoxDecoration(
              color: const Color(0xFF6366F1),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: Color(0xFF1E1B4B),
            ),
          ),
        ],
      ),
    );
  }

  // ── Food Picker & Goal Dialog ─────────────────────────────────────────────
  void _showFoodPicker(BuildContext context, WidgetRef ref, MealType meal) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.85,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (ctx, scroll) => _FoodPickerSheet(meal: meal, scroll: scroll),
      ),
    );
  }

  void _showGoalSettingDialog(BuildContext context, WidgetRef ref, double currentGoal) {
    double goal = currentGoal;
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (c) => StatefulBuilder(
        builder: (ctx, setS) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          padding: const EdgeInsets.fromLTRB(22, 16, 22, 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(width: 40, height: 4, decoration: BoxDecoration(color: const Color(0xFFE2E8F0), borderRadius: BorderRadius.circular(2))),
              const SizedBox(height: 18),
              const Text('每日摄入热量预算', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Color(0xFF1E1B4B))),
              const SizedBox(height: 6),
              const Text('基于日常基础代谢率 (BMR) 与活动消耗推荐', style: TextStyle(fontSize: 12, color: Color(0xFF64748B))),
              const SizedBox(height: 24),
              Text('${goal.toInt()} kcal', style: const TextStyle(fontSize: 42, fontWeight: FontWeight.w900, color: Color(0xFF6366F1))),
              const SizedBox(height: 16),
              Slider(
                value: goal,
                min: 1200,
                max: 3500,
                divisions: 46,
                activeColor: const Color(0xFF6366F1),
                inactiveColor: const Color(0xFFE2E8F0),
                onChanged: (v) => setS(() => goal = v),
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: const Color(0xFFF8FAFC), borderRadius: BorderRadius.circular(14)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text('碳水: ${(goal * 0.5 / 4).toInt()}g', style: const TextStyle(fontSize: 12, color: Color(0xFF64748B), fontWeight: FontWeight.w600)),
                    Text('蛋白: ${(goal * 0.25 / 4).toInt()}g', style: const TextStyle(fontSize: 12, color: Color(0xFF64748B), fontWeight: FontWeight.w600)),
                    Text('脂肪: ${(goal * 0.25 / 9).toInt()}g', style: const TextStyle(fontSize: 12, color: Color(0xFF64748B), fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
              const SizedBox(height: 22),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    ref.read(dietProvider.notifier).setGoal(goal);
                    Navigator.pop(c);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6366F1),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: const Text('保存热量预算', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Meal Card Component ─────────────────────────────────────────────────────
class _MealCard extends StatelessWidget {
  final MealType meal;
  final List<DietEntry> entries;
  final VoidCallback onAdd;
  final VoidCallback onAiScan;
  final ValueChanged<String> onRemove;

  const _MealCard({
    required this.meal,
    required this.entries,
    required this.onAdd,
    required this.onAiScan,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final mealTotal = entries.fold(0.0, (s, e) => s + e.cal);

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: const [
          BoxShadow(color: Color(0x061E1B4B), blurRadius: 16, offset: Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: meal.color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(meal.icon, color: meal.color, size: 22),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    meal.label,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Color(0xFF1E1B4B)),
                  ),
                  Text(
                    meal.suggestion,
                    style: const TextStyle(fontSize: 11, color: Color(0xFF94A3B8), fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              const Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${mealTotal.toInt()}',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: meal.color),
                  ),
                  const Text('kcal', style: TextStyle(fontSize: 10, color: Color(0xFF94A3B8), fontWeight: FontWeight.bold)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Food Entries List
          if (entries.isEmpty)
            Container(
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Center(
                child: Text(
                  '尚未记录${meal.label}，吃点健康的吧 🥗',
                  style: const TextStyle(fontSize: 12, color: Color(0xFF94A3B8), fontWeight: FontWeight.w600),
                ),
              ),
            )
          else
            ...entries.map((entry) => Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: const Color(0xFFF1F5F9)),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(7),
                        decoration: BoxDecoration(
                          color: meal.color.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(entry.food.icon, size: 16, color: meal.color),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              entry.food.name,
                              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFF1E1B4B)),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '${entry.servings.toStringAsFixed(1)}份 · 碳${entry.carbs.toInt()}g 蛋${entry.protein.toInt()}g 脂${entry.fat.toInt()}g · ${DateFormat('HH:mm').format(entry.time)}',
                              style: const TextStyle(fontSize: 11, color: Color(0xFF64748B)),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        '${entry.cal.toInt()} kcal',
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: Color(0xFF1E1B4B)),
                      ),
                      const SizedBox(width: 8),
                      InkWell(
                        onTap: () => onRemove(entry.id),
                        child: Container(
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: const Color(0xFFEF4444).withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(Icons.close_rounded, size: 14, color: Color(0xFFEF4444)),
                        ),
                      ),
                    ],
                  ),
                )),
          const SizedBox(height: 12),
          // Action Buttons: + 记饮食, 📷 AI识图
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 40,
                  child: OutlinedButton.icon(
                    onPressed: onAdd,
                    icon: Icon(Icons.add_rounded, size: 18, color: meal.color),
                    label: Text('+ 记录${meal.label}', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: meal.color)),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: meal.color.withValues(alpha: 0.4)),
                      backgroundColor: meal.color.withValues(alpha: 0.05),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              SizedBox(
                height: 40,
                child: IconButton.outlined(
                  onPressed: onAiScan,
                  icon: const Icon(Icons.camera_alt_outlined, size: 18, color: Color(0xFF10B981)),
                  tooltip: '拍照识图',
                  style: IconButton.styleFrom(
                    side: BorderSide(color: const Color(0xFF10B981).withValues(alpha: 0.4)),
                    backgroundColor: const Color(0xFF10B981).withValues(alpha: 0.05),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─── Food Picker Sheet Component ─────────────────────────────────────────────
class _FoodPickerSheet extends ConsumerStatefulWidget {
  final MealType meal;
  final ScrollController scroll;
  const _FoodPickerSheet({required this.meal, required this.scroll});

  @override
  ConsumerState<_FoodPickerSheet> createState() => _FoodPickerSheetState();
}

class _FoodPickerSheetState extends ConsumerState<_FoodPickerSheet> {
  String _keyword = '';
  String _category = '全部';
  final _categories = ['全部', '主食', '肉类', '蔬菜', '水果', '饮品', '坚果'];

  @override
  Widget build(BuildContext context) {
    final filtered = _foods.where((f) {
      if (_category != '全部' && f.category != _category) return false;
      if (_keyword.isNotEmpty && !f.name.contains(_keyword)) return false;
      return true;
    }).toList();

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(color: const Color(0xFFE2E8F0), borderRadius: BorderRadius.circular(2)),
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Icon(widget.meal.icon, color: widget.meal.color, size: 24),
              const SizedBox(width: 8),
              Text(
                '添加${widget.meal.label}',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Color(0xFF1E1B4B)),
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.close_rounded, color: Color(0xFF64748B)),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const SizedBox(height: 10),
          // Search Input
          TextField(
            decoration: InputDecoration(
              hintText: '搜索食物或饮品（如 米饭、鸡胸肉、牛奶）...',
              hintStyle: const TextStyle(fontSize: 13, color: Color(0xFF94A3B8)),
              prefixIcon: const Icon(Icons.search_rounded, color: Color(0xFF94A3B8)),
              filled: true,
              fillColor: const Color(0xFFF8FAFC),
              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
            ),
            onChanged: (v) => setState(() => _keyword = v),
          ),
          const SizedBox(height: 12),
          // Category Chips
          SizedBox(
            height: 36,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _categories.length,
              itemBuilder: (ctx, i) {
                final cat = _categories[i];
                final sel = cat == _category;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(cat),
                    selected: sel,
                    onSelected: (_) => setState(() => _category = cat),
                    selectedColor: widget.meal.color,
                    backgroundColor: const Color(0xFFF1F5F9),
                    checkmarkColor: Colors.white,
                    labelStyle: TextStyle(
                      color: sel ? Colors.white : const Color(0xFF64748B),
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20), side: BorderSide.none),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 12),
          // Food List
          Expanded(
            child: filtered.isEmpty
                ? const Center(
                    child: Text(
                      '未找到相关食物，可尝试搜索其他关键词',
                      style: TextStyle(color: Color(0xFF94A3B8), fontSize: 13),
                    ),
                  )
                : ListView.separated(
                    controller: widget.scroll,
                    itemCount: filtered.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                    itemBuilder: (_, i) => _FoodItemTile(
                      food: filtered[i],
                      color: widget.meal.color,
                      onTap: () => _addWithServingsModal(filtered[i]),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Future<void> _addWithServingsModal(FoodItem food) async {
    double servings = 1.0;
    DateTime selectedTime = DateTime.now();

    final result = await showModalBottomSheet<Map<String, dynamic>>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => StatefulBuilder(
        builder: (ctx, setS) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
            top: 20,
            left: 22,
            right: 22,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(width: 40, height: 4, decoration: BoxDecoration(color: const Color(0xFFE2E8F0), borderRadius: BorderRadius.circular(2))),
              const SizedBox(height: 16),
              Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: widget.meal.color.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(food.icon, color: widget.meal.color, size: 24),
                  ),
                  const SizedBox(width: 14),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(food.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Color(0xFF1E1B4B))),
                      Text('${food.cal.round()} kcal / ${food.unitDesc}', style: const TextStyle(fontSize: 12, color: Color(0xFF64748B))),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Portion Quick Chips: 0.5份, 1.0份, 1.5份, 2.0份
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [0.5, 1.0, 1.5, 2.0].map((s) {
                  final isSel = servings == s;
                  return ChoiceChip(
                    label: Text('${s}份'),
                    selected: isSel,
                    onSelected: (_) => setS(() => servings = s),
                    selectedColor: widget.meal.color,
                    labelStyle: TextStyle(
                      color: isSel ? Colors.white : const Color(0xFF1E1B4B),
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
              // Stepper Controls
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.remove_circle_rounded, size: 38),
                    color: servings > 0.5 ? widget.meal.color : const Color(0xFFCBD5E1),
                    onPressed: servings > 0.5 ? () => setS(() => servings = (servings - 0.5).clamp(0.5, 10.0)) : null,
                  ),
                  Container(
                    width: 120,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: Center(
                      child: Text(
                        '${servings.toStringAsFixed(1)} 份',
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Color(0xFF1E1B4B)),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add_circle_rounded, size: 38),
                    color: widget.meal.color,
                    onPressed: () => setS(() => servings = (servings + 0.5).clamp(0.5, 10.0)),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              // Nutritional Summary for this portion
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text('热量: ${(food.cal * servings).toInt()} kcal', style: TextStyle(fontWeight: FontWeight.bold, color: widget.meal.color, fontSize: 13)),
                    Text('碳水: ${(food.carbs * servings).toInt()}g', style: const TextStyle(fontSize: 12, color: Color(0xFF64748B))),
                    Text('蛋白: ${(food.protein * servings).toInt()}g', style: const TextStyle(fontSize: 12, color: Color(0xFF64748B))),
                    Text('脂肪: ${(food.fat * servings).toInt()}g', style: const TextStyle(fontSize: 12, color: Color(0xFF64748B))),
                  ],
                ),
              ),
              const SizedBox(height: 22),
              // Confirm Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(ctx, {'servings': servings, 'time': selectedTime}),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: widget.meal.color,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: const Text('加入餐食记录 🚀', style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w800)),
                ),
              ),
            ],
          ),
        ),
      ),
    );

    if (result != null) {
      ref.read(dietProvider.notifier).addEntry(
            food,
            result['servings'],
            widget.meal,
            time: result['time'],
          );
      if (mounted) Navigator.pop(context);
    }
  }
}

// ─── Food Item Tile ──────────────────────────────────────────────────────────
class _FoodItemTile extends StatelessWidget {
  final FoodItem food;
  final Color color;
  final VoidCallback onTap;

  const _FoodItemTile({required this.food, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFF1F5F9)),
        ),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(food.icon, color: color, size: 22),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    food.name,
                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Color(0xFF1E1B4B)),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    '${food.unitDesc} · 碳水 ${food.carbs}g · 蛋白 ${food.protein}g · 脂肪 ${food.fat}g',
                    style: const TextStyle(fontSize: 11, color: Color(0xFF94A3B8)),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${food.cal.round()}',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: color),
                ),
                const Text('kcal', style: TextStyle(fontSize: 10, color: Color(0xFF94A3B8), fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(width: 6),
            const Icon(Icons.add_circle_outline_rounded, color: Color(0xFFCBD5E1), size: 20),
          ],
        ),
      ),
    );
  }
}
