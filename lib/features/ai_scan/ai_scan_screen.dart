// AI 健康扫描 (对应 Android ai_health_scan + bg_scan_box)
// 摄像头取景框 + 模拟扫描

import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimens.dart';
import '../../l10n/app_localizations.dart';
import '../../l10n/app_l10n_ext.dart';

class AiHealthScanScreen extends StatefulWidget {
  const AiHealthScanScreen({super.key});
  @override
  State<AiHealthScanScreen> createState() => _AiHealthScanScreenState();
}

class _AiHealthScanScreenState extends State<AiHealthScanScreen> {
  bool _scanning = false;
  String? _result;
  Timer? _timer;
  double _progress = 0;

  void _startScan() {
    setState(() {
      _scanning = true;
      _result = null;
      _progress = 0;
    });
    HapticFeedback.lightImpact();
    _timer = Timer.periodic(const Duration(milliseconds: 30), (t) {
      if (!mounted) {
        t.cancel();
        return;
      }
      setState(() {
        _progress += 0.012;
        if (_progress >= 1) {
          _progress = 1;
          t.cancel();
          _scanning = false;
          _result = _genResult();
        }
      });
    });
  }

  String _genResult() {
    final r = Random();
    return '${r.nextInt(4) + 1}项指标';
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppL10n.of(context).s;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(l.aiHealthScan, style: const TextStyle(color: Colors.white)),
      ),
      body: Stack(
        children: [
          // 模拟取景
          Center(
            child: Container(
              width: 280, height: 280,
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.primary, width: 3),
                borderRadius: BorderRadius.circular(20),
                color: Colors.white.withValues(alpha: 0.05),
              ),
              child: Stack(
                children: [
                  if (_scanning) Positioned(
                    top: _progress * 280 - 2,
                    left: 0, right: 0,
                    child: Container(
                      height: 3,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [AppColors.primary.withValues(alpha: 0), AppColors.primary, AppColors.primary.withValues(alpha: 0)],
                        ),
                      ),
                    ),
                  ),
                  // 4 角
                  ..._buildCornersList(),
                ],
              ),
            ),
          ),
          // 底部信息
          Positioned(
            left: 0, right: 0, bottom: 80,
            child: Column(
              children: [
                if (_scanning) Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      Text(l.scanning,
                        style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
                      const SizedBox(height: 8),
                      LinearProgressIndicator(
                        value: _progress,
                        backgroundColor: Colors.white.withValues(alpha: 0.2),
                        valueColor: const AlwaysStoppedAnimation(AppColors.primary),
                        minHeight: 4,
                      ),
                    ],
                  ),
                )
                else if (_result != null) _ResultPanel(onClose: () => setState(() => _result = null))
                else Column(
                  children: [
                    const Text('将面部/身体置于取景框内',
                      style: TextStyle(color: Colors.white70, fontSize: 14)),
                    const SizedBox(height: 4),
                    const Text('保持光线充足',
                      style: TextStyle(color: Colors.white54, fontSize: 12)),
                  ],
                ),
              ],
            ),
          ),
          // 底部按钮
          Positioned(
            left: 0, right: 0, bottom: 16,
            child: Center(
              child: Column(
                children: [
                  GestureDetector(
                    onTap: _scanning ? null : _startScan,
                    child: Container(
                      width: 80, height: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 4),
                        color: _scanning ? AppColors.textHint : Colors.transparent,
                      ),
                      child: Center(
                        child: Container(
                          width: 60, height: 60,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _scanning ? Colors.white54 : Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(_scanning ? l.scanning : l.tapToScan,
                    style: const TextStyle(color: Colors.white70, fontSize: 12)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildCornersList() {
    return [
      Positioned(top: 0, left: 0, child: _corner(0, 0, 0)),
      Positioned(top: 0, right: 0, child: _corner(1, 0, 90)),
      Positioned(bottom: 0, left: 0, child: _corner(0, 1, 270)),
      Positioned(bottom: 0, right: 0, child: _corner(1, 1, 180)),
    ];
  }

  Widget _corner(int right, int bottom, double rotation) {
    return Transform.rotate(
      angle: rotation * pi / 180,
      child: Container(
        width: 30, height: 30,
        decoration: BoxDecoration(
          border: Border(
            top: const BorderSide(color: AppColors.primary, width: 4),
            left: const BorderSide(color: AppColors.primary, width: 4),
            right: right == 1 ? const BorderSide(color: AppColors.primary, width: 4) : BorderSide.none,
            bottom: bottom == 1 ? const BorderSide(color: AppColors.primary, width: 4) : BorderSide.none,
          ),
        ),
      ),
    );
  }
}

class _ResultPanel extends StatelessWidget {
  final VoidCallback onClose;
  const _ResultPanel({required this.onClose});
  @override
  Widget build(BuildContext context) {
    final l = AppL10n.of(context).s;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(AppDimens.spacingMd),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimens.radiusCard),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(Icons.face_rounded, color: AppColors.primary, size: 32),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(l.scanComplete, style: const TextStyle(color: AppColors.textPrimary, fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 2),
                    Text('${l.heartRate}: 72 bpm  |  ${l.spo2}: 98%  |  ${l.stressLevel}: 中',
                      style: const TextStyle(color: AppColors.textHint, fontSize: 12)),
                  ],
                ),
              ),
              IconButton(icon: const Icon(Icons.close_rounded, color: AppColors.textHint), onPressed: onClose),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity, height: 40,
            child: ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
              child: const Text('查看完整报告'),
            ),
          ),
        ],
      ),
    );
  }
}

