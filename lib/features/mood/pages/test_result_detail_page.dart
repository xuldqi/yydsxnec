import 'package:flutter/material.dart';
import '../theme/app_theme.dart';


import '../models/mental_assessment.dart';
import '../models/therapy_recommendation.dart';
import '../services/database_service.dart';
import '../services/daily_reminder_service.dart';
import '../services/therapy_recommendation_service.dart';
import 'breathing_exercise_page.dart';
import 'mental_support_page.dart';

class TestResultDetailPage extends StatefulWidget {
  final Map<String, dynamic> record;

  const TestResultDetailPage({super.key, required this.record});

  @override
  State<TestResultDetailPage> createState() => _TestResultDetailPageState();
}

class _TestResultDetailPageState extends State<TestResultDetailPage> {
  static const List<String> _sbtiDimensionOrder = [
    'S1',
    'S2',
    'S3',
    'E1',
    'E2',
    'E3',
    'A1',
    'A2',
    'A3',
    'Ac1',
    'Ac2',
    'Ac3',
    'So1',
    'So2',
    'So3',
  ];

  late final AssessmentResult _result;
  _RetestReminderInfo? _retestReminder;

  @override
  void initState() {
    super.initState();
    _result = AssessmentResult.fromMap(widget.record);
    _loadRetestReminder();
  }

