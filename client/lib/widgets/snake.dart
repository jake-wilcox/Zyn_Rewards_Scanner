import 'package:flutter/material.dart';

class Snake extends StatefulWidget {
  const Snake({super.key});

  @override
  State<Snake> createState() => _SnakeState();
}

class _SnakeState extends State<Snake> {
  @override
  Widget build(BuildContext context) {
    return Container(
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
            return Padding(
                padding: EdgeInsets.all(3),
                child: Container(
                  color: const Color(0xff21a7d9)const Color(0xff21a7d9),
                ));
          },
        ),
      ),
    );
  }
}
