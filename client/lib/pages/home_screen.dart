import 'dart:convert';

import 'package:client/widgets/CodetextBox.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String points = '';
  void getPoints() async {
    Response response = await get(Uri.http('192.168.0.5:8000', 'getPoints'));
    print('data aquired over');
    Map data = jsonDecode(response.body);
    print(data);

    setState(() {
      points = data['points'];
    });
  }

  @override
  void initState() {
    getPoints();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text(
          'James Camzyn',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('hello'),
              Text('wrld'),
              Text(points),
              CodeTextBox(code: ''),
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/camera');
        },
        child: const Icon(Icons.camera_alt),
      ),
    );
  }
}
