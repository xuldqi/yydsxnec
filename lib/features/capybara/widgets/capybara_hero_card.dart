import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/capybara_provider.dart';
import '../models/capybara_state.dart';
import 'capybara_pet_widget.dart';

class CapybaraHeroCard extends ConsumerWidget {
  final bool showHeader;
  const CapybaraHeroCard({super.key, this.showHeader = true});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final capyState = ref.watch(capybaraProvider);

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
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: bgGradient,
        ),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        children: [
          if (showHeader) ...[
            // Top row: Status Badge & Hearts Balance + Sanctuary Jump
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

          // Middle Row: Speech Bubble & Interactive Multi-Frame Capybara
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Left: Speech Bubble (clean, compact)
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.9),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                      bottomRight: Radius.circular(16),
                      bottomLeft: Radius.circular(4),
                    ),
                  ),
                  child: Text(
                    capyState.activeDialogue,
                    style: const TextStyle(
                      fontSize: 12.5,
                      height: 1.45,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF2D2522),
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 12),

              // Right: Multi-Frame Animated 2D Capybara
              CapybaraPetWidget(
                mood: capyState.mood,
                accessoryId: capyState.currentAccessoryId,
                size: 115,
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
