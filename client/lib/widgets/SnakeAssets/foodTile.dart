import 'package:flutter/material.dart';

class FoodTile extends StatelessWidget {
  const FoodTile({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(3),
      child: Container(
        color: const Color(0xff1e4383),
      ),
    );
  }
}
