import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart'; 
import 'package:setup_app/pages/home_page.dart';
import 'package:setup_app/tables/exercise.dart';
import 'package:setup_app/tables/routine.dart';
import 'package:setup_app/tables/routine_exercise.dart';
import 'package:setup_app/model/routine_storage.dart';
import 'package:setup_app/widgets/reps_or_weight_editor.dart';

class ReviewAndEditPage extends StatefulWidget {
  final List<Exercise> selectedExercises;
  final void Function(Routine routine) onSave;

  const ReviewAndEditPage({
    super.key,
    required this.selectedExercises,
    required this.onSave,
  });

  @override
  State<ReviewAndEditPage> createState() => _ReviewAndEditPageState();
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
    await routineStorage.saveRoutines(routine);

    // Guardar estadísticas de ejercicios para esta rutina
    widget.onSave(routine);
    if (!mounted) return;
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const HomePage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
            Locales.string(context, 'review_and_edit_routine')), // Traducción
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
                labelText:
                    Locales.string(context, 'routine_name'), // Traducción
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              Locales.string(context, 'selected_exercises'), // Traducción
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
                        '${routineExercise.repetitions.length} series of ${routineExercise.repetitions.join(", ")} ${Locales.string(context, 'reps')}'), // Traducción
                    children: [
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
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
                                        label: Locales.string(
                                            context, 'reps'), // Traducción
                                        isReps: true,
                                      ),
                                      const Spacer(),
                                      RepsOrWeightEditor(
                                        value: routineExercise
                                            .weights[seriesIndex],
                                        onValueChanged: (newValue) =>
                                            _updateWeight(
                                                index, seriesIndex, newValue),
                                        label: Locales.string(
                                            context, 'kg'), // Traducción
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
                          child: Text(Locales.string(
                              context, 'add_series')), // Traducción
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
              child:
                  Text(Locales.string(context, 'save_routine')), // Traducción
            ),
          ],
        ),
      ),
    );
  }
}
