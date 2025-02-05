import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextfield extends StatelessWidget {

  final String text;
  final TextEditingController? controller;
  final bool required;
  final String? Function(String?)? validator;
  final TextInputType? textInputType;

  const CustomTextfield({
    super.key,
    required this.text,
    this.controller,
    this.required = false,
    this.validator,
    this.textInputType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {

    String? Function(String?) validatorFunction;

    if(required && validator == null){
      validatorFunction = (value) {
                              if (value == null || value.isEmpty){
                                return 'Campo richisto';
                              }
                              return null;
                          };
    }else if (required && validator != null){
      validatorFunction = validator!;
    }else{
      validatorFunction = (value) {return null;};
    }




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
        Stack(
          children: [
            TextFormField(
              controller: controller,
              decoration: InputDecoration(
                hintText: text,
                border: OutlineInputBorder(),
                errorStyle: Theme.of(context).textTheme.displaySmall,
              ),
              validator: validatorFunction,
              keyboardType: textInputType,
            ),
          ],
        ),
        SizedBox(
          height: 10,
        )
      ],
    );
  }
}