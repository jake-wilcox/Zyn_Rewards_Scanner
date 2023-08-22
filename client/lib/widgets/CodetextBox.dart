import 'package:client/pages/sucess_screen.dart';
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
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) =>
                      SucessScreen(code: _defaultCodeController.text)));
            },
            style: const ButtonStyle(
              backgroundColor: MaterialStatePropertyAll(Colors.blue),
              shape: MaterialStatePropertyAll(
                RoundedRectangleBorder(borderRadius: BorderRadius.zero),
              ),
            ),
            child: const Icon(Icons.arrow_right_alt, color: Colors.white),
          ),
        ),
      ],
    );
  }
}
