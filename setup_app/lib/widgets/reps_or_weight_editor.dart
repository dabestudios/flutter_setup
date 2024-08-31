import 'package:flutter/material.dart';

class RepsOrWeightEditor extends StatelessWidget {
  final int value;
  final void Function(int) onValueChanged;
  final String label;
  final bool isReps;

  const RepsOrWeightEditor({
    super.key,
    required this.value,
    required this.onValueChanged,
    required this.label,
    required this.isReps,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.inversePrimary,
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.remove, size: 15),
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
                    const SizedBox(height: 3),
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        label,
                        style: TextStyle(
                          fontSize: 12,
                          color: Theme.of(context).hintColor,
                        ),
                      ),
                    ),
                    TextField(
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        alignLabelWithHint: true,
                      ),
                      onChanged: (value) {
                        final intValue = int.tryParse(value) ?? 0;
                        onValueChanged(intValue);
                      },
                      controller: TextEditingController(
                        text: value.toString(),
                      ),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontSize: 22), // Tamaño del texto principal
                    ),
                  ]),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.add, size: 15),
              onPressed: () {
                onValueChanged(value + 1);
              },
            ),
          ],
        ));
  }
}
