import '../widgets/glassmorphic_wrapper.dart';
import '../widgets/capwords_sticker_stage.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../models/drink_record.dart';
import '../services/database_service.dart';
import '../../../../core/theme/app_colors.dart';
import '../utils/navigation_helper.dart';
import '../widgets/price_glow_badge.dart';

class RecordDetailPage extends StatefulWidget {
  final String recordId;
  const RecordDetailPage({super.key, required this.recordId});

  @override
  State<RecordDetailPage> createState() => _RecordDetailPageState();
}

class _RecordDetailPageState extends State<RecordDetailPage> {
  final DatabaseService _db = DatabaseService();
  DrinkRecord? _record;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadRecordDetail();
  }

  Future<void> _loadRecordDetail() async {
    try {
      final id = int.tryParse(widget.recordId);
      if (id != null) {
        final record = await _db.getDrinkRecord(id);
        setState(() {
          _record = record;
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (_) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _deleteRecord() async {
    if (_record == null || _record!.id == null) return;

    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          '确认删除',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Text('您确定要删除「${_record!.name}」的记录吗？该操作不可撤销。'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('删除'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await _db.deleteDrinkRecord(_record!.id!);
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('记录已成功删除')));
        context.go('/records');
      }
    }
  }

  void _navigateToEdit() {
    if (_record == null) return;

    // Pass prefill values including edit_id
    final prefill = {
      'edit_id': _record!.id,
      'name': _record!.name,
      'category': _record!.category,
      'volume': _record!.volume,
      'size': _record!.size,
      'sugar': _record!.sugar,
      'fat': _record!.fat,
      'protein': _record!.protein,
      'caffeine': _record!.caffeine,
      'calories': _record!.calories,
      'brand': _record!.brand ?? '',
      'price': _record!.price,
      'notes': _record!.notes ?? '',
      'imagePath': _record!.imagePath ?? '',
      'recordTime': _record!.recordTime,
    };

    context.push('/record', extra: prefill);
  }

  String _formatDateTime(DateTime dt) {
    return '${dt.year}年${dt.month}月${dt.day}日 ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case '奶茶':
        return const Color(0xFFFCD34D);
      case '果茶':
        return const Color(0xFFF472B6);
      case '咖啡':
        return const Color(0xFF8B5CF6);
      case '白开水':
        return const Color(0xFF60A5FA);
      default:
        return const Color(0xFFA7F3D0);
    }
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case '奶茶':
      case '果茶':
        return Icons.local_drink;
      case '咖啡':
        return Icons.coffee;
      case '白开水':
        return Icons.water_drop;
      default:
        return Icons.local_cafe;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (_record == null) {
      return Scaffold(
        appBar: AppBar(elevation: 0),
        body: const Center(child: Text('未找到该喝水记录')),
      );
    }

    final record = _record!;
    final categoryColor = _getCategoryColor(record.category);
    final isSugarHigh = record.sugar >= 30.0;
    final isCaffeineHigh = record.caffeine >= 150.0;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('喝水详情'),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => goBackOr(context, '/records'),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
            onPressed: _deleteRecord,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. 头像/名称/基本卡片
            GlassmorphicCard(
              child: Row(
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: categoryColor.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      _getCategoryIcon(record.category),
                      color: categoryColor,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (record.brand != null && record.brand!.isNotEmpty)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            margin: const EdgeInsets.only(bottom: 4),
                            decoration: BoxDecoration(
                              color: categoryColor.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              record.brand!,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: categoryColor.darken(0.2),
                              ),
                            ),
                          ),
                        Text(
                          record.name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _formatDateTime(record.recordTime),
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // 右侧价格
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      PriceGlowBadge(price: record.price),
                      const SizedBox(height: 4),
                      Text(
                        record.size,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // 2. 健康建议警告牌
            if (isSugarHigh || isCaffeineHigh) ...[
              GlassmorphicCard(
                color: const Color(0xFFFEF2F2), // Light red bg
                child: Column(
                  children: [
                    if (isSugarHigh)
                      Row(
                        children: const [
                          Icon(
                            Icons.warning_amber_rounded,
                            color: Colors.redAccent,
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              '此杯饮品糖分含量较高（超过30g），注意控制今日额外甜食摄入。',
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.redAccent,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    if (isSugarHigh && isCaffeineHigh)
                      const SizedBox(height: 10),
                    if (isCaffeineHigh)
                      Row(
                        children: const [
                          Icon(
                            Icons.warning_amber_rounded,
                            color: Colors.redAccent,
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              '此杯饮品咖啡因含量较高（超过150mg），建议下午三点后避免饮用，以免影响睡眠。',
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.redAccent,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],

            // 3. 营养元素网格
            _buildSectionHeader('营养与配料分析'),
            GlassmorphicCard(
              child: GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 3,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.3,
                children: [
                  _buildNutritionCell(
                    '容量',
                    '${record.volume.round()} ml',
                    Icons.local_drink_outlined,
                    Colors.blue,
                  ),
                  _buildNutritionCell(
                    '热量',
                    '${record.calories.round()} kcal',
                    Icons.bolt,
                    Colors.pink,
                  ),
                  _buildNutritionCell(
                    '糖分',
                    '${record.sugar.toStringAsFixed(1)} g',
                    Icons.icecream_outlined,
                    Colors.orange,
                  ),
                  _buildNutritionCell(
                    '咖啡因',
                    '${record.caffeine.round()} mg',
                    Icons.coffee_maker_outlined,
                    Colors.deepPurple,
                  ),
                  _buildNutritionCell(
                    '脂肪',
                    '${record.fat.toStringAsFixed(1)} g',
                    Icons.opacity,
                    Colors.teal,
                  ),
                  _buildNutritionCell(
                    '蛋白质',
                    '${record.protein.toStringAsFixed(1)} g',
                    Icons.fitness_center_outlined,
                    Colors.green,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // 4. 图片或备注
            if ((record.notes != null && record.notes!.isNotEmpty) ||
                (record.imagePath != null && record.imagePath!.isNotEmpty)) ...[
              _buildSectionHeader('附加信息'),
              GlassmorphicCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (record.imagePath != null &&
                        record.imagePath!.isNotEmpty) ...[
                      Hero(
                        tag: 'record_image_${record.id ?? record.hashCode}',
                        child: Material(
                          color: Colors.transparent,
                          child: CapWordsStickerStage(
                            imagePath: record.imagePath!,
                            title: record.name,
                            price: record.price,
                            showCaption: true,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                    ],
                    if (record.notes != null && record.notes!.isNotEmpty)
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.edit_note, color: Colors.black54),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              record.notes!,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black87,
                                height: 1.4,
                              ),
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
            ],

            // 5. 操作底栏
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _navigateToEdit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                icon: const Icon(Icons.edit, size: 20),
                label: const Text(
                  '修改记录',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: _deleteRecord,
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.error,
                  side: const BorderSide(
                    color: AppColors.error,
                    width: 1.5,
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                icon: const Icon(Icons.delete, size: 20),
                label: const Text(
                  '删除记录',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.bold,
          color: Colors.black54,
        ),
      ),
    );
  }

  Widget _buildNutritionCell(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.12), width: 1.2),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color, size: 16),
              const SizedBox(width: 4),
              Text(
                label,
                style: const TextStyle(fontSize: 11, color: Colors.black54),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: color.darken(0.15),
            ),
          ),
        ],
      ),
    );
  }
}

// 辅助暗化颜色的扩展方法
extension on Color {
  Color darken([double amount = .1]) {
    assert(amount >= 0 && amount <= 1);
    final hsl = HSLColor.fromColor(this);
    final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));
    return hslDark.toColor();
  }
}
