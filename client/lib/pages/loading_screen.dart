import 'dart:convert';

import 'package:client/config.dart';
import 'package:client/widgets/snake.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';

class Loading extends StatefulWidget {
  const Loading({super.key});

  @override
  State<Loading> createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  bool _isLoading = true;
  bool _loadFailed = false;

  void getData() async {
    print('opening chromedriver');
    Response response = await get(Uri.http(BASE_IP, 'login'));
    print('sucessful chromedriver');
    Map data = jsonDecode(response.body);
    print(data['success']);
    if (data['success'] == false) {
      setState(() {
        _isLoading = false;
        _loadFailed = true;
      });
    } else {
      setState(() {
        _isLoading = false;
      });
    }

    // Navigator.pushReplacementNamed(context, '/home', arguments: data);
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.all(10),
              child: Snake(),
            ),
            SizedBox(
              width: 75,
              child: TextButton(
                onPressed: _isLoading
                    ? null
                    : () {
                        Navigator.pushReplacementNamed(
                          context,
                          '/home',
                        );
                      },
                style: ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll(
                      _isLoading ? Colors.grey : const Color(0xff21a7d9)),
                  shape: const MaterialStatePropertyAll(
                    RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                  ),
                ),
                child: Text('ENTER CODES',
                    style: GoogleFonts.openSans(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    )),
              ),
            ),
            _loadFailed
                ? Text('Loading failed :( Try again later')
                : Container(),
          ],
        ),
      ),
    );
  }
}
