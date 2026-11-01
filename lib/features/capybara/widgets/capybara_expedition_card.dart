import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../core/services/step_provider.dart' as step_svc;
import '../providers/capybara_provider.dart';
import '../models/expedition_stage.dart';
import 'capybara_pet_widget.dart';

/// 动态山景漫步探索卡片（灵感源于 Yoomy 探险之旅架构）
/// 随步数和里程阶梯式动态蜕变场景：晨光原野 -> 阳光林道 -> 落日山脊 -> 巅峰星空
class CapybaraExpeditionCard extends ConsumerStatefulWidget {
  final bool showHeader;
  const CapybaraExpeditionCard({super.key, this.showHeader = true});

  @override
  ConsumerState<CapybaraExpeditionCard> createState() => _CapybaraExpeditionCardState();
}

class _CapybaraExpeditionCardState extends ConsumerState<CapybaraExpeditionCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _ambientController;
  String? _temporaryQuote;
  DateTime? _quoteExpireTime;

  @override
  void initState() {
    super.initState();
    _ambientController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat();
  }

  @override
  void dispose() {
    _ambientController.dispose();
    super.dispose();
  }

  void _showPetQuote(String quote) {
    setState(() {
      _temporaryQuote = quote;
      _quoteExpireTime = DateTime.now().add(const Duration(seconds: 4));
    });

    Future.delayed(const Duration(seconds: 4), () {
      if (mounted && _quoteExpireTime != null && DateTime.now().isAfter(_quoteExpireTime!)) {
        setState(() {
          _temporaryQuote = null;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final capyState = ref.watch(capybaraProvider);
    final stepAsync = ref.watch(step_svc.stepProvider);
    final steps = stepAsync.valueOrNull?.todaySteps ?? 6820;
    final km = (steps * 0.0007).clamp(0.0, 999.0);
    const stepGoal = 8000;
    final progress = (steps / stepGoal).clamp(0.0, 1.0);
    final stage = ExpeditionStage.fromSteps(steps);

    return Container(
      width: double.infinity,
      height: 250,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: Stack(
          children: [
            // 1. 动态层级视差山林风景画布 (CustomPainter)
            Positioned.fill(
              child: AnimatedBuilder(
                animation: _ambientController,
                builder: (context, _) {
                  return CustomPaint(
                    painter: _ExpeditionLandscapePainter(
                      stage: stage,
                      progress: progress,
                      ambientTime: _ambientController.value,
                    ),
                  );
                },
              ),
            ),

            // 2. 顶部状态栏：阶段标签 + 爱心金币与小窝入口
            Positioned(
              top: 14,
              left: 16,
              right: 16,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // 左侧：阶段胶囊徽章（点击可查看漫步里程图谱）
                  GestureDetector(
                    onTap: () => _showStagesBottomSheet(context, steps),
                    behavior: HitTestBehavior.opaque,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.28),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.25),
                          width: 0.8,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            stage.badgeIcon,
                            size: 13,
                            color: stage.isNight ? const Color(0xFFFBBF24) : Colors.white,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            stage.name,
                            style: const TextStyle(
                              fontSize: 11.5,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                              letterSpacing: 0.2,
                            ),
                          ),
                          const SizedBox(width: 3),
                          Icon(
                            Icons.keyboard_arrow_down_rounded,
                            size: 14,
                            color: Colors.white.withValues(alpha: 0.8),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // 右侧：爱心金币 + 前往小窝入口
                  GestureDetector(
                    onTap: () => context.push('/capybara'),
                    behavior: HitTestBehavior.opaque,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.28),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.25),
                          width: 0.8,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text('💛', style: TextStyle(fontSize: 11)),
                          const SizedBox(width: 4),
                          Text(
                            '${capyState.hearts}',
                            style: const TextStyle(
                              fontSize: 11.5,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Container(width: 1, height: 9, color: Colors.white30),
                          const SizedBox(width: 6),
                          const Text(
                            '小窝',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                          const Icon(Icons.chevron_right_rounded, size: 13, color: Colors.white),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // 3. 漫步主角：卡皮巴拉站立在山脊小道上
            Positioned(
              right: 18,
              bottom: 48,
              child: CapybaraPetWidget(
                mood: capyState.mood,
                accessoryId: capyState.currentAccessoryId,
                size: 115,
                onPet: () {
                  ref.read(capybaraProvider.notifier).pet();
                  _showPetQuote(capyState.activeDialogue);
                },
              ),
            ),

            // 4. 摸头或互动时弹出的元气对白气泡
            if (_temporaryQuote != null)
              Positioned(
                right: 30,
                bottom: 165,
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 190),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.95),
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x26000000),
                        blurRadius: 10,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Text(
                    _temporaryQuote!,
                    style: const TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF2D2522),
                      height: 1.3,
                    ),
                  ),
                ),
              ),

            // 5. 底部 HUD 探索进度面板
            Positioned(
              left: 16,
              right: 16,
              bottom: 14,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // 左侧：大数字里程与探索目标
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            Text(
                              km.toStringAsFixed(1),
                              style: const TextStyle(
                                fontSize: 34,
                                fontWeight: FontWeight.w900,
                                color: Colors.white,
                                letterSpacing: -1.2,
                                height: 1.0,
                                shadows: [
                                  Shadow(
                                    color: Colors.black45,
                                    blurRadius: 8,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 4),
                            const Text(
                              'km',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: Colors.white70,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              '${NumberFormat('#,###').format(steps)} 步',
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          stage.nextCheckpointInfo(steps),
                          style: TextStyle(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w600,
                            color: Colors.white.withValues(alpha: 0.85),
                            shadows: const [
                              Shadow(
                                color: Colors.black54,
                                blurRadius: 6,
                                offset: Offset(0, 1),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // 右侧：「去走路」快捷入口胶囊按钮
                  GestureDetector(
                    onTap: () => context.push('/count-time?type=健走'),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF8D5B4C),
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.35),
                          width: 1.0,
                        ),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x35000000),
                            blurRadius: 10,
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
                          Icon(Icons.chevron_right_rounded, size: 14, color: Colors.white),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showStagesBottomSheet(BuildContext context, int currentSteps) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
          decoration: const BoxDecoration(
            color: Color(0xFF26201D),
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                '卡皮巴拉漫步探索图谱',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              const SizedBox(height: 4),
              const Text(
                '每日步数将推进漫步画卷，陪它看遍四季山河',
                style: TextStyle(fontSize: 12, color: Colors.white70),
              ),
              const SizedBox(height: 16),
              ...ExpeditionStage.values.map((s) {
                final isCurrent = s == ExpeditionStage.fromSteps(currentSteps);
                final isReached = currentSteps >= s.minSteps;

                return Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  decoration: BoxDecoration(
                    color: isCurrent
                        ? const Color(0xFF8D5B4C).withValues(alpha: 0.35)
                        : Colors.white.withValues(alpha: 0.06),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: isCurrent ? const Color(0xFF8D5B4C) : Colors.transparent,
                      width: 1.2,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        s.badgeIcon,
                        size: 20,
                        color: isReached ? const Color(0xFFE5A93C) : Colors.white38,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  s.name,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: isReached ? Colors.white : Colors.white60,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  s.stepRange,
                                  style: const TextStyle(fontSize: 11, color: Colors.white54),
                                ),
                              ],
                            ),
                            const SizedBox(height: 2),
                            Text(
                              s.subtitle,
                              style: const TextStyle(fontSize: 11, color: Colors.white70),
                            ),
                          ],
                        ),
                      ),
                      if (isCurrent)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: const Color(0xFF8D5B4C),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Text(
                            '当前阶段',
                            style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                        )
                      else if (isReached)
                        const Icon(Icons.check_circle_rounded, size: 16, color: Color(0xFF52B788)),
                    ],
                  ),
                );
              }),
            ],
          ),
        );
      },
    );
  }
}

