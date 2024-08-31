import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart'; // Asegúrate de importar flutter_locales
import 'package:provider/provider.dart'; // Importar provider
import 'package:setup_app/model/exercise_service.dart';
import 'package:setup_app/pages/routine_workout_page.dart';
import 'package:setup_app/model/routine_model.dart'; // Importar RoutineModel
import 'package:setup_app/tables/routine.dart';
import 'package:setup_app/tables/routine_exercise.dart';

class RoutineDetailPage extends StatefulWidget {
  final Routine routine;

  const RoutineDetailPage({super.key, required this.routine});

  @override
  State<RoutineDetailPage> createState() => _RoutineDetailPageState();
}

class _RoutineDetailPageState extends State<RoutineDetailPage> {
  late List<RoutineExercise> _exercises;
  final ExerciseService _exerciseService = ExerciseService();

  @override
  void initState() {
    super.initState();
    _exercises = widget.routine.exercises;
  }

  void _onReorder(int oldIndex, int newIndex) {
    setState(() {
      if (newIndex > oldIndex) {
        newIndex -= 1;
      }
      final RoutineExercise exercise = _exercises.removeAt(oldIndex);
      _exercises.insert(newIndex, exercise);
    });
  }

  void _startWorkout() async {
    // Accede al modelo de rutina desde el Provider
    final routineModel = Provider.of<RoutineModel>(context, listen: false);

    // Guarda la rutina en RoutineModel
    routineModel.setRoutine(widget.routine).then((_) {
      // Navega a la página de entrenamiento de la rutina
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const RoutineWorkoutPage(),
        ),
      );
    }).catchError((error) {
      // Maneja el error si ocurre durante el guardado
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                '${Locales.string(context, 'failed_to_save_routine')} $error')), // Traducción
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Locales.string(context, 'routine_detail')), // Traducción
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${Locales.string(context, 'last_updated')} ${widget.routine.lastDate.toLocal()}', // Traducción
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: _startWorkout,
                child: Text(
                    Locales.string(context, 'start_workout')), // Traducción
              ),
            ),
            const SizedBox(height: 20),
            Text(
              Locales.string(context, 'exercises'), // Traducción
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ReorderableListView(
                onReorder: _onReorder,
                children: _exercises
                    .asMap()
                    .entries
                    .map((entry) => Card(
                          key: ValueKey(entry.value),
                          margin: const EdgeInsets.symmetric(vertical: 8.0),
                          child: ListTile(
                            title: Text(
                                '${Locales.string(context, 'exercise_id')}: ${entry.value.exerciseId}'), // Traducción
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                    '${Locales.string(context, 'reps')}: ${entry.value.repetitions.join(", ")}'), // Traducción
                                Text(
                                    '${Locales.string(context, 'weights')}: ${entry.value.weights.join(", ")}'), // Traducción
                              ],
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.info_outline),
                              onPressed: () {
                                _exerciseService.showExerciseInfo(
                                    context, entry.value.exerciseId);
                              },
                            ),
                          ),
                        ))
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
