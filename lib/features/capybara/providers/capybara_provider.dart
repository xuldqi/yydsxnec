import 'dart:math';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/capybara_state.dart';
import '../../../core/services/step_provider.dart' as step_svc;
import '../../../core/services/daily_health_provider.dart';
import '../../fasting/providers/fasting_provider.dart';

const _kHeartsKey = 'capybara_hearts_v2';
const _kAccessoryKey = 'capybara_accessory_v2';
const _kSceneKey = 'capybara_scene_v2';
const _kUnlockedAccessoriesKey = 'capybara_unlocked_accessories_v2';
const _kUnlockedScenesKey = 'capybara_unlocked_scenes_v2';
const _kCompanionshipDaysKey = 'capybara_companionship_days_v2';

final capybaraProvider = StateNotifierProvider<CapybaraNotifier, CapybaraState>((ref) {
  return CapybaraNotifier(ref);
});

class CapybaraNotifier extends StateNotifier<CapybaraState> {
  final Ref _ref;

  static const List<String> _petQuotes = [
    '呼噜呼噜... 好舒服呀~ (满意眯眼)',
    '摸摸头，今天也要心平气和、健康自律哦~',
    '水豚最喜欢你了！继续保持好状态！',
    '咕噜噜，有你的陪伴，今天又是治愈的一天。',
    '大大的拥抱！记得按时喝水多走动哦~',
    '心如止水，波澜不惊... 诶，被你摸笑了！',
  ];

  CapybaraNotifier(this._ref) : super(const CapybaraState()) {
    _loadFromPrefs();
  }

  Future<void> _loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final hearts = prefs.getInt(_kHeartsKey) ?? 150;
    final currentAccessoryId = prefs.getString(_kAccessoryKey) ?? 'orange';
    final currentSceneId = prefs.getString(_kSceneKey) ?? 'onsen';
    final unlockedAccList = prefs.getStringList(_kUnlockedAccessoriesKey) ?? ['none', 'orange'];
    final unlockedScenesList = prefs.getStringList(_kUnlockedScenesKey) ?? ['onsen'];
    final days = prefs.getInt(_kCompanionshipDaysKey) ?? 7;

    state = state.copyWith(
      hearts: hearts,
      currentAccessoryId: currentAccessoryId,
      currentSceneId: currentSceneId,
      unlockedAccessories: unlockedAccList.toSet(),
      unlockedScenes: unlockedScenesList.toSet(),
      companionshipDays: days,
    );

    // Initial mood update based on health providers
    updateMoodFromHealth();
  }

  /// 根据今日健康指标实时更新水豚状态
  void updateMoodFromHealth() {
    final fastingActive = _ref.read(activeFastingSessionProvider) != null;
    final healthAsync = _ref.read(dailyHealthProvider);
    final waterMl = healthAsync.valueOrNull?.waterMl ?? 1250;
    final stepsAsync = _ref.read(step_svc.stepProvider);
    final steps = stepsAsync.valueOrNull?.todaySteps ?? 6820;

    CapybaraMood targetMood;
    String quote;

    if (fastingActive) {
      targetMood = CapybaraMood.orange;
      quote = '轻断食专注进行中，心如止水，橘子稳稳顶在头上~';
    } else if (waterMl >= 1000) {
      targetMood = CapybaraMood.onsen;
      quote = '今日饮水达标，暖暖的温水温泉最滋养身体啦~';
    } else if (steps >= 6000) {
      targetMood = CapybaraMood.energetic;
      quote = '步数突破 6,000 步！活力满满，为你点赞！';
    } else {
      targetMood = CapybaraMood.sleepy;
      quote = '有点小犯困... 喝杯水、散散步帮我充充能吧~';
    }

    state = state.copyWith(
      mood: targetMood,
      activeDialogue: quote,
    );
  }

  /// 抚摸水豚互动
  void pet() {
    HapticFeedback.lightImpact();
    final randomQuote = _petQuotes[Random().nextInt(_petQuotes.length)];
    final newHearts = state.hearts + 2;

    state = state.copyWith(
      hearts: newHearts,
      activeDialogue: randomQuote,
    );
    _saveInt(_kHeartsKey, newHearts);
  }

  /// 完成健康任务奖励爱心
  void rewardHealthTask(String taskTitle, int rewardHearts) {
    HapticFeedback.mediumImpact();
    final newHearts = state.hearts + rewardHearts;
    final quote = '太棒了！完成了「$taskTitle」，奖励你 $rewardHearts 颗爱心！';

    state = state.copyWith(
      hearts: newHearts,
      activeDialogue: quote,
    );
    _saveInt(_kHeartsKey, newHearts);
  }

  /// 解锁配件
  bool unlockAccessory(String id, int cost) {
    if (state.hearts < cost) return false;
    final newHearts = state.hearts - cost;
    final newSet = Set<String>.from(state.unlockedAccessories)..add(id);

    state = state.copyWith(
      hearts: newHearts,
      unlockedAccessories: newSet,
      currentAccessoryId: id,
      activeDialogue: '哇！新配件太可爱了，谢谢你为我换上！',
    );

    _saveInt(_kHeartsKey, newHearts);
    _saveStringList(_kUnlockedAccessoriesKey, newSet.toList());
    _saveString(_kAccessoryKey, id);
    return true;
  }

  /// 穿戴配件
  void equipAccessory(String id) {
    state = state.copyWith(
      currentAccessoryId: id,
      activeDialogue: '换上新造型啦，你看好看吗~',
    );
    _saveString(_kAccessoryKey, id);
  }

  /// 解锁场景
  bool unlockScene(String id, int cost) {
    if (state.hearts < cost) return false;
    final newHearts = state.hearts - cost;
    final newSet = Set<String>.from(state.unlockedScenes)..add(id);

    state = state.copyWith(
      hearts: newHearts,
      unlockedScenes: newSet,
      currentSceneId: id,
      activeDialogue: '新场景好舒服！在这里生活太惬意了~',
    );

    _saveInt(_kHeartsKey, newHearts);
    _saveStringList(_kUnlockedScenesKey, newSet.toList());
    _saveString(_kSceneKey, id);
    return true;
  }

  /// 切换场景
  void equipScene(String id) {
    state = state.copyWith(
      currentSceneId: id,
      activeDialogue: '换到新场景啦，一起来深呼吸放松一下吧~',
    );
    _saveString(_kSceneKey, id);
  }

  Future<void> _saveInt(String key, int val) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(key, val);
  }

  Future<void> _saveString(String key, String val) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, val);
  }

  Future<void> _saveStringList(String key, List<String> val) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(key, val);
  }
}
