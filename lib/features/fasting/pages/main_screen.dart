import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../components/add_fasting_record_sheet.dart';
import '../components/harmony_picker_sheet.dart';
import '../core/constants/app_constants.dart';
import '../models/food.dart';
import '../providers/exercise_provider.dart';
import '../providers/food_record_provider.dart';
import '../utils/app_toast.dart';
import 'home_page.dart';
import 'fasting_page.dart';
import 'data_page.dart';
import 'food_search_page.dart';
import 'profile_page.dart';
import '../providers/water_provider.dart';
import '../providers/weight_provider.dart';
import 'package:steps_webu_flutter/core/theme/app_colors.dart';

class MainScreen extends ConsumerStatefulWidget {
  const MainScreen({super.key});

  @override
  ConsumerState<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const HomePage(),
    const FastingPage(),
    const DataPage(),
    const ProfilePage(),
  ];

  void _onTabSelected(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _showQuickActionSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) => _buildQuickActionSheet(sheetContext),
    );
  }

  Widget _buildQuickActionSheet(BuildContext sheetContext) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
      decoration: const BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(32.0),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 44,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.divider,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 14),
          const Row(
            children: [
              Expanded(
                child: Text(
                  '快捷记录',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          GridView.count(
            shrinkWrap: true,
            crossAxisCount: 3,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 1,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              _actionButton(
                icon: Icons.water_drop_rounded,
                label: '饮水',
                tint: AppColors.info,
                onTap: () {
                  Navigator.pop(sheetContext);
                  _showWaterRecordDialog();
                },
              ),
              _actionButton(
                icon: Icons.monitor_weight_rounded,
                label: '体重',
                tint: AppColors.primary,
                onTap: () {
                  Navigator.pop(sheetContext);
                  _showWeightRecordDialog();
                },
              ),
              _actionButton(
                icon: Icons.fitness_center_rounded,
                label: '运动',
                tint: AppColors.warning,
                onTap: () {
                  Navigator.pop(sheetContext);
                  _showExerciseRecordDialog();
                },
              ),
              _actionButton(
                icon: Icons.restaurant_rounded,
                label: '饮食',
                tint: AppColors.error,
                onTap: () {
                  Navigator.pop(sheetContext);
                  _openFoodSearchForRecord();
                },
              ),
              _actionButton(
                icon: Icons.timer_rounded,
                label: '断食',
                tint: AppColors.primary,
                onTap: () {
                  Navigator.pop(sheetContext);
                  _showAddFastingRecordSheet();
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _actionButton({
    required IconData icon,
    required String label,
    required Color tint,
    required VoidCallback onTap,
  }) {
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(16.0),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: tint.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(16.0),
                ),
                child: Icon(icon, color: tint, size: 28),
              ),
              const SizedBox(height: 10),
              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showAddFastingRecordSheet() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const AddFastingRecordSheet(),
    );
  }

  void _showWaterRecordDialog() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.28),
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(32.0),
          ),
        ),
        child: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(18, 10, 18, 22),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 42,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.divider,
                    borderRadius: BorderRadius.circular(99.0),
                  ),
                ),
                const SizedBox(height: 18),
                const Row(
                  children: [
                    Expanded(
                      child: Text(
                        '添加饮水',
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(child: _waterAmountButton(100, '小杯')),
                    const SizedBox(width: 10),
                    Expanded(child: _waterAmountButton(200, '中杯')),
                    const SizedBox(width: 10),
                    Expanded(child: _waterAmountButton(300, '大杯')),
                    const SizedBox(width: 10),
                    Expanded(child: _waterAmountButton(500, '水瓶')),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _waterAmountButton(int amount, String label) {
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(16.0),
      child: InkWell(
        onTap: () {
          Navigator.of(context).pop();
          _addWaterRecord(amount);
        },
        borderRadius: BorderRadius.circular(16.0),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 6),
          child: Column(
            children: [
              const Icon(
                Icons.local_drink_rounded,
                color: AppColors.info,
                size: 30,
              ),
              const SizedBox(height: 8),
              Text(
                label,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 12,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                '${amount}ml',
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showWeightRecordDialog() {
    final weightController = TextEditingController();
    final bodyFatController = TextEditingController();
    final notesController = TextEditingController();
    var isTarget = false;

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.28),
      builder: (sheetContext) => StatefulBuilder(
        builder: (context, setState) => HarmonyPickerSheet(
          title: '添加体重记录',
          subtitle: '记录当前体重，也可以设为目标体重',
          confirmText: '保存',
          heightFactor: 0.58,
          onCancel: () => Navigator.pop(sheetContext),
          onConfirm: () {
            final weight = double.tryParse(weightController.text.trim());
            if (weight == null || weight <= 0) {
              showAppToast(context, '请输入有效体重', type: AppToastType.error);
              return;
            }
            Navigator.pop(sheetContext);
            _addWeightRecord(
              weight: weight,
              bodyFat: double.tryParse(bodyFatController.text.trim()),
              notes: notesController.text.trim().isEmpty
                  ? null
                  : notesController.text.trim(),
              isTarget: isTarget,
            );
          },
          child: Padding(
            padding: EdgeInsets.only(
              left: 18,
              right: 18,
              top: 18,
              bottom: MediaQuery.viewInsetsOf(context).bottom + 24,
            ),
            child: Column(
              children: [
                _harmonyInput(
                  controller: weightController,
                  label: '体重',
                  hint: 'kg',
                  icon: Icons.monitor_weight_rounded,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                ),
                const SizedBox(height: 10),
                _harmonyInput(
                  controller: bodyFatController,
                  label: '体脂率',
                  hint: '可选，%',
                  icon: Icons.percent_rounded,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                ),
                const SizedBox(height: 10),
                _harmonyInput(
                  controller: notesController,
                  label: '备注',
                  hint: '可选',
                  icon: Icons.note_rounded,
                  maxLines: 2,
                ),
                const SizedBox(height: 12),
                SwitchListTile(
                  value: isTarget,
                  contentPadding: EdgeInsets.zero,
                  activeThumbColor: AppColors.primary,
                  title: const Text(
                    '设为目标体重',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  subtitle: const Text('开启后会更新目标体重'),
                  onChanged: (value) => setState(() => isTarget = value),
                ),
              ],
            ),
          ),
        ),
      ),
    ).then((_) {
      weightController.dispose();
      bodyFatController.dispose();
      notesController.dispose();
    });
  }

  void _showExerciseRecordDialog() {
    ExerciseType selectedType = ExerciseType.walking;
    int durationMinutes = 30;
    int intensity = 3;
    final caloriesController = TextEditingController();
    final distanceController = TextEditingController();
    final notesController = TextEditingController();

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.28),
      builder: (sheetContext) => StatefulBuilder(
        builder: (context, setState) => HarmonyPickerSheet(
          title: '添加运动记录',
          subtitle: '选择类型、时长和可选数据',
          confirmText: '保存',
          heightFactor: 0.78,
          onCancel: () => Navigator.pop(sheetContext),
          onConfirm: () {
            Navigator.pop(sheetContext);
            _addExerciseRecord(
              type: selectedType,
              durationMinutes: durationMinutes,
              calories: double.tryParse(caloriesController.text.trim()),
              distance: double.tryParse(distanceController.text.trim()),
              notes: notesController.text.trim().isEmpty
                  ? null
                  : notesController.text.trim(),
              intensity: intensity,
            );
          },
          child: SingleChildScrollView(
            padding: EdgeInsets.only(
              left: 18,
              right: 18,
              top: 18,
              bottom: MediaQuery.viewInsetsOf(context).bottom + 24,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '运动类型',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 14,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: ExerciseType.values.map((type) {
                    return HarmonyOptionChip(
                      label: _exerciseTypeName(type),
                      selected: selectedType == type,
                      onTap: () => setState(() => selectedType = type),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 18),
                Row(
                  children: [
                    const Expanded(
                      child: Text(
                        '运动时长',
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 14,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                    Text(
                      '$durationMinutes分钟',
                      style: const TextStyle(
                        color: AppColors.primaryDark,
                        fontSize: 14,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                SizedBox(
                  height: 132,
                  child: HarmonyWheelPicker<int>(
                    items: List.generate(24, (index) => (index + 1) * 5),
                    selectedIndex: 5,
                    labelBuilder: (minute) => '$minute 分钟',
                    onSelectedItemChanged: (index) {
                      setState(() => durationMinutes = (index + 1) * 5);
                    },
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  '运动强度',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 14,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: List.generate(5, (index) {
                    final level = index + 1;
                    return Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(right: index == 4 ? 0 : 8),
                        child: HarmonyOptionChip(
                          label: '$level',
                          selected: intensity == level,
                          onTap: () => setState(() => intensity = level),
                        ),
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 18),
                _harmonyInput(
                  controller: caloriesController,
                  label: '消耗卡路里',
                  hint: '留空自动估算',
                  icon: Icons.local_fire_department_rounded,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                ),
                if (selectedType == ExerciseType.running ||
                    selectedType == ExerciseType.cycling ||
                    selectedType == ExerciseType.walking) ...[
                  const SizedBox(height: 10),
                  _harmonyInput(
                    controller: distanceController,
                    label: '距离',
                    hint: '公里，可选',
                    icon: Icons.straighten_rounded,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                  ),
                ],
                const SizedBox(height: 10),
                _harmonyInput(
                  controller: notesController,
                  label: '备注',
                  hint: '可选',
                  icon: Icons.note_rounded,
                  maxLines: 2,
                ),
              ],
            ),
          ),
        ),
      ),
    ).then((_) {
      caloriesController.dispose();
      distanceController.dispose();
      notesController.dispose();
    });
  }

  Widget _harmonyInput({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: AppColors.textSecondary),
        labelText: label,
        hintText: hint,
        filled: true,
        fillColor: AppColors.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.0),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.0),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.0),
          borderSide: const BorderSide(
            color: AppColors.primary,
            width: 1.4,
          ),
        ),
      ),
    );
  }

  Future<void> _openFoodSearchForRecord() async {
    final selectedFood = await Navigator.push<FoodItem>(
      context,
      MaterialPageRoute(builder: (context) => const FoodSearchPage()),
    );
    if (!mounted || selectedFood == null) return;
    _showAddFoodDialog(selectedFood);
  }

  void _showAddFoodDialog(FoodItem food) {
    double quantity = 100.0;
    String unit = 'g';
    String? mealType;
    String? notes;

    final quantityController = TextEditingController(text: '100');
    final notesController = TextEditingController();

    showDialog<void>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text('添加 ${food.name}'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: quantityController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: InputDecoration(
                    labelText: '数量',
                    filled: true,
                    fillColor: AppColors.surface,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16.0),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16.0),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16.0),
                      borderSide: const BorderSide(
                        color: AppColors.primary,
                        width: 1.4,
                      ),
                    ),
                    suffix: DropdownButton<String>(
                      value: unit,
                      isDense: true,
                      underline: const SizedBox(),
                      items: const [
                        DropdownMenuItem(value: 'g', child: Text('g')),
                        DropdownMenuItem(value: 'ml', child: Text('ml')),
                        DropdownMenuItem(value: '份', child: Text('份')),
                      ],
                      onChanged: (value) {
                        if (value != null) {
                          setState(() => unit = value);
                        }
                      },
                    ),
                  ),
                  onChanged: (value) {
                    quantity = double.tryParse(value) ?? 100.0;
                  },
                ),
                const SizedBox(height: 16),
                const Text(
                  '餐次',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 14,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children:
                      [
                        {'value': 'breakfast', 'label': '早餐'},
                        {'value': 'lunch', 'label': '午餐'},
                        {'value': 'dinner', 'label': '晚餐'},
                        {'value': 'snack', 'label': '加餐'},
                      ].map((item) {
                        final isSelected = mealType == item['value'];
                        return ChoiceChip(
                          label: Text(item['label']!),
                          selected: isSelected,
                          onSelected: (selected) {
                            setState(
                              () => mealType = selected ? item['value'] : null,
                            );
                          },
                          selectedColor: AppColors.primary,
                          labelStyle: const TextStyle(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.w700,
                          ),
                        );
                      }).toList(),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: notesController,
                  decoration: const InputDecoration(
                    labelText: '备注（可选）',
                    filled: true,
                    fillColor: AppColors.surface,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(16.0),
                      ),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  maxLines: 2,
                  onChanged: (value) => notes = value.isEmpty ? null : value,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('取消'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _addFoodRecord(
                  food: food,
                  quantity: quantity,
                  unit: unit,
                  mealType: mealType,
                  notes: notes,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
              ),
              child: const Text('保存'),
            ),
          ],
        ),
      ),
    ).then((_) {
      quantityController.dispose();
      notesController.dispose();
    });
  }

  void _addWaterRecord(int amount) async {
    try {
      await ref.read(waterRecordsProvider.notifier).addQuickRecord(amount);
      if (mounted) {
        showAppToast(context, '已添加${amount}ml饮水记录', type: AppToastType.success);
      }
    } catch (error) {
      if (mounted) {
        showAppToast(context, '添加失败: $error', type: AppToastType.error);
      }
    }
  }

  void _addWeightRecord({
    required double weight,
    double? bodyFat,
    String? notes,
    required bool isTarget,
  }) async {
    try {
      if (isTarget) {
        await ref
            .read(weightRecordsProvider.notifier)
            .setTargetWeight(weight, notes: notes);
      } else {
        await ref
            .read(weightRecordsProvider.notifier)
            .addRecord(weight: weight, bodyFat: bodyFat, notes: notes);
      }
      if (mounted) {
        showAppToast(
          context,
          isTarget ? '目标体重已更新' : '已添加体重记录',
          type: AppToastType.success,
        );
      }
    } catch (error) {
      if (mounted) {
        showAppToast(context, '添加失败: $error', type: AppToastType.error);
      }
    }
  }

  void _addExerciseRecord({
    required ExerciseType type,
    required int durationMinutes,
    double? calories,
    double? distance,
    String? notes,
    int? intensity,
  }) async {
    try {
      await ref
          .read(exerciseRecordsProvider.notifier)
          .addRecord(
            type: type,
            durationMinutes: durationMinutes,
            calories: calories,
            distance: distance,
            notes: notes,
            intensity: intensity,
          );
      if (mounted) {
        showAppToast(
          context,
          '已添加运动记录: ${_formatDuration(durationMinutes)}',
          type: AppToastType.success,
        );
      }
    } catch (error) {
      if (mounted) {
        showAppToast(context, '添加失败: $error', type: AppToastType.error);
      }
    }
  }

  void _addFoodRecord({
    required FoodItem food,
    required double quantity,
    required String unit,
    String? mealType,
    String? notes,
  }) async {
    try {
      await ref
          .read(foodRecordsProvider.notifier)
          .addRecord(
            foodId: food.id,
            foodName: food.name,
            quantity: quantity,
            unit: unit,
            mealType: mealType,
            notes: notes,
            nutrition: food.nutrition,
          );
      if (mounted) {
        showAppToast(context, '已添加 ${food.name}', type: AppToastType.success);
      }
    } catch (error) {
      if (mounted) {
        showAppToast(context, '添加失败: $error', type: AppToastType.error);
      }
    }
  }

  String _formatDuration(int minutes) {
    if (minutes < 60) return '$minutes分钟';
    final hours = minutes ~/ 60;
    final mins = minutes % 60;
    return mins == 0 ? '$hours小时' : '$hours小时$mins分钟';
  }

  String _exerciseTypeName(ExerciseType type) {
    switch (type) {
      case ExerciseType.walking:
        return '步行';
      case ExerciseType.running:
        return '跑步';
      case ExerciseType.cycling:
        return '骑行';
      case ExerciseType.swimming:
        return '游泳';
      case ExerciseType.yoga:
        return '瑜伽';
      case ExerciseType.weightTraining:
        return '力量训练';
      case ExerciseType.other:
        return '其他';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: IndexedStack(index: _currentIndex, children: _pages),
      floatingActionButton: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.3),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: FloatingActionButton(
          onPressed: _showQuickActionSheet,
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: const CircleBorder(),
          child: const Icon(Icons.add_rounded, size: 34),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        color: AppColors.surface,
        shape: const CircularNotchedRectangle(),
        notchMargin: 8.0,
        height: 68,
        padding: EdgeInsets.zero,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildTabItem(icon: Icons.home_rounded, label: '首页', index: 0),
            _buildTabItem(
              icon: Icons.calendar_view_week_rounded,
              label: '计划',
              index: 1,
            ),
            const SizedBox(width: 48), // Space for FAB
            _buildTabItem(icon: Icons.insights_rounded, label: '数据', index: 2),
            _buildTabItem(icon: Icons.person_rounded, label: '我的', index: 3),
          ],
        ),
      ),
    );
  }

  Widget _buildTabItem({
    required IconData icon,
    required String label,
    required int index,
  }) {
    final isSelected = _currentIndex == index;
    final color = isSelected
        ? AppColors.primary
        : AppColors.primary;

    return InkWell(
      onTap: () => _onTabSelected(index),
      borderRadius: BorderRadius.circular(24.0),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.w900 : FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
