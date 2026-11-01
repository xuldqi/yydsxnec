import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/services/step_provider.dart' as step_svc;
import '../providers/capybara_provider.dart';
import '../models/expedition_stage.dart';
import 'capybara_pet_widget.dart';

/// 动态山景漫步探索卡片（复刻 Yoomy 2D 横版卷轴视差探险世界）
/// 上半部分为 3 层横版游戏卷轴视差森林背景，水豚在屏幕中央沿山路持续迈步向前，
/// 下半部分平滑向浅色背景渐变淡出，并呈现超大公里数与探索赛段指标。
class CapybaraExpeditionCard extends ConsumerStatefulWidget {
  final bool showHeader;
  const CapybaraExpeditionCard({super.key, this.showHeader = true});

  @override
  ConsumerState<CapybaraExpeditionCard> createState() => _CapybaraExpeditionCardState();
}

class _CapybaraExpeditionCardState extends ConsumerState<CapybaraExpeditionCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _walkController;
  String? _temporaryQuote;
  DateTime? _quoteExpireTime;

  @override
  void initState() {
    super.initState();
    // 持续滚动的横版视差控制器（14秒为一个卷轴主循环）
    _walkController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 14),
    )..repeat();
  }

  @override
  void dispose() {
    _walkController.dispose();
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

    final stage = ExpeditionStage.fromSteps(steps);
    final progress = ExpeditionStage.stageProgress(steps);
    final remainingSteps = ExpeditionStage.stepsToNextStage(steps);
    final nextStage = ExpeditionStage.nextStage(steps);
    final distanceKm = (steps * 0.00075).toStringAsFixed(1);

    // 默认探索随行台词
    final defaultQuote = _temporaryQuote ??
        (stage == ExpeditionStage.summit
            ? '登顶成功！今晚营地星空格外璀璨✨'
            : '正迈步穿过${stage.name}，微风真舒服～');

    const cardHeight = 390.0;

    return Container(
      width: double.infinity,
      height: cardHeight,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0C3E2723),
            blurRadius: 20,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: Stack(
          children: [
            // ── 1. 三层横版卷轴视差森林与山径画布 ──────────────────────────
            Positioned.fill(
              child: AnimatedBuilder(
                animation: _walkController,
                builder: (context, _) {
                  return CustomPaint(
                    painter: _ParallaxExpeditionPainter(
                      stage: stage,
                      progress: progress,
                      walkTime: _walkController.value,
                    ),
                  );
                },
              ),
            ),

            // ── 2. 顶部工具栏：阶段胶囊 + 小窝金币入口 ───────────────────────
            Positioned(
              top: 14,
              left: 16,
              right: 16,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // 左侧：阶段胶囊徽章（点击可弹出 4 阶段地图底单）
                  GestureDetector(
                    onTap: () => _showStagesBottomSheet(context, steps),
                    behavior: HitTestBehavior.opaque,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 6),
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
                          const SizedBox(width: 5),
                          Text(
                            stage.name,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                              letterSpacing: 0.2,
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Icon(
                            Icons.keyboard_arrow_down_rounded,
                            size: 14,
                            color: Colors.white70,
                          ),
                        ],
                      ),
                    ),
                  ),

                  // 右侧：爱心金币 + 前往小窝入口
                  if (widget.showHeader)
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

            // ── 3. 屏幕正中央：水豚在山路持续迈步向前 ───────────────────────
            Positioned(
              left: 0,
              right: 0,
              top: cardHeight * 0.36,
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // 水豚头顶治愈对白气泡
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 250),
                      child: Container(
                        key: ValueKey(defaultQuote),
                        margin: const EdgeInsets.only(bottom: 6),
                        padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.94),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x18000000),
                              blurRadius: 10,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Text(
                          defaultQuote,
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF2D2522),
                          ),
                        ),
                      ),
                    ),

                    // 水豚角色本体（走步动作模式，中央站立且迈步）
                    GestureDetector(
                      onTap: () {
                        final quotes = [
                          '大步流星，正在翻越山峦！',
                          '深呼吸～山林里的空气好清新！',
                          '一步一个脚印，很快就要登顶啦！',
                          '最喜欢和你一起在路上探索了！',
                        ];
                        final pick = quotes[Random().nextInt(quotes.length)];
                        _showPetQuote(pick);
                      },
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // 脚底与道路贴合的柔和接触阴影
                          Positioned(
                            bottom: 6,
                            child: Container(
                              width: 68,
                              height: 12,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                gradient: RadialGradient(
                                  colors: [
                                    Colors.black.withValues(alpha: 0.32),
                                    Colors.black.withValues(alpha: 0.0),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          // 水豚连续迈步行走动画
                          CapybaraPetWidget(
                            mood: capyState.mood,
                            accessoryId: capyState.currentAccessoryId,
                            size: 112,
                            forceMode: PetAnimMode.walk,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ── 4. 底部渐变浅色过渡区：大字公里数与赛段进度 ─────────────────
            Positioned(
              left: 20,
              right: 20,
              bottom: 18,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // 左侧：Yoomy 式大字公里数与步数说明
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // 大字公里数与单位
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Text(
                            distanceKm,
                            style: const TextStyle(
                              fontSize: 38,
                              fontWeight: FontWeight.w900,
                              color: Color(0xFF1E293B),
                              height: 1.0,
                              letterSpacing: -1.2,
                            ),
                          ),
                          const SizedBox(width: 5),
                          const Text(
                            'km',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF64748B),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      // 步数与下个赛段差额
                      Text(
                        stage == ExpeditionStage.summit
                            ? '今日达成 $steps 步 · 已登顶巅峰营地 ⚑'
                            : '今日 $steps 步 · 距「${nextStage?.name ?? '巅峰'}」还差 $remainingSteps 步',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF475569),
                        ),
                      ),
                    ],
                  ),

                  // 右侧：去运动行动按钮
                  GestureDetector(
                    onTap: () => context.go('/sport'),
                    behavior: HitTestBehavior.opaque,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF2D3748), Color(0xFF1A202C)],
                        ),
                        borderRadius: BorderRadius.circular(22),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x1F000000),
                            blurRadius: 10,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '去走路',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(width: 4),
                          Icon(
                            Icons.arrow_forward_rounded,
                            size: 14,
                            color: Colors.white,
                          ),
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

  // ── 5. 探险赛段图谱弹窗 ──────────────────────────────────────────
  void _showStagesBottomSheet(BuildContext context, int currentSteps) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) => _ExpeditionRoadmapSheet(currentSteps: currentSteps),
    );
  }
}

