import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../models/relax_audio_preset.dart';
import '../services/database_service.dart';
import '../services/relax_audio_controller.dart';
import '../theme/app_theme.dart';

class WhiteNoisePage extends StatefulWidget {
  const WhiteNoisePage({super.key});

  @override
  State<WhiteNoisePage> createState() => _WhiteNoisePageState();
}

class _WhiteNoisePageState extends State<WhiteNoisePage> {
  final RelaxAudioController _audio = RelaxAudioController.instance;

  @override
  void initState() {
    super.initState();
    _audio.addListener(_handleAudioChanged);
  }

  @override
  void dispose() {
    _audio.removeListener(_handleAudioChanged);
    super.dispose();
  }

  void _handleAudioChanged() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('白噪音空间'),
        backgroundColor: AppTheme.backgroundColor,
        elevation: 0,
      ),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            AppTheme.pageHorizontalPadding,
            12,
            AppTheme.pageHorizontalPadding,
            28,
          ),
          children: [
            _NoiseHero(
              preset: _audio.selectedPreset,
              isPlaying: _audio.isPlaying,
              isPreparing: _audio.isPreparing,
              canStop: _audio.canStop,
              remainingSeconds: _audio.remainingSeconds,
              onPressed: () async {
                try {
                  await _audio.togglePlay();
                } catch (e) {
                  if (!mounted) return;
                  final msg = e.toString().contains('暂不支持')
                      ? '当前系统暂不支持白噪音播放'
                      : '声音暂时没有播放出来，请再试一次';
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text(msg)));
                }
              },
              onStop: _audio.canStop ? _audio.stop : null,
            ),
            const SizedBox(height: 18),
            _VolumePanel(
              color: _audio.selectedPreset.color,
              volume: _audio.volume,
              onChanged: _audio.setVolume,
            ),
            const SizedBox(height: 18),
            const _ToolSectionTitle('选择声音'),
            const SizedBox(height: 10),
            ...RelaxAudioPresets.all.map(
              (preset) => _NoisePresetTile(
                preset: preset,
                selected: preset.id == _audio.selectedPreset.id,
                onTap: () => _audio.selectPreset(preset),
              ),
            ),
            const SizedBox(height: 18),
            const _ToolSectionTitle('定时关闭'),
            const SizedBox(height: 10),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                _TimerChip(
                  label: '不定时',
                  selected: _audio.remainingSeconds == 0,
                  onTap: () => _audio.setSleepTimer(0),
                ),
                _TimerChip(
                  label: '10 分钟',
                  selected:
                      _audio.remainingSeconds > 0 &&
                      _audio.remainingSeconds <= 600,
                  onTap: () => _audio.setSleepTimer(10),
                ),
                _TimerChip(
                  label: '20 分钟',
                  selected:
                      _audio.remainingSeconds > 600 &&
                      _audio.remainingSeconds <= 1200,
                  onTap: () => _audio.setSleepTimer(20),
                ),
                _TimerChip(
                  label: '30 分钟',
                  selected: _audio.remainingSeconds > 1200,
                  onTap: () => _audio.setSleepTimer(30),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class GuidedRelaxPage extends StatefulWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final int durationMinutes;
  final List<RelaxGuideStep> steps;

  const GuidedRelaxPage({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.durationMinutes,
    required this.steps,
  });

  @override
  State<GuidedRelaxPage> createState() => _GuidedRelaxPageState();
}

class _GuidedRelaxPageState extends State<GuidedRelaxPage> {
  Timer? _timer;
  int _elapsedSeconds = 0;
  bool _isRunning = false;

  int get _totalSeconds => widget.durationMinutes * 60;
  double get _progress => (_elapsedSeconds / _totalSeconds).clamp(0.0, 1.0);

