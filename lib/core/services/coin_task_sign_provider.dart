// 金币体系 - 所有任务/签到/钱包页共享
// + 任务模型 + 任务进度
// + 签到模型 + 连续天数

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ── 金币 Notifier ───────────────────────────────────────────────

class CoinTransaction {
  final String id, type, description;
  final int amount;
  final DateTime time;
  CoinTransaction({required this.id, required this.type, required this.description,
    required this.amount, required this.time});

  Map<String, dynamic> toJson() => {
    'id': id, 'type': type, 'desc': description,
    'amount': amount, 'time': time.toIso8601String(),
  };
  factory CoinTransaction.fromJson(Map<String, dynamic> j) => CoinTransaction(
    id: j['id'] as String, type: j['type'] as String,
    description: j['desc'] as String, amount: j['amount'] as int,
    time: DateTime.parse(j['time'] as String),
  );
}

class CoinState {
  final int balance;
  final int totalEarned;
  final int totalSpent;
  final List<CoinTransaction> transactions;
  CoinState({this.balance = 0, this.totalEarned = 0, this.totalSpent = 0, this.transactions = const []});

  CoinState copyWith({int? balance, int? totalEarned, int? totalSpent, List<CoinTransaction>? transactions}) =>
    CoinState(
      balance: balance ?? this.balance,
      totalEarned: totalEarned ?? this.totalEarned,
      totalSpent: totalSpent ?? this.totalSpent,
      transactions: transactions ?? this.transactions,
    );
}

class CoinNotifier extends Notifier<CoinState> {
  static const _kBalance = 'coin_balance';
  static const _kEarned = 'coin_earned';
  static const _kSpent = 'coin_spent';
  static const _kTx = 'coin_tx';

  @override
  CoinState build() => CoinState();

  Future<void> load() async {
    final p = await SharedPreferences.getInstance();
    final txs = (p.getStringList(_kTx) ?? []).map((s) {
      final parts = s.split('|');
      return CoinTransaction(
        id: parts[0], type: parts[1], description: parts[2],
        amount: int.parse(parts[3]), time: DateTime.parse(parts[4]),
      );
    }).toList();
    state = CoinState(
      balance: p.getInt(_kBalance) ?? 0,
      totalEarned: p.getInt(_kEarned) ?? 0,
      totalSpent: p.getInt(_kSpent) ?? 0,
      transactions: txs,
    );
  }

  Future<void> earn(int amount, String type, String description) async {
    final tx = CoinTransaction(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      type: type, description: description, amount: amount, time: DateTime.now(),
    );
    final newTxs = [tx, ...state.transactions];
    state = state.copyWith(
      balance: state.balance + amount,
      totalEarned: state.totalEarned + amount,
      transactions: newTxs,
    );
    await _save();
  }

  Future<bool> spend(int amount, String type, String description) async {
    if (state.balance < amount) return false;
    final tx = CoinTransaction(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      type: type, description: description, amount: -amount, time: DateTime.now(),
    );
    state = state.copyWith(
      balance: state.balance - amount,
      totalSpent: state.totalSpent + amount,
      transactions: [tx, ...state.transactions],
    );
    await _save();
    return true;
  }

  Future<void> _save() async {
    final p = await SharedPreferences.getInstance();
    await p.setInt(_kBalance, state.balance);
    await p.setInt(_kEarned, state.totalEarned);
    await p.setInt(_kSpent, state.totalSpent);
    final txStrs = state.transactions.take(200).map((t) =>
      '${t.id}|${t.type}|${t.description}|${t.amount}|${t.time.toIso8601String()}'
    ).toList();
    await p.setStringList(_kTx, txStrs);
  }
}

final coinProvider = NotifierProvider<CoinNotifier, CoinState>(CoinNotifier.new);

// ── 任务 Notifier ───────────────────────────────────────────────

enum TaskType { sign, step, sport, water, sleep, invite, watchAd, custom }

extension TaskTypeX on TaskType {
  String get label {
    switch (this) {
      case TaskType.sign: return '签到';
      case TaskType.step: return '步数';
      case TaskType.sport: return '运动';
      case TaskType.water: return '饮水';
      case TaskType.sleep: return '睡眠';
      case TaskType.invite: return '邀请';
      case TaskType.watchAd: return '看广告';
      case TaskType.custom: return '自定义';
    }
  }
  String get key {
    switch (this) {
      case TaskType.sign: return 'sign';
      case TaskType.step: return 'step';
      case TaskType.sport: return 'sport';
      case TaskType.water: return 'water';
      case TaskType.sleep: return 'sleep';
      case TaskType.invite: return 'invite';
      case TaskType.watchAd: return 'watchAd';
      case TaskType.custom: return 'custom';
    }
  }
  static TaskType? fromKey(String k) {
    for (final t in TaskType.values) {
      if (t.key == k) return t;
    }
    return null;
  }
}

