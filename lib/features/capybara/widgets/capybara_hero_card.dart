import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../core/services/step_provider.dart' as step_svc;
import '../providers/capybara_provider.dart';
import '../models/capybara_state.dart';
import 'capybara_pet_widget.dart';

class CapybaraHeroCard extends ConsumerWidget {
  final bool showHeader;
  const CapybaraHeroCard({super.key, this.showHeader = true});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final capyState = ref.watch(capybaraProvider);
    final stepAsync = ref.watch(step_svc.stepProvider);
    final steps = stepAsync.valueOrNull?.todaySteps ?? 6820;
    const stepGoal = 8000;
    final progress = (steps / stepGoal).clamp(0.0, 1.0);

    // Warm, cohesive Finch/OtterLife aesthetic palette
    List<Color> bgGradient;
    switch (capyState.currentSceneId) {
      case 'grassland':
        bgGradient = [const Color(0xFFF6FAF7), const Color(0xFFEAF4EC)];
        break;
      case 'bedroom':
        bgGradient = [const Color(0xFFFAF7F5), const Color(0xFFF1EBE5)];
        break;
      case 'autumn':
        bgGradient = [const Color(0xFFFDF7F1), const Color(0xFFF6ECE0)];
        break;
      case 'onsen':
      default:
        bgGradient = [const Color(0xFFFBF8F5), const Color(0xFFF3ECE4)];
        break;
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: bgGradient,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [
          BoxShadow(
            color: Color(0x067A533E),
            blurRadius: 16,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          if (showHeader) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: capyState.mood.badgeBg,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildMoodIcon(capyState.mood),
                      const SizedBox(width: 4),
                      Text(
                        capyState.mood.label,
                        style: TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w800,
                          color: capyState.mood.badgeColor,
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () => context.push('/capybara'),
                  behavior: HitTestBehavior.opaque,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.8),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Row(
                      children: [
                        const Text('💛', style: TextStyle(fontSize: 11)),
                        const SizedBox(width: 4),
                        Text(
                          '${capyState.hearts}',
                          style: const TextStyle(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFF3D342F),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Container(width: 1, height: 9, color: const Color(0xFFE5DDD5)),
                        const SizedBox(width: 6),
                        const Text(
                          '小窝',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF8D5B4C),
                          ),
                        ),
                        const Icon(Icons.chevron_right_rounded, size: 13, color: Color(0xFF8D5B4C)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
          ],

          // 核心主角区：左侧直观步数与「去走路」，右侧水豚安然站立待机
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // 左侧：步数进度 + 快捷「去走路」按键
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '今日步数',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF8C7E77),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          NumberFormat('#,###').format(steps),
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFF2D2522),
                            letterSpacing: -1.0,
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Text(
                          '步',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF8C7E77),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '目标 ${(progress * 100).toInt()}%   消耗 ${(steps * 0.038).toInt()} kcal',
                      style: const TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF8C7E77),
                      ),
                    ),
                    const SizedBox(height: 10),
                    // 「去走路」快捷入口胶囊按键（去掉前后双图标包裹，仅保留简洁文字与单向右箭头）
                    GestureDetector(
                      onTap: () => context.push('/count-time?type=健走'),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 7),
                        decoration: BoxDecoration(
                          color: const Color(0xFF8D5B4C),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x208D5B4C),
                              blurRadius: 8,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Text(
                              '去走路',
                              style: TextStyle(
                                fontSize: 12.5,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(width: 2),
                            Icon(Icons.chevron_right_rounded,
                                size: 14, color: Colors.white),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // 右侧：多帧站立待机微动水豚（可摸头互动）
              CapybaraPetWidget(
                mood: capyState.mood,
                accessoryId: capyState.currentAccessoryId,
                size: 118,
                onPet: () => ref.read(capybaraProvider.notifier).pet(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMoodIcon(CapybaraMood mood) {
    switch (mood) {
      case CapybaraMood.orange:
        return const Text('🍊', style: TextStyle(fontSize: 12));
      case CapybaraMood.onsen:
        return const Text('♨️', style: TextStyle(fontSize: 12));
      case CapybaraMood.energetic:
        return const Text('✨', style: TextStyle(fontSize: 12));
      case CapybaraMood.sleepy:
        return const Text('💤', style: TextStyle(fontSize: 12));
    }
  }
}
