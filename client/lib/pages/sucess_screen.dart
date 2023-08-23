import 'dart:convert';
import 'package:client/functions/enterCode.dart';
import 'package:client/widgets/CodetextBox.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
                  Padding(
                    padding: const EdgeInsets.fromLTRB(15, 50, 15, 100),
                    child: Column(
                      children: [
                        SizedBox(
                          width: 400,
                          child: Container(
                            color: _codeAccepted == false
                                ? Colors.red
                                : Colors.green,
                            child: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 12),
                                    child: Text(_message,
                                        style: GoogleFonts.openSans(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white,
                                          height: 1.3,
                                        )),
                                  ),
                                  Icon(
                                    _codeAccepted == false
                                        ? Icons.dangerous_outlined
                                        : Icons.check_circle,
                                    color: Colors.white,
                                    size: 35,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  _codeAccepted == false
                      ? Padding(
                          padding: const EdgeInsets.only(bottom: 30),
                          child: CodeTextBox(code: _code),
                        )
                      : const SizedBox(),
                  SizedBox(
                    width: 300,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: const ButtonStyle(
                        backgroundColor:
                            MaterialStatePropertyAll(Color(0xff21a7d9)),
                      ),
                      child: const Icon(Icons.camera_alt, color: Colors.white),
                    ),
                  ),
                  SizedBox(
                    width: 300,
                    child: ElevatedButton(
                      onPressed: () async {
                        //replace page with home
                        Navigator.popUntil(
                          context,
                          ModalRoute.withName('/home'),
                        );
                      },
                      style: const ButtonStyle(
                        backgroundColor:
                            MaterialStatePropertyAll(Color(0xff1e4383)),
                      ),
                      child: const Icon(Icons.home, color: Colors.white),
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