class Task {
  final String id;
  final TaskType type;
  final String title, description;
  final int reward; // 金币
  final int targetValue; // 目标值
  final int currentValue; // 当前进度
  final String unit;
  final bool completed;
  final bool claimed;
  final DateTime? expiresAt;

  Task({required this.id, required this.type, required this.title, required this.description,
    required this.reward, required this.targetValue, required this.currentValue,
    required this.unit, this.completed = false, this.claimed = false, this.expiresAt});

  double get progress => targetValue == 0 ? 0 : (currentValue / targetValue).clamp(0.0, 1.0);

  Task copyWith({int? currentValue, bool? completed, bool? claimed}) => Task(
    id: id, type: type, title: title, description: description,
    reward: reward, targetValue: targetValue,
    currentValue: currentValue ?? this.currentValue,
    unit: unit,
    completed: completed ?? this.completed,
    claimed: claimed ?? this.claimed,
    expiresAt: expiresAt,
  );
}

class TaskState {
  final List<Task> daily;
  final List<Task> newbie;
  final List<Task> growth;
  TaskState({this.daily = const [], this.newbie = const [], this.growth = const []});
}

class TaskNotifier extends Notifier<TaskState> {
  @override
  TaskState build() {
    final now = DateTime.now();
    final end = DateTime(now.year, now.month, now.day, 23, 59, 59);
    return TaskState(
      daily: [
        Task(id: 'd_step', type: TaskType.step, title: '完成今日步数目标',
          description: '今日步数达到 8000 步', reward: 50, targetValue: 8000, currentValue: 6800, unit: '步',
          expiresAt: end),
        Task(id: 'd_sport', type: TaskType.sport, title: '完成 1 次运动',
          description: '任意运动记录 1 次', reward: 30, targetValue: 1, currentValue: 0, unit: '次',
          expiresAt: end),
        Task(id: 'd_water', type: TaskType.water, title: '完成饮水目标',
          description: '今日饮水达到 2000ml', reward: 30, targetValue: 2000, currentValue: 1500, unit: 'ml',
          expiresAt: end),
        Task(id: 'd_sleep', type: TaskType.sleep, title: '记录睡眠',
          description: '添加一次睡眠记录', reward: 20, targetValue: 1, currentValue: 0, unit: '次',
          expiresAt: end),
      ],
      newbie: [
        Task(id: 'n1', type: TaskType.sign, title: '首次签到',
          description: '完成第一次每日签到', reward: 50, targetValue: 1, currentValue: 0, unit: '次'),
        Task(id: 'n2', type: TaskType.invite, title: '邀请 1 位好友',
          description: '邀请 1 位好友注册', reward: 200, targetValue: 1, currentValue: 0, unit: '人'),
        Task(id: 'n3', type: TaskType.custom, title: '完善个人资料',
          description: '设置身高体重生日', reward: 30, targetValue: 1, currentValue: 0, unit: '次'),
      ],
      growth: [
        Task(id: 'g_step', type: TaskType.step, title: '连续 7 天达标',
          description: '连续 7 天完成步数目标', reward: 300, targetValue: 7, currentValue: 3, unit: '天'),
        Task(id: 'g_sport', type: TaskType.sport, title: '累计 10 次运动',
          description: '累计完成 10 次运动记录', reward: 200, targetValue: 10, currentValue: 4, unit: '次'),
        Task(id: 'g_watch', type: TaskType.watchAd, title: '看 3 次广告',
          description: '观看 3 次激励视频', reward: 150, targetValue: 3, currentValue: 0, unit: '次'),
      ],
    );
  }

  void updateDailyProgress(String id, int value) {
    final list = state.daily.map((t) {
      if (t.id != id) return t;
      final completed = value >= t.targetValue;
      return t.copyWith(currentValue: value, completed: completed);
    }).toList();
    state = TaskState(daily: list, newbie: state.newbie, growth: state.growth);
  }

  Future<void> claim(Task task) async {
    final list = [...state.daily, ...state.newbie, ...state.growth];
    final idx = list.indexWhere((t) => t.id == task.id);
    if (idx < 0 || !list[idx].completed || list[idx].claimed) return;
    list[idx] = list[idx].copyWith(claimed: true);
    final daily = list.where((t) => state.daily.any((d) => d.id == t.id)).toList();
    final newbie = list.where((t) => state.newbie.any((n) => n.id == t.id)).toList();
    final growth = list.where((t) => state.growth.any((g) => g.id == t.id)).toList();
    state = TaskState(daily: daily, newbie: newbie, growth: growth);
    await ref.read(coinProvider.notifier).earn(task.reward, 'task', '完成任务：${task.title}');
  }

  int get claimableCount {
    final all = [...state.daily, ...state.newbie, ...state.growth];
    return all.where((t) => t.completed && !t.claimed).length;
  }