/// 绘制北欧高质感多层视差山林风景
class _ExpeditionLandscapePainter extends CustomPainter {
  final ExpeditionStage stage;
  final double progress;
  final double ambientTime;

  _ExpeditionLandscapePainter({
    required this.stage,
    required this.progress,
    required this.ambientTime,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // 1. 天空渐变背景
    final skyRect = Offset.zero & size;
    final skyGradient = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: stage.skyColors,
    );
    final skyPaint = Paint()..shader = skyGradient.createShader(skyRect);
    canvas.drawRect(skyRect, skyPaint);

    // 2. 天空中的天体（太阳 / 月亮 / 星空）
    _drawCelestial(canvas, size);

    // 3. 远方雪山剪影层 (Distant Mountains with Parallax)
    _drawFarMountains(canvas, size);

    // 4. 中景高耸松林层 (Alpine Fir & Pine Trees)
    _drawPineTrees(canvas, size);

    // 5. 前景蜿蜒山脊小路 (Foreground Ridge Path)
    _drawForegroundPath(canvas, size);

    // 6. 巅峰营地篝火与胜利旗帜 (如果达成目标)
    if (stage == ExpeditionStage.summit) {
      _drawCampfireAndFlag(canvas, size);
    }
  }

  void _drawCelestial(Canvas canvas, Size size) {
    if (stage.isNight) {
      // 绘制璀璨星辰
      final starRandom = Random(42);
      final starPaint = Paint()..color = Colors.white;
      for (int i = 0; i < 28; i++) {
        final x = starRandom.nextDouble() * size.width;
        final y = starRandom.nextDouble() * (size.height * 0.45);
        final radius = 0.8 + starRandom.nextDouble() * 1.5;
        // 星星轻微呼吸闪烁
        final twinkle = (sin(ambientTime * 2 * pi * 2 + i) + 1) / 2;
        starPaint.color = Colors.white.withValues(alpha: 0.3 + 0.6 * twinkle);
        canvas.drawCircle(Offset(x, y), radius, starPaint);
      }

      // 银色月牙
      final moonCenter = Offset(size.width * 0.28, size.height * 0.22);
      final moonPaint = Paint()..color = const Color(0xFFFDE68A).withValues(alpha: 0.9);
      canvas.drawCircle(moonCenter, 13, moonPaint);
      final shadowPaint = Paint()..color = stage.skyColors.first;
      canvas.drawCircle(moonCenter.translate(5, -2), 11, shadowPaint);
    } else {
      // 白昼/黄昏太阳
      final isDusk = stage == ExpeditionStage.dusk;
      final sunCenter = isDusk
          ? Offset(size.width * 0.45, size.height * 0.38)
          : Offset(size.width * 0.35, size.height * 0.20);
      final sunColor = isDusk ? const Color(0xFFFF9E64) : const Color(0xFFFFF3D4);

      // 光晕
      canvas.drawCircle(
        sunCenter,
        28,
        Paint()..color = sunColor.withValues(alpha: 0.25),
      );
      // 太阳本体
      canvas.drawCircle(
        sunCenter,
        14,
        Paint()..color = sunColor.withValues(alpha: 0.95),
      );
    }
  }

