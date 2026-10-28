import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class MediaGalleryResult {
  final bool success;
  final String? uri;
  final String? message;

  const MediaGalleryResult({required this.success, this.uri, this.message});

  factory MediaGalleryResult.fromMap(Map<dynamic, dynamic>? map) {
    if (map == null) {
      return const MediaGalleryResult(success: false, message: '相册保存不可用');
    }
    return MediaGalleryResult(
      success: map['success'] == true,
      uri: map['uri']?.toString(),
      message: map['message']?.toString(),
    );
  }
}

class MediaGalleryService {
  MediaGalleryService._();

  static const MethodChannel _channel = MethodChannel('xiaolu_water/media');

  static Future<MediaGalleryResult> saveImageToGallery(String imagePath) async {
    if (kIsWeb || imagePath.trim().isEmpty) {
      return const MediaGalleryResult(success: false, message: '当前平台不支持相册保存');
    }

    try {
      final result = await _channel.invokeMapMethod<String, dynamic>(
        'saveImageToGallery',
        {'path': imagePath},
      );
      return MediaGalleryResult.fromMap(result);
    } on MissingPluginException {
      return const MediaGalleryResult(success: false, message: '当前平台未接入相册保存');
    } on PlatformException catch (error) {
      return MediaGalleryResult(
        success: false,
        message: error.message ?? '相册保存失败',
      );
    }
  }
}
