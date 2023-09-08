import 'dart:convert';

import 'package:client/config.dart';
import 'package:client/functions/enterCode.dart';
import 'package:countup/countup.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String code = '';
  bool codeAccepted = false;
  String message = '';
  bool initialLoad = true;
  bool messageLoading = true;
  double points = 0;
  String newPoints = '';
  final TextEditingController _defaultCodeController = TextEditingController();

  double startPoints = 0;

  Future<void> acceptCookies() async {
    Response response = await get(Uri.http(BASE_IP, 'acceptCookies'));
    print('cookies accepted');
  }

  Future<double> getPoints() async {
    Response response = await get(Uri.http(BASE_IP, 'getPoints'));
    print('data aquired over');
    Map data = jsonDecode(response.body);
    print(data);
    return data['points'];
  }

  void _enterCode(code) async {
    setState(() {
      messageLoading = true;
      initialLoad = false;
    });
    print('entering code on home screen');
    print(code);
    final res = await EnterCode.enterCodeReq(code);

    Map jsonResponse = jsonDecode(res.body);

    print(jsonResponse);
    int status = jsonResponse['status_code'];
    if (status == 0) {
      _defaultCodeController.text = '';
      setState(() {
        codeAccepted = true;
      });
    } else {
      _defaultCodeController.text = code;
      setState(() {
        codeAccepted = false;
      });
    }
    setState(() {
      message = jsonResponse['message'];
      messageLoading = false;
    });
  }

  void updateStartPoints(sp) {
    startPoints = sp;
  }

  @override
  void initState() {
    super.initState();
    acceptCookies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff21a7d9),
        title: const Text(
          'Rewards Scanner',
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
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 75),
                child: Container(
                  color: const Color(0xff1e4383),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                    child: Column(
                      children: [
                        FutureBuilder(
                          builder: (ctx, snapshot) {
                            // Checking if future is resolved or not
                            if (snapshot.connectionState ==
                                ConnectionState.done) {
                              // If we got an error
                              if (snapshot.hasError) {
                                return Center(
                                  child: Text(
                                    '${snapshot.error} occurred',
                                    style: const TextStyle(fontSize: 10),
                                  ),
                                );

                                // if we got our data
                              } else if (snapshot.hasData) {
                                // Extracting data from snapshot object
                                WidgetsBinding.instance
                                    .addPostFrameCallback((_) {
                                  // Update startPoints after the UI is built
                                  updateStartPoints(snapshot.data!);
                                });

                                final data = snapshot.data as double;
                                return Center(
                                  child: Countup(
                                    begin: startPoints,
                                    end: data,
                                    duration: Duration(seconds: 2),
                                    style: GoogleFonts.openSans(
                                      fontSize: 65,
                                      fontWeight: FontWeight.w800,
                                      color: Colors.white,
                                      height: 1,
                                    ),
                                  ),
                                );
                              }
                            }

                            // Displaying LoadingSpinner to indicate waiting state
                            return Center(
                              child: Text(
                                '${startPoints.toStringAsFixed(0)}',
                                style: GoogleFonts.openSans(
                                  fontSize: 65,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white,
                                  height: 1,
                                ),
                              ),
                            );
                          },

                          // Future that needs to be resolved
                          // inorder to display something on the Canvas
                          future: getPoints(),
                        ),
                        // child: Text(
                        //   points,
                        //   ),
                        // ),
                        Text(
                          'POINTS',
                          style: GoogleFonts.openSans(
                            fontSize: 25,
                            color: const Color(0xff21a7d9),
                            height: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 20, top: 20),
                child: SizedBox(
                  height: 110,
                  width: MediaQuery.of(context).size.width - 50,
                  child: initialLoad == true
                      ? Container()
                      : messageLoading == true
                          ? Center(
                              child: const SizedBox(
                                child: CircularProgressIndicator(),
                              ),
                            )
                          : Container(
                              color: codeAccepted == false
                                  ? Colors.red
                                  : Colors.green,
                              child: Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Column(
                                  children: [
                                    Text(message,
                                        style: GoogleFonts.openSans(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white,
                                          height: 1.3,
                                        )),
                                    Icon(
                                      codeAccepted == false
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
              ),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: SizedBox(
                      width: 250,
                      height: 50,
                      child: TextField(
                        controller: _defaultCodeController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Enter Rewards Code',
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 50,
                    child: TextButton(
                      onPressed: () {
                        _enterCode(_defaultCodeController.text);
                      },
                      style: const ButtonStyle(
                        backgroundColor:
                            MaterialStatePropertyAll(Color(0xff21a7d9)),
                        shape: MaterialStatePropertyAll(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.zero),
                        ),
                      ),
                      child: const Icon(Icons.arrow_right_alt,
                          color: Colors.white),
                    ),
                  )
                ],
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final code = await Navigator.pushNamed(context, '/camera');
          print(code);
          if (code != null) {
            print('entering code');
            _enterCode(code);
          }
        },
        backgroundColor: const Color(0xff21a7d9),
        child: const Icon(Icons.camera_alt, color: Colors.white),
      ),
    );
  }
}
