import 'package:flutter/material.dart';
import 'package:setup_app/pages/routine_workout_page.dart';
import 'package:setup_app/tables/exercise.dart';
import 'package:setup_app/tables/routine.dart';
import 'package:setup_app/tables/routine_exercise.dart';
import 'package:setup_app/model/routine_storage.dart';

class RoutineDetailPage extends StatefulWidget {
  final Routine routine;

  RoutineDetailPage({required this.routine});

  @override
  _RoutineDetailPageState createState() => _RoutineDetailPageState();
}

class _RoutineDetailPageState extends State<RoutineDetailPage> {
  late List<RoutineExercise> _exercises;
  final ExerciseLoader _exerciseLoader = ExerciseLoader();
  final RoutineStorage _routineStorage =
      RoutineStorage(); // Usar la instancia singleton

  @override
  void initState() {
    super.initState();
    _exercises = widget.routine.exercises;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.routine.name),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
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
              'Last updated: ${widget.routine.lastDate.toLocal()}',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Text(
              'Exercises:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                  itemCount: widget.routine.exercises.length,
                  itemBuilder: (context, index) {
                    final exercise = widget.routine.exercises[index];
                    return Card(
                      margin: EdgeInsets.symmetric(vertical: 8.0),
                      child: ListTile(
                        title: Text('Exercise ID: ${exercise.exerciseId}'),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Reps: ${exercise.repetitions.join(", ")}'),
                            Text('Weights: ${exercise.weights.join(", ")}'),
                          ],
                        ),
                        trailing: IconButton(
                          icon: Icon(Icons.info_outline),
                          onPressed: () {
                            showExerciseInfo(
                                context, _exercises[index].exerciseId);
                          },
                        ),
                      ),
                    );
                  }),
            ),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Navega a la página de entrenamiento de la rutina
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          RoutineWorkoutPage(routine: widget.routine),
                    ),
                  );
                },
                child: Text('Start Workout'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showExerciseInfo(BuildContext context, String exerciseId) async {
    Exercise? exercise = await _exerciseLoader.getExerciseById(exerciseId);

    if (exercise == null) {
      print('Error: Exercise not found for ID $exerciseId');
      return;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(exercise.name),
          content: Column(
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
              Text(
                'Instructions:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              for (var instruction in exercise.instructions)
                Text('- $instruction'),
              const SizedBox(height: 10),
              Text(
                'Images:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              for (var image in exercise.images) Text('- $image'),
            ],
          ),
          actions: [
            TextButton(
              child: Text('Close'),
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
