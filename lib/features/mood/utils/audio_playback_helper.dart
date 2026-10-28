import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

/// 获取用于 just_audio 播放的本地文件路径。
/// 在 Android 上部分机型/版本对 app 私有目录路径支持不稳定，先复制到临时目录再播可提高兼容性。
Future<String?> getPlayablePath(String filePath) async {
  final file = File(filePath);
  if (!file.existsSync()) return null;
  final absolutePath = file.absolute.path;

  if (!Platform.isAndroid) {
    return absolutePath;
  }

  try {
    final dir = await getTemporaryDirectory();
    final name = p.basename(absolutePath);
    final tempFile = File(p.join(dir.path, 'play_$name'));
    await tempFile.writeAsBytes(await file.readAsBytes());
    return tempFile.absolute.path;
  } catch (_) {
    return absolutePath;
  }
}
