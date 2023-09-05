import 'package:client/widgets/SnakeAssets/foodTile.dart';
import 'package:flutter/material.dart';
import 'package:client/widgets/SnakeAssets/snakeTile.dart';
import 'package:client/widgets/SnakeAssets/blankTile.dart';

class Snake extends StatefulWidget {
  const Snake({super.key});

  @override
  State<Snake> createState() => _SnakeState();
}

class _SnakeState extends State<Snake> {
  List<int> snakePos = [0, 1, 2];
  var food = 23;
  var direction = 'down';

  void moveJit() {
    switch (direction) {
      case 'down':
    }
  }
  // add a check funciton that sees if the snake ate, ran into wall or itself.
  // if set(snakePos) == snakePos --- :(

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onVerticalDragUpdate: (details) {
        print('y: ${details.delta.dy}');
        if (details.delta.dy < 0) {
          print('swiped up');
          direction = 'up';
        } else {
          print('swipe down');
          direction = 'down';
        }
      },
      onHorizontalDragUpdate: (details) {
        print('x: ${details.delta.dx}');
        if (details.delta.dx < 0) {
          print('swiped left');
          direction = 'left';
        } else {
          print('swipe right');
          direction = 'right';
        }
      },
      child: Container(
        color: Colors.grey[300],
        child: Center(
          child: GridView.builder(
            padding: EdgeInsets.all(12),
            shrinkWrap: true,
            itemCount: 110,
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
        ),
      ),
    );
  }
}