  Future<void> _loadRetestReminder() async {
    final raw = await DatabaseService().getData(
      _retestReminderStorageKey(_result),
    );
    if (!mounted) return;
    if (raw is Map) {
      final reminder = _RetestReminderInfo.fromMap(
        Map<String, dynamic>.from(raw),
      );
      if (reminder.scheduledAt.isAfter(DateTime.now())) {
        setState(() {
          _retestReminder = reminder;
        });
        return;
      }
      await DatabaseService().removeData(_retestReminderStorageKey(_result));
    }
    setState(() {
      _retestReminder = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isSbtiResult = _result.assessmentId.startsWith('sbti_');
    final isMbtiResult = _result.assessmentId.startsWith('mbti_');
    final isEnneagramResult = _result.assessmentId.startsWith('enneagram_');
    final isPersonalityResult =
        isSbtiResult || isMbtiResult || isEnneagramResult;
    final sbtiData = _sbtiData;
    final mbtiData = _mbtiData;
    final enneagramData = _enneagramData;
    final therapyRecommendations = isPersonalityResult
        ? const <TherapyRecommendation>[]
        : TherapyRecommendationService.recommendationsFor(_result);
    final nextStep = isPersonalityResult
        ? null
        : TherapyRecommendationService.nextStepFor(
            _result,
            recommendations: therapyRecommendations,
          );
    final dateStr =
        '${_result.createdAt.year}年${_result.createdAt.month}月${_result.createdAt.day}日 '
        '${_result.createdAt.hour.toString().padLeft(2, '0')}:${_result.createdAt.minute.toString().padLeft(2, '0')}';
    final severityColor = _severityColor(_result.severity);

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
          '评测结果',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppTheme.textPrimary,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: AppTheme.pageHorizontalPadding,
            vertical: 16,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _result.assessmentName,
                style: TextStyle(fontSize: 14, color: AppTheme.textHint),
              ),
              SizedBox(height: 4),
              Text(
                dateStr,
                style: TextStyle(fontSize: 13, color: AppTheme.textHint),
              ),
              SizedBox(height: 20),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _result.emoji,
                          style: TextStyle(fontSize: 28),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _result.resultTitle,
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w600,
                                  color: AppTheme.textPrimary,
                                  height: 1.3,
                                ),
                              ),
                              SizedBox(height: 12),
                              Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: [
                                  _resultChip(
                                    label: _result.category.label,
                                    textColor: AppTheme.primaryColor,
                                    backgroundColor: AppTheme.primaryColor
                                        .withValues(alpha: 0.1),
                                  ),
                                  _resultChip(
                                    label: _result.severity.label,
                                    textColor: severityColor,
                                    backgroundColor: severityColor.withValues(
                                      alpha: 0.12,
                                    ),
                                  ),
                                  _resultChip(
                                    label:
                                        '分数 ${_result.totalScore}/${_result.maxScore}',
                                    textColor: AppTheme.textSecondary,
                                    backgroundColor: AppTheme.surfaceColor
                                        .withValues(alpha: 0.9),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    if (_result.periodLabel != null ||
                        _result.sourceLabel != null) ...[
                      SizedBox(height: 16),
                      Text(
                        [
                          if (_result.periodLabel != null)
                            '评估区间：${_result.periodLabel}',
                          if (_result.sourceLabel != null)
                            '来源：${_result.sourceLabel}',
                        ].join('  ·  '),
                        style: TextStyle(
                          fontSize: 12,
                          color: AppTheme.textHint,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              SizedBox(height: 20),
              if (nextStep != null) ...[
                _buildPrioritySection(
                  context,
                  nextStep,
                  therapyRecommendations,
                ),
                SizedBox(height: 20),
                _buildSecondaryActionSection(
                  context,
                  primaryActionType: nextStep.type,
                ),
                SizedBox(height: 20),
              ],
              _resultSection(
                title: '你现在的状态说明',
                child: Text(
                  _result.summary,
                  style: TextStyle(
                    fontSize: 15,
                    color: AppTheme.textSecondary,
                    height: 1.6,
                  ),
                ),
              ),
              if (isSbtiResult && sbtiData != null) ...[
                SizedBox(height: 20),
                _resultSection(
                  title: '匹配概览',
                  child: _buildSbtiTopMatches(sbtiData),
                ),
                SizedBox(height: 20),
                _resultSection(
                  title: '15 维度分布',
                  child: _buildSbtiDimensionBreakdown(sbtiData),
                ),
              ],
              if (isMbtiResult && mbtiData != null) ...[
                SizedBox(height: 20),
                _resultSection(
                  title: '类型匹配',
                  child: _buildMbtiTopMatches(mbtiData),
                ),
                SizedBox(height: 20),
                _resultSection(
                  title: '四大维度分布',
                  child: _buildMbtiDimensionBreakdown(mbtiData),
                ),
              ],
              if (isEnneagramResult && enneagramData != null) ...[
                SizedBox(height: 20),
                _resultSection(
                  title: '核心性格解析',
                  child: _buildEnneagramOverview(enneagramData),
                ),
                SizedBox(height: 20),
                _resultSection(
                  title: '九型分数分布',
                  child: _buildEnneagramDimensionBreakdown(enneagramData),
                ),
              ],
              SizedBox(height: 20),
              _resultSection(
                title: isPersonalityResult ? '更适合你的做法' : '为什么建议这样开始',
                child: Text(
                  _result.guidance,
                  style: TextStyle(
                    fontSize: 15,
                    color: AppTheme.textPrimary,
                    height: 1.6,
                  ),
                ),
              ),
              if (therapyRecommendations.isNotEmpty) ...[
                SizedBox(height: 20),
                _buildTherapySection(therapyRecommendations),
              ],
              if (_result.isStandardized && _result.disclaimer != null) ...[
                SizedBox(height: 20),
                _resultSection(
                  title: '筛查说明',
                  child: Text(
                    _result.disclaimer!,
                    style: TextStyle(
                      fontSize: 14,
                      color: AppTheme.textSecondary,
                      height: 1.6,
                    ),
                  ),
                  borderColor: AppTheme.primaryColor.withValues(alpha: 0.15),
                  backgroundColor: AppTheme.primaryColor.withValues(
                    alpha: 0.06,
                  ),
                ),
              ],
              if (_result.recommendProfessionalSupport ||
                  _result.urgentSafetyReview) ...[
                SizedBox(height: 20),
                _buildSupportCard(_result),
              ],
              SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Map<String, dynamic>? get _sbtiData {
    final raw = _result.extras['sbti'];
    if (raw is Map) {
      return Map<String, dynamic>.from(raw);
    }
    return null;
  }

  Map<String, dynamic>? get _mbtiData {
    final raw = _result.extras['mbti'];
    if (raw is Map) {
      return Map<String, dynamic>.from(raw);
    }
    return null;
  }

  Map<String, dynamic>? get _enneagramData {
    final raw = _result.extras['enneagram'];
    if (raw is Map) {
      return Map<String, dynamic>.from(raw);
    }
    return null;
  }

  Widget _buildSbtiTopMatches(Map<String, dynamic> sbtiData) {
    final modeKicker = sbtiData['modeKicker']?.toString() ?? '';
    final badge = sbtiData['badge']?.toString() ?? '';
    final topMatchesRaw = sbtiData['topMatches'];
    final topMatches = topMatchesRaw is List
        ? topMatchesRaw
              .whereType<Map>()
              .map((item) => Map<String, dynamic>.from(item))
              .toList(growable: false)
        : const <Map<String, dynamic>>[];
    final flagsRaw = sbtiData['flags'];
    final flags = flagsRaw is Map
        ? Map<String, dynamic>.from(flagsRaw)
        : const <String, dynamic>{};
    final drinkTriggered = flags['drinkTriggered'] == true;
    final fallbackTriggered = flags['fallbackTriggered'] == true;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (modeKicker.isNotEmpty)
          Text(
            modeKicker,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimary,
            ),
          ),
        if (badge.isNotEmpty) ...[
          SizedBox(height: 4),
          Text(
            badge,
            style: TextStyle(fontSize: 13, color: AppTheme.textSecondary),
          ),
        ],
        if (drinkTriggered || fallbackTriggered) ...[
          SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              if (drinkTriggered)
                _resultChip(
                  label: '隐藏饮酒人格触发',
                  textColor: const Color(0xFFAF6E27),
                  backgroundColor: const Color(0xFFFBE8CF),
                ),
              if (fallbackTriggered)
                _resultChip(
                  label: '低匹配兜底触发',
                  textColor: const Color(0xFF8B5A4A),
                  backgroundColor: const Color(0xFFF4E2DB),
                ),
            ],
          ),
        ],
        if (topMatches.isNotEmpty) ...[
          SizedBox(height: 14),
          ...topMatches.asMap().entries.map((entry) {
            final index = entry.key;
            final match = entry.value;
            final code = match['code']?.toString() ?? '--';
            final cn = match['cn']?.toString() ?? '';
            final displayName = cn.isNotEmpty ? cn : code;
            final similarity = _toInt(match['similarity']);
            final exact = _toInt(match['exact']);
            final distance = _toInt(match['distance']);
            return Padding(
              padding: EdgeInsets.only(
                bottom: index == topMatches.length - 1 ? 0 : 10,
              ),
              child: Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppTheme.surfaceColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 22,
                      height: 22,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: AppTheme.primaryColor.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        '${index + 1}',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.primaryColor,
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            displayName,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.textPrimary,
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            '匹配度 $similarity% · 精准命中 $exact/15 · 总差值 $distance',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppTheme.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ],
    );
  }

  Widget _buildEnneagramOverview(Map<String, dynamic> data) {
    final primary = data['primaryType'];
    final wing = data['wingType'];
    final topTypesRaw = data['topTypes'];
    final topTypes = topTypesRaw is List
        ? topTypesRaw
              .whereType<Map>()
              .map((item) => Map<String, dynamic>.from(item))
              .toList(growable: false)
        : const <Map<String, dynamic>>[];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (primary != null && wing != null) ...[
          Text(
            '${primary['code']}w${wing['code']}（主型 ${primary['code']}号 / 偏 ${wing['code']}号）',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimary,
            ),
          ),
          SizedBox(height: 12),
        ],
        if (topTypes.isNotEmpty) ...[
          Text(
            '前三高分倾向：',
            style: TextStyle(fontSize: 14, color: AppTheme.textSecondary),
          ),
          SizedBox(height: 8),
          ...topTypes.asMap().entries.map((entry) {
            final index = entry.key;
            final match = entry.value;
            final code = match['code']?.toString() ?? '--';
            final name = match['name']?.toString() ?? '';
            final score = match['score']?.toString() ?? '0';
            return Padding(
              padding: EdgeInsets.only(
                bottom: index == topTypes.length - 1 ? 0 : 8,
              ),
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: AppTheme.surfaceColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 20,
                      height: 20,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: AppTheme.primaryColor.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        '${index + 1}',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.primaryColor,
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        '$code号 $name',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                    ),
                    Text(
                      '$score 分',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.primaryColor,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ],
    );
  }

  Widget _buildEnneagramDimensionBreakdown(Map<String, dynamic> data) {
    final scoresRaw = data['typeScores'];
    final scores = scoresRaw is Map
        ? Map<String, dynamic>.from(scoresRaw)
        : const <String, dynamic>{};

    // Sort keys 1-9
    final keys = scores.keys.toList(growable: false);
    keys.sort((a, b) => int.parse(a).compareTo(int.parse(b)));

    return Column(
      children: keys.map((typeCode) {
        final score = _toInt(scores[typeCode]);
        return Padding(
          padding: EdgeInsets.only(bottom: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '$typeCode号',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  Text(
                    '$score分',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 6),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: score / 100,
                  backgroundColor: AppTheme.primaryColor.withValues(alpha: 0.1),
                  color: AppTheme.primaryColor,
                  minHeight: 6,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildSbtiDimensionBreakdown(Map<String, dynamic> sbtiData) {
    final rawScoresRaw = sbtiData['rawScores'];
    final levelsRaw = sbtiData['levels'];
    final metaRaw = sbtiData['dimensionMeta'];
    final rawScores = rawScoresRaw is Map
        ? Map<String, dynamic>.from(rawScoresRaw)
        : const <String, dynamic>{};
    final levels = levelsRaw is Map
        ? Map<String, dynamic>.from(levelsRaw)
        : const <String, dynamic>{};
    final meta = metaRaw is Map
        ? Map<String, dynamic>.from(metaRaw)
        : const <String, dynamic>{};

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: _sbtiDimensionOrder
          .map((dimensionId) {
            final label = meta[dimensionId]?.toString() ?? dimensionId;
            final score = _toInt(rawScores[dimensionId]).clamp(0, 6);
            final level = levels[dimensionId]?.toString() ?? 'L';
            final ratio = (score / 6).clamp(0.0, 1.0);
            final levelColor = _sbtiLevelColor(level);
            return Padding(
              padding: EdgeInsets.only(bottom: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          label,
                          style: TextStyle(
                            fontSize: 13,
                            color: AppTheme.textPrimary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Text(
                        '$score/6 · $level',
                        style: TextStyle(
                          fontSize: 12,
                          color: levelColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 5),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(999),
                    child: LinearProgressIndicator(
                      value: ratio,
                      minHeight: 8,
                      backgroundColor: AppTheme.surfaceColor,
                      valueColor: AlwaysStoppedAnimation<Color>(levelColor),
                    ),
                  ),
                ],
              ),
            );
          })
          .toList(growable: false),
    );
  }

  int _toInt(dynamic value) {
    if (value is int) return value;
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }

  Color _sbtiLevelColor(String level) {
    return switch (level) {
      'H' => const Color(0xFF4F8A5D),
      'M' => const Color(0xFFC7903E),
      _ => const Color(0xFF8A8F94),
    };
  }

  Widget _buildMbtiTopMatches(Map<String, dynamic> mbtiData) {
    final typeCode = mbtiData['typeCode']?.toString() ?? '--';
    final typeName = mbtiData['typeName']?.toString() ?? '';
    final confidence = _toInt(mbtiData['confidence']);
    final topMatchesRaw = mbtiData['topMatches'];
    final topMatches = topMatchesRaw is List
        ? topMatchesRaw
              .whereType<Map>()
              .map((item) => Map<String, dynamic>.from(item))
              .toList(growable: false)
        : const <Map<String, dynamic>>[];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$typeCode${typeName.isNotEmpty ? '（$typeName）' : ''}',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppTheme.textPrimary,
          ),
        ),
        SizedBox(height: 6),
        Text(
          '当前偏好清晰度：$confidence%',
          style: TextStyle(fontSize: 13, color: AppTheme.textSecondary),
        ),
        if (topMatches.isNotEmpty) ...[
          SizedBox(height: 14),
          ...topMatches.asMap().entries.map((entry) {
            final index = entry.key;
            final match = entry.value;
            final code = match['code']?.toString() ?? '--';
            final name = match['name']?.toString() ?? '';
            final similarity = _toInt(match['similarity']);
            final exact = _toInt(match['exact']);
            return Padding(
              padding: EdgeInsets.only(
                bottom: index == topMatches.length - 1 ? 0 : 10,
              ),
              child: Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppTheme.surfaceColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 22,
                      height: 22,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: AppTheme.primaryColor.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        '${index + 1}',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.primaryColor,
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '$code${name.isNotEmpty ? '（$name）' : ''}',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.textPrimary,
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            '匹配度 $similarity% · 精准命中 $exact/4',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppTheme.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ],
    );
  }

  Widget _buildMbtiDimensionBreakdown(Map<String, dynamic> mbtiData) {
    final raw = mbtiData['dimensionBreakdown'];
    final dimensions = raw is List
        ? raw
              .whereType<Map>()
              .map((item) => Map<String, dynamic>.from(item))
              .toList(growable: false)
        : const <Map<String, dynamic>>[];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: dimensions
          .map((item) {
            final dimensionName = item['dimensionName']?.toString() ?? '--';
            final leftLetter = item['leftLetter']?.toString() ?? '';
            final rightLetter = item['rightLetter']?.toString() ?? '';
            final leftLabel = item['leftLabel']?.toString() ?? '';
            final rightLabel = item['rightLabel']?.toString() ?? '';
            final leftCount = _toInt(item['leftCount']);
            final rightCount = _toInt(item['rightCount']);
            final total = _toInt(item['total']).clamp(1, 9999);
            final ratio = (leftCount / total).clamp(0.0, 1.0);
            final selected = item['selectedLetter']?.toString() ?? '';
            final strength = _toInt(item['strength']);
            return Padding(
              padding: EdgeInsets.only(bottom: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          dimensionName,
                          style: TextStyle(
                            fontSize: 13,
                            color: AppTheme.textPrimary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Text(
                        '$selected · 倾向 $strength%',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppTheme.primaryColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 5),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(999),
                    child: LinearProgressIndicator(
                      value: ratio,
                      minHeight: 8,
                      backgroundColor: AppTheme.surfaceColor,
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        AppTheme.primaryColor,
                      ),
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    '$leftLetter-$leftLabel: $leftCount   |   $rightLetter-$rightLabel: $rightCount',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ],
              ),
            );
          })
          .toList(growable: false),
    );
  }

  Widget _buildSupportCard(AssessmentResult result) {
    final urgent = result.urgentSafetyReview;
    final color = urgent ? const Color(0xFFD96C5F) : const Color(0xFF9E7B4F);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.18)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            urgent ? '安全提醒' : '求助建议',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
          SizedBox(height: 8),
          Text(
            urgent
                ? '如果你已经担心自己的安全，或出现了伤害自己的想法，请不要一个人扛着。现在就联系可信任的人、当地急救电话、医院急诊或危机支持资源。'
                : '如果这种状态已经持续影响到睡眠、工作、学习或关系，建议尽快联系心理咨询师、精神科/身心科医生，或当地可获得的专业支持资源。',
            style: TextStyle(
              fontSize: 14,
              color: AppTheme.textPrimary,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPrioritySection(
    BuildContext context,
    HealingNextStep nextStep,
    List<TherapyRecommendation> recommendations,
  ) {
    final primaryRecommendation = recommendations.isNotEmpty
        ? recommendations.first
        : null;
    final accentColor = _result.urgentSafetyReview
        ? const Color(0xFFC64D42)
        : AppTheme.primaryColor;
    final subline = primaryRecommendation == null
        ? '先做最重要的一步'
        : '推荐方向：${primaryRecommendation.approach.label}';

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [accentColor.withValues(alpha: 0.14), Colors.white],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: accentColor.withValues(alpha: 0.18)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.85),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              '如果只先做一件事',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: accentColor,
              ),
            ),
          ),
          SizedBox(height: 14),
          Text(
            nextStep.title,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: AppTheme.textPrimary,
              height: 1.3,
            ),
          ),
          SizedBox(height: 8),
          Text(
            nextStep.description,
            style: TextStyle(
              fontSize: 14,
              color: AppTheme.textPrimary,
              height: 1.6,
            ),
          ),
          SizedBox(height: 10),
          Text(
            subline,
            style: TextStyle(
              fontSize: 12,
              color: accentColor,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 18),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => _handlePrimaryAction(context, nextStep.type),
              style: ElevatedButton.styleFrom(
                backgroundColor: accentColor,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: Text(
                nextStep.buttonLabel,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTherapySection(List<TherapyRecommendation> recommendations) {
    return _resultSection(
      title: '可参考的支持方向',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: recommendations.asMap().entries.map((entry) {
          final index = entry.key;
          final recommendation = entry.value;
          final approach = recommendation.approach;
          return Container(
            margin: EdgeInsets.only(
              bottom: index == recommendations.length - 1 ? 0 : 12,
            ),
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.surfaceColor,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryColor.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        approach.shortLabel,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.primaryColor,
                        ),
                      ),
                    ),
                    if (index == 0) ...[
                      SizedBox(width: 8),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE8F4EA),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          '优先考虑',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.primaryColor.withOpacity(0.8),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                SizedBox(height: 10),
                Text(
                  approach.label,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimary,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  recommendation.rationale,
                  style: TextStyle(
                    fontSize: 13,
                    color: AppTheme.textPrimary,
                    height: 1.6,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  approach.summary,
                  style: TextStyle(
                    fontSize: 13,
                    color: AppTheme.textSecondary,
                    height: 1.6,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  '先做什么：${approach.firstStep}',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppTheme.textSecondary,
                    height: 1.5,
                  ),
                ),
                if (recommendation.emphasizeProfessionalSupport) ...[
                  SizedBox(height: 8),
                  Text(
                    '这条方向更适合在心理咨询或医疗支持中系统推进。',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppTheme.primaryColor,
                      height: 1.5,
                    ),
                  ),
                ],
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildSecondaryActionSection(
    BuildContext context, {
    required HealingActionType primaryActionType,
  }) {
    final secondaryActions = <Widget>[];

    void addButton({
      required HealingActionType type,
      required String label,
      required VoidCallback onPressed,
    }) {
      if (type == primaryActionType) return;
      secondaryActions.add(
        Padding(
          padding: EdgeInsets.only(top: secondaryActions.isEmpty ? 0 : 12),
          child: _outlinedActionButton(label: label, onPressed: onPressed),
        ),
      );
    }

    addButton(
      type: HealingActionType.supportPlan,
      label: '开始 7 天支持计划',
      onPressed: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => SevenDaySupportPlanPage(result: _result),
          ),
        );
      },
    );

    if (_result.recommendProfessionalSupport || _result.urgentSafetyReview) {
      addButton(
        type: HealingActionType.supportPage,
        label: _result.urgentSafetyReview ? '查看安全支持' : '查看求助与支持',
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => MentalSupportPage(result: _result),
            ),
          );
        },
      );
    }

    addButton(
      type: HealingActionType.breathing,
      label: '去做呼吸练习',
      onPressed: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const BreathingExercisePage()),
        );
      },
    );

    return _resultSection(
      title: '接下来你还可以',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...secondaryActions,
          if (_result.isStandardized && _retestReminder != null) ...[
            Padding(
              padding: EdgeInsets.only(top: 12),
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppTheme.surfaceColor,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '复测提醒已设置',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      _formatRetestReminderTime(_retestReminder!.scheduledAt),
                      style: TextStyle(
                        fontSize: 13,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 12),
              child: _outlinedActionButton(
                label: '取消复测提醒',
                onPressed: () async {
                  await _cancelRetestReminder(context);
                },
              ),
            ),
          ],
          if (_result.isStandardized)
            Padding(
              padding: EdgeInsets.only(top: 12),
              child: _outlinedActionButton(
                label: _retestReminder == null ? '7 天后提醒我复测' : '重新设置复测提醒',
                onPressed: () async {
                  await _scheduleRetestReminder(context);
                },
              ),
            ),
        ],
      ),
    );
  }

  void _handlePrimaryAction(BuildContext context, HealingActionType type) {
    switch (type) {
      case HealingActionType.supportPage:
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => MentalSupportPage(result: _result)),
        );
        return;
      case HealingActionType.breathing:
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const BreathingExercisePage()),
        );
        return;
      case HealingActionType.supportPlan:
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => SevenDaySupportPlanPage(result: _result),
          ),
        );
    }
  }

  Widget _outlinedActionButton({
    required String label,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: AppTheme.primaryColor,
          side: BorderSide(color: AppTheme.primaryColor),
          padding: EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        child: Text(label),
      ),
    );
  }

  Future<void> _scheduleRetestReminder(BuildContext context) async {
    await DailyReminderService.init();
    final granted = await DailyReminderService.checkAndRequestPermissions();
    if (!granted) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('需要通知权限才能设置复测提醒')));
      }
      return;
    }

    final now = DateTime.now();
    final scheduledAt = DateTime(now.year, now.month, now.day + 7, 20);
    final notificationId =
        200000 + (_result.createdAt.millisecondsSinceEpoch % 1000000);

    await DailyReminderService.scheduleRetestReminder(
      notificationId: notificationId,
      scheduledAt: scheduledAt,
      payload: 'retest_${_result.assessmentId}',
    );
    final reminder = _RetestReminderInfo(
      key: _retestReminderStorageKey(_result),
      assessmentId: _result.assessmentId,
      assessmentName: _result.assessmentName,
      scheduledAt: scheduledAt,
      notificationId: notificationId,
    );
    await DatabaseService().saveData(reminder.key, reminder.toMap());
    if (mounted) {
      setState(() {
        _retestReminder = reminder;
      });
    }

    if (context.mounted) {
      final dateText =
          '${scheduledAt.month}月${scheduledAt.day}日 ${scheduledAt.hour.toString().padLeft(2, '0')}:${scheduledAt.minute.toString().padLeft(2, '0')}';
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('已设置复测提醒：$dateText')));
    }
  }

  Future<void> _cancelRetestReminder(BuildContext context) async {
    final reminder = _retestReminder;
    if (reminder == null) return;
    await DailyReminderService.cancelNotification(reminder.notificationId);
    await DatabaseService().removeData(reminder.key);
    if (!mounted) return;
    setState(() {
      _retestReminder = null;
    });
    if (context.mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('已取消复测提醒')));
    }
  }

  String _formatRetestReminderTime(DateTime time) {
    return '${time.month}月${time.day}日 '
        '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  Widget _resultSection({
    required String title,
    required Widget child,
    Color? backgroundColor,
    Color? borderColor,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppTheme.textPrimary,
          ),
        ),
        SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: backgroundColor ?? Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: borderColor != null ? Border.all(color: borderColor) : null,
          ),
          child: child,
        ),
      ],
    );
  }

  Widget _resultChip({
    required String label,
    required Color textColor,
    required Color backgroundColor,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: textColor,
        ),
      ),
    );
  }

  Color _severityColor(AssessmentSeverity severity) {
    switch (severity) {
      case AssessmentSeverity.low:
        return AppTheme.primaryColor;
      case AssessmentSeverity.mild:
        return const Color(0xFF8A9D5A);
      case AssessmentSeverity.moderate:
        return const Color(0xFFC7903E);
      case AssessmentSeverity.elevated:
        return const Color(0xFFD96C5F);
      case AssessmentSeverity.high:
      case AssessmentSeverity.urgent:
        return const Color(0xFFC64D42);
    }
  }
}

