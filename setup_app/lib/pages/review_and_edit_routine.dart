import 'package:flutter/material.dart';
import 'package:setup_app/tables/exercise.dart';
import 'package:setup_app/tables/routine.dart';
import 'package:setup_app/tables/routine_exercise.dart';

class ReviewAndEditPage extends StatefulWidget {
  final List<Exercise> selectedExercises;
  final void Function(Routine routine) onSave;

  ReviewAndEditPage({required this.selectedExercises, required this.onSave});

  @override
  _ReviewAndEditPageState createState() => _ReviewAndEditPageState();
}

class _ReviewAndEditPageState extends State<ReviewAndEditPage> {
  late List<RoutineExercise> _editableExercises;
  final TextEditingController _routineNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _editableExercises = widget.selectedExercises.map((exercise) {
      return RoutineExercise(
        routineId: '',
        exerciseId: exercise.id,
        repetitions: [10, 10, 10], // Tres series de 10 repeticiones por defecto
        weights: [20, 20, 20], // Tres series de 20 kg por defecto
      );
    }).toList();
  }

  void _addSeries(int index) {
    setState(() {
      _editableExercises[index]
          .repetitions
          .add(10); // Añade una nueva serie con 10 repeticiones
      _editableExercises[index]
          .weights
          .add(20); // Añade una nueva serie con 20 kg
    });
  }

  void _removeSeries(int exerciseIndex, int seriesIndex) {
    setState(() {
      if (_editableExercises[exerciseIndex].repetitions.length > 1) {
        _editableExercises[exerciseIndex].repetitions.removeAt(seriesIndex);
        _editableExercises[exerciseIndex].weights.removeAt(seriesIndex);
      }
    });
  }

  void _updateReps(int exerciseIndex, int seriesIndex, int reps) {
    setState(() {
      _editableExercises[exerciseIndex].repetitions[seriesIndex] = reps;
    });
  }

  void _updateWeight(int exerciseIndex, int seriesIndex, int weight) {
    setState(() {
      _editableExercises[exerciseIndex].weights[seriesIndex] = weight;
    });
  }

  void _saveRoutine() {
    if (_routineNameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a routine name')),
      );
      return;
    }

    final routine = Routine(
      id: UniqueKey().toString(),
      name: _routineNameController.text,
      lastDate: DateTime.now(),
      exercises: _editableExercises,
    );

    widget.onSave(routine);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Review and Edit Routine'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _routineNameController,
              decoration: InputDecoration(
                labelText: 'Routine Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Selected Exercises:',
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: _editableExercises.length,
                itemBuilder: (context, index) {
                  final exercise = widget.selectedExercises[index];
                  final routineExercise = _editableExercises[index];
                  return ExpansionTile(
                    title: Text(exercise.name),
                    subtitle: Text(
                        '${routineExercise.repetitions.length} series, ${routineExercise.repetitions.join(", ")} reps, ${routineExercise.weights.join(", ")} kg'),
                    children: [
                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: routineExercise.repetitions.length,
                        itemBuilder: (context, seriesIndex) {
                          return Row(
                            children: [
                              IconButton(
                                icon: Icon(Icons.remove),
                                onPressed: () =>
                                    _removeSeries(index, seriesIndex),
                              ),
                              IconButton(
                                icon: Icon(Icons.remove),
                                onPressed: () {
                                  final currentReps =
                                      routineExercise.repetitions[seriesIndex];
                                  if (currentReps > 0) {
                                    _updateReps(
                                        index, seriesIndex, currentReps - 1);
                                  }
                                },
                              ),
                              Expanded(
                                child: TextField(
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    labelText: 'Reps',
                                  ),
                                  onChanged: (value) {
                                    final reps = int.tryParse(value) ?? 0;
                                    if (reps > 0) {
                                      _updateReps(index, seriesIndex, reps);
                                    }
                                  },
                                  controller: TextEditingController(
                                    text: routineExercise
                                        .repetitions[seriesIndex]
                                        .toString(),
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: Icon(Icons.add),
                                onPressed: () {
                                  final currentReps =
                                      routineExercise.repetitions[seriesIndex];
                                  if (currentReps > 0) {
                                    _updateReps(
                                        index, seriesIndex, currentReps + 1);
                                  }
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.remove),
                                onPressed: () {
                                  final currentWeight =
                                      routineExercise.weights[seriesIndex];
                                  if (currentWeight > 0) {
                                    _updateWeight(
                                        index, seriesIndex, currentWeight - 1);
                                  }
                                },
                              ),
                              Expanded(
                                child: TextField(
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    labelText: 'Kg',
                                  ),
                                  onChanged: (value) {
                                    final weight = int.tryParse(value) ?? 0;
                                    if (weight >= 0) {
                                      _updateWeight(index, seriesIndex, weight);
                                    }
                                  },
                                  controller: TextEditingController(
                                    text: routineExercise.weights[seriesIndex]
                                        .toString(),
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: Icon(Icons.add),
                                onPressed: () {
                                  final currentWeight =
                                      routineExercise.weights[seriesIndex];
                                  _updateWeight(
                                      index, seriesIndex, currentWeight + 1);
                                },
                              ),
                            ],
                          );
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: ElevatedButton(
                          onPressed: () => _addSeries(index),
                          child: Text('Add Series'),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveRoutine,
              child: Text('Save Routine'),
            ),
          ],
        ),
      ),
    );
  }
}
