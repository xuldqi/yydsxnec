import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:image_picker/image_picker.dart';
import 'package:record/record.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:just_audio/just_audio.dart';
import 'package:audioplayers/audioplayers.dart' as ap;
import 'dart:io';
import 'dart:async';
import '../theme/app_theme.dart';
import '../utils/audio_playback_helper.dart';
import '../services/ohos_native_service.dart';

class MediaPicker extends StatefulWidget {
  final List<String> imagePaths;
  final String? audioPath;
  final ValueChanged<String> onImageAdded;
  final ValueChanged<String> onImageRemoved;
  final ValueChanged<String?> onAudioChanged;

  /// 点击某张图片时回调（用于全屏预览），不设置则不可点击
  final void Function(String path)? onImageTap;

  const MediaPicker({
    super.key,
    required this.imagePaths,
    this.audioPath,
    required this.onImageAdded,
    required this.onImageRemoved,
    required this.onAudioChanged,
    this.onImageTap,
  });

  @override
  State<MediaPicker> createState() => _MediaPickerState();
}

class _MediaPickerState extends State<MediaPicker>
    with SingleTickerProviderStateMixin {
  final ImagePicker _imagePicker = ImagePicker();
  final AudioRecorder _audioRecorder = AudioRecorder();
  final AudioPlayer _audioPlayer = AudioPlayer();
  ap.AudioPlayer? _androidPlayer;

  late TabController _tabController;
  bool _isRecording = false;
  bool _isPlayingAudio = false;
  Duration _recordDuration = Duration.zero;
  Timer? _timer;
  Timer? _playbackResetTimer;

  double get _panelHeight {
    if (_tabController.index == 1) {
      return widget.audioPath == null ? 188 : 176;
    }
    if (widget.imagePaths.isEmpty) return 176;
    if (widget.imagePaths.length <= 3) return 186;
    if (widget.imagePaths.length <= 6) return 272;
    return 348;
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      if (!mounted) return;
      if (_tabController.indexIsChanging) return;
      setState(() {});
    });
    // 如果已有音频但没图片，默认显示音频页
    if (widget.audioPath != null && widget.imagePaths.isEmpty) {
      _tabController.index = 1;
    }
  }

  @override
  void dispose() {
    _audioRecorder.dispose();
    _audioPlayer.dispose();
    _androidPlayer?.dispose();
    unawaited(OhosNativeService.stopAudioFile());
    _timer?.cancel();
    _playbackResetTimer?.cancel();
    _tabController.dispose();
    super.dispose();
  }

  /// 仅在使用时申请：从相册选择（会触发相册/存储权限）
  Future<void> _pickImageFromGallery() async {
    if (kIsWeb) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Web平台图片功能暂未实现')));
      return;
    }
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
      );
      if (image != null) {
        widget.onImageAdded(image.path);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('选择图片失败: $e')));
      }
    }
  }

  /// 仅在使用时申请：拍照（会触发相机权限）
  Future<void> _pickImageFromCamera() async {
    if (kIsWeb) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Web平台图片功能暂未实现')));
      return;
    }
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.camera,
      );
      if (image != null) {
        widget.onImageAdded(image.path);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('拍照失败: $e')));
      }
    }
  }

  /// 展示相册/拍照选择，仅在用户点击对应选项时才请求相应权限
  void _showImageSourceChoice() {
    if (kIsWeb) {
      _pickImageFromGallery();
      return;
    }
    showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library_outlined),
                title: const Text('从相册选择'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImageFromGallery();
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt_outlined),
                title: const Text('拍照'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImageFromCamera();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 仅在使用时申请：用户点击「说出此刻的心情」时才请求麦克风权限
  Future<void> _startRecording() async {
    if (OhosNativeService.isOhos) {
      try {
        final path = await OhosNativeService.startRecording();
        if (path != null) {
          setState(() {
            _isRecording = true;
            _recordDuration = Duration.zero;
          });
          _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
            setState(() {
              _recordDuration += const Duration(seconds: 1);
            });
          });
        } else {
          if (mounted) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text('录音失败，请授予麦克风权限')));
          }
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('录音失败: $e')));
        }
      }
      return;
    }

    try {
      if (await _audioRecorder.hasPermission()) {
        final directory = await getApplicationDocumentsDirectory();
        final fileName = 'record_${DateTime.now().millisecondsSinceEpoch}.m4a';
        final path = p.join(directory.path, fileName);

        const config = RecordConfig();
        await _audioRecorder.start(config, path: path);

        setState(() {
          _isRecording = true;
          _recordDuration = Duration.zero;
        });

        _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
          setState(() {
            _recordDuration += const Duration(seconds: 1);
          });
        });
      } else {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('需要麦克风权限才能录音')));
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('录音失败: $e')));
      }
    }
  }

  Future<void> _stopRecording() async {
    try {
      _timer?.cancel();
      String? path;
      if (OhosNativeService.isOhos) {
        path = await OhosNativeService.stopRecording();
      } else {
        path = await _audioRecorder.stop();
      }

      setState(() {
        _isRecording = false;
      });

      if (path != null) {
        await Future.delayed(const Duration(milliseconds: 400));
        if (mounted) widget.onAudioChanged(path);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('停止录音失败: $e')));
      }
    }
  }

  Future<void> _playRecording() async {
    if (widget.audioPath == null) return;
    if (_isPlayingAudio) {
      await _stopPlayback();
      return;
    }
    final path = widget.audioPath!;
    final file = File(path);
    if (!file.existsSync()) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('录音文件不存在，无法播放')));
      }
      return;
    }
    final playablePath = await getPlayablePath(file.absolute.path);
    if (playablePath == null) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('无法准备播放')));
      }
      return;
    }
    try {
      if (mounted) {
        setState(() => _isPlayingAudio = true);
      }
      _playbackResetTimer?.cancel();
      if (OhosNativeService.isOhos) {
        final ok = await OhosNativeService.playAudioFile(file.absolute.path);
        if (!ok) {
          if (mounted) {
            setState(() => _isPlayingAudio = false);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('播放失败，请重新录制后再试'),
                duration: Duration(seconds: 3),
              ),
            );
          }
          return;
        }
      } else if (Platform.isAndroid) {
        _androidPlayer ??= ap.AudioPlayer();
        await _androidPlayer!.stop();
        await _androidPlayer!.setSource(ap.DeviceFileSource(playablePath));
        await _androidPlayer!.resume();
      } else {
        await _audioPlayer.stop();
        final fileUri = Uri.file(playablePath).toString();
        try {
          await _audioPlayer.setAudioSource(
            AudioSource.uri(Uri.parse(fileUri)),
          );
        } catch (_) {
          await _audioPlayer.setUrl(fileUri);
        }
        await _audioPlayer.seek(Duration.zero);
        await _audioPlayer.play();
      }
      _playbackResetTimer = Timer(const Duration(seconds: 30), () {
        if (mounted) setState(() => _isPlayingAudio = false);
      });
    } catch (e, st) {
      debugPrint('Playback error: $e\n$st');
      if (mounted) setState(() => _isPlayingAudio = false);
      if (mounted) {
        final errorMsg =
            e.toString().contains('MissingPluginException') ||
                e.toString().contains('UnimplementedError')
            ? '当前系统暂不支持语音播放'
            : '播放失败: $e';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMsg),
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  Future<void> _stopPlayback() async {
    _playbackResetTimer?.cancel();
    _playbackResetTimer = null;
    try {
      if (OhosNativeService.isOhos) {
        await OhosNativeService.stopAudioFile();
      } else if (Platform.isAndroid) {
        await _androidPlayer?.stop();
      } else {
        await _audioPlayer.stop();
      }
    } catch (_) {}
    if (mounted) setState(() => _isPlayingAudio = false);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.cardBackground,
        borderRadius: BorderRadius.circular(AppTheme.radiusL),
        boxShadow: AppTheme.lightCardShadow,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppTheme.paddingM,
              12,
              AppTheme.paddingM,
              6,
            ),
            child: _buildMediaTabSwitcher(),
          ),
          AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeOutCubic,
            height: _panelHeight,
            child: TabBarView(
              controller: _tabController,
              children: [_buildPhotoPanel(), _buildAudioPanel()],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMediaTabSwitcher() {
    return Row(
      children: [
        Expanded(
          child: _buildMediaTabItem(
            index: 0,
            icon: Icons.photo_library_outlined,
            label: '添加照片',
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _buildMediaTabItem(
            index: 1,
            icon: Icons.mic_none_outlined,
            label: '语音心情',
          ),
        ),
      ],
    );
  }

  Widget _buildMediaTabItem({
    required int index,
    required IconData icon,
    required String label,
  }) {
    final isSelected = _tabController.index == index;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          if (_tabController.index == index) return;
          _tabController.animateTo(index);
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOutCubic,
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected
                ? AppTheme.primaryColor.withAlpha(20)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected
                  ? AppTheme.primaryColor.withAlpha(128)
                  : Colors.transparent,
              width: 1.3,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 20,
                color: isSelected
                    ? AppTheme.primaryColor
                    : AppTheme.secondaryText.withAlpha(180),
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                  color: isSelected
                      ? AppTheme.primaryColor
                      : AppTheme.secondaryText.withAlpha(190),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPhotoPanel() {
    return Padding(
      padding: EdgeInsets.all(AppTheme.paddingM),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final panelWidth = constraints.maxWidth;
          final crossAxisCount = panelWidth < 280 ? 2 : 3;
          final addTileCount = widget.imagePaths.length < 9 ? 1 : 0;

          return Column(
            children: [
              if (widget.imagePaths.isEmpty)
                Expanded(
                  child: GestureDetector(
                    onTap: _showImageSourceChoice,
                    child: Container(
                      width: double.infinity,
                      constraints: const BoxConstraints(minHeight: 150),
                      padding: const EdgeInsets.fromLTRB(20, 18, 20, 16),
                      decoration: BoxDecoration(
                        color: AppTheme.surfaceColor,
                        borderRadius: BorderRadius.circular(AppTheme.radiusM),
                        border: Border.all(
                          color: AppTheme.borderColor,
                          width: 1.0,
                          style: BorderStyle.solid,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.add_a_photo_outlined,
                            size: 32,
                            color: AppTheme.lightText,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '选择照片',
                            textAlign: TextAlign.center,
                            style: AppTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              else
                Expanded(
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                      childAspectRatio: panelWidth < 280 ? 0.92 : 1,
                    ),
                    itemCount: widget.imagePaths.length + addTileCount,
                    itemBuilder: (context, index) {
                      if (index < widget.imagePaths.length) {
                        return _buildImageItem(widget.imagePaths[index]);
                      }
                      return GestureDetector(
                        onTap: _showImageSourceChoice,
                        child: Container(
                          constraints: const BoxConstraints(
                            minWidth: 84,
                            minHeight: 84,
                          ),
                          decoration: BoxDecoration(
                            color: AppTheme.primaryColor.withAlpha(14),
                            borderRadius: BorderRadius.circular(
                              AppTheme.radiusM,
                            ),
                            border: Border.all(
                              color: AppTheme.primaryColor.withAlpha(120),
                              width: 1.1,
                            ),
                          ),
                          child: const Icon(
                            Icons.add,
                            color: AppTheme.primaryColor,
                            size: 24,
                          ),
                        ),
                      );
                    },
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildAudioPanel() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(AppTheme.paddingM),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_isRecording) ...[
              const _RecordingPulse(),
              const SizedBox(height: 6),
              Text(
                '${_recordDuration.inMinutes}:${(_recordDuration.inSeconds % 60).toString().padLeft(2, '0')}',
                style: const TextStyle(
                  color: AppTheme.sadColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 12),
              ElevatedButton.icon(
                onPressed: _stopRecording,
                icon: const Icon(Icons.stop, size: 20),
                label: const Text('停止录音'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.sadColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                ),
              ),
            ] else if (widget.audioPath == null) ...[
              Icon(
                Icons.mic_none,
                size: 44,
                color: AppTheme.primaryColor.withAlpha(160),
              ),
              const SizedBox(height: 12),
              ElevatedButton.icon(
                onPressed: _startRecording,
                icon: const Icon(Icons.mic, size: 20),
                label: const Text('说出此刻的心情'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                  foregroundColor: Colors.white,
                  elevation: 1.5,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                ),
              ),
            ] else ...[
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppTheme.paddingM,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withAlpha(14),
                  border: Border.all(
                    color: AppTheme.primaryColor.withAlpha(120),
                    width: 1.2,
                  ),
                  borderRadius: BorderRadius.circular(AppTheme.radiusM),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.audiotrack,
                      color: AppTheme.primaryColor,
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Text(
                        '已录制一段语音',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: AppTheme.primaryText,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Container(
                        decoration: BoxDecoration(
                          color: _isPlayingAudio
                              ? AppTheme.sadColor.withAlpha(220)
                              : AppTheme.primaryColor.withAlpha(220),
                          shape: BoxShape.circle,
                        ),
                        padding: const EdgeInsets.all(2),
                        child: Icon(
                          _isPlayingAudio ? Icons.stop : Icons.play_arrow,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                      onPressed: _playRecording,
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.delete_outline,
                        color: AppTheme.sadColor,
                        size: 22,
                      ),
                      onPressed: () => widget.onAudioChanged(null),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _isPlayingAudio ? '正在播放录音，点击红色按钮可停止' : '点击播放听听看',
                style: const TextStyle(
                  color: AppTheme.secondaryText,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildImageItem(String path) {
    return Stack(
      children: [
        GestureDetector(
          onTap: widget.onImageTap != null
              ? () => widget.onImageTap!(path)
              : null,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppTheme.radiusM),
              border: Border.all(
                color: AppTheme.primaryColor.withAlpha(130),
                width: 1.2,
              ),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x22000000),
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
              image: DecorationImage(
                image: FileImage(File(path)),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        Positioned(
          top: 2,
          right: 2,
          child: GestureDetector(
            onTap: () => widget.onImageRemoved(path),
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: const BoxDecoration(
                color: Colors.black54,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.close, size: 12, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}

class _RecordingPulse extends StatefulWidget {
  const _RecordingPulse();

  @override
  State<_RecordingPulse> createState() => _RecordingPulseState();
}

class _RecordingPulseState extends State<_RecordingPulse>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppTheme.sadColor.withValues(
              alpha: 0.2 + (0.3 * _controller.value),
            ),
            shape: BoxShape.circle,
          ),
          child: Icon(Icons.mic, color: AppTheme.sadColor, size: 32),
        );
      },
    );
  }
}
