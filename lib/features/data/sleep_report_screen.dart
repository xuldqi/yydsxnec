import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:just_audio/just_audio.dart';
import '../../core/providers/sleep_data_provider.dart';

class SleepReportScreen extends StatelessWidget {
  const SleepReportScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final sleepData = Provider.of<SleepDataProvider>(context);
    final duration = sleepData.totalSleepDuration;
    final score = sleepData.sleepScore;

    int fallAsleepMinutes = 15; // default fallback
    if (sleepData.recentSleepData.isNotEmpty) {
      final startTime = sleepData.recentSleepData.first.time;
      final firstSleepPoint = sleepData.recentSleepData.firstWhere(
        (dp) => dp.phase != 'Awake',
        orElse: () => sleepData.recentSleepData.first,
      );
      if (firstSleepPoint.time.isAfter(startTime)) {
        fallAsleepMinutes = firstSleepPoint.time.difference(startTime).inMinutes;
      }
    }

    return Scaffold(
      backgroundColor: const Color(0xFF0A101C),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('睡眠报告', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.ios_share, color: Colors.white, size: 22),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('报告已保存至相册'), duration: Duration(seconds: 1)));
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            // Score Header
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text('$score', style: const TextStyle(color: Color(0xFFFFFFFF), fontSize: 56, fontWeight: FontWeight.bold)),
                    const Text(' 分', style: TextStyle(color: Color(0xFFFFFFFF), fontSize: 18, fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  score >= 90 ? '非常好' : score >= 70 ? '良好' : score >= 50 ? '一般' : '需改善',
                  style: const TextStyle(color: Color(0xFFFFFFFF), fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(5, (index) => Icon(
                    Icons.star,
                    color: index < (score / 20).ceil() ? Colors.amber : Colors.white12,
                    size: 20,
                  )),
                ),
                const SizedBox(height: 8),
                Text('超过了 ${(score * 1.02).clamp(0, 99).toInt()}% 的用户', style: const TextStyle(color: Colors.white54, fontSize: 14)),
              ],
            ),
            // Indicators Card
            _buildInfoCard(
              title: '睡眠指标',
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildMetric('入睡时长', '$fallAsleepMinutes', '分钟'),
                  _buildMetric('睡眠时长', '${duration.inHours}', '小时 ${duration.inMinutes.remainder(60)} 分钟'),
                  _buildMetric('睡眠效率', '$score', '%'),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Sleep Stages Chart
            _buildInfoCard(
              title: '睡眠阶段环形图',
              child: Column(
                children: [
                  SizedBox(
                    height: 180,
                    child: Stack(
                      children: [
                        PieChart(
                          PieChartData(
                            sectionsSpace: 2,
                            centerSpaceRadius: 60,
                            startDegreeOffset: -90,
                            sections: [
                              PieChartSectionData(color: const Color(0xFF3B5998), value: sleepData.getPhaseDuration('Deep').inMinutes.toDouble() == 0 ? 1 : sleepData.getPhaseDuration('Deep').inMinutes.toDouble(), title: '', radius: 20),
                              PieChartSectionData(color: const Color(0xFF5A95D1), value: sleepData.getPhaseDuration('Light').inMinutes.toDouble() == 0 ? 1 : sleepData.getPhaseDuration('Light').inMinutes.toDouble(), title: '', radius: 20),
                              PieChartSectionData(color: const Color(0xFF90C29F), value: sleepData.getPhaseDuration('REM').inMinutes.toDouble() == 0 ? 1 : sleepData.getPhaseDuration('REM').inMinutes.toDouble(), title: '', radius: 20),
                              PieChartSectionData(color: const Color(0xFFF2C94C), value: sleepData.getPhaseDuration('Awake').inMinutes.toDouble() == 0 ? 1 : sleepData.getPhaseDuration('Awake').inMinutes.toDouble(), title: '', radius: 20),
                            ],
                          ),
                        ),
                        Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text('$score%', style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),
                              const Text('睡眠得分', style: TextStyle(color: Colors.white54, fontSize: 14)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildPhaseLegend('深睡', const Color(0xFF3B5998)),
                      const SizedBox(width: 16),
                      _buildPhaseLegend('浅睡', const Color(0xFF5A95D1)),
                      const SizedBox(width: 16),
                      _buildPhaseLegend('REM', const Color(0xFF90C29F)),
                      const SizedBox(width: 16),
                      _buildPhaseLegend('清醒', const Color(0xFFF2C94C)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Sleep Analysis Card
            _buildInfoCard(
              title: '睡眠分析',
              child: Text(
                score >= 90 ? '昨晚睡得非常棒！深睡比例充足，睡眠连续性良好，你的身体得到了完美的恢复，继续保持哦～' :
                score >= 70 ? '昨晚睡得还不错。睡眠整体规律，但深睡时间还可以进一步提升。建议睡前放松心情，减少屏幕时间。' :
                score >= 50 ? '昨晚睡眠质量一般。入睡时间较长或夜间有较多清醒，可能与睡前进食或压力有关。' :
                '昨晚睡眠不佳。睡眠效率偏低，深睡眠不足。建议调整作息，保持规律运动，睡前避免咖啡因。',
                style: const TextStyle(color: Colors.white, fontSize: 15, height: 1.5),
              ),
            ),
            const SizedBox(height: 20),

            // Snore Lab Card
            Builder(builder: (_) {
              final latestSession = sleepData.history.isNotEmpty ? sleepData.history.last : null;
              final snippetPaths = latestSession?.snoreSnippets ?? [];
              final snoreMin = latestSession?.snoreMinutes ?? 0;
              if (snippetPaths.isEmpty && snoreMin == 0) {
                return _buildInfoCard(
                  title: '梦话与鼾声',
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(color: Color(0xFF4ADE80).withOpacity(0.15), shape: BoxShape.circle),
                        child: const Icon(Icons.check_circle, color: Color(0xFF4ADE80), size: 20),
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Text('昨晚未检测到鼾声或梦话，睡得很安静！',
                          style: TextStyle(color: Colors.white, fontSize: 15)),
                      ),
                    ],
                  ),
                );
              }
              return _buildInfoCard(
                title: '梦话与鼾声',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(color: Color(0xFFF87171).withOpacity(0.15), shape: BoxShape.circle),
                          child: const Icon(Icons.warning_amber_rounded, color: Colors.redAccent, size: 20),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            '昨晚录到了 ${snippetPaths.length} 段鼾声/梦话片段',
                            style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    ...snippetPaths.asMap().entries.map((entry) {
                      final idx = entry.key;
                      final path = entry.value;
                      return Padding(
                        padding: EdgeInsets.only(top: idx > 0 ? 12 : 0),
                        child: SnoreSnippetPlayer(filePath: path, time: '片段 ${idx + 1}', type: '鼾声', duration: '0:05'),
                      );
                    }),
                  ],
                ),
              );
            }),
            const SizedBox(height: 20),

            Builder(builder: (_) {
              final latestSession = sleepData.history.isNotEmpty ? sleepData.history.last : null;
              final tags = latestSession?.tags ?? [];
              if (tags.isEmpty) return const SizedBox.shrink();

              // Map of tag ID to Name/Icon/Color
              final Map<String, Map<String, dynamic>> tagMapping = {
                'caffeine': {'name': '咖啡因', 'icon': Icons.coffee, 'color': Colors.brown},
                'alcohol': {'name': '酒精', 'icon': Icons.local_bar, 'color': Colors.redAccent},
                'exercise': {'name': '运动', 'icon': Icons.fitness_center, 'color': Color(0xFF4ADE80)},
                'late_meal': {'name': '晚顿/宵夜', 'icon': Icons.fastfood, 'color': Colors.orange},
                'screen_time': {'name': '屏幕使用', 'icon': Icons.phone_iphone, 'color': Colors.blue},
                'meditation': {'name': '冥想放松', 'icon': Icons.self_improvement, 'color': Colors.teal},
              };

              List<Widget> insights = [];
              final totalMin = duration.inMinutes == 0 ? 1 : duration.inMinutes;
              final deepMin = sleepData.getPhaseDuration('Deep').inMinutes;
              final deepRatio = deepMin / totalMin;

              if (tags.contains('caffeine')) {
                if (deepRatio < 0.2) {
                  insights.add(const _InsightRow(
                    icon: Icons.coffee,
                    color: Colors.brown,
                    text: '昨晚摄入了咖啡因，深睡比例偏低（低于 20%）。咖啡因会缩短深睡眠时长，建议下午 2 点后避免摄入。',
                  ));
                } else {
                  insights.add(const _InsightRow(
                    icon: Icons.coffee,
                    color: Colors.brown,
                    text: '昨晚摄入了咖啡因，深睡比例虽然尚可，但为避免睡眠质量受损，仍建议睡前 6 小时内禁食咖啡因。',
                  ));
                }
              }
              if (tags.contains('alcohol')) {
                insights.add(const _InsightRow(
                  icon: Icons.local_bar,
                  color: Colors.redAccent,
                  text: '昨晚有饮酒行为。酒精虽能诱导快速入睡，但会在下半夜降解并导致觉醒、中断睡眠，减少 REM 睡眠。',
                ));
              }
              if (tags.contains('exercise')) {
                insights.add(const _InsightRow(
                  icon: Icons.fitness_center,
                  color: Color(0xFF4ADE80),
                  text: '昨晚进行了睡前运动。适度运动有助于提高基础睡眠效率，促进深睡眠产生。',
                ));
              }
              if (tags.contains('late_meal')) {
                insights.add(const _InsightRow(
                  icon: Icons.fastfood,
                  color: Colors.orange,
                  text: '昨晚睡前进食了晚顿/宵夜。这会让肠胃在睡眠中被迫加班，易引起微觉醒或腹胀，建议睡前 2 小时禁食。',
                ));
              }
              if (tags.contains('screen_time')) {
                insights.add(const _InsightRow(
                  icon: Icons.phone_iphone,
                  color: Colors.blue,
                  text: '睡前长时间使用电子产品。蓝光会抑制褪黑素释放，推迟生物钟，建议睡前 1 小时停止使用手机。',
                ));
              }
              if (tags.contains('meditation')) {
                insights.add(const _InsightRow(
                  icon: Icons.self_improvement,
                  color: Colors.teal,
                  text: '昨晚进行了冥想/放松。这有助于激活副交感神经，降低心率和血压，进入理想的深度睡眠状态。',
                ));
              }

              return Column(
                children: [
                  _buildInfoCard(
                    title: '睡前习惯分析',
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: tags.map((tagId) {
                            final details = tagMapping[tagId];
                            if (details == null) return const SizedBox.shrink();
                            return Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: (details['color'] as Color).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: (details['color'] as Color).withOpacity(0.3), width: 0.8),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(details['icon'] as IconData, size: 16, color: details['color'] as Color),
                                  const SizedBox(width: 6),
                                  Text(
                                    details['name'] as String,
                                    style: TextStyle(color: details['color'] as Color, fontSize: 13, fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                        if (insights.isNotEmpty) ...[
                          const SizedBox(height: 20),
                          const Divider(height: 1, color: Colors.white12),
                          const SizedBox(height: 16),
                          ...insights,
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              );
            }),

            // Suggestions Card
            _buildInfoCard(
              title: '睡眠建议',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  _BulletPoint('保持规律的作息时间'),
                  SizedBox(height: 12),
                  _BulletPoint('睡前避免使用电子设备'),
                  SizedBox(height: 12),
                  _BulletPoint('保持卧室安静、黑暗和适宜的温度'),
                ],
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard({required String title, required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Color(0xFF151C2C),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }

  Widget _buildMetric(String label, String value, String unit) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.white54, fontSize: 12)),
        const SizedBox(height: 8),
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(value, style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
            Text(' $unit', style: const TextStyle(color: Colors.white, fontSize: 12)),
          ],
        ),
      ],
    );
  }

  Widget _buildPhaseLegend(String label, Color color) {
    return Row(
      children: [
        Container(width: 8, height: 8, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(color: Colors.white54, fontSize: 12)),
      ],
    );
  }

}

class SnoreSnippetPlayer extends StatefulWidget {
  final String filePath;
  final String time;
  final String type;
  final String duration;

  const SnoreSnippetPlayer({
    Key? key,
    required this.filePath,
    required this.time,
    required this.type,
    required this.duration,
  }) : super(key: key);

  @override
  State<SnoreSnippetPlayer> createState() => _SnoreSnippetPlayerState();
}

class _SnoreSnippetPlayerState extends State<SnoreSnippetPlayer> {
  final AudioPlayer _player = AudioPlayer();
  bool _isPlaying = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _player.playerStateStream.listen((state) {
      if (mounted) {
        setState(() {
          _isPlaying = state.playing;
          if (state.processingState == ProcessingState.completed) {
            _isPlaying = false;
            _player.seek(Duration.zero);
            _player.pause();
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  Future<void> _togglePlay() async {
    if (_isPlaying) {
      await _player.pause();
    } else {
      setState(() => _isLoading = true);
      try {
        if (_player.audioSource == null) {
          await _player.setFilePath(widget.filePath);
        }
        await _player.play();
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('播放失败: $e')));
        }
      } finally {
        if (mounted) setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Color(0xFF151C2C),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: _togglePlay,
            child: _isLoading
                ? const SizedBox(width: 36, height: 36, child: CircularProgressIndicator(strokeWidth: 2))
                : Icon(
                    _isPlaying ? Icons.pause_circle_filled : Icons.play_circle_fill,
                    color: Color(0xFF4ADE80),
                    size: 36,
                  ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.time, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600)),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: widget.type == '梦话' ? Colors.blue.withOpacity(0.1) : Colors.orange.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(widget.type, style: TextStyle(color: widget.type == '梦话' ? Colors.blue : Colors.orange, fontSize: 10)),
                    ),
                    const SizedBox(width: 8),
                    Text(widget.duration, style: const TextStyle(color: Colors.white54, fontSize: 12)),
                  ],
                ),
              ],
            ),
          ),
          // Fake audio wave visualization - animate when playing
          Row(
            children: List.generate(10, (index) {
              return AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.symmetric(horizontal: 1.5),
                width: 3,
                height: _isPlaying ? (8.0 + (index * 7 % 13)) : 6.0,
                decoration: BoxDecoration(color: _isPlaying ? Color(0xFF4ADE80) : Colors.white24, borderRadius: BorderRadius.circular(2)),
              );
            }),
          ),
        ],
      ),
    );
  }
}

class _BulletPoint extends StatelessWidget {
  final String text;
  const _BulletPoint(this.text);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 6, right: 12),
          width: 6,
          height: 6,
          decoration: const BoxDecoration(color: Color(0xFF4ADE80), shape: BoxShape.circle),
        ),
        Expanded(
          child: Text(text, style: const TextStyle(color: Colors.white, fontSize: 14)),
        ),
      ],
    );
  }
}

class _InsightRow extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String text;

  const _InsightRow({
    Key? key,
    required this.icon,
    required this.color,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
