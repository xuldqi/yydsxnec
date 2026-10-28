import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/food_provider.dart';
import '../models/food.dart';
import 'package:steps_webu_flutter/core/theme/app_colors.dart';

class FoodSearchPage extends ConsumerStatefulWidget {
  const FoodSearchPage({super.key});

  @override
  ConsumerState<FoodSearchPage> createState() => _FoodSearchPageState();
}

class _FoodSearchPageState extends ConsumerState<FoodSearchPage> {
  final TextEditingController _controller = TextEditingController();
  String? _selectedCategoryId;
  String _keyword = '';

  @override
  Widget build(BuildContext context) {
    final categoriesAsync = ref.watch(rootFoodCategoriesProvider);
    final resultsAsync = ref.watch(
      foodSearchProvider((_keyword, _selectedCategoryId)),
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('食物查询'),
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        centerTitle: true,
      ),
      body: Container(
        decoration: const BoxDecoration(gradient: const LinearGradient(colors: [AppColors.background, AppColors.surface])),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 14),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        decoration: InputDecoration(
                          hintText: '输入食物名称，如：苹果 / 鸡蛋',
                          filled: true,
                          fillColor: AppColors.surface,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                              16.0,
                            ),
                            borderSide: BorderSide.none,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                              16.0,
                            ),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                              16.0,
                            ),
                            borderSide: const BorderSide(
                              color: AppColors.primary,
                              width: 1.4,
                            ),
                          ),
                          prefixIcon: const Icon(
                            Icons.search_rounded,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        onChanged: (v) => setState(() => _keyword = v),
                      ),
                    ),
                    const SizedBox(width: 10),
                    categoriesAsync.when(
                      data: (cats) => Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(
                            16.0,
                          ),
                        ),
                        child: DropdownButton<String?>(
                          value: _selectedCategoryId,
                          underline: const SizedBox(),
                          borderRadius: BorderRadius.circular(
                            16.0,
                          ),
                          icon: const Icon(Icons.expand_more_rounded),
                          items: [
                            const DropdownMenuItem<String?>(
                              value: null,
                              child: Text('全部'),
                            ),
                            ...cats.map(
                              (c) => DropdownMenuItem<String?>(
                                value: c.id,
                                child: Text(c.name),
                              ),
                            ),
                          ],
                          onChanged: (v) =>
                              setState(() => _selectedCategoryId = v),
                        ),
                      ),
                      loading: () => const SizedBox(
                        width: 44,
                        height: 44,
                        child: Center(
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      ),
                      error: (_, __) => const SizedBox(width: 44),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: resultsAsync.when(
                  data: (items) => ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
                    itemCount: items.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final item = items[index];
                      return Material(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(16.0),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(
                            16.0,
                          ),
                          onTap: () {
                            Navigator.pop(context, item);
                          },
                          onLongPress: () => _showDetail(item),
                          child: Padding(
                            padding: const EdgeInsets.all(14),
                            child: Row(
                              children: [
                                Container(
                                  width: 44,
                                  height: 44,
                                  decoration: BoxDecoration(
                                    color: AppColors.primary,
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  child: const Icon(
                                    Icons.restaurant_rounded,
                                    color: AppColors.primary,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item.name,
                                        style: const TextStyle(
                                          color: AppColors.textPrimary,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        () {
                                          if (item.nutrition == null) {
                                            return '无营养数据';
                                          }
                                          final brief = _briefNutrition(
                                            item.nutrition!,
                                          );
                                          return brief.isEmpty
                                              ? '无营养数据'
                                              : brief;
                                        }(),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          color: AppColors.textSecondary,
                                          fontSize: 12,
                                          height: 1.35,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 8),
                                const Icon(
                                  Icons.chevron_right_rounded,
                                  color: AppColors.primary,
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  loading: () => const Center(
                    child: Text(
                      '输入关键词开始检索',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  error: (e, _) => Center(child: Text('加载失败: $e')),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _briefNutrition(Map<String, dynamic> n) {
    final filtered = _filterKnownNutrition(n);
    final energy = filtered['能量'] ?? filtered['energy'] ?? filtered['kcal'];
    final protein = filtered['蛋白质'] ?? filtered['protein'];
    final fat = filtered['脂肪'] ?? filtered['fat'];
    final carbs = filtered['碳水化合物'] ?? filtered['carbohydrate'];
    final parts = <String>[];
    if (energy != null) parts.add('能量: $energy');
    if (protein != null) parts.add('蛋白: $protein');
    if (fat != null) parts.add('脂肪: $fat');
    if (carbs != null) parts.add('碳水: $carbs');
    return parts.join('  ');
  }

  Map<String, dynamic> _filterKnownNutrition(Map<String, dynamic> n) {
    final Map<String, dynamic> result = {};
    bool hasDigit(String s) => RegExp(r'[0-9]').hasMatch(s);
    final Set<String> unknownMarks = {'未知', '-', '—', 'N/A', 'n/a'};
    n.forEach((key, value) {
      if (value == null) return;
      final text = value.toString().trim();
      if (text.isEmpty) return;
      if (unknownMarks.contains(text)) return;
      if (!hasDigit(text)) return;
      result[key] = text;
    });
    return result;
  }

  Future<void> _showDetail(FoodItem item) async {
    final selected = await showModalBottomSheet<FoodItem>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24.0),
        ),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.6,
          minChildSize: 0.4,
          maxChildSize: 0.9,
          builder: (_, controller) {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          item.name,
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ElevatedButton.icon(
                            icon: const Icon(Icons.add),
                            label: const Text('添加'),
                            onPressed: () => Navigator.pop(context, item),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 8),
                          IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1),
                Expanded(
                  child: ListView(
                    controller: controller,
                    padding: const EdgeInsets.all(16),
                    children: [
                      if (item.nutrition == null)
                        const Text('暂无营养成分数据')
                      else ...[
                        const Text(
                          '营养成分（每100g/100ml）',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 8),
                        ..._filterKnownNutrition(item.nutrition!).entries.map(
                          (e) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 6),
                            child: Row(
                              children: [
                                Expanded(child: Text(e.key)),
                                Text('${e.value}'),
                              ],
                            ),
                          ),
                        ),
                        if (_filterKnownNutrition(item.nutrition!).isEmpty)
                          const Text('暂无营养成分数据'),
                      ],
                    ],
                  ),
                ),
              ],
            );
          },
        );
      },
    );
    if (!mounted || selected == null) return;
    Navigator.pop(context, selected);
  }
}
