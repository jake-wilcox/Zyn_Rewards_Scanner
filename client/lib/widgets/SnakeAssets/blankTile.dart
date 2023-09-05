import 'package:flutter/material.dart';

class BlankTile extends StatelessWidget {
  const BlankTile({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(3),
      child: Container(
        color: Colors.grey[400],
      ),
    );
  }
}
