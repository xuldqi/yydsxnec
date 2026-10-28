import 'dart:async';
import 'dart:io';
import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

class LocalOutlineService {
  static const MethodChannel _segmentationChannel = MethodChannel(
    'xiaolu_water/segmentation',
  );

  static bool enableLegacyFallback = true;

  static const int _edgeThreshold = 46;
  static const int _strokeRadius = 2;
  static const int _stickerOutlineRadius = 30;

  Future<String?> createWhiteOutline(File sourceFile) async {
    return createCutoutSticker(sourceFile);
  }

  Future<String?> createCutoutSticker(File sourceFile) async {
    try {
      if (!await sourceFile.exists()) return null;

      final nativeStickerPath = await _createNativeSticker(sourceFile.path);
      if (nativeStickerPath != null) return nativeStickerPath;

      if (!enableLegacyFallback) return null;

      final bytes = await sourceFile.readAsBytes();
      final codec = await ui.instantiateImageCodec(bytes);
      final frame = await codec.getNextFrame();
      final image = frame.image;
      final byteData = await image.toByteData(
        format: ui.ImageByteFormat.rawRgba,
      );
      if (byteData == null) return null;

      final width = image.width;
      final height = image.height;
      final pixels = byteData.buffer.asUint8List();
      final sticker = _buildStickerPixels(pixels, width, height);
      final pngBytes = await _encodePng(sticker, width, height);
      if (pngBytes == null) return null;

      final dir = await getApplicationDocumentsDirectory();
      final output = File(
        '${dir.path}/drink_sticker_${DateTime.now().microsecondsSinceEpoch}.png',
      );
      await output.writeAsBytes(pngBytes, flush: true);
      return output.path;
    } catch (error) {
      debugPrint('Native segmentation failed: $error');
      return null;
    }
  }

  Future<String?> _createNativeSticker(String sourcePath) async {
    if (kIsWeb) return null;
    try {
      final isOhos =
          Platform.operatingSystem == 'ohos' ||
          Platform.operatingSystem == 'harmonyos';
      if (!Platform.isAndroid && !isOhos) return null;
      final path = await _segmentationChannel.invokeMethod<String>(
        'createSticker',
        {'path': sourcePath},
      );
      if (path == null || path.trim().isEmpty) return null;
      return path;
    } catch (_) {
      return null;
    }
  }

  Uint8List _buildStickerPixels(Uint8List pixels, int width, int height) {
    final gradient = _buildGradient(pixels, width, height);
    final background = _estimateBackgroundColor(pixels, width, height);
    final candidate = _buildForegroundCandidate(
      pixels,
      gradient,
      background,
      width,
      height,
    );
    var mask = _selectMainComponent(candidate, width, height);

    if (!_hasMask(mask)) {
      return _buildOutlinePixels(pixels, width, height);
    }

    mask = _dilateMask(mask, width, height, 2);
    mask = _erodeMask(mask, width, height, 2);
    mask = _dilateMask(mask, width, height, 1);

    final outlineMask = _dilateMask(mask, width, height, _stickerOutlineRadius);
    final softInnerMask = _erodeMask(mask, width, height, 1);
    final result = Uint8List(width * height * 4);

    for (var i = 0; i < width * height; i++) {
      final p = i * 4;
      if (outlineMask[i] != 0 && mask[i] == 0) {
        result[p] = 255;
        result[p + 1] = 255;
        result[p + 2] = 255;
        result[p + 3] = 255;
      }

      if (mask[i] == 0) continue;
      result[p] = pixels[p];
      result[p + 1] = pixels[p + 1];
      result[p + 2] = pixels[p + 2];
      result[p + 3] = softInnerMask[i] != 0 ? 255 : 230;
    }

    return result;
  }

  Float32List _buildGradient(Uint8List pixels, int width, int height) {
    final gray = Float32List(width * height);
    for (var i = 0; i < width * height; i++) {
      final p = i * 4;
      gray[i] =
          0.299 * pixels[p] + 0.587 * pixels[p + 1] + 0.114 * pixels[p + 2];
    }

    final magnitude = Float32List(width * height);
    var maxMagnitude = 0.0;
    for (var y = 1; y < height - 1; y++) {
      for (var x = 1; x < width - 1; x++) {
        final i = y * width + x;
        final gx =
            -gray[(y - 1) * width + x - 1] +
            gray[(y - 1) * width + x + 1] -
            2 * gray[y * width + x - 1] +
            2 * gray[y * width + x + 1] -
            gray[(y + 1) * width + x - 1] +
            gray[(y + 1) * width + x + 1];
        final gy =
            -gray[(y - 1) * width + x - 1] -
            2 * gray[(y - 1) * width + x] -
            gray[(y - 1) * width + x + 1] +
            gray[(y + 1) * width + x - 1] +
            2 * gray[(y + 1) * width + x] +
            gray[(y + 1) * width + x + 1];
        final value = math.sqrt(gx * gx + gy * gy);
        magnitude[i] = value;
        if (value > maxMagnitude) maxMagnitude = value;
      }
    }

    if (maxMagnitude <= 0) return magnitude;
    for (var i = 0; i < magnitude.length; i++) {
      magnitude[i] = (magnitude[i] / maxMagnitude).clamp(0, 1).toDouble();
    }
    return magnitude;
  }

