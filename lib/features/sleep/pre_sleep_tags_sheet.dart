import 'dart:ui';
import 'package:flutter/material.dart';

class PreSleepTagsSheet extends StatefulWidget {
  final Function(List<String> selectedTags) onConfirm;

  const PreSleepTagsSheet({Key? key, required this.onConfirm}) : super(key: key);

  @override
  State<PreSleepTagsSheet> createState() => _PreSleepTagsSheetState();
}

class _PreSleepTagsSheetState extends State<PreSleepTagsSheet> {
  final List<Map<String, dynamic>> _tagOptions = [
    {'id': 'caffeine', 'name': '咖啡因', 'icon': Icons.coffee, 'desc': '摄入咖啡、茶或可乐等'},
    {'id': 'alcohol', 'name': '酒精', 'icon': Icons.local_bar, 'desc': '睡前饮酒'},
    {'id': 'exercise', 'name': '运动', 'icon': Icons.fitness_center, 'desc': '睡前进行了健身或运动'},
    {'id': 'late_meal', 'name': '晚顿/宵夜', 'icon': Icons.fastfood, 'desc': '睡前2小时内进食'},
    {'id': 'screen_time', 'name': '屏幕使用', 'icon': Icons.phone_iphone, 'desc': '长时间使用手机/电脑'},
    {'id': 'meditation', 'name': '冥想放松', 'icon': Icons.self_improvement, 'desc': '进行冥想、拉伸或泡澡'},
  ];

  final Set<String> _selectedIds = {};

  void _toggleTag(String id) {
    setState(() {
      if (_selectedIds.contains(id)) {
        _selectedIds.remove(id);
      } else {
        _selectedIds.add(id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1C1C1E).withOpacity(0.85),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        border: Border.all(color: Colors.white.withOpacity(0.08), width: 0.5),
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 34),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Handle bar
                Center(
                  child: Container(
                    width: 36,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(2.5),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  '昨晚你做了什么？',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                const Text(
                  '选择你的睡前习惯，以分析其对睡眠质量的影响',
                  style: TextStyle(
                    color: Colors.white54,
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                // Grid of tags
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 2.2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemCount: _tagOptions.length,
                  itemBuilder: (context, index) {
                    final tag = _tagOptions[index];
                    final id = tag['id'] as String;
                    final isSelected = _selectedIds.contains(id);

                    return InkWell(
                      onTap: () => _toggleTag(id),
                      borderRadius: BorderRadius.circular(16),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                        decoration: BoxDecoration(
                          color: isSelected 
                              ? const Color(0xFF6B9B78).withOpacity(0.25)
                              : Colors.white.withOpacity(0.04),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isSelected 
                                ? const Color(0xFF6B9B78).withOpacity(0.6)
                                : Colors.white.withOpacity(0.08),
                            width: isSelected ? 1.5 : 0.8,
                          ),
                          boxShadow: isSelected ? [
                            BoxShadow(
                              color: const Color(0xFF6B9B78).withOpacity(0.15),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            )
                          ] : null,
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: isSelected 
                                    ? const Color(0xFF6B9B78).withOpacity(0.2)
                                    : Colors.white.withOpacity(0.05),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                tag['icon'] as IconData,
                                color: isSelected ? const Color(0xFF90C29F) : Colors.white70,
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    tag['name'] as String,
                                    style: TextStyle(
                                      color: isSelected ? Colors.white : Colors.white70,
                                      fontSize: 15,
                                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    tag['desc'] as String,
                                    style: TextStyle(
                                      color: isSelected ? Colors.white70.withOpacity(0.7) : Colors.white30,
                                      fontSize: 10,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 32),
                // Actions
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                            side: BorderSide(color: Colors.white.withOpacity(0.15)),
                          ),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                          widget.onConfirm([]); // Empty list for skip
                        },
                        child: const Text(
                          '跳过',
                          style: TextStyle(color: Colors.white70, fontSize: 16),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF6B9B78), Color(0xFF2E4537)],
                          ),
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF2E4537).withOpacity(0.4),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            )
                          ],
                        ),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                            widget.onConfirm(_selectedIds.toList());
                          },
                          child: const Text(
                            '确认并开始',
                            style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
