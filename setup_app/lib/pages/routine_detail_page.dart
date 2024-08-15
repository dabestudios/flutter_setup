import 'package:flutter/material.dart';
import 'package:setup_app/model/exercise_service.dart';
import 'package:setup_app/pages/routine_workout_page.dart';
import 'package:setup_app/tables/routine.dart';
import 'package:setup_app/tables/routine_exercise.dart';

class RoutineDetailPage extends StatefulWidget {
  final Routine routine;

  RoutineDetailPage({required this.routine});

  @override
  _RoutineDetailPageState createState() => _RoutineDetailPageState();
}

class _RoutineDetailPageState extends State<RoutineDetailPage> {
  late List<RoutineExercise> _exercises;
  final ExerciseService _exerciseService =
      ExerciseService(); // Instancia del servicio

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
                            _exerciseService.showExerciseInfo(
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
}
