import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/services/step_provider.dart' as step_svc;
import '../providers/capybara_provider.dart';
import '../models/expedition_stage.dart';
import 'capybara_pet_widget.dart';

/// 动态山景漫步探索卡片（复刻 Yoomy 2D 横版卷轴视差探险世界）
/// 沉浸式顶满状态栏、推平屏幕两侧（全宽无边框），
/// 上半部分为 3 层横版游戏卷轴视差森林背景，水豚在屏幕中央沿山路持续迈步向前，
/// 下半部分平滑向浅色背景渐变淡出，中央呈现超大公里数与「今日步行 X / Y 步」。
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
    final stepData = stepAsync.valueOrNull ?? const step_svc.StepState(todaySteps: 0, goal: 10000);
    final steps = stepData.todaySteps;
    final goalSteps = stepData.goal > 0 ? stepData.goal : 10000;

    final stage = ExpeditionStage.fromSteps(steps);
    final progress = ExpeditionStage.stageProgress(steps);
    final distanceKm = (steps * 0.00075).toStringAsFixed(1);

    // 默认探索随行台词
    final defaultQuote = _temporaryQuote ??
        (stage == ExpeditionStage.summit
            ? '登顶成功！今晚营地星空格外璀璨✨'
            : '微风真舒服，大步向前走～');

    // 状态栏高度适配（沉浸式顶满状态栏）
    final topPadding = MediaQuery.of(context).padding.top;
    const cardHeight = 425.0;

    final now = DateTime.now();
    final dateText = '${now.month}月${now.day}日';

    return SizedBox(
      width: double.infinity,
      height: cardHeight,
      child: Stack(
        children: [
          // ── 1. 三层横版卷轴视差森林与山径画布（沉浸式顶满状态栏） ───────
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

          // ── 2. 顶部透明状态栏区域：左侧今日日期 + 右侧小窝入口 ────────────
          Positioned(
            top: topPadding + 6,
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // 左侧：固定显示今日日期（白色大字 + 柔和投影）
                Text(
                  dateText,
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    letterSpacing: -0.5,
                    shadows: [
                      Shadow(
                        color: Colors.black38,
                        blurRadius: 6,
                        offset: Offset(0, 1.5),
                      ),
                    ],
                  ),
                ),

                // 右侧：爱心金币 + 前往小窝入口（磨砂玻璃白字）
                GestureDetector(
                  onTap: () => context.push('/capybara'),
                  behavior: HitTestBehavior.opaque,
                  child: Container(
                    height: 34,
                    padding: const EdgeInsets.symmetric(horizontal: 11),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.28),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.25),
                        width: 0.8,
                      ),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x18000000),
                          blurRadius: 8,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text('💛', style: TextStyle(fontSize: 12)),
                        const SizedBox(width: 4),
                        Text(
                          '${capyState.hearts}',
                          style: const TextStyle(
                            fontSize: 12,
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
                            fontSize: 11.5,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                        const Icon(Icons.chevron_right_rounded, size: 14, color: Colors.white),
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
            top: 145,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // 水豚头顶治愈对白气泡
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 250),
                    child: Container(
                      key: ValueKey(defaultQuote),
                      margin: const EdgeInsets.only(bottom: 4),
                      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 5),
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
                                  Colors.black.withValues(alpha: 0.35),
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
                          size: 110,
                          forceMode: PetAnimMode.walk,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── 4. 居中大字公里数与步数（白色文字 + 向上微调） ─────────────────
          Positioned(
            left: 20,
            right: 20,
            bottom: 64,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // 居中大字公里数（数字绝对水平居中，km 附着右侧不影响居中重心）
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    // 左侧镜像不可见占位，确保纯数字处于绝对水平中心
                    Opacity(
                      opacity: 0.0,
                      child: Text(
                        ' km',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    Text(
                      distanceKm,
                      style: const TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        height: 1.0,
                        letterSpacing: -1.2,
                        shadows: [
                          Shadow(
                            color: Colors.black45,
                            blurRadius: 10,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      ' km',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: Colors.white.withValues(alpha: 0.90),
                        shadows: const [
                          Shadow(
                            color: Colors.black38,
                            blurRadius: 6,
                            offset: Offset(0, 1.5),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                // 居中步数：今日步行 当前步数 / 目标步数 步（纯白文字）
                Text(
                  '今日步行 $steps / $goalSteps 步',
                  style: TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w700,
                    color: Colors.white.withValues(alpha: 0.95),
                    letterSpacing: 0.2,
                    shadows: const [
                      Shadow(
                        color: Colors.black38,
                        blurRadius: 6,
                        offset: Offset(0, 1.5),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
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
    // 1. 天空渐变（顶满顶部状态栏）
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
      final sunCenter = Offset(size.width * 0.76, size.height * 0.26);
      final auraPaint = Paint()
        ..color = const Color(0x33FFB347)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 28);
      canvas.drawCircle(sunCenter, 38, auraPaint);

      final sunPaint = Paint()..color = const Color(0xFFFFD180);
      canvas.drawCircle(sunCenter, 22, sunPaint);
    } else {
      // 朝阳 / 暖日与微光晕
      final sunCenter = Offset(size.width * 0.72, size.height * 0.18);
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
    final moonCenter = Offset(size.width * 0.78, size.height * 0.16);
    final moonPaint = Paint()..color = const Color(0xFFFDE68A);
    canvas.drawCircle(moonCenter, 17, moonPaint);

    final shadowPaint = Paint()..color = const Color(0xFF0F172A);
    canvas.drawCircle(moonCenter.translate(-5, -4), 14, shadowPaint);

    // 闪烁繁星
    final rand = Random(42);
    final starPaint = Paint()..color = Colors.white;
    for (int i = 0; i < 28; i++) {
      final sx = rand.nextDouble() * size.width;
      final sy = rand.nextDouble() * (size.height * 0.38);
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
      _drawSingleMountain(canvas, x + 60, size.height * 0.44, 180, 110, paint, snowPaint);
      // 峰 2 (最高主峰)
      _drawSingleMountain(canvas, x + 230, size.height * 0.47, 230, 145, paint, snowPaint);
      // 峰 3
      _drawSingleMountain(canvas, x + 390, size.height * 0.45, 190, 120, paint, snowPaint);
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
      path.moveTo(x, size.height * 0.54);
      path.quadraticBezierTo(
        x + cycleWidth * 0.5,
        size.height * 0.46,
        x + cycleWidth,
        size.height * 0.54,
      );
      path.lineTo(x + cycleWidth, size.height);
      path.lineTo(x, size.height);
      path.close();
      canvas.drawPath(path, midMountainPaint);

      // 中景密集小松树群
      _drawPineTree(canvas, Offset(x + 50, size.height * 0.50), 52, midTreePaint);
      _drawPineTree(canvas, Offset(x + 95, size.height * 0.49), 64, midTreePaint);
      _drawPineTree(canvas, Offset(x + 140, size.height * 0.51), 48, midTreePaint);
      _drawPineTree(canvas, Offset(x + 220, size.height * 0.47), 70, midTreePaint);
      _drawPineTree(canvas, Offset(x + 270, size.height * 0.48), 56, midTreePaint);
      _drawPineTree(canvas, Offset(x + 350, size.height * 0.50), 62, midTreePaint);
      _drawPineTree(canvas, Offset(x + 410, size.height * 0.52), 50, midTreePaint);
    }
  }

  // ── 【第 3 层：前景】前行山路与近景大松树（视差滚动：1.0x）──────────────
  void _drawForegroundTrail(Canvas canvas, Size size) {
    final offset = (walkTime * cycleWidth * 1.0) % cycleWidth;
    final trailY = size.height * 0.63; // 与水豚脚底严丝合缝

    // 1. 随着卷轴移动的前景高大冷杉（在小径后侧掠过）
    final fgTreePaint = Paint()..color = stage.treeColor;
    for (double startX = -cycleWidth; startX < size.width + cycleWidth; startX += cycleWidth) {
      final x = startX - offset;
      _drawPineTree(canvas, Offset(x + 55, trailY - 4), 130, fgTreePaint);
      _drawPineTree(canvas, Offset(x + 285, trailY - 6), 145, fgTreePaint);
      _drawPineTree(canvas, Offset(x + 435, trailY - 4), 115, fgTreePaint);
    }

    // 2. 前景山体底座
    final groundPath = Path();
    groundPath.moveTo(0, trailY - 5);
    groundPath.cubicTo(
      size.width * 0.35,
      trailY - 2,
      size.width * 0.70,
      trailY - 8,
      size.width,
      trailY - 4,
    );
    groundPath.lineTo(size.width, size.height);
    groundPath.lineTo(0, size.height);
    groundPath.close();

    final groundPaint = Paint()..color = stage.groundColor;
    canvas.drawPath(groundPath, groundPaint);

    // 3. 【清晰立体的山间漫步小路】（横跨屏幕，带泥土路面、碎石脚印纹理与路缘高光）
    _drawTrailRibbon(canvas, size, offset, trailY);
  }

  // 绘制山径路面（凸显正在路上前行）
  void _drawTrailRibbon(Canvas canvas, Size size, double offset, double trailY) {
    // 道路带状路面（宽度约 26px）
    final roadPath = Path();
    roadPath.moveTo(0, trailY - 5);
    roadPath.cubicTo(
      size.width * 0.35,
      trailY - 2,
      size.width * 0.70,
      trailY - 8,
      size.width,
      trailY - 4,
    );
    roadPath.lineTo(size.width, trailY + 22);
    roadPath.cubicTo(
      size.width * 0.70,
      trailY + 18,
      size.width * 0.35,
      trailY + 24,
      0,
      trailY + 21,
    );
    roadPath.close();

    // 步道路面颜色（比草地稍深/偏泥土或山石质感）
    final roadColor = stage.isNight
        ? const Color(0xFF1E293B).withValues(alpha: 0.85)
        : (stage == ExpeditionStage.dusk
            ? const Color(0xFF4A2B20).withValues(alpha: 0.78)
            : const Color(0xFF384D35).withValues(alpha: 0.68));
    final roadPaint = Paint()..color = roadColor;
    canvas.drawPath(roadPath, roadPaint);

    // 道路上沿亮色高光线
    final trailLinePaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.30)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.2;

    final trailPath = Path();
    trailPath.moveTo(0, trailY - 5);
    trailPath.cubicTo(
      size.width * 0.35,
      trailY - 2,
      size.width * 0.70,
      trailY - 8,
      size.width,
      trailY - 4,
    );
    canvas.drawPath(trailPath, trailLinePaint);

    // 道路路面虚线/碎石步道纹理（随步速滚动）
    final stonePaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.24)
      ..strokeCap = StrokeCap.round;

    for (double sx = -cycleWidth; sx < size.width + cycleWidth; sx += 46) {
      final x = sx - offset;
      if (x < -20 || x > size.width + 20) continue;

      final t = (x / size.width).clamp(0.0, 1.0);
      final y = trailY + sin(t * pi) * 2;

      // 短脚印/步道石虚线
      stonePaint.strokeWidth = 2.4;
      canvas.drawLine(Offset(x, y + 6), Offset(x + 10, y + 6.2), stonePaint);

      // 小石子圆点
      stonePaint.strokeWidth = 1.6;
      canvas.drawCircle(Offset(x + 24, y + 12), 1.2, stonePaint);
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

  // ── 6. 底部平滑过渡淡出 ("下面是底色灰色的渐变，渐变再多点") ────────────
  void _drawBottomFadeGradient(Canvas canvas, Size size) {
    // 从山路下方大跨度平滑渐变淡出到应用主背景灰色 #F3F4F8
    final fadeRect = Rect.fromLTWH(0, size.height * 0.70, size.width, size.height * 0.30);
    final fadePaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        stops: const [0.0, 0.35, 0.70, 1.0],
        colors: [
          const Color(0xFFF3F4F8).withValues(alpha: 0.0),
          const Color(0xFFF3F4F8).withValues(alpha: 0.35),
          const Color(0xFFF3F4F8).withValues(alpha: 0.85),
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