// ═════════════════════════════════════════════════════════════════════════════
// 3 层横版卷轴游戏视差渲染器 (Parallax 2D Side-Scroller)
// ═════════════════════════════════════════════════════════════════════════════
class _ParallaxExpeditionPainter extends CustomPainter {
  final ExpeditionStage stage;
  final double progress;
  final double walkTime; // 0.0 -> 1.0

  _ParallaxExpeditionPainter({
    required this.stage,
    required this.progress,
    required this.walkTime,
  });

  static const double cycleWidth = 480.0;

  @override
  void paint(Canvas canvas, Size size) {
    // 1. 天空渐变
    _drawSkyGradient(canvas, size);

    // 2. 天文元素（朝阳、日落或繁星明月）
    _drawCelestial(canvas, size);

    // 3. 【第 1 层：远景】远雪山峰（视差滚动速度：0.10x）
    _drawFarMountains(canvas, size);

    // 4. 【第 2 层：中景】中景山脊与云杉林道（视差滚动速度：0.35x）
    _drawMidForest(canvas, size);

    // 5. 【第 3 层：前景】前行山路、地表植被与近景大松树（视差滚动速度：1.0x）
    _drawForegroundTrail(canvas, size);

    // 6. 底部渐变平滑过渡浅色背景 ("逐渐的变浅")
    _drawBottomFadeGradient(canvas, size);
  }

