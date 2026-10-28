import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../services/media_gallery_service.dart';
import '../services/ocr_service.dart';
import '../services/record_draft_service.dart';
import '../services/local_outline_service.dart';
import '../../../../core/theme/app_colors.dart';
import '../utils/navigation_helper.dart';
import '../widgets/capwords_sticker_stage.dart';

class PhotoOcrPage extends StatefulWidget {
  final Map<String, dynamic>? initialPrefill;

  const PhotoOcrPage({super.key, this.initialPrefill});

  @override
  State<PhotoOcrPage> createState() => _PhotoOcrPageState();
}

enum _PhotoFlowState { camera, processing, preview, error }

class _PhotoOcrPageState extends State<PhotoOcrPage> {
  final ImagePicker _imagePicker = ImagePicker();
  final RecordDraftService _recordDraftService = RecordDraftService();

  CameraController? _cameraController;
  Future<void>? _cameraInitFuture;
  _PhotoFlowState _flowState = _PhotoFlowState.camera;
  String? _capturedImagePath;
  String? _errorMessage;
  Map<String, dynamic>? _recordExtra;
  bool _galleryBackupDone = false;
  bool _enableCutout = true;

  static const List<String> _categories = [
    '奶茶',
    '果茶',
    '咖啡',
    '白开水',
    '瓶装饮品',
    '其他',
  ];
  static const List<String> _sizes = ['小杯', '中杯', '大杯', '超大杯'];

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  Future<void> _initCamera() async {
    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) {
        throw StateError('没有可用摄像头');
      }
      final backCamera = cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.back,
        orElse: () => cameras.first,
      );
      final controller = CameraController(
        backCamera,
        ResolutionPreset.high,
        enableAudio: false,
        imageFormatGroup: ImageFormatGroup.jpeg,
      );
      _cameraController = controller;
      _cameraInitFuture = controller.initialize();
      await _cameraInitFuture;
      if (mounted) setState(() {});
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _flowState = _PhotoFlowState.error;
        _errorMessage = '相机不可用，可从相册选择';
      });
    }
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  Future<void> _captureAndRecognize() async {
    final controller = _cameraController;
    if (controller == null ||
        !controller.value.isInitialized ||
        controller.value.isTakingPicture) {
      return;
    }

    try {
      final image = await controller.takePicture();
      await _saveCapturedPhotoToGallery(image.path);
      await _processImage(image.path);
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _flowState = _PhotoFlowState.error;
        _errorMessage = '拍照失败，可重新尝试';
      });
    }
  }

  Future<void> _pickFromGallery() async {
    final image = await _imagePicker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 88,
      maxWidth: 1280,
      maxHeight: 1280,
    );
    if (image == null) return;
    await _processImage(image.path);
  }

  Future<void> _processImage(String imagePath) async {
    if (!mounted) return;
    setState(() {
      _flowState = _PhotoFlowState.processing;
      _capturedImagePath = imagePath;
      _recordExtra = null;
      _errorMessage = null;
    });

    try {
      final imageFile = File(imagePath);

      final ocrService = OCRService();
      if (!ocrService.isInitialized) {
        await ocrService.initialize(
          OCRConfig(apiKey: '', baseUrl: 'local-device'),
        );
      }

      final result = await ocrService.recognizeFromFile(imageFile);
      
      String? stickerPath;
      if (_enableCutout) {
        try {
          final outlineService = LocalOutlineService();
          stickerPath = await outlineService.createCutoutSticker(imageFile);
        } catch (e) {
          debugPrint('Failed to generate sticker: $e');
        }
      }
      final finalImagePath = stickerPath ?? imagePath;

      final extra = _buildRecordExtra(result: result, imagePath: finalImagePath);

      if (!mounted) return;
      setState(() {
        _flowState = _PhotoFlowState.preview;
        _recordExtra = extra;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _flowState = _PhotoFlowState.preview;
        _recordExtra = {
          'category': '瓶装饮品',
          'imagePath': imagePath,
          'originalImagePath': imagePath,
          'from_photo_record': true,
          'ocr_error': '识别不可用，可手动填写',
        };
      });
    }
  }

  Map<String, dynamic> _buildRecordExtra({
    required OCRResult result,
    required String imagePath,
  }) {
    if (!result.success) {
      return {
        'category': '瓶装饮品',
        'imagePath': imagePath,
        'originalImagePath': imagePath,
        'from_photo_record': true,
        'ocr_error': result.errorMessage ?? '识别失败，可手动填写',
      };
    }

    final draft = _recordDraftService.draftFromOcr(
      result: result,
      currentName: '',
      currentCategory: '瓶装饮品',
      currentSize: '中杯',
      categories: _categories,
      sizes: _sizes,
    );

    return {
      'name': draft.name,
      'category': draft.category,
      'size': draft.size,
      'volume': double.tryParse(draft.volumeText),
      'sugar': double.tryParse(draft.sugarText),
      'fat': double.tryParse(draft.fatText),
      'protein': double.tryParse(draft.proteinText),
      'caffeine': double.tryParse(draft.caffeineText),
      'calories': double.tryParse(draft.caloriesText),
      'imagePath': imagePath,
      'originalImagePath': imagePath,
      'from_photo_record': true,
    };
  }

  Future<void> _saveCapturedPhotoToGallery(String imagePath) async {
    final result = await MediaGalleryService.saveImageToGallery(imagePath);
    if (!mounted) return;
    _galleryBackupDone = result.success;
  }

  void _confirmRecord() {
    final extra = _recordExtra;
    if (extra == null) return;
    context.push('/record', extra: _mergeWithInitialPrefill(extra));
  }

  Map<String, dynamic> _mergeWithInitialPrefill(Map<String, dynamic> extra) {
    final initialPrefill = widget.initialPrefill;
    if (initialPrefill == null || initialPrefill.isEmpty) return extra;

    final merged = <String, dynamic>{...initialPrefill};
    extra.forEach((key, value) {
      if (value == null) return;
      if (value is String && value.trim().isEmpty) return;
      merged[key] = value;
    });
    return merged;
  }

  void _retake() {
    setState(() {
      _flowState = _PhotoFlowState.camera;
      _capturedImagePath = null;
      _recordExtra = null;
      _errorMessage = null;
      _galleryBackupDone = false;
    });
    if (_cameraController == null || _cameraInitFuture == null) {
      _initCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('拍照记录'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => goBackOr(context, '/home'),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Center(
                child: GestureDetector(
                  onTap: () => setState(() => _enableCutout = !_enableCutout),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: _enableCutout ? AppColors.primary : const Color(0xFFE5E5E5),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          _enableCutout ? Icons.auto_awesome_rounded : Icons.image_rounded,
                          size: 18,
                          color: _enableCutout ? Colors.white : const Color(0xFF7A7A7A),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          '智能抠图',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: _enableCutout ? Colors.white : const Color(0xFF7A7A7A),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(18, 16, 18, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(child: _buildStage()),
              const SizedBox(height: 16),
              _buildActions(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStage() {
    switch (_flowState) {
      case _PhotoFlowState.camera:
        return _buildCameraStage();
      case _PhotoFlowState.processing:
        return _buildProcessingStage();
      case _PhotoFlowState.preview:
        return _buildPreviewStage();
      case _PhotoFlowState.error:
        return _buildErrorStage();
    }
  }

  Widget _buildCameraStage() {
    final controller = _cameraController;
    if (controller == null || _cameraInitFuture == null) {
      return const Center(child: CircularProgressIndicator(strokeWidth: 3));
    }

    return FutureBuilder<void>(
      future: _cameraInitFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator(strokeWidth: 3));
        }
        return ClipRRect(
          borderRadius: BorderRadius.circular(28),
          child: Stack(
            fit: StackFit.expand,
            children: [
              CameraPreview(controller),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.82),
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(28),
                ),
              ),
              Positioned(
                left: 18,
                right: 18,
                bottom: 18,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.34),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: const Text(
                    '对准饮品或包装，拍下后本地识别',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildProcessingStage() {
    final imagePath = _capturedImagePath;
    return ClipRRect(
      borderRadius: BorderRadius.circular(28),
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (imagePath != null)
            Image.file(File(imagePath), fit: BoxFit.cover)
          else
            Container(color: const Color(0xFFF1F0EC)),
          Container(color: Colors.black.withValues(alpha: 0.22)),
          const Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(color: Colors.white, strokeWidth: 3),
                SizedBox(height: 14),
                Text(
                  '正在识别照片',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPreviewStage() {
    final extra = _recordExtra;
    final imagePath = extra?['imagePath'] as String? ?? _capturedImagePath;
    if (imagePath == null) return _buildErrorStage();
    
    // If it's a generated sticker, show it with CapWordsStickerStage for the "paper-cut" feel
    final isSticker = extra != null && extra['imagePath'] != extra['originalImagePath'];
    
    if (isSticker) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Container(color: const Color(0xFFD4D4D4)),
            Center(
              child: Hero(
                tag: 'record_image_preview',
                child: Material(
                  color: Colors.transparent,
                  child: CapWordsStickerStage(
                    imagePath: imagePath,
                    title: extra['name'] as String? ?? '饮品',
                    price: null,
                    showCaption: false,
                    backgroundColor: Colors.transparent,
                  ),
                ),
              ),
            ),
            Positioned(
              left: 16,
              right: 16,
              bottom: 16,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.36),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  _galleryBackupDone ? '原图已保存到系统相册' : '已保留原图',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(28),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.file(
            File(imagePath),
            fit: BoxFit.cover,
            filterQuality: FilterQuality.high,
          ),
          Positioned(
            left: 16,
            right: 16,
            bottom: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.36),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                _galleryBackupDone ? '原图已保存到系统相册' : '已保留原图',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorStage() {
    return Center(
      child: Text(
        _errorMessage ?? '拍照记录不可用',
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: AppColors.textSecondary,
          fontSize: 15,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _buildActions() {
    switch (_flowState) {
      case _PhotoFlowState.camera:
        return SizedBox(
          height: 86,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Positioned(
                left: 16,
                child: IconButton(
                  tooltip: '相册',
                  iconSize: 28,
                  icon: const Icon(Icons.photo_library_rounded, color: AppColors.primary),
                  onPressed: _pickFromGallery,
                ),
              ),
              Semantics(
                button: true,
                label: '拍照',
                child: GestureDetector(
                  onTap: _captureAndRecognize,
                  child: Container(
                    width: 74,
                    height: 74,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFFFFFBF8),
                      border: Border.all(
                        color: AppColors.primary.withValues(alpha: 0.22),
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.18),
                          blurRadius: 18,
                          offset: const Offset(0, 7),
                        ),
                      ],
                    ),
                    alignment: Alignment.center,
                    child: Container(
                      width: 56,
                      height: 56,
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.camera_alt_rounded,
                        color: Colors.white,
                        size: 26,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      case _PhotoFlowState.processing:
        return const SizedBox(height: 52, child: Center(child: Text('处理中...')));
      case _PhotoFlowState.preview:
        return Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: _retake,
                icon: const Icon(Icons.refresh_rounded),
                label: const Text('重拍'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: _confirmRecord,
                icon: const Icon(Icons.check_rounded),
                label: const Text('确认使用'),
              ),
            ),
          ],
        );
      case _PhotoFlowState.error:
        return SizedBox(
          height: 52,
          child: Center(
            child: ElevatedButton.icon(
              onPressed: _retake,
              icon: const Icon(Icons.camera_alt_rounded),
              label: const Text('重试'),
            ),
          ),
        );
    }
  }
}
