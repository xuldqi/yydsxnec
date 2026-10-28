import 'dart:io';
import '../models/emotion_record.dart';
import '../theme/app_theme.dart';

import 'package:flutter/material.dart';

import '../emoon_entry.dart' show MoodOptionUtils, EmotionRecord;
import '../services/database_service.dart';
import '../widgets/media_picker.dart';

class EditRecordPage extends StatefulWidget {
  final EmotionRecord record;

  const EditRecordPage({super.key, required this.record});

  @override
  State<EditRecordPage> createState() => _EditRecordPageState();
}

class _EditRecordPageState extends State<EditRecordPage> {
  late String _selectedMood;
  final List<String> _additionalMoods = [];
  late String _selectedTrigger;
  late int _bodyEnergy;
  late int _bodySleep;
  late int _bodyAppetite;
  late TextEditingController _noteController;
  late double _intensity;
  late List<String> _imagePaths;
  String? _audioPath;
  final DatabaseService _dbService = DatabaseService();
  List<Map<String, dynamic>> _moods = [];

  static const List<String> _triggerTags = ['工作', '家庭', '睡眠', '天气', '人际', '其他'];

  bool _isMoodSelected(String label) {
    return _selectedMood == label || _additionalMoods.contains(label);
  }

  List<String> get _selectedMoodLabels {
    return [if (_selectedMood.isNotEmpty) _selectedMood, ..._additionalMoods];
  }

  Map<String, dynamic>? _findMood(String label) {
    for (final mood in _moods) {
      if (mood['label'] == label) return mood;
    }
    return null;
  }

  String _emojiForMood(String label) {
    final mood = _findMood(label);
    final emoji = mood?['emoji'];
    return emoji is String && emoji.isNotEmpty ? emoji : '😐';
  }

  void _toggleMoodSelection(String label) {
    final isPrimary = _selectedMood == label;
    final isAdditional = _additionalMoods.contains(label);

    setState(() {
      if (isPrimary) {
        if (_additionalMoods.isNotEmpty) {
          _selectedMood = _additionalMoods.removeAt(0);
        } else {
          _selectedMood = '';
        }
      } else if (isAdditional) {
        _additionalMoods.remove(label);
      } else if (_selectedMood.isEmpty) {
        _selectedMood = label;
      } else {
        _additionalMoods.add(label);
      }
    });
  }

  static const List<Map<String, dynamic>> _defaultMoods = [
    {
      'emoji': '😊',
      'label': '开心',
      'color': Color(0xFFFFD93D),
      'icon': Icons.sentiment_satisfied,
    },
    {
      'emoji': '🥰',
      'label': '幸福',
      'color': Color(0xFFF48FB1),
      'icon': Icons.favorite,
    },
    {
      'emoji': '😢',
      'label': '难过',
      'color': Color(0xFF6B8CCE),
      'icon': Icons.sentiment_dissatisfied,
    },
    {
      'emoji': '😠',
      'label': '生气',
      'color': Color(0xFFE57373),
      'icon': Icons.sentiment_very_dissatisfied,
    },
    {
      'emoji': '😰',
      'label': '焦虑',
      'color': Color(0xFFFFB74D),
      'icon': Icons.sentiment_neutral,
    },
    {
      'emoji': '😴',
      'label': '疲惫',
      'color': Color(0xFF90A4AE),
      'icon': Icons.hotel,
    },
  ];

  @override
  void initState() {
    super.initState();
    _selectedMood = widget.record.mood;
    _additionalMoods
      ..clear()
      ..addAll(widget.record.additionalMoods);
    _selectedTrigger = widget.record.triggerTag;
    _bodyEnergy = widget.record.bodyEnergy;
    _bodySleep = widget.record.bodySleep;
    _bodyAppetite = widget.record.bodyAppetite;
    _noteController = TextEditingController(text: widget.record.note);
    _intensity = widget.record.intensity;
    _imagePaths = List<String>.from(widget.record.imagePaths);
    _audioPath = widget.record.audioPath;
    _moods = List<Map<String, dynamic>>.from(_defaultMoods);
    _loadMoods();
  }

