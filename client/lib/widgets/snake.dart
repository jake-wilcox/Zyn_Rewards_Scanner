import 'dart:async';
import 'dart:math';

import 'package:client/widgets/SnakeAssets/foodTile.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:client/widgets/SnakeAssets/snakeTile.dart';
import 'package:client/widgets/SnakeAssets/blankTile.dart';
import 'package:google_fonts/google_fonts.dart';

class Snake extends StatefulWidget {
  const Snake({super.key});

  @override
  State<Snake> createState() => _SnakeState();
}

class _SnakeState extends State<Snake> {
  List<int> snakePos = [13, 23, 33];
  int food = 28;
  String direction = 'down';
  bool gameStarted = false;
  int gameTiles = 110;
  int snakeSpeed = 200;
  bool looser = false;

  bool displayMenu = true;
  int score = 0;
  String scoreDisplay = 'PLAY SOME SNAKE WHILE WE LOAD...';

  void startGame() {
    displayMenu = false;
    snakePos = [13, 23, 33];
    food = 28;
    direction = 'down';
    looser = false;

    Timer.periodic(Duration(milliseconds: snakeSpeed), (timer) {
      if (looser) {
        print('LOOSER');
        setState(() {
          displayMenu = true;
          scoreDisplay = 'SCORE: ${score}';
        });
        timer.cancel();
      } else {
        setState(() {
          moveJit();
        });
      }
    });
  }

  void moveJit() {
    var newHead;
    switch (direction) {
      case 'down':
        newHead = snakePos.last + 10;
        if (newHead > gameTiles) {
          looser = true;
        }
      case 'up':
        newHead = snakePos.last - 10;
        if (0 > newHead) {
          looser = true;
        }
      case 'right':
        newHead = snakePos.last + 1;
        if (newHead % 10 == 0) {
          looser = true;
        }
      case 'left':
        newHead = snakePos.last - 1;
        if (newHead % 10 == 9) {
          looser = true;
        }
    }
    //move snake
    snakePos.add(newHead);
    if (newHead == food) {
      score += 1;
      spawnFood();
    } else {
      snakePos.removeAt(0);
    }
    // check for snake on snake collition
    print(Set.of(snakePos).toList());
    print(snakePos);
    if (!listEquals(Set.of(snakePos).toList(), snakePos)) {
      //looser
      print('snake collision');
      looser = true;
    }
  }

  void spawnFood() {
    while (snakePos.contains(food)) {
      food = Random().nextInt(gameTiles);
    }
  }

  //callback function for when we change dificulty
  void updateSpeed(int newSpeed) {
    setState(() {
      print('updating speed');
      snakeSpeed = newSpeed;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onVerticalDragUpdate: (details) {
        print('y: ${details.delta.dy}');
        if (details.delta.dy < 0) {
          if (direction != 'down') {
            print('swiped up');
            direction = 'up';
          }
        } else {
          if (direction != 'up') {
            print('swipe down');
            direction = 'down';
          }
          print(snakePos.last);
        }
      },
      onHorizontalDragUpdate: (details) {
        print('x: ${details.delta.dx}');
        if (details.delta.dx < 0) {
          if (direction != 'right') {
            print('swiped left');
            direction = 'left';
          }
        } else {
          if (direction != 'left') {
            print('swipe right');
            direction = 'right';
          }
        }
      },
      child: Container(
        color: Colors.grey[300],
        child: Stack(
          alignment: Alignment.center,
          children: [
            GridView.builder(
              padding: EdgeInsets.all(12),
              shrinkWrap: true,
              itemCount: gameTiles,
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 10,
              ),
              itemBuilder: (context, index) {
                if (snakePos.contains(index)) {
                  return SnakeTile();
                } else if (index == food) {
                  return FoodTile();
                } else {
                  return BlankTile();
                }
              },
            ),
            displayMenu == true
                ? Container(
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        width: 300,
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: Text(
                                scoreDisplay,
                                style: GoogleFonts.openSans(
                                  fontSize: 25,
                                  fontWeight: FontWeight.w800,
                                  height: 1,
                                ),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                DifficultyButton(
                                    dif: 'EASY',
                                    speed: 325,
                                    onSpeedChanged: updateSpeed),
                                DifficultyButton(
                                    dif: 'MEDUIM',
                                    speed: 200,
                                    onSpeedChanged: updateSpeed),
                                DifficultyButton(
                                    dif: 'HARD',
                                    speed: 75,
                                    onSpeedChanged: updateSpeed),
                                SizedBox(
                                  width: 50,
                                  child: TextButton(
                                    onPressed: () {
                                      startGame();
                                    },
                                    style: const ButtonStyle(
                                      backgroundColor: MaterialStatePropertyAll(
                                          Color(0xff1e4383)),
                                      shape: MaterialStatePropertyAll(
                                        RoundedRectangleBorder(
                                            borderRadius: BorderRadius.zero),
                                      ),
                                    ),
                                    child: const Icon(Icons.arrow_right,
                                        color: Colors.white),
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  )
                : Container()
          ],
        ),
      ),
    );
  }
}

class DifficultyButton extends StatelessWidget {
  final String dif;
  final int speed;
  final Function(int) onSpeedChanged;
  const DifficultyButton(
      {super.key,
      required this.dif,
      required this.speed,
      required this.onSpeedChanged});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 75,
      child: TextButton(
        onPressed: () {
          onSpeedChanged(speed);
        },
        style: const ButtonStyle(
          backgroundColor: MaterialStatePropertyAll(Color(0xff21a7d9)),
          shape: MaterialStatePropertyAll(
            RoundedRectangleBorder(borderRadius: BorderRadius.zero),
          ),
        ),
        child: Text(dif,
            style: GoogleFonts.openSans(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            )),
      ),
    );
  }
}
