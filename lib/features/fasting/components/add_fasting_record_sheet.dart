import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../providers/fasting_provider.dart';
import '../models/fasting_session.dart';
import '../models/fasting_plan.dart';
import '../core/constants/app_constants.dart';
import 'package:steps_webu_flutter/core/theme/app_colors.dart';
import '../utils/picker_utils.dart';
import 'package:flutter/cupertino.dart';

class AddFastingRecordSheet extends ConsumerStatefulWidget {
  final FastingSession? editingSession;
  const AddFastingRecordSheet({super.key, this.editingSession});

  @override
  ConsumerState<AddFastingRecordSheet> createState() =>
      _AddFastingRecordSheetState();
}

class _AddFastingRecordSheetState extends ConsumerState<AddFastingRecordSheet> {
  FastingPlan? _selectedPlan;
  DateTime _startTime = DateTime.now().subtract(const Duration(hours: 16));
  DateTime _endTime = DateTime.now();

  @override
  void initState() {
    super.initState();
    if (widget.editingSession != null) {
      _startTime = widget.editingSession!.startTime;
      _endTime = widget.editingSession!.endTime ?? DateTime.now();
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final plansAsync = ref.read(fastingPlansProvider);
      final plans = plansAsync.valueOrNull ?? FastingPlan.presetPlans;
      if (plans.isNotEmpty) {
        setState(() {
          if (widget.editingSession != null) {
            _selectedPlan = plans.firstWhere(
              (p) => p.id == widget.editingSession!.planId,
              orElse: () => plans.first,
            );
          } else {
            _selectedPlan = plans.firstWhere(
              (p) => p.id == 'preset_16_8',
              orElse: () => plans.first,
            );
          }
        });
      }
    });
  }

  Future<void> _selectDateTime(BuildContext context, bool isStart) async {
    final initialDate = isStart ? _startTime : _endTime;

    final result = await PickerUtils.showCupertinoDateTimePicker(
      context,
      initialDateTime: initialDate,
      mode: CupertinoDatePickerMode.dateAndTime,
      minimumDate: DateTime(2020),
      maximumDate: DateTime.now(),
    );

    if (result == null) return;

    setState(() {
      if (isStart) {
        _startTime = result;
      } else {
        _endTime = result;
      }
    });
  }

  void _saveRecord() {
    if (_selectedPlan == null) return;
    if (_endTime.isBefore(_startTime)) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('结束时间不能早于开始时间')));
      return;
    }

    if (widget.editingSession != null) {
      final updatedSession = widget.editingSession!.copyWith(
        planId: _selectedPlan!.id,
        startTime: _startTime,
        endTime: _endTime,
        fastingHours: _selectedPlan!.fastingHours,
        eatingHours: _selectedPlan!.eatingHours,
      );
      ref.read(fastingSessionsProvider.notifier).updateSession(updatedSession);
    } else {
      final session = FastingSession(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        planId: _selectedPlan!.id,
        startTime: _startTime,
        endTime: _endTime,
        fastingHours: _selectedPlan!.fastingHours,
        eatingHours: _selectedPlan!.eatingHours,
        status: FastingStatus.completed,
        createdAt: DateTime.now(),
      );
      ref.read(fastingSessionsProvider.notifier).addManualSession(session);
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final plansAsync = ref.watch(fastingPlansProvider);
    final plans = plansAsync.valueOrNull ?? FastingPlan.presetPlans;
    final formatter = DateFormat('yyyy-MM-dd HH:mm');

    return Container(
      padding: const EdgeInsets.all(
        24,
      ).copyWith(bottom: MediaQuery.of(context).viewInsets.bottom + 24),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            widget.editingSession != null ? '编辑断食记录' : '补记断食记录',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w900,
              color: AppColors.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          DropdownButtonFormField<FastingPlan>(
            initialValue: _selectedPlan,
            decoration: InputDecoration(
              labelText: '断食计划',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            items: plans.map((plan) {
              return DropdownMenuItem(value: plan, child: Text(plan.name));
            }).toList(),
            onChanged: (val) {
              setState(() {
                _selectedPlan = val;
              });
            },
          ),
          const SizedBox(height: 16),
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('开始时间'),
            trailing: Text(
              formatter.format(_startTime),
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            ),
            onTap: () => _selectDateTime(context, true),
          ),
          const Divider(),
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('结束时间'),
            trailing: Text(
              formatter.format(_endTime),
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            ),
            onTap: () => _selectDateTime(context, false),
          ),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: _saveRecord,
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.primary,
              minimumSize: const Size.fromHeight(54),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: const Text(
              '保存记录',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
