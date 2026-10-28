// Period Provider
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart';
import '../../core/database/app_database.dart' as db;
import '../../core/services/database_provider.dart';

@immutable
class PeriodRecord {
  final String id;
  final DateTime startDate;
  final int durationDays;
  final int cycleDays;
  final List<String> symptoms;
  final String? note;

  const PeriodRecord({
    required this.id,
    required this.startDate,
    this.durationDays = 5,
    this.cycleDays = 28,
    this.symptoms = const [],
    this.note,
  });
}

@immutable
class PeriodState {
  final List<PeriodRecord> records;
  final DateTime? lastPeriod;
  final int avgCycle;
  const PeriodState({this.records = const [], this.lastPeriod, this.avgCycle = 28});

  PeriodState copyWith({List<PeriodRecord>? records, DateTime? lastPeriod, int? avgCycle}) {
    return PeriodState(
      records: records ?? this.records,
      lastPeriod: lastPeriod ?? this.lastPeriod,
      avgCycle: avgCycle ?? this.avgCycle,
    );
  }

  /// 当前周期所处阶段
  String get currentPhase {
    if (lastPeriod == null) return '未设置';
    final days = DateTime.now().difference(lastPeriod!).inDays;
    final cycleDay = days % avgCycle;
    if (cycleDay < 5) return '月经期';
    if (cycleDay < 13) return '卵泡期';
    if (cycleDay < 16) return '排卵期';
    return '黄体期';
  }

  int get cycleDay {
    if (lastPeriod == null) return 0;
    return DateTime.now().difference(lastPeriod!).inDays % avgCycle + 1;
  }

  /// 下次月经预测
  DateTime? get nextPrediction {
    if (lastPeriod == null) return null;
    return lastPeriod!.add(Duration(days: avgCycle));
  }

  int get daysToNext {
    final n = nextPrediction;
    if (n == null) return 0;
    return n.difference(DateTime.now()).inDays;
  }
}

class PeriodNotifier extends AsyncNotifier<PeriodState> {
  @override
  Future<PeriodState> build() async {
    return _load();
  }

  Future<PeriodState> _load() async {
    final database = ref.read(databaseProvider);
    final records = await database.getPeriodRecords();
    
    if (records.isEmpty) {
      return const PeriodState();
    }
    
    final mapped = records.map((r) => PeriodRecord(
      id: r.id,
      startDate: r.startDate,
      durationDays: r.durationDays,
      cycleDays: r.cycleDays,
      symptoms: r.symptoms?.split(',').where((e) => e.isNotEmpty).toList() ?? [],
      note: r.note,
    )).toList();
    
    return PeriodState(
      records: mapped,
      lastPeriod: mapped.first.startDate,
      avgCycle: mapped.first.cycleDays,
    );
  }

  Future<void> load() async {
    state = AsyncData(await _load());
  }

  Future<void> addPeriod(DateTime start, {int durationDays = 5, List<String> symptoms = const [], String? note}) async {
    final database = ref.read(databaseProvider);
    final current = state.valueOrNull ?? const PeriodState();
    final id = DateTime.now().millisecondsSinceEpoch.toString();
    
    await database.insertPeriodRecord(db.PeriodRecordsCompanion.insert(
      id: id,
      startDate: start,
      durationDays: Value(durationDays),
      cycleDays: Value(current.avgCycle),
      symptoms: Value(symptoms.join(',')),
      note: Value(note),
    ));
    
    state = AsyncData(await _load());
  }

  Future<void> removePeriod(String id) async {
    final database = ref.read(databaseProvider);
    await database.deletePeriodRecord(id);
    state = AsyncData(await _load());
  }

  Future<void> setCycle(int days) async {
    // Ideally this updates UserSettings or we just store cycle in the latest PeriodRecord.
    // Since PeriodRecords has cycleDays, we can update the latest record's cycleDays.
    final current = state.valueOrNull ?? const PeriodState();
    if (current.records.isNotEmpty) {
      final database = ref.read(databaseProvider);
      final latest = current.records.first;
      // We need to delete and re-insert since we don't have update DAO
      await database.deletePeriodRecord(latest.id);
      await database.insertPeriodRecord(db.PeriodRecordsCompanion.insert(
        id: latest.id,
        startDate: latest.startDate,
        durationDays: Value(latest.durationDays),
        cycleDays: Value(days),
        symptoms: Value(latest.symptoms.join(',')),
        note: Value(latest.note),
      ));
      state = AsyncData(await _load());
    } else {
      state = AsyncData(current.copyWith(avgCycle: days));
    }
  }
}

final periodProvider = AsyncNotifierProvider<PeriodNotifier, PeriodState>(PeriodNotifier.new);
