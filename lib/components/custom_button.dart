import 'package:flutter/material.dart';
import 'package:installatori_de/theme/colors.dart';

class CustomButton extends StatelessWidget {

  final String text;
  final void Function()? onPressed;

  const CustomButton(
    {
      super.key,
      required this.text,
      this.onPressed
    }
  );

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: TextButton(
        style: TextButton.styleFrom(
            backgroundColor: CustomColors.buttonColor,
            minimumSize: Size(double.infinity, 50),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10)
            ),
        ),
        onPressed: onPressed,
        child: Text(
          text,
          style: TextStyle(
            color: CustomColors.secondaryText,
            fontSize: 15,
            fontWeight: FontWeight.bold,
            fontFamily: 'Outfit',

          ),
        ),
      
      ),
    );
  }
}