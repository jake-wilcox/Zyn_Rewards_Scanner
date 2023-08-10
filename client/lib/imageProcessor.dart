import 'dart:io';
import 'dart:math';
import 'package:flutter/rendering.dart';
import 'package:image/image.dart' as IMG;

class ImageProcessor {
  static Future cropPlz(
      String srcFilePath, String destFilePath, bool flip) async {
    var bytes = await File(srcFilePath).readAsBytes();
    IMG.Image src = IMG.decodeImage(bytes)!;

    int offsetX = (src.width - min(src.width, src.height)) ~/ 2;
    int offsetY = (src.height - min(src.width, src.height)) ~/ 2;

    IMG.Image destImage =
        IMG.copyCrop(src, x: offsetX, y: offsetY, width: 300, height: 100);

    if (flip) {
      destImage = IMG.flipVertical(destImage);
    }

    var jpg = IMG.encodeJpg(destImage);
    await File(srcFilePath).writeAsBytes(jpg);
  }
}
