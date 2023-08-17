import 'package:flutter/material.dart';
import 'dart:io';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

class SucessScreen extends StatefulWidget {
  final String imgPath;
  const SucessScreen({super.key, required this.imgPath});

  @override
  State<SucessScreen> createState() => _SucessScreenState();
}

class _SucessScreenState extends State<SucessScreen> {
  bool _isBusy = false;
  bool _codeAccepted = false;

  @override
  void initState() {
    super.initState();
    final InputImage inputImage = InputImage.fromFilePath(widget.imgPath);
    process(inputImage);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('sucess screen')),
      // The image is stored as a file on the device. Use the `Image.file`
      // constructor with the given path to display the image.
      body: _isBusy == true
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Center(
              child: Image.file(File(widget.imgPath)),
            ),
    );
  }

  void process(InputImage image) async {
    final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
    setState(() {
      _isBusy = true;
    });

    final RecognizedText recognizedText =
        await textRecognizer.processImage(image);
    print('text recognized');
    print(recognizedText.text);
    _codeAccepted = true;

    setState(() {
      _isBusy = false;
    });
  }
}
