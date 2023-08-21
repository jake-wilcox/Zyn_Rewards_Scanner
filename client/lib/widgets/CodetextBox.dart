import 'package:flutter/material.dart';

class CodeTextBox extends StatefulWidget {
  final String code;
  const CodeTextBox({
    super.key,
    required this.code,
  });

  @override
  State<CodeTextBox> createState() => _CodeTextBoxState();
}

class _CodeTextBoxState extends State<CodeTextBox> {
  final TextEditingController _defaultCodeController = TextEditingController();

  @override
  void initState() {
    _defaultCodeController.text = widget.code;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        TextField(
          controller: _defaultCodeController,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'Enter Rewards Code',
          ),
        ),
      ],
    );
  }
}
