import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';
import '../models/poop_log.dart';
import '../services/storage_service.dart';
import '../../../core/theme/app_colors.dart';

class PoopScreen extends StatefulWidget {
  const PoopScreen({super.key});

  @override
  State<PoopScreen> createState() => _PoopScreenState();
}

class _PoopScreenState extends State<PoopScreen> {
  final PoopStorageService _storage = PoopStorageService();

  List<PoopLog> _history = [];
  bool _isLoading = true;

  final List<Map<String, dynamic>> _bristolTypes = [
    {'type': 1, 'label': 'Type 1: 硬球状', 'desc': '像坚果 (很难排出)', 'icon': Icons.circle, 'color': Colors.brown[800]},
    {'type': 2, 'label': 'Type 2: 香肠状', 'desc': '有坚硬肿块', 'icon': Icons.view_headline, 'color': Colors.brown[700]},
    {'type': 3, 'label': 'Type 3: 香肠状', 'desc': '表面有裂纹', 'icon': Icons.format_align_justify, 'color': Colors.brown[600]},
    {'type': 4, 'label': 'Type 4: 蛇状/香肠状', 'desc': '表面光滑 (最理想)', 'icon': Icons.drag_handle, 'color': Colors.brown},
    {'type': 5, 'label': 'Type 5: 软块状', 'desc': '边缘清晰 (容易排出)', 'icon': Icons.more_horiz, 'color': Colors.brown[400]},
    {'type': 6, 'label': 'Type 6: 糊状/蓬松', 'desc': '边缘粗糙 (糊状便)', 'icon': Icons.waves, 'color': Colors.brown[300]},
    {'type': 7, 'label': 'Type 7: 水状/腹泻', 'desc': '无固体块 (腹泻)', 'icon': Icons.water_drop, 'color': Colors.brown[200]},
  ];

