import 'package:flutter/material.dart';

class RepsOrWeightEditor extends StatelessWidget {
  final int value;
  final void Function(int) onValueChanged;
  final String label;
  final bool isReps; // Determina si es para reps o peso

  RepsOrWeightEditor({
    required this.value,
    required this.onValueChanged,
    required this.label,
    required this.isReps,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          icon: Icon(Icons.remove, size: 15),
          onPressed: () {
            if (value > 0) {
              onValueChanged(value - 1);
            }
          },
        ),
        SizedBox(
          width: 60,
          child: TextField(
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: label,
              border: InputBorder.none,
              alignLabelWithHint: true, // Alinea la etiqueta con el campo
            ),
            onChanged: (value) {
              final intValue = int.tryParse(value) ?? 0;
              onValueChanged(intValue);
            },
            controller: TextEditingController(
              text: value.toString(),
            ),
            textAlign: TextAlign.center,
          ),
        ),
        IconButton(
          icon: Icon(Icons.add, size: 15),
          onPressed: () {
            onValueChanged(value + 1);
          },
        ),
      ],
    );
  }
}
