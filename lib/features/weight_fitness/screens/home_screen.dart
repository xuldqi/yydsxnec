import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:go_router/go_router.dart';
import '../../../core/services/user_profile_provider.dart';
import '../models/weight_log.dart';
import '../services/storage_service.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final WeightStorageService _storage = WeightStorageService();
  final _weightCtrl = TextEditingController();
  final _bodyFatCtrl = TextEditingController();
  final _notesCtrl = TextEditingController();

  List<WeightLog> _history = [];
  bool _isLoading = true;
  int _tabIndex = 0; // 0=Day, 1=Week, 2=Month, 3=Year

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  @override
  void dispose() {
    _weightCtrl.dispose();
    _bodyFatCtrl.dispose();
    _notesCtrl.dispose();
    super.dispose();
  }

  Future<void> _loadHistory() async {
    setState(() => _isLoading = true);
    final logs = await _storage.getWeightLogs();
    setState(() {
      _history = logs;
      _isLoading = false;
    });
  }

  double _calculateBmi(double weight, double heightCm) {
    if (heightCm <= 0) return 0.0;
    final heightM = heightCm / 100.0;
    return weight / (heightM * heightM);
  }

  String _getShape(double bmi) {
    if (bmi <= 0) return '未知';
    if (bmi < 18.5) return '偏瘦';
    if (bmi < 24.0) return '标准';
    if (bmi < 28.0) return '超重';
    return '肥胖';
  }

  void _showAddWeightSheet() {
    _weightCtrl.clear();
    _bodyFatCtrl.clear();
    _notesCtrl.clear();
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + 24,
            top: 24, left: 24, right: 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(child: Text('记录体重', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
              const SizedBox(height: 24),
              TextField(
                controller: _weightCtrl,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  labelText: '体重 (kg)',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _bodyFatCtrl,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  labelText: '体脂率 (% 可选)',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () async {
                  final weight = double.tryParse(_weightCtrl.text.trim());
                  if (weight == null || weight <= 0) return;
                  final bodyFat = double.tryParse(_bodyFatCtrl.text.trim());

                  final newLog = WeightLog(
                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                    weight: weight,
                    bodyFat: bodyFat,
                    notes: '',
                    timestamp: DateTime.now(),
                  );
                  await _storage.saveWeightLog(newLog);
                  
                  final profile = ref.read(userProfileProvider);
                  ref.read(userProfileProvider.notifier).update(profile.copyWith(weightKg: weight.toInt()));

                  if (mounted) Navigator.pop(context);
                  _loadHistory();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF10B981),
                  minimumSize: const Size(double.infinity, 52),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(26)),
                  elevation: 0,
                ),
                child: const Text('保存', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final profile = ref.watch(userProfileProvider);
    final height = profile.heightCm > 0 ? profile.heightCm.toDouble() : 170.0;
    
    final currentWeight = _history.isNotEmpty ? _history.first.weight : profile.weightKg.toDouble();
    final currentFat = _history.isNotEmpty ? _history.first.bodyFat : null;
    final bmi = _calculateBmi(currentWeight, height);
    final shape = _getShape(bmi);

    final chartLogs = _history.take(7).toList().reversed.toList();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black, size: 20),
          onPressed: () => context.pop(),
        ),
        title: const Text('体重记录', style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_month_rounded, color: Colors.black),
            onPressed: () {},
          )
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.only(bottom: 40),
        child: Column(
          children: [
            // Tabs
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              child: Container(
                height: 36,
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(18),
                ),
                padding: const EdgeInsets.all(2),
                child: Row(
                  children: [
                    _buildTab(0, '日'),
                    _buildTab(1, '周'),
                    _buildTab(2, '月'),
                    _buildTab(3, '年'),
                  ],
                ),
              ),
            ),

            // Date Selector
            Padding(
              padding: const EdgeInsets.only(top: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.chevron_left_rounded, size: 28),
                  Container(
                    width: 200,
                    alignment: Alignment.center,
                    child: Text(
                      DateFormat('MM月dd日').format(DateTime.now()),
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const Icon(Icons.chevron_right_rounded, size: 28),
                ],
              ),
            ),

            // Huge Weight Text
            Padding(
              padding: const EdgeInsets.only(top: 32),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    currentWeight.toStringAsFixed(1),
                    style: const TextStyle(fontSize: 56, fontWeight: FontWeight.bold, color: Color(0xFF10B981), height: 1.1),
                  ),
                  const SizedBox(width: 8),
                  const Text('kg', style: TextStyle(fontSize: 20, color: Color(0xFF6B7280))),
                ],
              ),
            ),
            
            // Subtitle
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(DateFormat('HH:mm').format(DateTime.now()), style: const TextStyle(fontSize: 14, color: Color(0xFF666666))),
                  const SizedBox(width: 12),
                  const Text('比昨天 -0.0kg', style: TextStyle(fontSize: 14, color: Color(0xFF10B981))),
                ],
              ),
            ),

            // Chart
            if (chartLogs.isNotEmpty)
              Container(
                height: 200,
                margin: const EdgeInsets.only(top: 24, left: 16, right: 16),
                child: LineChart(
                  LineChartData(
                    gridData: const FlGridData(show: false),
                    titlesData: const FlTitlesData(show: false),
                    borderData: FlBorderData(show: false),
                    lineBarsData: [
                      LineChartBarData(
                        spots: List.generate(chartLogs.length, (idx) => FlSpot(idx.toDouble(), chartLogs[idx].weight)),
                        isCurved: true,
                        color: const Color(0xFF10B981),
                        barWidth: 3,
                        dotData: const FlDotData(show: true),
                        belowBarData: BarAreaData(show: true, color: const Color(0xFF10B981).withValues(alpha: 0.1)),
                      ),
                    ],
                  ),
                ),
              ),

            // 3 Small Cards
            Padding(
              padding: const EdgeInsets.only(top: 24, left: 20, right: 20),
              child: Row(
                children: [
                  _buildSmallCard('体脂率', currentFat != null ? '${currentFat.toStringAsFixed(1)}%' : '--'),
                  const SizedBox(width: 12),
                  _buildSmallCard('BMI', bmi.toStringAsFixed(1)),
                  const SizedBox(width: 12),
                  _buildSmallCard('体型', shape),
                ],
              ),
            ),

            // Bottom Button
            Padding(
              padding: const EdgeInsets.only(top: 32, left: 20, right: 20),
              child: ElevatedButton(
                onPressed: _showAddWeightSheet,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF10B981),
                  minimumSize: const Size(double.infinity, 52),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(26)),
                  elevation: 0,
                ),
                child: const Text('+ 记录体重', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTab(int index, String text) {
    final isSelected = _tabIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _tabIndex = index),
        child: Container(
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF10B981) : Colors.transparent,
            borderRadius: BorderRadius.circular(16),
          ),
          alignment: Alignment.center,
          child: Text(
            text,
            style: TextStyle(
              fontSize: 14,
              color: isSelected ? Colors.white : const Color(0xFF666666),
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSmallCard(String title, String value) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Text(title, style: const TextStyle(fontSize: 13, color: Color(0xFF666666))),
            const SizedBox(height: 8),
            Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black)),
          ],
        ),
      ),
    );
  }
}
