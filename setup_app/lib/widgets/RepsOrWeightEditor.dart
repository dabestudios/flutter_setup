import 'dart:ffi';

import 'package:flutter/material.dart';

class RepsOrWeightEditor extends StatelessWidget {
  final int value;
  final void Function(int) onValueChanged;
  final String label;
  final bool isReps;

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
          width: 55,
          child: Stack(
            children: [
              Column(children: [
                SizedBox(height: 3),
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    label,
                    style: TextStyle(
                      fontSize: 12,
                      color: Theme.of(context).hintColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                TextField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    alignLabelWithHint: true,
                  ),
                  onChanged: (value) {
                    final intValue = int.tryParse(value) ?? 0;
                    onValueChanged(intValue);
                  },
                  controller: TextEditingController(
                    text: this.value.toString(),
                  ),
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16), // Tamaño del texto principal
                ),
              ]),
            ],
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
