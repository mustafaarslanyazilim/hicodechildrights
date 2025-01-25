import 'package:flutter/material.dart';
import 'package:hicodechildrights/color.dart';


class GradientButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const GradientButton({
    Key? key,
    required this.text,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        decoration: BoxDecoration(
          gradient: AppGradients.primaryGradient, // Gradient rengi icin olusturduk
          borderRadius: BorderRadius.circular(10), 
        ),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        child: Center(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.white, 
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
