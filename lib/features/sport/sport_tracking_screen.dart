import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import '../../core/theme/app_colors.dart';
import 'sport_tracking_provider.dart';

class SportTrackingScreen extends ConsumerWidget {
  final String sportType;

  const SportTrackingScreen({super.key, required this.sportType});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(sportTrackingProvider);
    final notifier = ref.read(sportTrackingProvider.notifier);

    return WillPopScope(
      onWillPop: () async {
        if (state.isTracking) return false;
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.black, // 纯黑底色
        body: Stack(
          children: [
            // 1. 盲绘轨迹画布
            Positioned.fill(
              child: CustomPaint(
                painter: BlindRoutePainter(
                  path: state.path,
                ),
              ),
            ),
            
            // 2. 顶部玻璃拟物数据仪表盘
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: ClipRect(
                child: BackdropFilter(
                  filter: ui.ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Container(
                    padding: const EdgeInsets.only(top: 60, bottom: 20, left: 20, right: 20),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.4),
                      border: Border(bottom: BorderSide(color: Colors.white.withValues(alpha: 0.1))),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          state.distanceKm.toStringAsFixed(2),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 72,
                            fontWeight: FontWeight.w800,
                            fontFamily: 'Roboto',
                          ),
                        ),
                        const Text(
                          '公里',
                          style: TextStyle(color: Colors.white70, fontSize: 16),
                        ),
                        const SizedBox(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _DashboardItem(label: '配速', value: state.paceFormatted),
                            _DashboardItem(label: '用时', value: state.durationFormatted),
                            _DashboardItem(label: '大卡', value: state.calories.toStringAsFixed(0)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // 3. 底部控制区
            Positioned(
              bottom: 40,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (!state.isTracking && state.duration == Duration.zero)
                    _ControlButton(
                      icon: Icons.play_arrow_rounded,
                      color: AppColors.primary,
                      onTap: () => notifier.startTracking(),
                      label: '开始',
                    )
                  else ...[
                    if (state.isPaused)
                      _ControlButton(
                        icon: Icons.play_arrow_rounded,
                        color: AppColors.primary,
                        onTap: () => notifier.resumeTracking(),
                        label: '继续',
                      )
                    else
                      _ControlButton(
                        icon: Icons.pause_rounded,
                        color: Colors.orange,
                        onTap: () => notifier.pauseTracking(),
                        label: '暂停',
                      ),
                    const SizedBox(width: 32),
                    _ControlButton(
                      icon: Icons.stop_rounded,
                      color: Colors.redAccent,
                      onTap: () async {
                        await notifier.finishAndSave(sportType);
                        if (context.mounted) Navigator.of(context).pop();
                      },
                      label: '结束',
                    ),
                  ]
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DashboardItem extends StatelessWidget {
  final String label;
  final String value;
  const _DashboardItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(color: Colors.white54, fontSize: 14),
        ),
      ],
    );
  }
}

class _ControlButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  final String label;

  const _ControlButton({
    required this.icon,
    required this.color,
    required this.onTap,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color.withValues(alpha: 0.2),
              border: Border.all(color: color, width: 2),
              boxShadow: [
                BoxShadow(
                  color: color.withValues(alpha: 0.4),
                  blurRadius: 20,
                  spreadRadius: 2,
                )
              ],
            ),
            child: Icon(icon, color: color, size: 40),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          label,
          style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}

/// 核心：将真实的经纬度转化为画布上的轨迹并绘制渐变发光线条
class BlindRoutePainter extends CustomPainter {
  final List<Position> path;

  BlindRoutePainter({required this.path});

  @override
  void paint(Canvas canvas, Size size) {
    if (path.length < 2) return;

    // 1. 找出经纬度的边界框 (Bounding Box)
    double minLat = path[0].latitude;
    double maxLat = path[0].latitude;
    double minLng = path[0].longitude;
    double maxLng = path[0].longitude;

    for (var p in path) {
      if (p.latitude < minLat) minLat = p.latitude;
      if (p.latitude > maxLat) maxLat = p.latitude;
      if (p.longitude < minLng) minLng = p.longitude;
      if (p.longitude > maxLng) maxLng = p.longitude;
    }

    // 2. 计算缩放比例 (将轨迹铺满画布但留有 padding)
    const padding = 60.0;
    final drawWidth = size.width - padding * 2;
    final drawHeight = size.height - padding * 2;

    // 防止边界重合除以0
    final latDiff = (maxLat - minLat) == 0 ? 0.0001 : (maxLat - minLat);
    final lngDiff = (maxLng - minLng) == 0 ? 0.0001 : (maxLng - minLng);

    // 计算 X 和 Y 轴的缩放比例，取较小的值以保持轨迹不变形
    final scaleX = drawWidth / lngDiff;
    final scaleY = drawHeight / latDiff;
    final scale = scaleX < scaleY ? scaleX : scaleY;

    // 计算整体偏移量居中
    final offsetX = (size.width - (lngDiff * scale)) / 2;
    final offsetY = (size.height - (latDiff * scale)) / 2;

    // 3. 构建 Path
    final uiPath = Path();
    for (int i = 0; i < path.length; i++) {
      final p = path[i];
      // 经度对应 X, 纬度对应 Y (地图的 Y 轴是上正下负，屏幕是上负下正，需要翻转)
      final x = offsetX + (p.longitude - minLng) * scale;
      final y = size.height - (offsetY + (p.latitude - minLat) * scale); // 翻转 Y

      if (i == 0) {
        uiPath.moveTo(x, y);
      } else {
        uiPath.lineTo(x, y);
      }
    }

    // 4. 定义发光渐变画笔
    final gradient = ui.Gradient.linear(
      const Offset(0, 0),
      Offset(size.width, size.height),
      [const Color(0xFF6BFFD7), AppColors.primary],
    );

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6.0
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..shader = gradient
      ..maskFilter = const MaskFilter.blur(BlurStyle.solid, 4.0); // 发光效果

    // 5. 绘制轨迹
    canvas.drawPath(uiPath, paint);

    // 绘制起点和终点圆点
    final startP = path.first;
    final endP = path.last;
    final startX = offsetX + (startP.longitude - minLng) * scale;
    final startY = size.height - (offsetY + (startP.latitude - minLat) * scale);
    final endX = offsetX + (endP.longitude - minLng) * scale;
    final endY = size.height - (offsetY + (endP.latitude - minLat) * scale);

    final dotPaint = Paint()..color = Colors.white..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(startX, startY), 6.0, dotPaint);
    canvas.drawCircle(Offset(endX, endY), 6.0, dotPaint..color = AppColors.primary);
  }

  @override
  bool shouldRepaint(covariant BlindRoutePainter oldDelegate) {
    return oldDelegate.path != path || oldDelegate.path.length != path.length;
  }
}
