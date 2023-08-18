import 'package:flutter/material.dart';
import 'package:client/pages/home_screen.dart';
import 'package:client/pages/camera_screen.dart';
import 'package:client/pages/loading_screen.dart';

void main() {
  runApp(MaterialApp(
    title: 'Flutter Demo',
    theme: ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      useMaterial3: true,
    ),
    initialRoute: '/',
    routes: {
      '/': (context) => const Loading(),
      '/home': (context) => const HomeScreen(),
      '/camera': (context) => const CameraScreen(),
    },
  ));
}
