import 'dart:convert';
import 'package:client/functions/enterCode.dart';
import 'package:client/widgets/CodetextBox.dart';
import 'package:flutter/material.dart';

class SucessScreen extends StatefulWidget {
  final String code;
  const SucessScreen({super.key, required this.code});

  @override
  State<SucessScreen> createState() => _SucessScreenState();
}

class _SucessScreenState extends State<SucessScreen> {
  bool _isBusy = false;
  bool _codeAccepted = false;
  String _message = '';
  String _code = '';

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
              child: Column(
                children: [
                  Text(_message),
                  _codeAccepted == false
                      ? CodeTextBox(code: _code)
                      : SizedBox(),
                  SizedBox(
                    width: 300,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Icon(Icons.camera_alt, color: Colors.grey),
                    ),
                  ),
                  SizedBox(
                    width: 300,
                    child: ElevatedButton(
                      onPressed: () {
                        //replace page with home
                        Navigator.popUntil(
                            context, ModalRoute.withName('/home'));
                      },
                      child: Icon(Icons.home, color: Colors.grey),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  @override
  void initState() {
    super.initState();
    // final InputImage inputImage = InputImage.fromFilePath(widget.imgPath);
    processCode(widget.code);
  }

  void processCode(String code) async {
    // final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
    setState(() {
      _isBusy = true;
    });

    // final RecognizedText recognizedText =
    // await textRecognizer.processImage(image);
    // print('text recognized');
    // print(recognizedText.text);

    final response = await EnterCode.enterCodeReq(widget.code);

    Map jsonResponse = jsonDecode(response.body);

    print(jsonResponse);
    int status = jsonResponse['status_code'];
    if (status == 0) {
      setState(() {
        _codeAccepted = true;
      });
    }

    setState(() {
      _code = widget.code;
      _message = jsonResponse['message'];
      _isBusy = false;
    });
  }
}
