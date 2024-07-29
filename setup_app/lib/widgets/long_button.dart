import 'package:flutter/material.dart';

class LongButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isSelected;
  final bool isCorrect; // Determines if the button is correct
  final bool isButtonEnabled;

  LongButton({
    required this.text,
    required this.onPressed,
    required this.isSelected,
    required this.isCorrect,
    required this.isButtonEnabled,
  });

  @override
  Widget build(BuildContext context) {
    Color backgroundColor = Colors.grey[700]!;
    if (!isButtonEnabled) {
      if (isSelected && isCorrect) {
        backgroundColor = Colors.green[700]!;
      } else if (isSelected && !isCorrect) {
        backgroundColor = Colors.red[700]!;
      } else if (!isSelected && isCorrect) {
        backgroundColor = Colors.green[300]!;
      } else {
        backgroundColor = Colors.grey[700]!;
      }
    }

    return SizedBox(
      width: double.infinity,
      child: AbsorbPointer(
        absorbing: !isButtonEnabled,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: backgroundColor,
            foregroundColor: Colors.white,
            textStyle: TextStyle(
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          onPressed: onPressed,
          child: Text(text),
        ),
      ),
    );
  }
}
