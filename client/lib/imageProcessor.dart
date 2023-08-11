import 'dart:io';
import 'package:image/image.dart' as IMG;

class ImageProcessor {
  static Future cropPlz(String srcFilePath) async {
    var bytes = await File(srcFilePath).readAsBytes();
    IMG.Image src = IMG.decodeImage(bytes)!;

    int w = (src.width * 0.8).round();
    int offsetX = (src.width - w) ~/ 2;
    int offsetY = 503;

    IMG.Image destImage =
        IMG.copyCrop(src, x: offsetX, y: offsetY, width: w, height: 90);

    var jpg = IMG.encodeJpg(destImage);
    await File(srcFilePath).writeAsBytes(jpg);
  }
}
