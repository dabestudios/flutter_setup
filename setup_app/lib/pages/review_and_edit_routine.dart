import 'package:flutter/material.dart';
import 'package:setup_app/tables/exercise.dart';
import 'package:setup_app/tables/routine.dart';
import 'package:setup_app/tables/routine_exercise.dart';
import 'package:setup_app/widgets/RepsOrWeightEditor.dart';

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
  bool _isRoutineNameEmpty = true;

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

    _routineNameController.addListener(_onRoutineNameChanged);
  }

  void _onRoutineNameChanged() {
    setState(() {
      _isRoutineNameEmpty = _routineNameController.text.isEmpty;
    });
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
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Review and Edit Routine'),
        backgroundColor: theme.appBarTheme.backgroundColor,
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
                        '${routineExercise.repetitions.length} series of ${routineExercise.repetitions.join(", ")} reps'),
                    children: [
                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: routineExercise.repetitions.length,
                        itemBuilder: (context, seriesIndex) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5.0),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      RepsOrWeightEditor(
                                        value: routineExercise
                                            .repetitions[seriesIndex],
                                        onValueChanged: (newValue) =>
                                            _updateReps(
                                                index, seriesIndex, newValue),
                                        label: 'Reps',
                                        isReps: true,
                                      ),
                                      const Spacer(),
                                      RepsOrWeightEditor(
                                        value: routineExercise
                                            .weights[seriesIndex],
                                        onValueChanged: (newValue) =>
                                            _updateWeight(
                                                index, seriesIndex, newValue),
                                        label: 'Kg',
                                        isReps: false,
                                      ),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(Icons.delete,
                                      color: theme.colorScheme.inversePrimary),
                                  onPressed: () =>
                                      _removeSeries(index, seriesIndex),
                                ),
                              ],
                            ),
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
              onPressed: _isRoutineNameEmpty ? null : _saveRoutine,
              child: Text('Save Routine'),
            ),
          ],
        ),
      ),
    );
  }
}
