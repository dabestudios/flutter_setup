// routine_list_page.dart
import 'package:flutter/material.dart';
import 'package:setup_app/tables/routine.dart';
import 'package:setup_app/tables/routine_storage.dart';

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
        title: const Text('Saved Routines'),
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
              return ListTile(
                title: Text(routine.name),
                subtitle: Text('Last updated: ${routine.lastDate.toLocal()}'),
                onTap: () {
                  // Navigate to details page
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RoutineDetailPage(routine: routine),
                    ),
                  );
                },
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
                  return ListTile(
                    title: Text('Exercise ID: ${exercise.exerciseId}'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Reps: ${exercise.repetitions.join(", ")}'),
                        Text('Weights: ${exercise.weights.join(", ")}'),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