  // ── 天空底色 ────────────────────────────────────────────────────────
  void _drawSkyGradient(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final paint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: stage.skyColors,
      ).createShader(rect);
    canvas.drawRect(rect, paint);
  }

  // ── 天文背景 ────────────────────────────────────────────────────────
  void _drawCelestial(Canvas canvas, Size size) {
    if (stage.isNight) {
      // 繁星与月亮
      _drawStarsAndMoon(canvas, size);
    } else if (stage == ExpeditionStage.dusk) {
      // 晚霞大落日
      final sunCenter = Offset(size.width * 0.76, size.height * 0.28);
      final auraPaint = Paint()
        ..color = const Color(0x33FFB347)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 28);
      canvas.drawCircle(sunCenter, 38, auraPaint);

      final sunPaint = Paint()..color = const Color(0xFFFFD180);
      canvas.drawCircle(sunCenter, 22, sunPaint);
    } else {
      // 朝阳 / 暖日与微光晕
      final sunCenter = Offset(size.width * 0.72, size.height * 0.20);
      final auraPaint = Paint()
        ..color = Colors.white.withValues(alpha: 0.22)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 22);
      canvas.drawCircle(sunCenter, 36, auraPaint);

      final sunPaint = Paint()..color = Colors.white.withValues(alpha: 0.90);
      canvas.drawCircle(sunCenter, 18, sunPaint);
    }
  }

  void _drawStarsAndMoon(Canvas canvas, Size size) {
    // 弯月
    final moonCenter = Offset(size.width * 0.78, size.height * 0.18);
    final moonPaint = Paint()..color = const Color(0xFFFDE68A);
    canvas.drawCircle(moonCenter, 17, moonPaint);

    final shadowPaint = Paint()..color = const Color(0xFF0F172A);
    canvas.drawCircle(moonCenter.translate(-5, -4), 14, shadowPaint);

    // 闪烁繁星
    final rand = Random(42);
    final starPaint = Paint()..color = Colors.white;
    for (int i = 0; i < 28; i++) {
      final sx = rand.nextDouble() * size.width;
      final sy = rand.nextDouble() * (size.height * 0.40);
      final twinkle = (sin(walkTime * 2 * pi * 2 + i) + 1) / 2;
      final radius = 0.8 + rand.nextDouble() * 1.4;
      starPaint.color = Colors.white.withValues(alpha: 0.35 + twinkle * 0.65);
      canvas.drawCircle(Offset(sx, sy), radius, starPaint);
    }
  }

  // ── 【第 1 层：远景】远雪山峰（视差滚动：0.10x）───────────────────────
  void _drawFarMountains(Canvas canvas, Size size) {
    final offset = (walkTime * cycleWidth * 0.10) % cycleWidth;
    final paint = Paint()..color = stage.mountainFarColor.withValues(alpha: 0.65);
    final snowPaint = Paint()..color = Colors.white.withValues(alpha: 0.45);

    // 绘制循环连接的尖锐阿尔卑斯雪山群
    for (double startX = -cycleWidth; startX < size.width + cycleWidth; startX += cycleWidth) {
      final x = startX - offset;

      // 峰 1
      _drawSingleMountain(canvas, x + 60, size.height * 0.42, 180, 110, paint, snowPaint);
      // 峰 2 (最高主峰)
      _drawSingleMountain(canvas, x + 230, size.height * 0.45, 230, 145, paint, snowPaint);
      // 峰 3
      _drawSingleMountain(canvas, x + 390, size.height * 0.44, 190, 120, paint, snowPaint);
    }
  }

  void _drawSingleMountain(
    Canvas canvas,
    double peakX,
    double baseGroundY,
    double width,
    double peakHeight,
    Paint mountainPaint,
    Paint snowPaint,
  ) {
    final topY = baseGroundY - peakHeight;
    final p = Path();
    p.moveTo(peakX - width / 2, baseGroundY);
    p.lineTo(peakX, topY);
    p.lineTo(peakX + width / 2, baseGroundY);
    p.close();
    canvas.drawPath(p, mountainPaint);

    // 峰顶雪盖
    final snowH = peakHeight * 0.28;
    final snowW = width * 0.28;
    final sp = Path();
    sp.moveTo(peakX - snowW / 2, topY + snowH);
    sp.lineTo(peakX, topY);
    sp.lineTo(peakX + snowW / 2, topY + snowH);
    sp.lineTo(peakX + snowW * 0.15, topY + snowH * 0.8);
    sp.lineTo(peakX - snowW * 0.15, topY + snowH * 1.1);
    sp.close();
    canvas.drawPath(sp, snowPaint);
  }

  // ── 【第 2 层：中景】中景山脊与云杉林道（视差滚动：0.35x）──────────────
  void _drawMidForest(Canvas canvas, Size size) {
    final offset = (walkTime * cycleWidth * 0.35) % cycleWidth;
    final midMountainPaint = Paint()..color = stage.mountainColor;
    final midTreePaint = Paint()..color = stage.mountainColor.withValues(alpha: 0.90);

    // 绵延起伏的中景山坡
    for (double startX = -cycleWidth; startX < size.width + cycleWidth; startX += cycleWidth) {
      final x = startX - offset;

      final path = Path();
      path.moveTo(x, size.height * 0.52);
      path.quadraticBezierTo(
        x + cycleWidth * 0.5,
        size.height * 0.44,
        x + cycleWidth,
        size.height * 0.52,
      );
      path.lineTo(x + cycleWidth, size.height);
      path.lineTo(x, size.height);
      path.close();
      canvas.drawPath(path, midMountainPaint);

      // 中景密集小松树群
      _drawPineTree(canvas, Offset(x + 50, size.height * 0.48), 52, midTreePaint);
      _drawPineTree(canvas, Offset(x + 95, size.height * 0.47), 64, midTreePaint);
      _drawPineTree(canvas, Offset(x + 140, size.height * 0.49), 48, midTreePaint);
      _drawPineTree(canvas, Offset(x + 220, size.height * 0.45), 70, midTreePaint);
      _drawPineTree(canvas, Offset(x + 270, size.height * 0.46), 56, midTreePaint);
      _drawPineTree(canvas, Offset(x + 350, size.height * 0.48), 62, midTreePaint);
      _drawPineTree(canvas, Offset(x + 410, size.height * 0.50), 50, midTreePaint);
    }
  }

  // ── 【第 3 层：前景】前行山路与近景大松树（视差滚动：1.0x）──────────────
  void _drawForegroundTrail(Canvas canvas, Size size) {
    final offset = (walkTime * cycleWidth * 1.0) % cycleWidth;

    // 1. 随着卷轴移动的大松树（在路边后方掠过）
    final fgTreePaint = Paint()..color = stage.treeColor;
    for (double startX = -cycleWidth; startX < size.width + cycleWidth; startX += cycleWidth) {
      final x = startX - offset;
      // 树 1
      _drawPineTree(canvas, Offset(x + 70, size.height * 0.58), 125, fgTreePaint);
      // 树 2
      _drawPineTree(canvas, Offset(x + 280, size.height * 0.57), 140, fgTreePaint);
      // 树 3
      _drawPineTree(canvas, Offset(x + 430, size.height * 0.59), 110, fgTreePaint);
    }

    // 2. 前景山体底座
    final groundPath = Path();
    groundPath.moveTo(0, size.height * 0.56);
    groundPath.cubicTo(
      size.width * 0.35,
      size.height * 0.59,
      size.width * 0.70,
      size.height * 0.55,
      size.width,
      size.height * 0.57,
    );
    groundPath.lineTo(size.width, size.height);
    groundPath.lineTo(0, size.height);
    groundPath.close();

    final groundPaint = Paint()..color = stage.groundColor;
    canvas.drawPath(groundPath, groundPaint);

    // 3. 【清晰的山间漫步小路】（横跨屏幕，有路面纹理与边缘高光）
    _drawTrailRibbon(canvas, size, offset);
  }

  // 绘制山径路面（凸显正在路上前行）
  void _drawTrailRibbon(Canvas canvas, Size size, double offset) {
    // 道路上沿高光线
    final trailLinePaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.22)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.2;

    final trailPath = Path();
    trailPath.moveTo(0, size.height * 0.56);
    trailPath.cubicTo(
      size.width * 0.35,
      size.height * 0.59,
      size.width * 0.70,
      size.height * 0.55,
      size.width,
      size.height * 0.57,
    );
    canvas.drawPath(trailPath, trailLinePaint);

    // 道路路面虚线/石子质感纹理（随步速滚动）
    final stonePaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.18)
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round;

    for (double sx = -cycleWidth; sx < size.width + cycleWidth; sx += 48) {
      final x = sx - offset;
      if (x < -20 || x > size.width + 20) continue;

      // 根据贝塞尔近似估算 Y 高度
      final t = (x / size.width).clamp(0.0, 1.0);
      final y = size.height * (0.56 + sin(t * pi) * 0.025);

      canvas.drawLine(Offset(x, y + 6), Offset(x + 12, y + 6.5), stonePaint);
    }
  }

  // 绘制单棵松树（三层几何三角冠与树干）
  void _drawPineTree(Canvas canvas, Offset base, double height, Paint paint) {
    final width = height * 0.46;
    final trunkW = width * 0.14;

    // 树干
    canvas.drawRect(
      Rect.fromCenter(
        center: Offset(base.dx, base.dy - height * 0.12),
        width: trunkW,
        height: height * 0.24,
      ),
      paint,
    );

    // 三层齿状重叠树冠
    for (int i = 0; i < 3; i++) {
      final tierY = base.dy - height * 0.22 - (i * height * 0.24);
      final tierW = width * (1.0 - i * 0.22);
      final tierH = height * 0.36;

      final p = Path();
      p.moveTo(base.dx - tierW / 2, tierY);
      p.lineTo(base.dx, tierY - tierH);
      p.lineTo(base.dx + tierW / 2, tierY);
      p.close();
      canvas.drawPath(p, paint);
    }
  }

  // ── 6. 底部平滑过渡淡出 ("下半部分逐渐变浅") ───────────────────────────
  void _drawBottomFadeGradient(Canvas canvas, Size size) {
    // 从道路底端（y ≈ 0.58）向底部平滑渐变到应用主背景色 #F3F4F8
    final fadeRect = Rect.fromLTWH(0, size.height * 0.54, size.width, size.height * 0.46);
    final fadePaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        stops: const [0.0, 0.40, 0.85, 1.0],
        colors: [
          stage.groundColor.withValues(alpha: 0.0),
          stage.groundColor.withValues(alpha: 0.45),
          const Color(0xFFF3F4F8).withValues(alpha: 0.92),
          const Color(0xFFF3F4F8),
        ],
      ).createShader(fadeRect);

    canvas.drawRect(fadeRect, fadePaint);
  }

  @override
  bool shouldRepaint(covariant _ParallaxExpeditionPainter oldDelegate) {
    return oldDelegate.stage != stage ||
        oldDelegate.progress != progress ||
        oldDelegate.walkTime != walkTime;
  }
}