  List<double> _estimateBackgroundColor(
    Uint8List pixels,
    int width,
    int height,
  ) {
    final margin = math.max(6, (math.min(width, height) * 0.06).round());
    final step = math.max(1, (math.min(width, height) / 180).round());
    var r = 0.0;
    var g = 0.0;
    var b = 0.0;
    var count = 0;

    for (var y = 0; y < height; y += step) {
      for (var x = 0; x < width; x += step) {
        if (x > margin &&
            x < width - margin &&
            y > margin &&
            y < height - margin) {
          continue;
        }
        final p = (y * width + x) * 4;
        r += pixels[p];
        g += pixels[p + 1];
        b += pixels[p + 2];
        count++;
      }
    }

    if (count == 0) return [255, 255, 255];
    return [r / count, g / count, b / count];
  }

  Uint8List _buildForegroundCandidate(
    Uint8List pixels,
    Float32List gradient,
    List<double> background,
    int width,
    int height,
  ) {
    final candidate = Uint8List(width * height);
    final cx = (width - 1) / 2;
    final cy = (height - 1) / 2;
    final maxDistance = math.sqrt(cx * cx + cy * cy);

    for (var y = 0; y < height; y++) {
      for (var x = 0; x < width; x++) {
        final i = y * width + x;
        final p = i * 4;
        final dr = pixels[p] - background[0];
        final dg = pixels[p + 1] - background[1];
        final db = pixels[p + 2] - background[2];
        final colorDistance = math.sqrt(dr * dr + dg * dg + db * db);
        final dx = x - cx;
        final dy = y - cy;
        final centerWeight =
            1 - (math.sqrt(dx * dx + dy * dy) / maxDistance).clamp(0, 1);
        final edgeBoost = gradient[i] * 85;
        final score = colorDistance + edgeBoost + centerWeight * 24;

        if (score > 58 && (colorDistance > 24 || gradient[i] > 0.22)) {
          candidate[i] = 1;
        }
      }
    }

    return _dilateMask(candidate, width, height, 1);
  }

  Uint8List _selectMainComponent(Uint8List candidate, int width, int height) {
    final total = width * height;
    final labels = Int32List(total);
    final queue = Int32List(total);
    var bestLabel = 0;
    var bestScore = 0.0;
    var label = 0;
    final cx = (width - 1) / 2;
    final cy = (height - 1) / 2;
    final maxDistance = math.sqrt(cx * cx + cy * cy);

    for (var start = 0; start < total; start++) {
      if (candidate[start] == 0 || labels[start] != 0) continue;

      label++;
      var head = 0;
      var tail = 0;
      queue[tail++] = start;
      labels[start] = label;

      var count = 0;
      var centerScore = 0.0;
      var touchesBorder = false;

      while (head < tail) {
        final current = queue[head++];
        final x = current % width;
        final y = current ~/ width;
        count++;

        if (x < 2 || y < 2 || x >= width - 2 || y >= height - 2) {
          touchesBorder = true;
        }

        final dx = x - cx;
        final dy = y - cy;
        centerScore +=
            1 - (math.sqrt(dx * dx + dy * dy) / maxDistance).clamp(0, 1);

        void addNeighbor(int next) {
          if (candidate[next] == 0 || labels[next] != 0) return;
          labels[next] = label;
          queue[tail++] = next;
        }

        if (x > 0) addNeighbor(current - 1);
        if (x < width - 1) addNeighbor(current + 1);
        if (y > 0) addNeighbor(current - width);
        if (y < height - 1) addNeighbor(current + width);
      }

      if (count < total * 0.002) continue;
      final averageCenterScore = centerScore / count;
      var score = count * (0.4 + averageCenterScore);
      if (touchesBorder) score *= 0.38;
      if (score > bestScore) {
        bestScore = score;
        bestLabel = label;
      }
    }

    final mask = Uint8List(total);
    if (bestLabel == 0) return mask;
    for (var i = 0; i < total; i++) {
      if (labels[i] == bestLabel) mask[i] = 1;
    }
    return mask;
  }