  void _drawFarMountains(Canvas canvas, Size size) {
    // 第一层：极远黛色山峦
    final farPath = Path();
    farPath.moveTo(0, size.height * 0.52);
    farPath.lineTo(size.width * 0.22, size.height * 0.32);
    farPath.lineTo(size.width * 0.48, size.height * 0.46);
    farPath.lineTo(size.width * 0.76, size.height * 0.28);
    farPath.lineTo(size.width, size.height * 0.45);
    farPath.lineTo(size.width, size.height);
    farPath.lineTo(0, size.height);
    farPath.close();

    final farPaint = Paint()..color = stage.mountainFarColor.withValues(alpha: 0.65);
    canvas.drawPath(farPath, farPaint);

    // 第二层：中远景尖峰雪山
    final midMountainPath = Path();
    midMountainPath.moveTo(0, size.height * 0.60);
    midMountainPath.lineTo(size.width * 0.16, size.height * 0.44);
    midMountainPath.lineTo(size.width * 0.36, size.height * 0.58);
    midMountainPath.lineTo(size.width * 0.62, size.height * 0.36);
    midMountainPath.lineTo(size.width * 0.88, size.height * 0.54);
    midMountainPath.lineTo(size.width, size.height * 0.48);
    midMountainPath.lineTo(size.width, size.height);
    midMountainPath.lineTo(0, size.height);
    midMountainPath.close();

    final midMountainPaint = Paint()..color = stage.mountainColor;
    canvas.drawPath(midMountainPath, midMountainPaint);
  }

