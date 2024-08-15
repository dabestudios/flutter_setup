import 'package:flutter/material.dart';
import 'package:setup_app/pages/routine_workout_page.dart';
import 'package:setup_app/tables/exercise.dart';
import 'package:setup_app/tables/routine.dart';
import 'package:setup_app/model/routine_storage.dart';
import 'package:setup_app/tables/routine_exercise.dart'; // Asegúrate de que globalExercises esté accesible

class RoutineListPage extends StatefulWidget {
  @override
  _RoutineListPageState createState() => _RoutineListPageState();
}

class _RoutineListPageState extends State<RoutineListPage> {
  final RoutineStorage _routineStorage = RoutineStorage();
  late Future<List<Routine>> _routinesFuture;

  @override
  void initState() {
    super.initState();
    _routinesFuture = _routineStorage.loadRoutines();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Routines'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              // Agrega una nueva rutina (implementar esta funcionalidad)
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Routine>>(
        future: _routinesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No routines found.'));
          }

          final routines = snapshot.data!;

          return ListView.builder(
            itemCount: routines.length,
            itemBuilder: (context, index) {
              final routine = routines[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RoutineDetailPage(routine: routine),
                    ),
                  );
                },
                child: Card(
                  margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  child: ListTile(
                    contentPadding: EdgeInsets.all(16.0),
                    leading: Icon(Icons.fitness_center, size: 40),
                    title: Text(
                      routine.name,
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    subtitle:
                        Text('Last updated: ${routine.lastDate.toLocal()}'),
                    trailing: IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        // Navega a la pantalla de edición
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                EditRoutinePage(routine: routine),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class RoutineDetailPage extends StatefulWidget {
  final Routine routine;

  RoutineDetailPage({required this.routine});

  @override
  _RoutineDetailPageState createState() => _RoutineDetailPageState();
}

class _RoutineDetailPageState extends State<RoutineDetailPage> {
  late List<RoutineExercise> _exercises;
  final ExerciseLoader _exerciseLoader = ExerciseLoader();

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
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      EditRoutinePage(routine: widget.routine),
                ),
              );
            },
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

class EditRoutinePage extends StatelessWidget {
  final Routine routine;

  EditRoutinePage({required this.routine});

  @override
  Widget build(BuildContext context) {
    // Implementar la lógica para editar la rutina
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit ${routine.name}'),
      ),
      body: Center(
        child: Text('Edit Routine Page (Funcionalidad no implementada aún)'),
      ),
    );
  }
}