  bool _hasMask(Uint8List mask) {
    for (final value in mask) {
      if (value != 0) return true;
    }
    return false;
  }

  Uint8List _dilateMask(Uint8List mask, int width, int height, int radius) {
    if (radius <= 0) return Uint8List.fromList(mask);
    final result = Uint8List(width * height);
    final radiusSquared = radius * radius;
    for (var y = 0; y < height; y++) {
      for (var x = 0; x < width; x++) {
        final i = y * width + x;
        if (mask[i] == 0) continue;
        for (var dy = -radius; dy <= radius; dy++) {
          final yy = y + dy;
          if (yy < 0 || yy >= height) continue;
          for (var dx = -radius; dx <= radius; dx++) {
            if (dx * dx + dy * dy > radiusSquared) continue;
            final xx = x + dx;
            if (xx < 0 || xx >= width) continue;
            result[yy * width + xx] = 1;
          }
        }
      }
    }
    return result;
  }

  Uint8List _erodeMask(Uint8List mask, int width, int height, int radius) {
    if (radius <= 0) return Uint8List.fromList(mask);
    final result = Uint8List(width * height);
    final radiusSquared = radius * radius;
    for (var y = 0; y < height; y++) {
      for (var x = 0; x < width; x++) {
        var keep = true;
        for (var dy = -radius; dy <= radius && keep; dy++) {
          final yy = y + dy;
          if (yy < 0 || yy >= height) {
            keep = false;
            break;
          }
          for (var dx = -radius; dx <= radius; dx++) {
            if (dx * dx + dy * dy > radiusSquared) continue;
            final xx = x + dx;
            if (xx < 0 || xx >= width || mask[yy * width + xx] == 0) {
              keep = false;
              break;
            }
          }
        }
        if (keep) result[y * width + x] = 1;
      }
    }
    return result;
  }

  Uint8List _buildOutlinePixels(Uint8List pixels, int width, int height) {
    final gray = Float32List(width * height);
    for (var i = 0; i < width * height; i++) {
      final p = i * 4;
      gray[i] =
          0.299 * pixels[p] + 0.587 * pixels[p + 1] + 0.114 * pixels[p + 2];
    }

    final magnitude = Float32List(width * height);
    var maxMagnitude = 0.0;
    for (var y = 1; y < height - 1; y++) {
      for (var x = 1; x < width - 1; x++) {
        final i = y * width + x;
        final gx =
            -gray[(y - 1) * width + x - 1] +
            gray[(y - 1) * width + x + 1] -
            2 * gray[y * width + x - 1] +
            2 * gray[y * width + x + 1] -
            gray[(y + 1) * width + x - 1] +
            gray[(y + 1) * width + x + 1];
        final gy =
            -gray[(y - 1) * width + x - 1] -
            2 * gray[(y - 1) * width + x] -
            gray[(y - 1) * width + x + 1] +
            gray[(y + 1) * width + x - 1] +
            2 * gray[(y + 1) * width + x] +
            gray[(y + 1) * width + x + 1];
        final value = math.sqrt(gx * gx + gy * gy);
        magnitude[i] = value;
        if (value > maxMagnitude) maxMagnitude = value;
      }
    }

    final scale = maxMagnitude > 0 ? 255 / maxMagnitude : 1.0;
    final edgeMask = Uint8List(width * height);
    for (var i = 0; i < width * height; i++) {
      if (magnitude[i] * scale > _edgeThreshold) {
        edgeMask[i] = 255;
      }
    }

    final result = Uint8List(width * height * 4);
    for (var y = 0; y < height; y++) {
      for (var x = 0; x < width; x++) {
        var strongest = 0;
        for (var dy = -_strokeRadius; dy <= _strokeRadius; dy++) {
          final yy = y + dy;
          if (yy < 0 || yy >= height) continue;
          for (var dx = -_strokeRadius; dx <= _strokeRadius; dx++) {
            final xx = x + dx;
            if (xx < 0 || xx >= width) continue;
            if (dx * dx + dy * dy > _strokeRadius * _strokeRadius) continue;
            strongest = math.max(strongest, edgeMask[yy * width + xx]);
          }
        }

        if (strongest == 0) continue;
        final p = (y * width + x) * 4;
        result[p] = 255;
        result[p + 1] = 255;
        result[p + 2] = 255;
        result[p + 3] = strongest;
      }
    }
    return result;
  }

  Future<Uint8List?> _encodePng(Uint8List pixels, int width, int height) async {
    final completer = Completer<ui.Image>();
    ui.decodeImageFromPixels(
      pixels,
      width,
      height,
      ui.PixelFormat.rgba8888,
      completer.complete,
    );
    final image = await completer.future;
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    return byteData?.buffer.asUint8List();
  }
}
