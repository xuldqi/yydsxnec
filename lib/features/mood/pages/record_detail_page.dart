import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'package:just_audio/just_audio.dart';

import '../models/emotion_record.dart';
import 'edit_record_page.dart';
import '../services/database_service.dart';
import '../services/ohos_native_service.dart';
import '../utils/audio_playback_helper.dart';

class RecordDetailPage extends StatefulWidget {
  final EmotionRecord record;

  /// 删除记录后回调（如切回「记录」页）
  final VoidCallback? onDeleted;

  const RecordDetailPage({super.key, required this.record, this.onDeleted});

  @override
  State<RecordDetailPage> createState() => _RecordDetailPageState();
}

class _RecordDetailPageState extends State<RecordDetailPage> {
  late EmotionRecord _record;
  final DatabaseService _dbService = DatabaseService();
  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    _record = widget.record;
    _loadRecord();
  }

  @override
  void dispose() {
    unawaited(OhosNativeService.stopAudioFile());
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _playAudio() async {
    if (_record.audioPath == null) return;
    final file = File(_record.audioPath!);
    if (!file.existsSync()) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('录音文件不存在，无法播放')));
      }
      return;
    }
    final playablePath = await getPlayablePath(file.absolute.path);
    if (playablePath == null) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('无法准备播放')));
      }
      return;
    }
    try {
      if (OhosNativeService.isOhos) {
        final ok = await OhosNativeService.playAudioFile(file.absolute.path);
        if (!ok && mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('播放失败，请重新录制后再试'),
              duration: Duration(seconds: 3),
            ),
          );
        }
        return;
      }
      await _audioPlayer.stop();
      final fileUri = Uri.file(playablePath).toString();
      try {
        await _audioPlayer.setAudioSource(AudioSource.uri(Uri.parse(fileUri)));
      } catch (_) {
        await _audioPlayer.setUrl(fileUri);
      }
      await _audioPlayer.seek(Duration.zero);
      await _audioPlayer.play();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('播放失败: $e'),
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  void _showImageViewer(int initialIndex) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => _DetailImageViewerPage(
          imagePaths: _record.imagePaths,
          initialIndex: initialIndex,
        ),
      ),
    );
  }

  Future<void> _loadRecord() async {
    final records = await _dbService.getEmotionRecords();
    final updated = records.firstWhere(
      (r) => r['id'] == _record.id,
      orElse: () => _record.toMap(),
    );
    if (mounted) {
      setState(() {
        _record = EmotionRecord.fromMap(updated);
      });
    }
  }

  Widget _buildBodyStateChip(String label, String value) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        '$label：$value',
        style: TextStyle(fontSize: 14, color: AppTheme.textSecondary),
      ),
    );
  }

  bool get _hasCycleData {
    return _record.menstrualStatus.isNotEmpty ||
        _record.cycleSymptoms.isNotEmpty ||
        _record.cycleFunctionImpact.isNotEmpty;
  }

  Widget _buildCycleChip(String text, {bool primary = false}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: primary
            ? AppTheme.primaryColor.withValues(alpha: 0.1)
            : AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 13,
          fontWeight: primary ? FontWeight.w600 : FontWeight.w500,
          color: primary ? AppTheme.primaryColor : AppTheme.textSecondary,
        ),
      ),
    );
  }

  String _formatFullDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final dateToCheck = DateTime(date.year, date.month, date.day);

    if (dateToCheck == today) {
      return '今天 ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    } else if (dateToCheck == today.subtract(const Duration(days: 1))) {
      return '昨天 ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    } else {
      return '${date.year}年${date.month}月${date.day}日 ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    }
  }

  Future<void> _deleteRecord() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('删除记录'),
        content: Text('确定要删除这条记录吗？删除后无法恢复。'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text('取消'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: Text('删除'),
          ),
        ],
      ),
    );
    if (confirm != true || !mounted) return;
    await _dbService.deleteEmotionRecord(_record.id);
    if (!mounted) return;
    widget.onDeleted?.call();
    Navigator.of(context).pop();
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('已删除')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppTheme.backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: AppTheme.textPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          '记录详情',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppTheme.textPrimary,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.edit_outlined, color: AppTheme.primaryColor),
            onPressed: () async {
              await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => EditRecordPage(record: _record),
                ),
              );
              _loadRecord();
            },
          ),
          IconButton(
            icon: Icon(Icons.delete_outline, color: Colors.red.shade400),
            onPressed: _deleteRecord,
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                AppTheme.pageHorizontalPadding,
                24,
                AppTheme.pageHorizontalPadding,
                24,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (_record.isTimeCapsule && _record.unlockAt != null) ...[
                    Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: AppTheme.primaryColor.withValues(alpha: 0.3),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.auto_stories,
                            color: AppTheme.primaryColor,
                            size: 24,
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              '这是你在 ${_record.createdAt.year}年${_record.createdAt.month}月${_record.createdAt.day}日 写给未来的自己，当时的心情是 ${_record.emoji} ${_record.mood}。',
                              style: TextStyle(
                                fontSize: 14,
                                color: AppTheme.textPrimary,
                                height: 1.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                  ],
                  Container(
                    padding: EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.04),
                          blurRadius: 16,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color:
                                AppTheme.primaryColor?.withValues(
                                  alpha: 0.15,
                                ) ??
                                AppTheme.surfaceColor,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Center(
                            child: Text(
                              _record.emoji,
                              style: TextStyle(fontSize: 48),
                            ),
                          ),
                        ),
                        SizedBox(width: 20),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: AppTheme.primaryColor
                                      ?.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  _record.mood,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color:
                                        AppTheme.primaryColor ??
                                        AppTheme.textSecondary,
                                  ),
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                _formatFullDate(_record.createdAt),
                                style: TextStyle(
                                  fontSize: 14,
                                  color: AppTheme.textHint,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (_record.additionalMoods.isNotEmpty) ...[
                    SizedBox(height: 16),
                    Text(
                      '附加情绪',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: List.generate(_record.additionalMoods.length, (
                        index,
                      ) {
                        final label = _record.additionalMoods[index];
                        final emoji = index < _record.additionalEmojis.length
                            ? _record.additionalEmojis[index]
                            : '😐';
                        return Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: AppTheme.surfaceColor,
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(
                            '$emoji $label',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: AppTheme.textSecondary,
                            ),
                          ),
                        );
                      }),
                    ),
                    SizedBox(height: 24),
                  ],
                  if (_record.hasAiAnalysis) ...[
                    Text(
                      'AI 识别',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    SizedBox(height: 8),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppTheme.surfaceColor,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: Text(
                              '${_record.aiDetectedEmoji ?? '😐'} ${_record.aiDetectedMood ?? '未识别'}',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: AppTheme.textPrimary,
                              ),
                            ),
                          ),
                          if (_record.aiSource != null)
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(999),
                              ),
                              child: Text(
                                _aiSourceLabel(_record.aiSource!),
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: AppTheme.textSecondary,
                                ),
                              ),
                            ),
                          if (_record.aiConfidence != null)
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(999),
                              ),
                              child: Text(
                                '置信度 ${(_record.aiConfidence! * 100).round()}%',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: AppTheme.textSecondary,
                                ),
                              ),
                            ),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: Text(
                              _record.isAiMatch ? '与你选择一致' : '与你选择不同',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: _record.isAiMatch
                                    ? AppTheme.primaryColor
                                    : AppTheme.textSecondary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 24),
                  ],
                  SizedBox(height: 24),
                  if (_record.intensity > 0) ...[
                    Text(
                      '情绪强度',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    SizedBox(height: 12),
                    Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: LinearProgressIndicator(
                              value: _record.intensity / 100,
                              backgroundColor: AppTheme.surfaceColor,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                AppTheme.primaryColor ??
                                    AppTheme.primaryColor,
                              ),
                              minHeight: 8,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          SizedBox(width: 16),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: AppTheme.primaryColor.withValues(
                                alpha: 0.1,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              '${_record.intensity.round()}%',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: AppTheme.primaryColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 24),
                  ],
                  if (_record.triggerTag.isNotEmpty) ...[
                    Text(
                      '可能原因',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    SizedBox(height: 8),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        _record.triggerTag,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: AppTheme.primaryColor,
                        ),
                      ),
                    ),
                    SizedBox(height: 24),
                  ],
                  if (_record.bodyEnergy > 0 ||
                      _record.bodySleep > 0 ||
                      _record.bodyAppetite > 0) ...[
                    Text(
                      '身体状态',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        if (_record.bodyEnergy > 0)
                          _buildBodyStateChip(
                            '精力',
                            ['', '差', '一般', '好'][_record.bodyEnergy],
                          ),
                        if (_record.bodySleep > 0)
                          _buildBodyStateChip(
                            '睡眠',
                            ['', '差', '一般', '好'][_record.bodySleep],
                          ),
                        if (_record.bodyAppetite > 0)
                          _buildBodyStateChip(
                            '食欲',
                            ['', '差', '一般', '好'][_record.bodyAppetite],
                          ),
                      ],
                    ),
                    SizedBox(height: 24),
                  ],
                  if (_hasCycleData) ...[
                    Text(
                      '周期情绪',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    SizedBox(height: 8),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          if (_record.menstrualStatus.isNotEmpty)
                            _buildCycleChip(
                              _record.menstrualStatus,
                              primary: true,
                            ),
                          ..._record.cycleSymptoms.map(_buildCycleChip),
                          if (_record.cycleFunctionImpact.isNotEmpty)
                            _buildCycleChip(_record.cycleFunctionImpact),
                        ],
                      ),
                    ),
                    SizedBox(height: 24),
                  ],
                  if (_record.note.isNotEmpty) ...[
                    Text(
                      '记录内容',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    SizedBox(height: 12),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        _record.note,
                        style: TextStyle(
                          fontSize: 15,
                          color: AppTheme.textSecondary,
                          height: 1.6,
                        ),
                      ),
                    ),
                  ] else ...[
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(40),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            Icons.note_outlined,
                            size: 48,
                            color: AppTheme.textHint.withValues(alpha: 0.5),
                          ),
                          SizedBox(height: 12),
                          Text(
                            '暂无记录内容',
                            style: TextStyle(
                              fontSize: 14,
                              color: AppTheme.textHint,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  if (_record.imagePaths.isNotEmpty) ...[
                    SizedBox(height: 24),
                    Text(
                      '图片',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    SizedBox(height: 12),
                    SizedBox(
                      height: 100,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: _record.imagePaths.length,
                        separatorBuilder: (_, __) => SizedBox(width: 12),
                        itemBuilder: (context, index) {
                          final path = _record.imagePaths[index];
                          return GestureDetector(
                            onTap: () => _showImageViewer(index),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.file(
                                File(path),
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => SizedBox(
                                  width: 100,
                                  height: 100,
                                  child: Icon(Icons.image_not_supported),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                  if (_record.audioPath != null) ...[
                    SizedBox(height: 24),
                    Text(
                      '语音',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    SizedBox(height: 12),
                    Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.mic,
                            color: AppTheme.primaryColor,
                            size: 28,
                          ),
                          SizedBox(width: 16),
                          const Expanded(
                            child: Text(
                              '已录制语音',
                              style: TextStyle(color: AppTheme.textSecondary),
                            ),
                          ),
                          IconButton.filled(
                            onPressed: _playAudio,
                            icon: Icon(Icons.play_arrow),
                            style: IconButton.styleFrom(
                              backgroundColor: AppTheme.primaryColor,
                              foregroundColor: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _aiSourceLabel(String source) {
    switch (source) {
      case 'text':
        return 'AI 文本';
      case 'voice':
        return 'AI 语音';
      case 'face':
        return 'AI 拍照';
      default:
        return 'AI 识别';
    }
  }
}

class _DetailImageViewerPage extends StatefulWidget {
  final List<String> imagePaths;
  final int initialIndex;

  const _DetailImageViewerPage({
    required this.imagePaths,
    required this.initialIndex,
  });

  @override
  State<_DetailImageViewerPage> createState() => _DetailImageViewerPageState();
}

class _DetailImageViewerPageState extends State<_DetailImageViewerPage> {
  late PageController _pageController;
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: Text(
          '${_currentIndex + 1} / ${widget.imagePaths.length}',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: PageView.builder(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        itemCount: widget.imagePaths.length,
        itemBuilder: (context, index) {
          return Center(
            child: InteractiveViewer(
              minScale: 0.5,
              maxScale: 4,
              child: Image.file(
                File(widget.imagePaths[index]),
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return Center(
                    child: Icon(
                      Icons.broken_image_outlined,
                      color: Colors.white,
                      size: 64,
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