  final List<Map<String, dynamic>> _colors = [
    {'name': 'Brown', 'hex': Colors.brown, 'label': '棕色'},
    {'name': 'Green', 'hex': Colors.green, 'label': '绿色'},
    {'name': 'Black', 'hex': Colors.black, 'label': '黑色'},
    {'name': 'Red', 'hex': Colors.red, 'label': '红色'},
    {'name': 'Pale', 'hex': const Color(0xFFD7CCC8), 'label': '灰白'},
  ];

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    setState(() => _isLoading = true);
    final logs = await _storage.getPoopLogs();
    setState(() {
      _history = logs;
      _isLoading = false;
    });
  }

  Future<void> _deleteRecord(String id) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('确认删除'),
        content: const Text('确定要删除这条记录吗？'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('取消')),
          TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('删除', style: TextStyle(color: Colors.red))),
        ],
      ),
    );

    if (confirm == true) {
      await _storage.deletePoopLog(id);
      _loadHistory();
    }
  }

  Color _getColorHex(String name) {
    final match = _colors.firstWhere((c) => c['name'] == name, orElse: () => _colors.first);
    return match['hex'] as Color;
  }

  String _getColorLabel(String name) {
    final match = _colors.firstWhere((c) => c['name'] == name, orElse: () => _colors.first);
    return match['label'] as String;
  }

  void _showAddRecordSheet() {
    int selectedType = 4;
    String selectedColor = 'Brown';
    final TextEditingController notesCtrl = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateSB) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.85,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('添加排便记录', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(context)),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('大便形状类型', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 12),
                          SizedBox(
                            height: 120,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              physics: const BouncingScrollPhysics(),
                              itemCount: _bristolTypes.length,
                              itemBuilder: (ctx, idx) {
                                final item = _bristolTypes[idx];
                                final isSelected = selectedType == item['type'];
                                return Padding(
                                  padding: const EdgeInsets.only(right: 12.0),
                                  child: GestureDetector(
                                    onTap: () => setStateSB(() => selectedType = item['type'] as int),
                                    child: Container(
                                      width: 100,
                                      decoration: BoxDecoration(
                                        color: isSelected ? const Color(0xFFF5F5DC) : AppColors.background,
                                        borderRadius: BorderRadius.circular(16),
                                        border: Border.all(
                                          color: isSelected ? Colors.brown : Colors.transparent,
                                          width: 2,
                                        ),
                                      ),
                                      padding: const EdgeInsets.all(10.0),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Icon(item['icon'] as IconData, color: item['color'] as Color, size: 28),
                                          const SizedBox(height: 6),
                                          Text(item['label'] as String, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                                          const SizedBox(height: 2),
                                          Text(item['desc'] as String, style: TextStyle(fontSize: 8, color: Colors.grey[600]), textAlign: TextAlign.center),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          const SizedBox(height: 20),
                          const Text('颜色', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: _colors.map((c) {
                              final isSelected = selectedColor == c['name'];
                              return GestureDetector(
                                onTap: () => setStateSB(() => selectedColor = c['name'] as String),
                                child: Column(
                                  children: [
                                    Container(
                                      width: 44,
                                      height: 44,
                                      decoration: BoxDecoration(
                                        color: c['hex'] as Color,
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: isSelected ? AppColors.primary : Colors.grey[300]!,
                                          width: isSelected ? 3.0 : 1.5,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(c['label'] as String, style: TextStyle(fontSize: 11, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
                                  ],
                                ),
                              );
                            }).toList(),
                          ),
                          const SizedBox(height: 20),
                          const Text('备注 (可选)', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 8),
                          TextField(
                            controller: notesCtrl,
                            decoration: InputDecoration(
                              hintText: '写下感受...',
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                              fillColor: AppColors.background,
                              filled: true,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      final newLog = PoopLog(
                        id: DateTime.now().millisecondsSinceEpoch.toString(),
                        type: selectedType,
                        color: selectedColor,
                        notes: notesCtrl.text.trim(),
                        timestamp: DateTime.now(),
                      );
                      await _storage.savePoopLog(newLog);
                      if (mounted) {
                        Navigator.pop(context);
                        _loadHistory();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.brown,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                      elevation: 0,
                    ),
                    child: const Text('保存', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                  SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final todayCount = _history.where((log) {
      final now = DateTime.now();
      return log.timestamp.year == now.year &&
             log.timestamp.month == now.month &&
             log.timestamp.day == now.day;
    }).length;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textPrimary, size: 20),
          onPressed: () => context.pop(),
        ),
        title: const Text('排便记录', style: TextStyle(color: AppColors.textPrimary, fontSize: 18, fontWeight: FontWeight.bold)),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text(
              '今日排便：$todayCount次',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _history.isEmpty
                    ? const Center(
                        child: Text('暂无记录', style: TextStyle(color: AppColors.textHint)),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: _history.length,
                        itemBuilder: (ctx, idx) {
                          final log = _history[idx];
                          final formattedTime = DateFormat('MM-dd HH:mm').format(log.timestamp);
                          final typeMatch = _bristolTypes.firstWhere(
                            (t) => t['type'] == log.type,
                            orElse: () => _bristolTypes.first,
                          );
                          return Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: ListTile(
                              leading: Container(
                                width: 44, height: 44,
                                decoration: BoxDecoration(
                                  color: _getColorHex(log.color).withValues(alpha: 0.1),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(typeMatch['icon'] as IconData, color: typeMatch['color'] as Color),
                              ),
                              title: Text(
                                '${typeMatch['label']} (${_getColorLabel(log.color)})',
                                style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(formattedTime, style: const TextStyle(fontSize: 12, color: AppColors.textHint)),
                                  if (log.notes.isNotEmpty) ...[
                                    const SizedBox(height: 4),
                                    Text('“${log.notes}”', style: const TextStyle(fontSize: 13, color: AppColors.textSecondary)),
                                  ]
                                ],
                              ),
                              trailing: IconButton(
                                icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                                onPressed: () => _deleteRecord(log.id),
                              ),
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddRecordSheet,
        backgroundColor: const Color(0xFFE0E0E0),
        elevation: 8,
        child: const Icon(Icons.add_rounded, color: Color(0xFF666666), size: 32),
      ),
    );
  }
}
