import 'package:flutter/material.dart';
import 'package:setup_app/tables/routine.dart';
import 'package:setup_app/tables/routine_exercise.dart';

class RoutineWorkoutPage extends StatefulWidget {
  final Routine routine;

  RoutineWorkoutPage({required this.routine});

  @override
  _RoutineWorkoutPageState createState() => _RoutineWorkoutPageState();
}

class _RoutineWorkoutPageState extends State<RoutineWorkoutPage> {
  late List<RoutineExercise> _editableExercises;

  @override
  void initState() {
    super.initState();
    _editableExercises = widget.routine.exercises
        .map((exercise) => RoutineExercise(
            exerciseId: exercise.exerciseId,
            repetitions: List<int>.from(exercise.repetitions),
            weights: List<int>.from(exercise.weights),
            isCompleted: List<bool>.filled(
                exercise.repetitions.length, false))) // Inicializa isCompleted
        .toList();
  }

  void _toggleCompletion(int exerciseIndex, int seriesIndex) {
    setState(() {
      _editableExercises[exerciseIndex].isCompleted[seriesIndex] =
          !_editableExercises[exerciseIndex].isCompleted[seriesIndex];
    });
  }

  void _finishWorkout() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.routine.name),
        actions: [
          IconButton(
            icon: Icon(Icons.check),
            onPressed: _finishWorkout,
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: _editableExercises.length,
        itemBuilder: (context, index) {
          final exercise = _editableExercises[index];
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Exercise: ${exercise.exerciseId}',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                      icon: Icon(Icons.more_vert),
                      onPressed: () {
                        // Opciones para el ejercicio
                      },
                    ),
                  ],
                ),
              ),
              DataTable(
                columns: [
                  DataColumn(label: Text('Serie')),
                  DataColumn(label: Text('Kg')),
                  DataColumn(label: Text('Reps')),
                  DataColumn(label: Text('Confirm')),
                ],
                rows: List<DataRow>.generate(
                  exercise.repetitions.length,
                  (seriesIndex) => DataRow(cells: [
                    DataCell(Text('Serie ${seriesIndex + 1}')),
                    DataCell(Text('${exercise.weights[seriesIndex]}')),
                    DataCell(Text('${exercise.repetitions[seriesIndex]}')),
                    DataCell(
                      Checkbox(
                        value: exercise.isCompleted[seriesIndex],
                        onChanged: (value) {
                          _toggleCompletion(index, seriesIndex);
                        },
                      ),
                    ),
                  ]),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