// ═════════════════════════════════════════════════════════════════════════════
// 探险赛段总览底单 (Roadmap Bottom Sheet)
// ═════════════════════════════════════════════════════════════════════════════
class _ExpeditionRoadmapSheet extends StatelessWidget {
  final int currentSteps;
  const _ExpeditionRoadmapSheet({required this.currentSteps});

  @override
  Widget build(BuildContext context) {
    final stages = ExpeditionStage.values;
    final currentStage = ExpeditionStage.fromSteps(currentSteps);

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 顶部手柄
          Center(
            child: Container(
              width: 38,
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFFE2E8F0),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),
          // 标题与说明
          const Row(
            children: [
              Text(
                '🏔️ 漫步登山探险图谱',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF1E293B),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          const Text(
            '随着今日步数推移，山林画卷将动态展现晨曦、烈日、晚霞与营火',
            style: TextStyle(fontSize: 12.5, color: Color(0xFF64748B)),
          ),
          const SizedBox(height: 20),

          // 4 个阶段时间轴
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: stages.length,
            separatorBuilder: (context, index) => const SizedBox(height: 10),
            itemBuilder: (ctx, i) {
              final s = stages[i];
              final isPassed = currentSteps >= s.maxSteps;
              final isCurrent = s == currentStage;

              return Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isCurrent ? const Color(0xFFF1F5F9) : const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(16),
                  border: isCurrent
                      ? Border.all(color: const Color(0xFF2D3748), width: 1.5)
                      : null,
                ),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: s.badgeColor.withValues(alpha: 0.15),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(s.badgeIcon, color: s.badgeColor, size: 20),
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
                                style: const TextStyle(
                                  fontSize: 14.5,
                                  fontWeight: FontWeight.w800,
                                  color: Color(0xFF1E293B),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                s.stepRange,
                                style: const TextStyle(
                                  fontSize: 11.5,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF64748B),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Text(
                            s.subtitle,
                            style: const TextStyle(fontSize: 11.5, color: Color(0xFF64748B)),
                          ),
                        ],
                      ),
                    ),
                    if (isPassed)
                      const Icon(Icons.check_circle_rounded, color: Color(0xFF10B981), size: 20)
                    else if (isCurrent)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: const Color(0xFF2D3748),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          '进行中',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
