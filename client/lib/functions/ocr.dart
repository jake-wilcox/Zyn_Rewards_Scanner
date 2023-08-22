import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

class OCR {
  static Future<String> ocr(String imgPath) async {
    final InputImage image = InputImage.fromFilePath(imgPath);
    final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
    final RecognizedText recognizedText =
        await textRecognizer.processImage(image);
    print(recognizedText.text);
    print('yuh');
    return recognizedText.text;
  }
}
