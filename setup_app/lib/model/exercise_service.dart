// exercise_service.dart
import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';
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
                Text(
                    '${Locales.string(context, 'force_label')}: ${exercise.force ?? Locales.string(context, 'no_value')}'),
                Text(
                    '${Locales.string(context, 'level_label')}: ${exercise.level ?? Locales.string(context, 'no_value')}'),
                Text(
                    '${Locales.string(context, 'mechanic_label')}: ${exercise.mechanic ?? Locales.string(context, 'no_value')}'),
                Text(
                    '${Locales.string(context, 'equipment_label')}: ${exercise.equipment ?? Locales.string(context, 'no_value')}'),
                Text(
                    '${Locales.string(context, 'primary_muscles_label')}: ${exercise.primaryMuscles.join(", ")}'),
                Text(
                    '${Locales.string(context, 'secondary_muscles_label')}: ${exercise.secondaryMuscles.join(", ")}'),
                Text(
                    '${Locales.string(context, 'category_label')}: ${exercise.category}'),
                const SizedBox(height: 10),
                Text('${Locales.string(context, 'instructions_label')}:',
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                for (var instruction in exercise.instructions)
                  Text('- $instruction'),
                const SizedBox(height: 10),
                Text('${Locales.string(context, 'images_label')}:',
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                if (exercise.images != null)
                  Image.asset('assets/photos/${exercise.images}')
                else
                  Text(Locales.string(context, 'no_images_available')),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: Text(Locales.string(context, 'close')),
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
