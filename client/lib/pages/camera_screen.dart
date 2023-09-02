import 'package:client/functions/imageProcessor.dart';
import 'package:client/functions/ocr.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'dart:io';

class CameraScreen extends StatefulWidget {
  const CameraScreen({Key? key}) : super(key: key);

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  late List<CameraDescription> cameras;
  late CameraController cameraController;

  @override
  void initState() {
    startCamera();
    super.initState();
  }

  void startCamera() async {
    cameras = await availableCameras();
    print(cameras);
    cameraController = CameraController(
// camera descriptions
// 0: main rear fasing camera, bad for closeups
// 1: front fasing camera
// 2: blurry af
// 3: close up cam
      cameras[3],
      ResolutionPreset.high,
      enableAudio: false,
    );

    await cameraController.initialize().then((value) {
      if (!mounted) {
        return;
      }
      setState(() {}); //To refresh widget
    }).catchError((e) {
      print(e);
    });
  }

  @override
  void dispose() {
    cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (cameraController.value.isInitialized) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: const Text(
            'Rewards Scanner',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: Stack(
          children: [
            CameraPreview(cameraController),
            // button stack
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: 500,
                height: 120,
                child: FloatingActionButton(
                  child: const Icon(Icons.camera),
                  onPressed: () async {
                    final pic = await cameraController.takePicture();
                    if (!mounted) return;

                    // crop image to prepare for ocr
                    await ImageProcessor.cropPlz(pic.path);

                    //send imgpath to ocr
                    final code = await OCR.ocr(pic.path);

                    //send file to image display widget
                    // Navigator.of(context).pop(MaterialPageRoute(builder: (context) => SucessScreen(code: code)));
                    Navigator.pop(context, code);
                  },
                ),
              ),
            ),
            cameraOverlay(),
          ],
        ),
      );
    } else {
      return const SizedBox();
    }
  }

  Widget cameraOverlay() {
    return Align(
      alignment: Alignment.center,
      child: Transform.scale(
        scale: 1.3,
        child: Container(
          margin: const EdgeInsets.only(bottom: 200),
          height: 130,
          width: 300,
          decoration: const ShapeDecoration(
            color: Colors.transparent,
            shape: RoundedRectangleBorder(
              side: BorderSide(width: 2, color: Colors.white),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(290),
                topRight: Radius.circular(290),
              ),
            ),
          ),
          child: const Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.only(bottom: 7),
              child: Text(
                style: TextStyle(fontSize: 20, color: Colors.black54),
                'XXXXXXXXXXXXXXXX',
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Widget that displays picutre
class DisplayPictureScreen extends StatelessWidget {
  final String imagePath;

  const DisplayPictureScreen({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Display the Picture')),
      // The image is stored as a file on the device. Use the `Image.file`
      // constructor with the given path to display the image.
      body: Image.file(File(imagePath)),
    );
  }
}
