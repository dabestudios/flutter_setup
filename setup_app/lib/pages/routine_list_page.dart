// routine_list_page.dart
import 'package:flutter/material.dart';
import 'package:setup_app/pages/routine_workout_page.dart';
import 'package:setup_app/tables/routine.dart';
import 'package:setup_app/model/routine_storage.dart';

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

class RoutineDetailPage extends StatelessWidget {
  final Routine routine;

  RoutineDetailPage({required this.routine});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(routine.name),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              // Navega a la pantalla de edición
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditRoutinePage(routine: routine),
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
              'Last updated: ${routine.lastDate.toLocal()}',
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
                itemCount: routine.exercises.length,
                itemBuilder: (context, index) {
                  final exercise = routine.exercises[index];
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
                    ),
                  );
                },
              ),
            ),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Navega a la página de entrenamiento de la rutina
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          RoutineWorkoutPage(routine: routine),
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

// La siguiente página RoutineWorkoutPage será creada en la siguiente parte.
