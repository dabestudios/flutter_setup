// exercise_service.dart
import 'package:flutter/material.dart';
import 'package:setup_app/tables/exercise.dart';

class ExerciseService {
  final ExerciseLoader _exerciseLoader = ExerciseLoader();

  Future<void> showExerciseInfo(BuildContext context, String exerciseId) async {
    Exercise? exercise = await _exerciseLoader.getExerciseById(exerciseId);

    if (exercise == null) {
      print('Error: Exercise not found for ID $exerciseId');
      return;
    }

    if (!context.mounted) return; // Asegúrate de que el contexto esté montado
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(exercise.name),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Force: ${exercise.force ?? "N/A"}'),
                Text('Level: ${exercise.level}'),
                Text('Mechanic: ${exercise.mechanic ?? "N/A"}'),
                Text('Equipment: ${exercise.equipment ?? "N/A"}'),
                Text('Primary Muscles: ${exercise.primaryMuscles.join(", ")}'),
                Text(
                    'Secondary Muscles: ${exercise.secondaryMuscles.join(", ")}'),
                Text('Category: ${exercise.category}'),
                const SizedBox(height: 10),
                const Text('Instructions:',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                for (var instruction in exercise.instructions)
                  Text('- $instruction'),
                const SizedBox(height: 10),
                const Text('Images:',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                if (exercise.images != null)
                  Image.asset('assets/photos/${exercise.images}')
                else
                  const Text('No images available'),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: const Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
