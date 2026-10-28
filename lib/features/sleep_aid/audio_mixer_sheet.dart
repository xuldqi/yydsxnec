import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/providers/audio_mixer_provider.dart';

class AudioMixerSheet extends StatelessWidget {
  const AudioMixerSheet({Key? key}) : super(key: key);

  String _getSoundscapeImage(String id) {
    if (id == 'cabin_noise') {
      return 'assets/images/sound_cabin.png';
    }
    return 'assets/images/sound_$id.png';
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AudioMixerProvider>(context);
    final current = provider.currentSoundscape;
    final size = MediaQuery.of(context).size;

    return Container(
      height: size.height * 0.85,
      decoration: const BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Stack(
        children: [
          // 1. Background Image of Current Soundscape (if loaded) with heavy blur
          if (current != null)
            Positioned.fill(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(28),
                ),
                child: Image.asset(
                  _getSoundscapeImage(current.id),
                  fit: BoxFit.cover,
                ),
              ),
            ),

          // 2. Blur Filter & Dark Premium Gradient Overlay
          Positioned.fill(
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(28),
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        const Color(0xFF0D1B2A).withOpacity(0.85),
                        const Color(0xFF0D1B2A).withOpacity(0.95),
                        const Color(0xFF070F18),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          // 3. Main Sheet Content
          Column(
            children: [
              const SizedBox(height: 12),
              // Drag Handle
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Header Bar (Title & Dismiss Button)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.white54),
                      onPressed: () => Navigator.pop(context),
                    ),
                    Text(
                      current == null ? '调音台' : '${current.title} 调音台',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.0,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.power_settings_new,
                        color: Colors.redAccent,
                      ),
                      tooltip: '停止全部',
                      onPressed: () {
                        provider.stopAll();
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 10),

              // Saved Presets (if any)
              if (provider.savedPresets.isNotEmpty) ...[
                _buildSavedPresets(context, provider),
                const SizedBox(height: 10),
              ],

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  children: [
                    const Icon(
                      Icons.graphic_eq_rounded,
                      color: Color(0xFFE7C66A),
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        current == null ? '先在播放页选择一个声音' : '调整每层声音的音量',
                        style: const TextStyle(
                          color: Colors.white54,
                          fontSize: 13,
                        ),
                      ),
                    ),
                    TextButton.icon(
                      onPressed: current == null
                          ? null
                          : () => _showSavePresetDialog(context, provider),
                      icon: const Icon(Icons.bookmark_add_outlined, size: 18),
                      label: const Text('保存预设'),
                      style: TextButton.styleFrom(
                        foregroundColor: const Color(0xFFE7C66A),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 8),

              // Mixer Sliders / Loading Spinner
              Expanded(
                child: provider.isLoading
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: Color(0xFF6BBF7A),
                        ),
                      )
                    : current == null
                    ? const Center(
                        child: Text(
                          '请选择声音播放',
                          style: TextStyle(color: Colors.white38),
                        ),
                      )
                    : _buildSlidersList(provider, current),
              ),

              if (current != null)
                SafeArea(
                  top: false,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 10, 24, 24),
                    child: SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: () {
                          provider.stopAll();
                          Navigator.pop(context);
                        },
                        icon: const Icon(Icons.stop_circle_outlined),
                        label: const Text('停止当前声音'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.white70,
                          side: BorderSide(
                            color: Colors.white.withOpacity(0.16),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSavedPresets(BuildContext context, AudioMixerProvider provider) {
    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: provider.savedPresets.length,
        itemBuilder: (context, index) {
          final preset = provider.savedPresets[index];
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 6),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                GestureDetector(
                  onTap: () {
                    provider.loadPreset(preset);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF90C29F), Color(0xFF6B9B78)],
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF6B9B78).withOpacity(0.3),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Row(
                        children: [
                          const Icon(Icons.star, size: 14, color: Colors.white),
                          const SizedBox(width: 4),
                          Text(
                            preset.name,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  right: -5,
                  top: -5,
                  child: GestureDetector(
                    onTap: () {
                      provider.deletePreset(preset.id);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: const BoxDecoration(
                        color: Colors.redAccent,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.close,
                        size: 12,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSlidersList(AudioMixerProvider provider, Soundscape current) {
    final stems = current.stems;
    return ListView.builder(
      key: ValueKey(current.id),
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      itemCount: stems.length,
      itemBuilder: (context, index) {
        final stem = stems[index];
        final volume = stem.volume;
        final isActive = volume > 0.01;

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: [
              // Track Number Badge
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: isActive
                      ? const Color(0xFF6BBF7A).withOpacity(0.2)
                      : Colors.white.withOpacity(0.05),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isActive
                        ? const Color(0xFF6BBF7A).withOpacity(0.6)
                        : Colors.transparent,
                  ),
                ),
                child: Center(
                  child: Text(
                    '${stem.index + 1}',
                    style: TextStyle(
                      color: isActive
                          ? const Color(0xFF6BBF7A)
                          : Colors.white38,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),

              // Track Name
              SizedBox(
                width: 100,
                child: Text(
                  stem.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: isActive ? Colors.white : Colors.white54,
                    fontSize: 13,
                    fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
              ),
              const SizedBox(width: 8),

              // Volume Slider
              Expanded(
                child: SliderTheme(
                  data: SliderThemeData(
                    trackHeight: 4,
                    activeTrackColor: const Color(0xFF6BBF7A),
                    inactiveTrackColor: Colors.white.withOpacity(0.1),
                    thumbColor: Colors.white,
                    overlayColor: const Color(0xFF6BBF7A).withOpacity(0.2),
                    thumbShape: const RoundSliderThumbShape(
                      enabledThumbRadius: 8,
                    ),
                    trackShape: const RoundedRectSliderTrackShape(),
                  ),
                  child: Slider(
                    value: volume,
                    onChanged: (val) {
                      provider.setStemVolume(stem.index, val);
                    },
                  ),
                ),
              ),

              // Volume Percentage Text
              SizedBox(
                width: 40,
                child: Text(
                  '${(volume * 100).toInt()}%',
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    color: isActive ? Colors.white70 : Colors.white30,
                    fontSize: 12,
                    fontFeatures: const [FontFeature.tabularFigures()],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showSavePresetDialog(
    BuildContext context,
    AudioMixerProvider provider,
  ) {
    String name = '';
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF162534),
          title: const Text('保存混音预设', style: TextStyle(color: Colors.white)),
          content: TextField(
            autofocus: true,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: '输入预设名称',
              hintStyle: TextStyle(color: Colors.white.withOpacity(0.4)),
              enabledBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white30),
              ),
              focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: Color(0xFF6BBF7A)),
              ),
            ),
            onChanged: (val) {
              name = val;
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('取消', style: TextStyle(color: Colors.white54)),
            ),
            TextButton(
              onPressed: () {
                if (name.trim().isNotEmpty) {
                  provider.saveCurrentMix(name.trim());
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('已保存混音预设'),
                      duration: Duration(seconds: 1),
                    ),
                  );
                }
              },
              child: const Text(
                '保存',
                style: TextStyle(color: Color(0xFF6BBF7A)),
              ),
            ),
          ],
        );
      },
    );
  }
}