  int get _currentStepIndex {
    final stepSeconds = math.max(1, _totalSeconds ~/ widget.steps.length);
    return (_elapsedSeconds ~/ stepSeconds).clamp(0, widget.steps.length - 1);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _toggle() {
    if (_isRunning) {
      _timer?.cancel();
      setState(() => _isRunning = false);
      return;
    }
    setState(() => _isRunning = true);
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      if (_elapsedSeconds >= _totalSeconds) {
        timer.cancel();
        setState(() => _isRunning = false);
        return;
      }
      setState(() => _elapsedSeconds++);
    });
  }

  void _restart() {
    _timer?.cancel();
    setState(() {
      _elapsedSeconds = 0;
      _isRunning = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final current = widget.steps[_currentStepIndex];
    final remaining = _totalSeconds - _elapsedSeconds;
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: AppTheme.backgroundColor,
        elevation: 0,
      ),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            AppTheme.pageHorizontalPadding,
            12,
            AppTheme.pageHorizontalPadding,
            28,
          ),
          children: [
            Container(
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                color: widget.color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: widget.color.withValues(alpha: 0.18)),
              ),
              child: Column(
                children: [
                  SizedBox(
                    width: 188,
                    height: 188,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          width: 188,
                          height: 188,
                          child: CircularProgressIndicator(
                            value: _progress,
                            strokeWidth: 10,
                            color: widget.color,
                            backgroundColor: Colors.white.withValues(
                              alpha: 0.72,
                            ),
                            strokeCap: StrokeCap.round,
                          ),
                        ),
                        Container(
                          width: 136,
                          height: 136,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.82),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            widget.icon,
                            color: widget.color,
                            size: 46,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),
                  Text(
                    current.title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    current.description,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 14,
                      height: 1.55,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 18),
                  Text(
                    _formatDuration(remaining),
                    style: TextStyle(
                      fontSize: 15,
                      color: widget.color,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 18),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: _restart,
                          style: OutlinedButton.styleFrom(
                            foregroundColor: widget.color,
                            side: BorderSide(
                              color: widget.color.withValues(alpha: 0.42),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          child: const Text('重来'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: FilledButton.icon(
                          onPressed: _toggle,
                          icon: Icon(
                            _isRunning
                                ? Icons.pause_rounded
                                : Icons.play_arrow_rounded,
                          ),
                          label: Text(_isRunning ? '暂停' : '开始'),
                          style: FilledButton.styleFrom(
                            backgroundColor: widget.color,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const _ToolSectionTitle('引导步骤'),
            const SizedBox(height: 10),
            ...widget.steps.asMap().entries.map((entry) {
              final selected = entry.key == _currentStepIndex;
              final step = entry.value;
              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: selected
                      ? widget.color.withValues(alpha: 0.12)
                      : Colors.white.withValues(alpha: 0.78),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: selected
                        ? widget.color.withValues(alpha: 0.28)
                        : Colors.transparent,
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${entry.key + 1}',
                      style: TextStyle(
                        fontSize: 15,
                        color: selected ? widget.color : AppTheme.textHint,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            step.title,
                            style: const TextStyle(
                              fontSize: 15,
                              color: AppTheme.textPrimary,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            step.description,
                            style: const TextStyle(
                              fontSize: 13,
                              height: 1.45,
                              color: AppTheme.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}

class EmotionalReleasePage extends StatefulWidget {
  const EmotionalReleasePage({super.key});

  @override
  State<EmotionalReleasePage> createState() => _EmotionalReleasePageState();
}

class _EmotionalReleasePageState extends State<EmotionalReleasePage> {
  static const String _storageKey = 'relax_release_notes';
  static const int _maxNotes = 30;

  final DatabaseService _dbService = DatabaseService();
  final TextEditingController _controller = TextEditingController();
  List<Map<String, dynamic>> _notes = [];

  @override
  void initState() {
    super.initState();
    _loadNotes();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _loadNotes() async {
    final raw = await _dbService.getData(_storageKey);
    if (raw is! List) return;
    if (!mounted) return;
    setState(() {
      _notes = raw
          .whereType<Map>()
          .map((e) => Map<String, dynamic>.from(e))
          .toList();
    });
  }

  Future<void> _saveNote() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    final next = [
      {
        'id': DateTime.now().millisecondsSinceEpoch.toString(),
        'text': text,
        'createdAt': DateTime.now().toIso8601String(),
      },
      ..._notes,
    ];
    if (next.length > _maxNotes) next.length = _maxNotes;
    await _dbService.saveData(_storageKey, next);
    if (!mounted) return;
    setState(() {
      _notes = next;
      _controller.clear();
    });
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('这张纸条已经替你收好')));
  }

  Future<void> _deleteNote(String id) async {
    final next = _notes.where((note) => note['id']?.toString() != id).toList();
    await _dbService.saveData(_storageKey, next);
    if (!mounted) return;
    setState(() => _notes = next);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('情绪卸载纸条'),
        backgroundColor: AppTheme.backgroundColor,
        elevation: 0,
      ),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            AppTheme.pageHorizontalPadding,
            12,
            AppTheme.pageHorizontalPadding,
            28,
          ),
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFFF6E8D2),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    '把暂时放不下的事写在这里',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    '这不是正式心情记录，不参与统计。写完就先把它放在这里。',
                    style: TextStyle(
                      fontSize: 13,
                      height: 1.45,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _controller,
                    minLines: 4,
                    maxLines: 7,
                    decoration: InputDecoration(
                      hintText: '我现在想先放下……',
                      filled: true,
                      fillColor: Colors.white.withValues(alpha: 0.82),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(18),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  FilledButton(
                    onPressed: _saveNote,
                    style: FilledButton.styleFrom(
                      backgroundColor: const Color(0xFFB9824F),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: const Text('放到纸条里'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const _ToolSectionTitle('最近纸条'),
            const SizedBox(height: 10),
            if (_notes.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 28),
                child: Center(
                  child: Text(
                    '还没有卸载纸条',
                    style: TextStyle(color: AppTheme.textSecondary),
                  ),
                ),
              )
            else
              ..._notes.map((note) {
                final id = note['id']?.toString() ?? '';
                return Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.86),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          note['text']?.toString() ?? '',
                          style: const TextStyle(
                            fontSize: 14,
                            height: 1.5,
                            color: AppTheme.textPrimary,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () => _deleteNote(id),
                        icon: const Icon(Icons.close_rounded, size: 18),
                        color: AppTheme.textHint,
                        tooltip: '删除',
                      ),
                    ],
                  ),
                );
              }),
          ],
        ),
      ),
    );
  }
}

class RelaxGuideStep {
  final String title;
  final String description;

  const RelaxGuideStep(this.title, this.description);
}

class RelaxGuides {
  static const mindfulness = [
    RelaxGuideStep('坐稳一点', '让背部有支撑，肩膀自然落下，不需要刻意摆出标准姿势。'),
    RelaxGuideStep('听见周围', '把注意力放到声音上，听见就好，不评价它好不好。'),
    RelaxGuideStep('回到呼吸', '感觉空气进来、出去。如果走神，只要轻轻回来。'),
    RelaxGuideStep('看见念头', '念头出现时，在心里说一句“我注意到了”，然后放它过去。'),
    RelaxGuideStep('慢慢结束', '动动手指和肩膀，把注意力带回现在的空间。'),
  ];

  static const bodyScan = [
    RelaxGuideStep('从额头开始', '觉察额头、眼周和下颌，允许它们松一点。'),
    RelaxGuideStep('放松肩颈', '感受肩膀的重量，让脖子不用继续用力撑着。'),
    RelaxGuideStep('经过胸口', '留意胸口和腹部的起伏，不调整也可以。'),
    RelaxGuideStep('来到双手', '感觉手掌、手指和指尖，看看有没有温度或麻麻的感觉。'),
    RelaxGuideStep('落到双脚', '感受脚跟和地面的接触，让身体知道现在是安全的。'),
  ];

  static const sleep = [
    RelaxGuideStep('调暗一点', '把屏幕或灯光调暗，先让环境安静下来。'),
    RelaxGuideStep('慢慢呼气', '每一次呼气都比吸气长一点，不用数得很准。'),
    RelaxGuideStep('松开今天', '把今天还没完成的事先放到明天，不在床上继续处理。'),
    RelaxGuideStep('想象落下', '想象身体像被柔软地托住，一点点往下沉。'),
    RelaxGuideStep('不用努力睡着', '只需要休息，不需要立刻睡着。'),
  ];

  static const stretch = [
    RelaxGuideStep('转动肩膀', '肩膀向后慢慢绕 5 圈，再向前绕 5 圈。'),
    RelaxGuideStep('放松脖子', '头轻轻倒向一侧，停 10 秒，换另一侧。'),
    RelaxGuideStep('打开胸口', '双手向后或扶住椅背，胸口轻轻打开。'),
    RelaxGuideStep('照顾眼睛', '看向远处 20 秒，再闭眼 10 秒。'),
    RelaxGuideStep('收回来', '喝一口水，感受身体比刚才松了一点。'),
  ];
}

class _NoiseHero extends StatelessWidget {
  final RelaxAudioPreset preset;
  final bool isPlaying;
  final bool isPreparing;
  final bool canStop;
  final int remainingSeconds;
  final VoidCallback onPressed;
  final VoidCallback? onStop;

  const _NoiseHero({
    required this.preset,
    required this.isPlaying,
    required this.isPreparing,
    required this.canStop,
    required this.remainingSeconds,
    required this.onPressed,
    required this.onStop,
  });

  @override
  Widget build(BuildContext context) {
    final statusText = isPreparing
        ? '正在加载声音'
        : isPlaying
        ? '正在播放'
        : canStop
        ? '已暂停'
        : preset.subtitle;
    final primaryLabel = isPreparing
        ? '加载中'
        : isPlaying
        ? '暂停'
        : canStop
        ? '继续'
        : '播放';
    final primaryIcon = isPreparing
        ? Icons.sync_rounded
        : isPlaying
        ? Icons.pause_rounded
        : Icons.play_arrow_rounded;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: preset.color.withValues(alpha: 0.13),
        borderRadius: BorderRadius.circular(28),
      ),
      child: Column(
        children: [
          Container(
            width: 156,
            height: 156,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.72),
              shape: BoxShape.circle,
            ),
            child: Icon(preset.icon, size: 64, color: preset.color),
          ),
          const SizedBox(height: 20),
          Text(
            preset.title,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w900,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            remainingSeconds > 0
                ? '将在 ${_formatDuration(remainingSeconds)} 后停止'
                : statusText,
            style: TextStyle(fontSize: 14, color: AppTheme.textSecondary),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: FilledButton.icon(
                  onPressed: isPreparing ? null : onPressed,
                  icon: Icon(primaryIcon),
                  label: Text(primaryLabel),
                  style: FilledButton.styleFrom(
                    backgroundColor: preset.color,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: preset.color.withValues(
                      alpha: 0.44,
                    ),
                    disabledForegroundColor: Colors.white.withValues(
                      alpha: 0.86,
                    ),
                    minimumSize: const Size(0, 50),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                  ),
                ),
              ),
              if (canStop) ...[
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: onStop,
                    icon: const Icon(Icons.stop_rounded),
                    label: const Text('停止'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: preset.color,
                      side: BorderSide(
                        color: preset.color.withValues(alpha: 0.42),
                      ),
                      backgroundColor: Colors.white.withValues(alpha: 0.68),
                      minimumSize: const Size(0, 50),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class _NoisePresetTile extends StatelessWidget {
  final RelaxAudioPreset preset;
  final bool selected;
  final VoidCallback onTap;

  const _NoisePresetTile({
    required this.preset,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: selected
            ? preset.color.withValues(alpha: 0.13)
            : Colors.white.withValues(alpha: 0.78),
        borderRadius: BorderRadius.circular(18),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(18),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                Icon(preset.icon, color: preset.color, size: 24),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        preset.title,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        preset.subtitle,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                if (selected)
                  Icon(
                    Icons.check_circle_rounded,
                    color: preset.color,
                    size: 20,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _VolumePanel extends StatelessWidget {
  final Color color;
  final double volume;
  final ValueChanged<double> onChanged;

  const _VolumePanel({
    required this.color,
    required this.volume,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.78),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Icon(Icons.volume_down_rounded, color: color, size: 22),
          Expanded(
            child: Slider(
              value: volume,
              min: 0,
              max: 1,
              activeColor: color,
              inactiveColor: color.withValues(alpha: 0.16),
              onChanged: onChanged,
            ),
          ),
          Icon(Icons.volume_up_rounded, color: color, size: 22),
        ],
      ),
    );
  }
}

class _TimerChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _TimerChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      selected: selected,
      label: Text(label),
      onSelected: (_) => onTap(),
      selectedColor: AppTheme.primaryColor.withValues(alpha: 0.16),
      labelStyle: TextStyle(
        color: selected ? AppTheme.primaryColor : AppTheme.textSecondary,
        fontWeight: selected ? FontWeight.w800 : FontWeight.w500,
      ),
      side: BorderSide(
        color: selected
            ? AppTheme.primaryColor.withValues(alpha: 0.36)
            : AppTheme.borderColor,
      ),
    );
  }
}

class _ToolSectionTitle extends StatelessWidget {
  final String text;

  const _ToolSectionTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w900,
        color: AppTheme.textPrimary,
      ),
    );
  }
}

String _formatDuration(int seconds) {
  final minutes = seconds ~/ 60;
  final secs = seconds % 60;
  return '$minutes:${secs.toString().padLeft(2, '0')}';
}
