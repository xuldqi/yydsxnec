import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/capybara_provider.dart';
import '../models/capybara_state.dart';
import 'capybara_pet_widget.dart';

class CapybaraHeroCard extends ConsumerWidget {
  const CapybaraHeroCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final capyState = ref.watch(capybaraProvider);

    // Dynamic scene background gradient
    List<Color> bgGradient;
    switch (capyState.currentSceneId) {
      case 'grassland':
        bgGradient = [const Color(0xFFECFDF5), const Color(0xFFF0FDF4)];
        break;
      case 'bedroom':
        bgGradient = [const Color(0xFFF5F3FF), const Color(0xFFEDE9FE)];
        break;
      case 'autumn':
        bgGradient = [const Color(0xFFFFFBEB), const Color(0xFFFEF3C7)];
        break;
      case 'onsen':
      default:
        bgGradient = [const Color(0xFFF3F0FF), const Color(0xFFEBEBFA)];
        break;
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: bgGradient,
        ),
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: Colors.white.withValues(alpha: 0.8), width: 1.5),
        boxShadow: const [
          BoxShadow(
            color: Color(0x08000000),
            blurRadius: 18,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // 1. Top row: Status Badge & Hearts Balance + Sanctuary Jump
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Mood Tag
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: capyState.mood.badgeBg,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: capyState.mood.badgeColor.withValues(alpha: 0.2)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildMoodIcon(capyState.mood),
                    const SizedBox(width: 5),
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

              // Hearts Counter & Wardrobe
              GestureDetector(
                onTap: () => context.push('/capybara'),
                behavior: HitTestBehavior.opaque,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.85),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x06000000),
                        blurRadius: 8,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      const Text('💛', style: TextStyle(fontSize: 13)),
                      const SizedBox(width: 4),
                      Text(
                        '${capyState.hearts}',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF1E1B4B),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Container(width: 1, height: 10, color: const Color(0xFFCBD5E1)),
                      const SizedBox(width: 6),
                      const Text(
                        '小窝',
                        style: TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF6366F1),
                        ),
                      ),
                      const Icon(Icons.chevron_right_rounded, size: 14, color: Color(0xFF6366F1)),
                    ],
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // 2. Middle Row: Speech Bubble & Interactive Capybara Avatar
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Left: Speech Bubble & Interactive hint
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(18),
                          topRight: Radius.circular(18),
                          bottomRight: Radius.circular(18),
                          bottomLeft: Radius.circular(4),
                        ),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x08000000),
                            blurRadius: 10,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Text(
                        capyState.activeDialogue,
                        style: const TextStyle(
                          fontSize: 12.5,
                          height: 1.4,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF334155),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.only(left: 4),
                      child: Row(
                        children: const [
                          Icon(Icons.touch_app_rounded, size: 13, color: Color(0xFF94A3B8)),
                          SizedBox(width: 4),
                          Text(
                            '轻触水豚摸摸头',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF94A3B8),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 14),

              // Right: Capybara Pet Interactive
              CapybaraPetWidget(
                mood: capyState.mood,
                accessoryId: capyState.currentAccessoryId,
                size: 110,
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
