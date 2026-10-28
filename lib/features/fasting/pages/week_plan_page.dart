import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/week_plan_provider.dart';
import '../providers/fasting_provider.dart';
import '../models/week_plan.dart';
import '../models/fasting_plan.dart';
import 'package:steps_webu_flutter/core/theme/app_colors.dart';
import '../components/modern_card.dart';
import '../utils/app_toast.dart';

class WeekPlanPage extends ConsumerStatefulWidget {
  const WeekPlanPage({super.key});

  @override
  ConsumerState<WeekPlanPage> createState() => _WeekPlanPageState();
}

class _WeekPlanPageState extends ConsumerState<WeekPlanPage> {
  final Set<int> _selectedFastingDays = {};
  String? _selectedPlanId;
  String _planName = '';

  @override
  Widget build(BuildContext context) {
    final weekPlansAsync = ref.watch(weekPlansProvider);
    final plansAsync = ref.watch(fastingPlansProvider);
    final activePlanAsync = ref.watch(activeWeekPlanProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('周计划'),
        centerTitle: true,
        backgroundColor: AppColors.background,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showCreateWeekPlanDialog(plansAsync),
            tooltip: '创建周计划',
          ),
        ],
      ),
      body: weekPlansAsync.when(
        data: (weekPlans) {
          if (weekPlans.isEmpty) {
            return _buildEmptyState(context, plansAsync);
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 活跃周计划
                activePlanAsync.when(
                  data: (activePlan) {
                    if (activePlan == null) {
                      return const SizedBox.shrink();
                    }
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '当前周计划',
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 16.0),
                        _buildWeekPlanCard(
                          context,
                          activePlan,
                          plansAsync,
                          true,
                        ),
                        const SizedBox(height: 32.0),
                      ],
                    );
                  },
                  loading: () => const SizedBox.shrink(),
                  error: (_, __) => const SizedBox.shrink(),
                ),

                // 周计划列表
                Text(
                  '所有周计划',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 16.0),
                ...weekPlans.map(
                  (plan) => Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: _buildWeekPlanCard(
                      context,
                      plan,
                      plansAsync,
                      plan.isActive,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline,
                size: 64,
                color: AppColors.error,
              ),
              const SizedBox(height: 16),
              Text('加载失败: $error'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref.refresh(weekPlansProvider),
                child: const Text('重试'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(
    BuildContext context,
    AsyncValue<List<FastingPlan>> plansAsync,
  ) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.calendar_today,
            size: 80,
            color: AppColors.textSecondary,
          ),
          const SizedBox(height: 24),
          Text(
            '暂无周计划',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          Text(
            '创建周计划，让断食更规律',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 32),
          plansAsync.when(
            data: (plans) => plans.isEmpty
                ? const Text('请先创建断食方案')
                : ElevatedButton.icon(
                    onPressed: () =>
                        _showCreateWeekPlanDialog(AsyncValue.data(plans)),
                    icon: const Icon(Icons.add),
                    label: const Text('创建周计划'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32.0,
                        vertical: 16.0,
                      ),
                    ),
                  ),
            loading: () => const CircularProgressIndicator(),
            error: (_, __) => const Text('加载失败'),
          ),
        ],
      ),
    );
  }

  Widget _buildWeekPlanCard(
    BuildContext context,
    WeekPlan weekPlan,
    AsyncValue<List<FastingPlan>> plansAsync,
    bool isActive,
  ) {
    return plansAsync.when(
      data: (plans) {
        final fastingPlan = plans.firstWhere(
          (p) => p.id == weekPlan.planId,
          orElse: () =>
              plans.isNotEmpty ? plans.first : FastingPlan.presetPlans.first,
        );

        return ModernCard(
          useGradient: isActive,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              weekPlan.name,
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(fontWeight: FontWeight.w600),
                            ),
                            if (isActive) ...[
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: Color(0xFF10B981).withValues(
                                    alpha: 0.16,
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  '进行中',
                                  style: Theme.of(context).textTheme.bodySmall
                                      ?.copyWith(
                                        color: Color(0xFF10B981),
                                        fontWeight: FontWeight.w600,
                                      ),
                                ),
                              ),
                            ],
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          fastingPlan.name,
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(color: AppColors.textSecondary),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          weekPlan.description,
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                  ),
                  PopupMenuButton(
                    itemBuilder: (context) => [
                      if (!isActive)
                        const PopupMenuItem(
                          value: 'activate',
                          child: Row(
                            children: [
                              Icon(Icons.check_circle_outline),
                              SizedBox(width: 8),
                              Text('设为活跃'),
                            ],
                          ),
                        ),
                      const PopupMenuItem(
                        value: 'edit',
                        child: Row(
                          children: [
                            Icon(Icons.edit),
                            SizedBox(width: 8),
                            Text('编辑'),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'delete',
                        child: Row(
                          children: [
                            Icon(
                              Icons.delete_outline,
                              color: AppColors.error,
                            ),
                            SizedBox(width: 8),
                            Text(
                              '删除',
                              style: TextStyle(color: AppColors.error),
                            ),
                          ],
                        ),
                      ),
                    ],
                    onSelected: (value) {
                      if (value == 'activate') {
                        ref
                            .read(weekPlansProvider.notifier)
                            .setActivePlan(weekPlan.id);
                      } else if (value == 'edit') {
                        _showEditWeekPlanDialog(weekPlan, plans);
                      } else if (value == 'delete') {
                        _confirmDelete(weekPlan);
                      }
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16.0),

              // 显示周计划日历
              _buildWeekCalendar(weekPlan),
            ],
          ),
        );
      },
      loading: () => const SizedBox(),
      error: (_, __) => const SizedBox(),
    );
  }

  Widget _buildWeekCalendar(WeekPlan plan) {
    const days = ['周一', '周二', '周三', '周四', '周五', '周六', '周日'];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: List.generate(7, (index) {
        final weekday = index + 1;
        final isFastingDay = plan.fastingDays.contains(weekday);
        final isRestDay = plan.restDays.contains(weekday);
        final isToday = weekday == DateTime.now().weekday;

        Color backgroundColor;
        Color textColor;
        IconData? icon;

        if (isRestDay) {
          backgroundColor = AppColors.surface;
          textColor = AppColors.textSecondary;
          icon = Icons.close;
        } else if (isFastingDay) {
          backgroundColor = AppColors.primary.withValues(alpha: 0.16);
          textColor = AppColors.primary;
          icon = Icons.check_circle;
        } else {
          backgroundColor = Colors.transparent;
          textColor = AppColors.textSecondary;
        }

        return Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: backgroundColor,
            shape: BoxShape.circle,
            border: isToday
                ? Border.all(color: AppColors.primary, width: 2)
                : null,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null)
                Icon(icon, size: 16, color: textColor)
              else
                Text(
                  days[index],
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: textColor,
                    fontWeight: isToday ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
            ],
          ),
        );
      }),
    );
  }

  void _showCreateWeekPlanDialog(AsyncValue<List<FastingPlan>> plansAsync) {
    _selectedFastingDays.clear();
    _selectedPlanId = null;
    _planName = '';

    plansAsync.when(
      data: (plans) {
        if (plans.isEmpty) {
          showAppToast(context, '请先创建断食方案', type: AppToastType.info);
          return;
        }

        _selectedPlanId = plans.first.id;
        _showWeekPlanDialog(plans: plans);
      },
      loading: () {},
      error: (_, __) {},
    );
  }

  void _showEditWeekPlanDialog(WeekPlan weekPlan, List<FastingPlan> plans) {
    _selectedFastingDays
      ..clear()
      ..addAll(weekPlan.fastingDays);
    _selectedPlanId = weekPlan.planId;
    _planName = weekPlan.name;
    _showWeekPlanDialog(plans: plans, editingPlan: weekPlan);
  }

  void _showWeekPlanDialog({
    required List<FastingPlan> plans,
    WeekPlan? editingPlan,
  }) {
    final nameController = TextEditingController(text: editingPlan?.name ?? '');
    final isEditing = editingPlan != null;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text(isEditing ? '编辑周计划' : '创建周计划'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 计划名称
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: '计划名称',
                    hintText: '例如：我的6+1计划',
                  ),
                  onChanged: (value) => _planName = value,
                ),
                const SizedBox(height: 16),

                // 选择断食方案
                const Text(
                  '选择断食方案:',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  initialValue: _selectedPlanId,
                  decoration: const InputDecoration(),
                  items: plans.map((plan) {
                    return DropdownMenuItem(
                      value: plan.id,
                      child: Text(
                        '${plan.name} (${plan.fastingHours}:${plan.eatingHours})',
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() => _selectedPlanId = value);
                  },
                ),
                const SizedBox(height: 16),

                // 选择断食日
                const Text(
                  '选择断食日:',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: List.generate(7, (index) {
                    final weekday = index + 1;
                    const days = ['一', '二', '三', '四', '五', '六', '日'];
                    final isSelected = _selectedFastingDays.contains(weekday);

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          if (isSelected) {
                            _selectedFastingDays.remove(weekday);
                          } else {
                            _selectedFastingDays.add(weekday);
                          }
                        });
                      },
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.primary.withValues(alpha: 0.16)
                              : AppColors.surface,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isSelected
                                ? AppColors.primary
                                : AppColors.divider,
                            width: 2,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            days[index],
                            style: TextStyle(
                              color: isSelected
                                  ? AppColors.primary
                                  : AppColors.textSecondary,
                              fontWeight: isSelected
                                  ? FontWeight.w600
                                  : FontWeight.normal,
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    TextButton(
                      onPressed: () {
                        setState(() {
                          // 6+1模式
                          _selectedFastingDays.clear();
                          _selectedFastingDays.addAll([1, 2, 3, 4, 5, 6]);
                        });
                      },
                      child: const Text('6+1'),
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          // 5+2模式
                          _selectedFastingDays.clear();
                          _selectedFastingDays.addAll([1, 2, 3, 4, 5]);
                        });
                      },
                      child: const Text('5+2'),
                    ),
                  ],
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
              onPressed: _selectedPlanId == null || _selectedFastingDays.isEmpty
                  ? null
                  : () {
                      Navigator.of(context).pop();
                      if (isEditing) {
                        _updateWeekPlan(editingPlan);
                      } else {
                        _createWeekPlan();
                      }
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
              ),
              child: Text(isEditing ? '保存' : '创建'),
            ),
          ],
        ),
      ),
    ).then((_) {
      nameController.dispose();
    });
  }

  void _createWeekPlan() {
    if (_selectedPlanId == null || _selectedFastingDays.isEmpty) return;

    final restDays = List.generate(
      7,
      (i) => i + 1,
    ).where((day) => !_selectedFastingDays.contains(day)).toList();

    final weekPlan = WeekPlan(
      id: 'weekplan_${DateTime.now().millisecondsSinceEpoch}',
      name: _planName.isEmpty
          ? (_selectedFastingDays.length == 6
                ? '6+1周计划'
                : _selectedFastingDays.length == 5
                ? '5+2周计划'
                : '自定义周计划')
          : _planName,
      planId: _selectedPlanId!,
      fastingDays: _selectedFastingDays.toList()..sort(),
      restDays: restDays..sort(),
      createdAt: DateTime.now(),
    );

    ref.read(weekPlansProvider.notifier).addPlan(weekPlan);

    showAppToast(context, '周计划创建成功', type: AppToastType.success);
  }

  void _updateWeekPlan(WeekPlan plan) {
    if (_selectedPlanId == null || _selectedFastingDays.isEmpty) return;

    final restDays = List.generate(
      7,
      (i) => i + 1,
    ).where((day) => !_selectedFastingDays.contains(day)).toList();

    final updatedPlan = plan.copyWith(
      name: _planName.trim().isEmpty ? plan.name : _planName.trim(),
      planId: _selectedPlanId!,
      fastingDays: _selectedFastingDays.toList()..sort(),
      restDays: restDays..sort(),
      lowCalorieDays: const [],
      updatedAt: DateTime.now(),
    );

    ref.read(weekPlansProvider.notifier).updatePlan(updatedPlan);

    showAppToast(context, '周计划已更新', type: AppToastType.success);
  }

  void _confirmDelete(WeekPlan plan) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('确认删除'),
        content: Text('确定要删除"${plan.name}"吗？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('取消'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              ref.read(weekPlansProvider.notifier).deletePlan(plan.id);
              showAppToast(context, '已删除', type: AppToastType.success);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
            ),
            child: const Text('删除'),
          ),
        ],
      ),
    );
  }
}