class FoodRecognitionScreen extends StatefulWidget {
  const FoodRecognitionScreen({super.key});
  @override
  State<FoodRecognitionScreen> createState() => _FoodRecognitionScreenState();
}

class _FoodRecognitionScreenState extends State<FoodRecognitionScreen> {
  bool _scanning = false;
  final _recognized = <_FoodItem>[];

  void _scan() {
    setState(() {
      _scanning = true;
      _recognized.clear();
    });
    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      setState(() {
        _scanning = false;
        _recognized.addAll([
          _FoodItem(name: '红烧肉', cal: 380, conf: 0.92),
          _FoodItem(name: '白米饭', cal: 116, conf: 0.96),
          _FoodItem(name: '青菜', cal: 32, conf: 0.88),
        ]);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final l = AppL10n.of(context).s;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(l.foodRecognition),
        backgroundColor: AppColors.surface,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppDimens.spacingMd),
        children: [
          // 拍照框
          GestureDetector(
            onTap: _scan,
            child: AspectRatio(
              aspectRatio: 4 / 3,
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(AppDimens.radiusCard),
                ),
                child: _scanning
                  ? const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(),
                          SizedBox(height: 12),
                          Text('识别中...', style: TextStyle(color: AppColors.textHint, fontSize: 13)),
                        ],
                      ),
                    )
                  : _recognized.isEmpty
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.camera_alt_rounded, size: 64, color: AppColors.textHint),
                          SizedBox(height: 12),
                          Text('点击拍照识别食物', style: TextStyle(color: AppColors.textHint, fontSize: 14)),
                        ],
                      )
                    : Stack(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(AppDimens.radiusCard),
                              gradient: LinearGradient(
                                begin: Alignment.topLeft, end: Alignment.bottomRight,
                                colors: [AppColors.sportOther, AppColors.warning],
                              ),
                            ),
                          ),
                          // 模拟识别的食物框
                          ..._recognized.asMap().entries.map((e) => Positioned(
                            top: 30.0 + e.key * 100,
                            left: 30,
                            right: 30,
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.white, width: 2),
                              ),
                              child: Text('${e.value.name} (${(e.value.conf * 100).toInt()}%)',
                                style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                            ),
                          )),
                        ],
                      ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          if (_recognized.isNotEmpty) ...[
            Text(l.recognized, style: const TextStyle(color: AppColors.textPrimary, fontSize: 17, fontWeight: FontWeight.w700)),
            const SizedBox(height: 10),
            ..._recognized.map((f) => Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(AppDimens.spacingSm),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Container(
                    width: 40, height: 40,
                    decoration: BoxDecoration(
                      color: AppColors.sportOther.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.restaurant_rounded, color: AppColors.sportOther, size: 22),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(f.name, style: const TextStyle(color: AppColors.textPrimary, fontSize: 14, fontWeight: FontWeight.w600)),
                        Text('置信度: ${(f.conf * 100).toInt()}%',
                          style: const TextStyle(color: AppColors.textHint, fontSize: 12)),
                      ],
                    ),
                  ),
                  Text('${f.cal} kcal',
                    style: const TextStyle(color: AppColors.warning, fontSize: 14, fontWeight: FontWeight.bold)),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('已加入今日饮食记录')));
                      context.pop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      minimumSize: const Size(0, 28),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                    child: const Text('加入', style: TextStyle(fontSize: 11)),
                  ),
                ],
              ),
            )),
          ],
          const SizedBox(height: 80),
        ],
      ),
    );
  }
}

class _FoodItem {
  final String name;
  final int cal;
  final double conf;
  _FoodItem({required this.name, required this.cal, required this.conf});
}
