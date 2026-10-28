import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class WhiteNoiseScreen extends ConsumerStatefulWidget {
  const WhiteNoiseScreen({super.key});

  @override
  ConsumerState<WhiteNoiseScreen> createState() => _WhiteNoiseScreenState();
}

class _WhiteNoiseScreenState extends ConsumerState<WhiteNoiseScreen> {
  final List<String> _categories = ['全部', '自然', '睡眠', '轻音乐', '冥想放松'];
  String _selectedCategory = '全部';

  // Mock data for sounds
  final List<Map<String, dynamic>> _sounds = [
    {'title': '春雨', 'category': '自然', 'icon': Icons.water_drop, 'color': 0xFF65B8D9},
    {'title': '篝火', 'category': '自然', 'icon': Icons.local_fire_department, 'color': 0xFFF59E0B},
    {'title': '海浪', 'category': '自然', 'icon': Icons.waves, 'color': 0xFF3B82F6},
    {'title': '风声', 'category': '自然', 'icon': Icons.air, 'color': 0xFF94A3B8},
    {'title': '夏夜虫鸣', 'category': '睡眠', 'icon': Icons.nightlight_round, 'color': 0xFF4F46E5},
    {'title': '森林清晨', 'category': '放松', 'icon': Icons.park, 'color': 0xFF10B981},
    {'title': '白噪音', 'category': '睡眠', 'icon': Icons.blur_on, 'color': 0xFF6B7280},
    {'title': '舒缓钢琴', 'category': '轻音乐', 'icon': Icons.piano, 'color': 0xFF8B5CF6},
  ];

  String _currentPlaying = '未在播放';
  bool _isPlaying = false;
  double _volume = 0.6;
  String _timerStatus = '未开启定时';

  @override
  Widget build(BuildContext context) {
    final filteredSounds = _selectedCategory == '全部'
        ? _sounds
        : _sounds.where((s) => s['category'] == _selectedCategory).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FA),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          '白噪音',
          style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: CustomScrollView(
        slivers: [
          // Categories
          SliverToBoxAdapter(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Row(
                children: _categories.map((category) {
                  final isSelected = _selectedCategory == category;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(category),
                      selected: isSelected,
                      onSelected: (selected) {
                        setState(() {
                          _selectedCategory = category;
                        });
                      },
                      selectedColor: const Color(0xFF10B981),
                      labelStyle: TextStyle(
                        color: isSelected ? Colors.white : Colors.black87,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: BorderSide(
                          color: isSelected ? Colors.transparent : Colors.grey.shade300,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),

          // Sound Grid
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1.2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final sound = filteredSounds[index];
                  final isPlayingThis = _currentPlaying == sound['title'] && _isPlaying;
                  
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        if (_currentPlaying == sound['title']) {
                          _isPlaying = !_isPlaying;
                        } else {
                          _currentPlaying = sound['title'];
                          _isPlaying = true;
                        }
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: isPlayingThis 
                            ? Border.all(color: const Color(0xFF10B981), width: 2)
                            : null,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Color(sound['color']).withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              sound['icon'],
                              color: Color(sound['color']),
                              size: 32,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            sound['title'],
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
                childCount: filteredSounds.length,
              ),
            ),
          ),

          // Player Card
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                ),
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _currentPlaying,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      _currentPlaying == '未在播放' ? '选择音效开始聆听' : '正在播放中...',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF94A3B8),
                      ),
                    ),
                    const SizedBox(height: 32),
                    
                    // Volume Control
                    Row(
                      children: [
                        const Icon(Icons.volume_up, color: Color(0xFF94A3B8), size: 20),
                        Expanded(
                          child: SliderTheme(
                            data: SliderTheme.of(context).copyWith(
                              activeTrackColor: const Color(0xFF10B981),
                              inactiveTrackColor: Colors.grey.shade200,
                              thumbColor: const Color(0xFF10B981),
                              overlayColor: const Color(0xFF10B981).withOpacity(0.2),
                              trackHeight: 4,
                            ),
                            child: Slider(
                              value: _volume,
                              onChanged: (val) {
                                setState(() {
                                  _volume = val;
                                });
                              },
                            ),
                          ),
                        ),
                        Text(
                          '${(_volume * 100).toInt()}%',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF94A3B8),
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 32),
                    
                    // Play Button
                    Center(
                      child: GestureDetector(
                        onTap: () {
                          if (_currentPlaying != '未在播放') {
                            setState(() {
                              _isPlaying = !_isPlaying;
                            });
                          }
                        },
                        child: Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: _currentPlaying == '未在播放' 
                                ? Colors.grey.shade300 
                                : const Color(0xFF10B981),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            _isPlaying ? Icons.pause : Icons.play_arrow,
                            color: Colors.white,
                            size: 40,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Timer Card
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16).copyWith(bottom: 40),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            '定时关闭',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _timerStatus,
                            style: const TextStyle(
                              fontSize: 13,
                              color: Color(0xFF94A3B8),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: const Text(
                        '更改时间 >',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF666666),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