  int get totalRewardClaimed {
    final all = [...state.daily, ...state.newbie, ...state.growth];
    return all.where((t) => t.claimed).fold(0, (s, t) => s + t.reward);
  }
}

final taskProvider = NotifierProvider<TaskNotifier, TaskState>(TaskNotifier.new);

// ── 签到 Notifier ───────────────────────────────────────────────

class SignDay {
  final int day; // 1-7
  final bool signed;
  final bool today;
  final bool future;
  final int reward;
  final bool makeup; // 是否补签
  SignDay({required this.day, required this.signed, required this.today, required this.future,
    required this.reward, this.makeup = false});
}

class SignState {
  final int consecutiveDays;
  final int totalSignedDays;
  final int makeupCards; // 补签卡数量
  final List<SignDay> week;
  final int todayReward;
  final bool todayClaimed;
  SignState({this.consecutiveDays = 0, this.totalSignedDays = 0, this.makeupCards = 0,
    this.week = const [], this.todayReward = 0, this.todayClaimed = false});
}

class SignNotifier extends Notifier<SignState> {
  static const _kCons = 'sign_consecutive';
  static const _kTotal = 'sign_total';
  static const _kMakeup = 'sign_makeup';
  static const _kLastDate = 'sign_last_date';

  @override
  SignState build() => _init();

  SignState _init() {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final rewards = [10, 20, 30, 50, 80, 100, 200]; // 周一到周日
    final week = <SignDay>[];
    for (int i = 0; i < 7; i++) {
      final d = startOfWeek.add(Duration(days: i));
      final isToday = d.day == now.day && d.month == now.month && d.year == now.year;
      final isFuture = d.isAfter(now);
      final signed = !isFuture && d.isBefore(now.add(const Duration(days: 1))) && (i < now.weekday - 1 || isToday);
      week.add(SignDay(day: i + 1, signed: signed, today: isToday, future: isFuture, reward: rewards[i]));
    }
    return SignState(
      consecutiveDays: 0,
      totalSignedDays: 0,
      makeupCards: 3,
      week: week,
      todayReward: rewards[now.weekday - 1],
      todayClaimed: false,
    );
  }

  Future<void> load() async {
    final p = await SharedPreferences.getInstance();
    state = SignState(
      consecutiveDays: p.getInt(_kCons) ?? 0,
      totalSignedDays: p.getInt(_kTotal) ?? 0,
      makeupCards: p.getInt(_kMakeup) ?? 3,
      week: state.week,
      todayReward: state.todayReward,
      todayClaimed: p.getString(_kLastDate) == _todayKey(),
    );
  }

  String _todayKey() {
    final now = DateTime.now();
    return '${now.year}-${now.month}-${now.day}';
  }

  Future<bool> signToday() async {
    if (state.todayClaimed) return false;
    final p = await SharedPreferences.getInstance();
    final newCons = state.consecutiveDays + 1;
    await p.setInt(_kCons, newCons);
    await p.setInt(_kTotal, state.totalSignedDays + 1);
    await p.setString(_kLastDate, _todayKey());
    await ref.read(coinProvider.notifier).earn(state.todayReward, 'sign', '每日签到');
    state = SignState(
      consecutiveDays: newCons,
      totalSignedDays: state.totalSignedDays + 1,
      makeupCards: state.makeupCards,
      week: state.week.asMap().entries.map((e) =>
        e.value.day == DateTime.now().weekday
          ? SignDay(day: e.value.day, signed: true, today: true, future: false,
              reward: e.value.reward, makeup: false)
          : e.value).toList(),
      todayReward: state.todayReward,
      todayClaimed: true,
    );
    return true;
  }

  Future<bool> makeup(int day) async {
    if (state.makeupCards <= 0) return false;
    if (day >= DateTime.now().weekday) return false;
    final p = await SharedPreferences.getInstance();
    final newCons = state.consecutiveDays + 1;
    await p.setInt(_kCons, newCons);
    await p.setInt(_kMakeup, state.makeupCards - 1);
    final reward = state.week[day - 1].reward;
    await ref.read(coinProvider.notifier).earn(reward, 'sign_makeup', '补签第$day天');
    state = SignState(
      consecutiveDays: newCons,
      totalSignedDays: state.totalSignedDays + 1,
      makeupCards: state.makeupCards - 1,
      week: state.week.asMap().entries.map((e) =>
        e.key == day - 1
          ? SignDay(day: e.value.day, signed: true, today: e.value.today, future: false,
              reward: e.value.reward, makeup: true)
          : e.value).toList(),
      todayReward: state.todayReward,
      todayClaimed: state.todayClaimed,
    );
    return true;
  }
}

final signProvider = NotifierProvider<SignNotifier, SignState>(SignNotifier.new);