  void _drawPineTrees(Canvas canvas, Size size) {
    // 绘制几棵高耸挺拔的针叶松树（复刻 Yoomy 标志性的北欧森林剪影）
    final treePaint = Paint()..color = stage.treeColor;

    // 左侧第一棵大松树
    _drawSinglePine(canvas, Offset(size.width * 0.10, size.height * 0.68), 95, treePaint);
    // 左中第二棵较高松树
    _drawSinglePine(canvas, Offset(size.width * 0.28, size.height * 0.64), 115, treePaint);
    // 中景细长冷杉
    _drawSinglePine(canvas, Offset(size.width * 0.45, size.height * 0.66), 85, treePaint);
    // 右侧中景松树
    _drawSinglePine(canvas, Offset(size.width * 0.60, size.height * 0.70), 75, treePaint);
  }

  void _drawSinglePine(Canvas canvas, Offset base, double height, Paint paint) {
    final width = height * 0.48;
    final trunkWidth = width * 0.14;

    // 树干
    canvas.drawRect(
      Rect.fromCenter(
        center: Offset(base.dx, base.dy - height * 0.15),
        width: trunkWidth,
        height: height * 0.3,
      ),
      paint,
    );

    // 三层重叠齿状三角树冠
    for (int i = 0; i < 3; i++) {
      final tierY = base.dy - height * 0.25 - (i * height * 0.24);
      final tierWidth = width * (1.0 - i * 0.22);
      final tierHeight = height * 0.38;

      final p = Path();
      p.moveTo(base.dx - tierWidth / 2, tierY);
      p.lineTo(base.dx, tierY - tierHeight);
      p.lineTo(base.dx + tierWidth / 2, tierY);
      p.close();
      canvas.drawPath(p, paint);
    }
  }

  void _drawForegroundPath(Canvas canvas, Size size) {
    // 前景平缓上升的山脊道路（水豚站立其上）
    final path = Path();
    path.moveTo(0, size.height * 0.72);
    // 优美的贝塞尔自然微坡
    path.quadraticBezierTo(
      size.width * 0.50,
      size.height * 0.75,
      size.width,
      size.height * 0.66,
    );
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    final groundPaint = Paint()..color = stage.groundColor;
    canvas.drawPath(path, groundPaint);

    // 绘制山体底部暗色渐变阴影，突出底部文字清晰度
    final shadowRect = Rect.fromLTWH(0, size.height * 0.60, size.width, size.height * 0.40);
    final shadowPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Colors.transparent,
          Colors.black.withValues(alpha: 0.65),
        ],
      ).createShader(shadowRect);
    canvas.drawRect(shadowRect, shadowPaint);
  }

  void _drawCampfireAndFlag(Canvas canvas, Size size) {
    // 达成目标的营地小篝火与胜利旗帜
    final fireX = size.width * 0.56;
    final fireY = size.height * 0.71;

    // 小篝火火光
    final flicker = sin(ambientTime * 2 * pi * 4) * 2;
    final flamePaint = Paint()..color = const Color(0xFFF97316);
    final flameCorePaint = Paint()..color = const Color(0xFFFDE047);

    canvas.drawCircle(Offset(fireX, fireY), 6 + flicker, flamePaint);
    canvas.drawCircle(Offset(fireX, fireY + 1), 3, flameCorePaint);

    // 胜利小旗杆
    final flagPaint = Paint()
      ..color = Colors.white70
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;
    canvas.drawLine(Offset(fireX - 16, fireY + 8), Offset(fireX - 16, fireY - 14), flagPaint);

    final flagCloth = Path()
      ..moveTo(fireX - 16, fireY - 14)
      ..lineTo(fireX - 7, fireY - 9)
      ..lineTo(fireX - 16, fireY - 4)
      ..close();
    canvas.drawPath(flagCloth, Paint()..color = const Color(0xFFEF4444));
  }

  @override
  bool shouldRepaint(covariant _ExpeditionLandscapePainter old) {
    return old.stage != stage ||
        old.progress != progress ||
        old.ambientTime != ambientTime;
  }
}
