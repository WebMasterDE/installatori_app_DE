import 'package:flutter/material.dart';

class CustomTextfield extends StatelessWidget {

  final String text;

  const CustomTextfield({
    super.key,
    required this.text,
    });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          text,
          style: Theme.of(context).textTheme.labelSmall,
        ),
        SizedBox(
          height: 7,
        ),
        TextField(
          decoration: InputDecoration(
            labelText: text,
            border: OutlineInputBorder(),
          ),
        ),
      ],
    );
  }
}