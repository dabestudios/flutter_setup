// review_and_edit_page.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:setup_app/pages/home_page.dart';
import 'package:setup_app/tables/exercise.dart';
import 'package:setup_app/tables/routine.dart';
import 'package:setup_app/tables/routine_exercise.dart';
import 'package:setup_app/model/routine_storage.dart';
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
  final RoutineStorage routineStorage = RoutineStorage();

  bool _isRoutineNameEmpty = true;

  @override
  void initState() {
    super.initState();
    _editableExercises = widget.selectedExercises.map((exercise) {
      return RoutineExercise(
        exerciseId: exercise.id,
        repetitions: [10, 10, 10],
        weights: [20, 20, 20],
        completionStatus: [false, false, false],
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
      _editableExercises[index].repetitions.add(10);
      _editableExercises[index].weights.add(20);
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

  Future<void> _saveRoutine() async {
    final routine = Routine(
      id: UniqueKey().toString(),
      name: _routineNameController.text,
      lastDate: DateTime.now(),
      exercises: _editableExercises,
    );

    // Guardar la rutina en la base de datos
    await _saveRoutineToDatabase(routine);

    // Guardar estadísticas de ejercicios para esta rutina
    widget.onSave(routine);
    if (!mounted) return;
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => HomePage()),
    );
  }

  Future<void> _saveRoutineToDatabase(Routine routine) async {
    try {
      // Cargar las rutinas existentes
      List<Routine> routines = await routineStorage.getRoutines();

      // Agregar la nueva rutina a la lista de rutinas existentes
      routines.add(routine);

      // Convertir la lista actualizada a JSON
      String jsonString = jsonEncode(routines.map((r) => r.toJson()).toList());

      // Guardar el JSON en el archivo local
      final file = await routineStorage.getLocalFile();
      await file.writeAsString(jsonString);
    } catch (e) {
      print("Error saving routine: $e");
    }
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