class _RetestReminderInfo {
  final String key;
  final String assessmentId;
  final String assessmentName;
  final DateTime scheduledAt;
  final int notificationId;

  const _RetestReminderInfo({
    required this.key,
    required this.assessmentId,
    required this.assessmentName,
    required this.scheduledAt,
    required this.notificationId,
  });

  Map<String, dynamic> toMap() {
    return {
      'key': key,
      'assessmentId': assessmentId,
      'assessmentName': assessmentName,
      'scheduledAt': scheduledAt.toIso8601String(),
      'notificationId': notificationId,
    };
  }

  factory _RetestReminderInfo.fromMap(Map<String, dynamic> map) {
    return _RetestReminderInfo(
      key: map['key']?.toString() ?? '',
      assessmentId: map['assessmentId']?.toString() ?? '',
      assessmentName: map['assessmentName']?.toString() ?? '',
      scheduledAt:
          DateTime.tryParse(map['scheduledAt']?.toString() ?? '') ??
          DateTime.now(),
      notificationId:
          int.tryParse(map['notificationId']?.toString() ?? '') ?? 0,
    );
  }
}

String _retestReminderStorageKey(AssessmentResult result) {
  return 'retest_reminder_${result.assessmentId}_${result.createdAt.millisecondsSinceEpoch}';
}
