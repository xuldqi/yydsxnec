import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/providers/audio_mixer_provider.dart';
import 'audio_mixer_sheet.dart';

class SleepAidScreen extends StatefulWidget {
  const SleepAidScreen({Key? key}) : super(key: key);

  @override
  State<SleepAidScreen> createState() => _SleepAidScreenState();
}

class _SleepAidScreenState extends State<SleepAidScreen> {
  String _selectedCategory = 'all';

  String _getSoundscapeImage(String id) {
    if (id == 'cabin_noise') {
      return 'assets/images/sound_cabin.png';
    }
    return 'assets/images/sound_$id.png';
  }

  String _formatTimerTime(int totalSeconds) {
    if (totalSeconds <= 0) return '';
    final minutes = totalSeconds ~/ 60;
    final seconds = totalSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  List<Map<String, String>> _filteredSoundscapes(AudioMixerProvider provider) {
    if (_selectedCategory == 'all') {
      return provider.availableSoundscapes;
    }
    return provider.availableSoundscapes
        .where((item) => item['category'] == _selectedCategory)
        .toList();
  }

  Future<void> _selectSoundscape(
    AudioMixerProvider provider,
    String soundscapeId,
  ) async {
    if (provider.currentSoundscape?.id == soundscapeId) {
      if (!provider.isPlaying) {
        await provider.togglePlay();
      }
      return;
    }
    await provider.loadSoundscape(soundscapeId);
  }

  void _openMixer(BuildContext context, AudioMixerProvider provider) {
    if (provider.currentSoundscape == null && !provider.isLoading) {
      final first = provider.availableSoundscapes.first;
      provider.loadSoundscape(first['id']!);
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const AudioMixerSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AudioMixerProvider>(context);
    final current = provider.currentSoundscape;
    final currentConfig = current == null
        ? provider.availableSoundscapes.first
        : provider.availableSoundscapes.firstWhere(
            (item) => item['id'] == current.id,
            orElse: () => provider.availableSoundscapes.first,
          );
    final currentId = current?.id ?? currentConfig['id']!;
    final currentTitle = current?.title ?? currentConfig['title']!;
    final soundscapes = _filteredSoundscapes(provider);

    return Scaffold(
      backgroundColor: const Color(0xFF0B1118),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              _getSoundscapeImage(currentId),
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      const Color(0xFF121B22).withOpacity(0.78),
                      const Color(0xFF0B1118).withOpacity(0.96),
                      const Color(0xFF0B1118),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SafeArea(
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 18, 24, 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          '助眠播放',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        IconButton(
                          tooltip: '调音台',
                          onPressed: () => _openMixer(context, provider),
                          icon: const Icon(Icons.tune_rounded),
                          color: Colors.white70,
                        ),
                      ],
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: _buildPlayerPanel(
                    context,
                    provider,
                    currentId,
                    currentTitle,
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(18, 24, 18, 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '声音列表',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 14),
                        _buildCategoryList(provider),
                      ],
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  sliver: SliverGrid(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 12,
                          crossAxisSpacing: 10,
                          childAspectRatio: 0.84,
                        ),
                    delegate: SliverChildBuilderDelegate((context, index) {
                      return _buildSoundscapeCard(
                        context,
                        provider,
                        soundscapes[index],
                      );
                    }, childCount: soundscapes.length),
                  ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 112)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlayerPanel(
    BuildContext context,
    AudioMixerProvider provider,
    String currentId,
    String currentTitle,
  ) {
    final hasCurrent = provider.currentSoundscape != null;
    final timerActive = provider.remainingTimerSeconds > 0;

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 10, 24, 6),
      child: Column(
        children: [
          Container(
            constraints: const BoxConstraints(maxWidth: 360),
            child: AspectRatio(
              aspectRatio: 1,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(28),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.asset(
                      _getSoundscapeImage(currentId),
                      fit: BoxFit.cover,
                    ),
                    if (provider.isLoading)
                      Container(
                        color: Colors.black.withOpacity(0.32),
                        child: const Center(
                          child: CircularProgressIndicator(
                            color: Color(0xFFE7C66A),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 22),
          Text(
            currentTitle,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            hasCurrent ? '正在播放环境声' : '从下方列表选择一个声音',
            style: const TextStyle(color: Colors.white54, fontSize: 14),
          ),
          const SizedBox(height: 26),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildRoundIconButton(
                tooltip: '定时关闭',
                icon: timerActive ? Icons.timer_rounded : Icons.timer_outlined,
                isActive: timerActive,
                onTap: () => _showTimerMenu(context, provider),
                footer: timerActive
                    ? _formatTimerTime(provider.remainingTimerSeconds)
                    : null,
              ),
              const SizedBox(width: 24),
              GestureDetector(
                onTap: provider.isLoading
                    ? null
                    : () {
                        if (hasCurrent) {
                          provider.togglePlay();
                        } else {
                          _selectSoundscape(provider, currentId);
                        }
                      },
                child: Container(
                  width: 76,
                  height: 76,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFFE7C66A),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFE7C66A).withOpacity(0.28),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Icon(
                    provider.isPlaying
                        ? Icons.pause_rounded
                        : Icons.play_arrow_rounded,
                    color: const Color(0xFF15120A),
                    size: 46,
                  ),
                ),
              ),
              const SizedBox(width: 24),
              _buildRoundIconButton(
                tooltip: '调音台',
                icon: Icons.graphic_eq_rounded,
                isActive: hasCurrent,
                onTap: () => _openMixer(context, provider),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRoundIconButton({
    required String tooltip,
    required IconData icon,
    required bool isActive,
    required VoidCallback onTap,
    String? footer,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Tooltip(
          message: tooltip,
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: onTap,
            child: Container(
              width: 54,
              height: 54,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isActive
                    ? const Color(0xFFE7C66A).withOpacity(0.16)
                    : Colors.white.withOpacity(0.08),
                border: Border.all(
                  color: isActive
                      ? const Color(0xFFE7C66A).withOpacity(0.42)
                      : Colors.white.withOpacity(0.08),
                ),
              ),
              child: Icon(
                icon,
                color: isActive ? const Color(0xFFE7C66A) : Colors.white70,
                size: 24,
              ),
            ),
          ),
        ),
        SizedBox(
          height: 20,
          child: footer == null
              ? const SizedBox.shrink()
              : Center(
                  child: Text(
                    footer,
                    style: const TextStyle(
                      color: Color(0xFFE7C66A),
                      fontSize: 11,
                      fontFeatures: [FontFeature.tabularFigures()],
                    ),
                  ),
                ),
        ),
      ],
    );
  }

  Widget _buildCategoryList(AudioMixerProvider provider) {
    return SizedBox(
      height: 46,
      child: ListView.separated(
        physics: const BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.zero,
        itemCount: provider.categories.length,
        separatorBuilder: (context, index) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final category = provider.categories[index];
          final id = category['id']!;
          final isSelected = id == _selectedCategory;
          return ChoiceChip(
            label: Text(category['name']!),
            selected: isSelected,
            onSelected: (_) {
              setState(() {
                _selectedCategory = id;
              });
            },
            labelStyle: TextStyle(
              color: isSelected ? const Color(0xFF15120A) : Colors.white70,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              fontSize: 13,
            ),
            selectedColor: const Color(0xFFE7C66A),
            backgroundColor: Colors.white.withOpacity(0.08),
            side: BorderSide(
              color: isSelected
                  ? Colors.transparent
                  : Colors.white.withOpacity(0.08),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSoundscapeCard(
    BuildContext context,
    AudioMixerProvider provider,
    Map<String, String> item,
  ) {
    final id = item['id']!;
    final title = item['title']!;
    final isCurrent = provider.currentSoundscape?.id == id;
    final isPlaying = isCurrent && provider.isPlaying;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: provider.isLoading
            ? null
            : () => _selectSoundscape(provider, id),
        child: Container(
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: isCurrent
                ? const Color(0xFFE7C66A).withOpacity(0.14)
                : Colors.white.withOpacity(0.06),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isCurrent
                  ? const Color(0xFFE7C66A).withOpacity(0.38)
                  : Colors.white.withOpacity(0.06),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AspectRatio(
                aspectRatio: 1.18,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.asset(_getSoundscapeImage(id), fit: BoxFit.cover),
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(0.42),
                          ],
                        ),
                      ),
                    ),
                    if (isCurrent)
                      Positioned(
                        top: 10,
                        left: 10,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE7C66A).withOpacity(0.16),
                            borderRadius: BorderRadius.circular(999),
                            border: Border.all(
                              color: const Color(0xFFE7C66A).withOpacity(0.34),
                            ),
                          ),
                          child: Text(
                            isPlaying ? '播放中' : '当前',
                            style: const TextStyle(
                              color: Color(0xFFE7C66A),
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    Positioned(
                      right: 10,
                      bottom: 10,
                      child: Container(
                        width: 34,
                        height: 34,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.black.withOpacity(0.32),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.16),
                          ),
                        ),
                        child: Icon(
                          isPlaying
                              ? Icons.graphic_eq_rounded
                              : Icons.play_arrow_rounded,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: isCurrent
                        ? Colors.white
                        : Colors.white.withOpacity(0.92),
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Padding(
                padding: const EdgeInsets.only(left: 12, right: 12, bottom: 12),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        isCurrent ? '当前声音' : '点按播放',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: isCurrent
                              ? const Color(0xFFE7C66A)
                              : Colors.white38,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    if (isCurrent)
                      GestureDetector(
                        onTap: () => _openMixer(context, provider),
                        child: Icon(
                          Icons.tune_rounded,
                          color: const Color(0xFFE7C66A).withOpacity(0.9),
                          size: 18,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showTimerMenu(BuildContext context, AudioMixerProvider provider) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF121B22),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        const options = [15, 30, 45, 60, 90];
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 42,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 18),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '定时关闭',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    for (final minutes in options)
                      ActionChip(
                        label: Text('$minutes 分钟'),
                        onPressed: () {
                          provider.setSleepTimer(minutes);
                          Navigator.pop(context);
                        },
                        labelStyle: const TextStyle(
                          color: Color(0xFF15120A),
                          fontWeight: FontWeight.w700,
                        ),
                        backgroundColor: const Color(0xFFE7C66A),
                        side: BorderSide.none,
                      ),
                    ActionChip(
                      label: const Text('取消定时'),
                      onPressed: () {
                        provider.setSleepTimer(0);
                        Navigator.pop(context);
                      },
                      labelStyle: const TextStyle(color: Colors.white70),
                      backgroundColor: Colors.white.withOpacity(0.08),
                      side: BorderSide(color: Colors.white.withOpacity(0.08)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