  Future<void> _loadMoods() async {
    final custom = await _dbService.getCustomEmotions();
    final records = await _dbService.getEmotionRecords();
    final parsedRecords = records.map((r) {
      try {
        return EmotionRecord.fromMap(r);
      } catch (_) {
        return null;
      }
    }).whereType<EmotionRecord>();
    if (mounted) {
      setState(() {
        _moods = MoodOptionUtils.merge(
          customLabels: custom,
          records: parsedRecords,
          currentRecord: widget.record,
        );
      });
    }
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  Widget _buildBodyStateRowEdit(
    String label,
    int value,
    ValueChanged<int> onChanged,
  ) {
    const options = [(0, '未选'), (1, '差'), (2, '一般'), (3, '好')];
    return Row(
      children: [
        SizedBox(
          width: 48,
          child: Text(
            label,
            style: TextStyle(fontSize: 14, color: AppTheme.textSecondary),
          ),
        ),
        const SizedBox(width: 12),
        ...options.map((e) {
          final (v, text) = e;
          final isSelected = value == v;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () => onChanged(v),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppTheme.primaryColor.withValues(alpha: 0.15)
                      : AppTheme.surfaceColor,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isSelected
                        ? AppTheme.primaryColor
                        : Colors.transparent,
                    width: 1.5,
                  ),
                ),
                child: Text(
                  text,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: isSelected
                        ? FontWeight.w600
                        : FontWeight.normal,
                    color: isSelected
                        ? AppTheme.primaryColor
                        : AppTheme.textSecondary,
                  ),
                ),
              ),
            ),
          );
        }),
      ],
    );
  }

  Future<void> _updateRecord() async {
    if (_selectedMood.isEmpty) return;

    final mood = _moods.firstWhere((m) => m['label'] == _selectedMood);
    final additionalMoodEntries = _additionalMoods
        .map(_findMood)
        .whereType<Map<String, dynamic>>()
        .toList();
    final updatedRecord = EmotionRecord(
      id: widget.record.id,
      mood: mood['label'],
      emoji: mood['emoji'],
      additionalMoods: List<String>.from(_additionalMoods),
      additionalEmojis: additionalMoodEntries
          .map((entry) => (entry['emoji'] as String?) ?? '😐')
          .toList(),
      note: _noteController.text,
      intensity: _intensity,
      createdAt: widget.record.createdAt,
      imagePaths: _imagePaths,
      audioPath: _audioPath,
      isTimeCapsule: widget.record.isTimeCapsule,
      unlockAt: widget.record.unlockAt,
      triggerTag: _selectedTrigger,
      bodyEnergy: _bodyEnergy,
      bodySleep: _bodySleep,
      bodyAppetite: _bodyAppetite,
      aiDetectedMood: widget.record.aiDetectedMood,
      aiDetectedEmoji: widget.record.aiDetectedEmoji,
      aiConfidence: widget.record.aiConfidence,
      aiSource: widget.record.aiSource,
    );

    await _dbService.updateEmotionRecord(updatedRecord.toMap());

    if (mounted) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('记录已更新'),
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 1),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppTheme.backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.close, color: AppTheme.textPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          '编辑记录',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppTheme.textPrimary,
          ),
        ),
        actions: [
          TextButton(
            onPressed: _updateRecord,
            child: const Text(
              '保存',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppTheme.primaryColor,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(
          AppTheme.pageHorizontalPadding,
          24,
          AppTheme.pageHorizontalPadding,
          24,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '选择情绪',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              _selectedMoodLabels.isEmpty
                  ? '可选择多种情绪，第一个会作为主情绪。'
                  : '已选 ${_selectedMoodLabels.length} 种情绪，第一个会作为主情绪保存。',
              style: const TextStyle(
                fontSize: 13,
                color: AppTheme.textSecondary,
              ),
            ),
            if (_selectedMoodLabels.isNotEmpty) ...[
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _selectedMoodLabels.map((label) {
                  final isPrimary = label == _selectedMood;
                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: isPrimary
                          ? AppTheme.primaryColor.withValues(alpha: 0.12)
                          : AppTheme.surfaceColor,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      '${_emojiForMood(label)} $label${isPrimary ? ' · 主情绪' : ''}',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: isPrimary
                            ? FontWeight.w600
                            : FontWeight.w500,
                        color: isPrimary
                            ? AppTheme.primaryColor
                            : AppTheme.textSecondary,
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 22),
            ],
            SizedBox(
              height: 88,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    for (var index = 0; index < _moods.length; index++)
                      Padding(
                        padding: EdgeInsets.only(
                          right: index == _moods.length - 1 ? 0 : 12,
                        ),
                        child: SizedBox(
                          width: 118,
                          child: _buildMoodSelectionCard(_moods[index]),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),
            const Text(
              '情绪强度',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        '轻微',
                        style: TextStyle(color: AppTheme.textHint),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '${_intensity.round()}%',
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            color: AppTheme.primaryColor,
                          ),
                        ),
                      ),
                      const Text(
                        '强烈',
                        style: TextStyle(color: AppTheme.textHint),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Slider(
                    value: _intensity,
                    min: 0,
                    max: 100,
                    activeColor: AppTheme.primaryColor,
                    inactiveColor: AppTheme.surfaceColor,
                    onChanged: (value) {
                      setState(() {
                        _intensity = value;
                      });
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            const Text(
              '可能原因（可选）',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppTheme.textSecondary,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _triggerTags.map((tag) {
                final isSelected = _selectedTrigger == tag;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedTrigger = isSelected ? '' : tag;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppTheme.primaryColor.withValues(alpha: 0.15)
                          : AppTheme.surfaceColor,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isSelected
                            ? AppTheme.primaryColor
                            : Colors.transparent,
                        width: 1.5,
                      ),
                    ),
                    child: Text(
                      tag,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: isSelected
                            ? FontWeight.w600
                            : FontWeight.normal,
                        color: isSelected
                            ? AppTheme.primaryColor
                            : AppTheme.textSecondary,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            const Text(
              '身体状态（可选）',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppTheme.textSecondary,
              ),
            ),
            const SizedBox(height: 8),
            _buildBodyStateRowEdit(
              '精力',
              _bodyEnergy,
              (v) => setState(() => _bodyEnergy = v),
            ),
            const SizedBox(height: 8),
            _buildBodyStateRowEdit(
              '睡眠',
              _bodySleep,
              (v) => setState(() => _bodySleep = v),
            ),
            const SizedBox(height: 8),
            _buildBodyStateRowEdit(
              '食欲',
              _bodyAppetite,
              (v) => setState(() => _bodyAppetite = v),
            ),
            const SizedBox(height: 32),
            const Text(
              '记录内容',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: TextField(
                controller: _noteController,
                maxLines: 5,
                style: const TextStyle(fontSize: 15),
                decoration: InputDecoration(
                  hintText: '写下此刻的想法...',
                  hintStyle: TextStyle(
                    color: AppTheme.textHint.withValues(alpha: 0.6),
                    height: 1.5,
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.all(20),
                ),
              ),
            ),
            const SizedBox(height: 32),
            const Text(
              '图片与语音',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            MediaPicker(
              imagePaths: _imagePaths,
              audioPath: _audioPath,
              onImageAdded: (path) {
                setState(() {
                  _imagePaths = [..._imagePaths, path];
                });
              },
              onImageRemoved: (path) {
                setState(() {
                  _imagePaths = _imagePaths.where((p) => p != path).toList();
                });
              },
              onAudioChanged: (path) {
                setState(() {
                  _audioPath = path;
                });
              },
              onImageTap: (path) => _showImageViewer(path),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _updateRecord,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Text(
                  '保存修改',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  void _showImageViewer(String path) {
    final paths = List<String>.from(_imagePaths);
    final initialIndex = paths.indexOf(path);
    if (initialIndex < 0) return;
    showDialog<void>(
      context: context,
      barrierColor: Colors.black87,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.zero,
        child: Stack(
          children: [
            PageView.builder(
              controller: PageController(initialPage: initialIndex),
              itemCount: paths.length,
              itemBuilder: (context, index) {
                return InteractiveViewer(
                  minScale: 0.5,
                  maxScale: 4,
                  child: Center(
                    child: Image.file(File(paths[index]), fit: BoxFit.contain),
                  ),
                );
              },
            ),
            Positioned(
              top: MediaQuery.of(context).padding.top + 8,
              right: 16,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.white, size: 28),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMoodSelectionCard(Map<String, dynamic> mood) {
    final label = mood['label'] as String;
    final isSelected = _isMoodSelected(label);
    final isPrimary = _selectedMood == label;
    final color = mood['color'] as Color? ?? AppTheme.primaryColor;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      child: Material(
        color: isSelected ? color.withValues(alpha: 0.2) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        elevation: isSelected ? 4 : 0,
        shadowColor: color.withValues(alpha: 0.3),
        child: InkWell(
          onTap: () => _toggleMoodSelection(label),
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 14),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  mood['emoji'] as String? ?? '😐',
                  style: const TextStyle(fontSize: 24),
                ),
                const SizedBox(width: 6),
                Flexible(
                  child: Text(
                    label,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.normal,
                      color: isSelected
                          ? AppTheme.textPrimary
                          : AppTheme.textSecondary,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (isPrimary) ...[
                  const SizedBox(width: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: const Text(
                      '主',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.primaryColor,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
