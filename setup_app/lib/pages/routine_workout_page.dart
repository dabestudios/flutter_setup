import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:provider/provider.dart'; // Importar provider
import 'package:setup_app/model/exercise_service.dart';
import 'package:setup_app/model/routine_storage.dart';
import 'package:setup_app/model/work_out_service.dart';
import 'package:setup_app/model/routine_model.dart'; // Importar RoutineModel
import 'package:setup_app/pages/home_page.dart';
import 'package:setup_app/tables/routine_exercise.dart';
import 'package:audioplayers/audioplayers.dart';

class RoutineWorkoutPage extends StatefulWidget {
  const RoutineWorkoutPage({super.key});

  @override
  State<RoutineWorkoutPage> createState() => _RoutineWorkoutPageState();
}

class _RoutineWorkoutPageState extends State<RoutineWorkoutPage> {
  late List<RoutineExercise> _editableExercises;
  final ExerciseService _exerciseService = ExerciseService();
  final WorkoutService _workoutService = WorkoutService();
  final RoutineStorage routineStorage = RoutineStorage();

  int _hours = 0;
  int _minutes = 0;
  int _seconds = 0;
  late Timer _timer;
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _hasChanges = false;

  @override
  void initState() {
    super.initState();

    // Obtener la rutina actual del RoutineModel
    final routineModel = Provider.of<RoutineModel>(context, listen: false);
    final routine = routineModel.currentRoutine;

    if (routine == null) {
      // Manejar el caso en el que no hay rutina disponible
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(Locales.string(context, 'no_routine_available'))),
        );
        Navigator.pop(context);
      });
      return;
    }

    _editableExercises = routine.exercises
        .map((exercise) => RoutineExercise(
            exerciseId: exercise.exerciseId,
            repetitions: List<int>.from(exercise.repetitions, growable: true),
            weights: List<int>.from(exercise.weights, growable: true),
            completionStatus: List<bool>.filled(
                exercise.repetitions.length, false,
                growable: true)))
        .toList();

    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_seconds < 59) {
          _seconds++;
        } else {
          _seconds = 0;
          if (_minutes < 59) {
            _minutes++;
          } else {
            _minutes = 0;
            _hours++;
          }
        }
      });
    });
  }

  void _toggleCompletion(int exerciseIndex, int seriesIndex) async {
    setState(() {
      _editableExercises[exerciseIndex].completionStatus[seriesIndex] =
          !_editableExercises[exerciseIndex].completionStatus[seriesIndex];
    });

    if (_editableExercises[exerciseIndex].completionStatus[seriesIndex]) {
      await _audioPlayer.play(AssetSource('sounds/victory.mp3'));
    }
  }

  void _addSeries(int exerciseIndex) {
    setState(() {
      _editableExercises[exerciseIndex].repetitions.add(0);
      _editableExercises[exerciseIndex].weights.add(0);
      _editableExercises[exerciseIndex].completionStatus.add(false);
      _hasChanges = true;
    });
  }

  void _removeSeries(int exerciseIndex, int seriesIndex) {
    setState(() {
      _editableExercises[exerciseIndex].repetitions.removeAt(seriesIndex);
      _editableExercises[exerciseIndex].weights.removeAt(seriesIndex);
      _editableExercises[exerciseIndex].completionStatus.removeAt(seriesIndex);
      _hasChanges = true;
    });
  }

  void _removeExercise(int exerciseIndex) {
    setState(() {
      _editableExercises.removeAt(exerciseIndex);
      _hasChanges = true;
    });
  }

  void _finishWorkout() async {
    _stopTimer(); // Detén el temporizador.

    // Obtener la rutina actual del RoutineModel
    final routineModel = Provider.of<RoutineModel>(context, listen: false);
    final routine = routineModel.currentRoutine;

    if (routine == null) {
      // Manejar el caso en el que no hay rutina disponible
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(Locales.string(context, 'no_routine_available'))),
      );
      Navigator.pop(context);
      return;
    }

    // Prepara los datos de la rutina para guardar.
    Map<String, dynamic> routineData = {
      'name': routine.name,
      'date': DateTime.now().toIso8601String(),
      'exercises': _editableExercises.map((exercise) {
        return {
          'exerciseId': exercise.exerciseId,
          'repetitions': exercise.repetitions,
          'weights': exercise.weights,
          'completionStatus': exercise.completionStatus,
        };
      }).toList(),
      'duration': {
        'hours': _hours,
        'minutes': _minutes,
        'seconds': _seconds,
      },
    };

    // Guarda la rutina usando el servicio.
    await _workoutService.saveRoutineStats(routine.id, routineData);

    // Guarda las estadísticas de los ejercicios.
    for (var exercise in _editableExercises) {
      final exerciseStatsData = {
        'exerciseId': exercise.exerciseId,
        'date': DateTime.now().toIso8601String(),
        'repetitions': exercise.repetitions,
        'weights': exercise.weights,
        'completionStatus': exercise.completionStatus,
      };
      await _workoutService.saveExerciseStats(exerciseStatsData);
    }
    _workoutService.loadExerciseStats();
    _workoutService.loadRoutinesStats();
    // Si hay cambios, guarda la rutina en el almacenamiento local
    if (_hasChanges) {
      routine.exercises = _editableExercises;
      await routineStorage.replaceCurrentRoutine(routine);
    }
    if (!mounted) return;
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const HomePage()),
    );
  }

  void _stopTimer() {
    _timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    final routineModel = Provider.of<RoutineModel>(context);

    final routine = routineModel.currentRoutine;

    if (routine == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text(Locales.string(context, 'error')),
        ),
        body: Center(
          child: Text(Locales.string(context, 'no_routine_available')),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('${Locales.string(context, 'workout')} ${routine.name}'),
      ),
      body: ListView.builder(
        itemCount: _editableExercises.length,
        itemBuilder: (context, index) {
          final exercise = _editableExercises[index];
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        exercise.exerciseId,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    PopupMenuButton<String>(
                      onSelected: (value) {
                        if (value == 'add_series') {
                          _addSeries(index);
                        } else if (value == 'remove_exercise') {
                          _removeExercise(index);
                        } else if (value == 'remove_serie') {
                          _removeSeries(index, 0);
                        } else if (value == 'info') {
                          _exerciseService.showExerciseInfo(
                              context, exercise.exerciseId);
                        }
                      },
                      itemBuilder: (BuildContext context) =>
                          <PopupMenuEntry<String>>[
                        PopupMenuItem<String>(
                          value: 'add_series',
                          child: Text(Locales.string(context, 'add_serie')),
                        ),
                        PopupMenuItem<String>(
                          value: 'remove_exercise',
                          child:
                              Text(Locales.string(context, 'remove_exercise')),
                        ),
                        PopupMenuItem<String>(
                          value: 'remove_serie',
                          child: Text(Locales.string(context, 'remove_serie')),
                        ),
                        PopupMenuItem<String>(
                          value: 'info',
                          child: Text(Locales.string(context, 'info')),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 8.0),
                Table(
                  columnWidths: const {
                    0: FlexColumnWidth(2),
                    1: FlexColumnWidth(2),
                    2: FlexColumnWidth(2),
                    3: FlexColumnWidth(2),
                  },
                  children: [
                    TableRow(
                      decoration: BoxDecoration(
                        color: Theme.of(context).appBarTheme.backgroundColor,
                      ),
                      children: [
                        TableCell(
                          child: Container(
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              Locales.string(context, 'serie'),
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                        TableCell(
                          child: Container(
                            alignment: Alignment.center,
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              Locales.string(context, 'kg'),
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                        TableCell(
                          child: Container(
                            alignment: Alignment.center,
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              Locales.string(context, 'reps'),
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                        TableCell(
                          child: Container(
                            alignment: Alignment.center,
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              Locales.string(context, 'confirm'),
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                    ...List<TableRow>.generate(
                      exercise.repetitions.length,
                      (seriesIndex) => TableRow(
                        decoration: BoxDecoration(
                          color: exercise.completionStatus[seriesIndex]
                              ? Colors.greenAccent
                              : null,
                        ),
                        children: [
                          TableCell(
                            child: Container(
                              height: 48.0, // Altura consistente
                              alignment: Alignment.centerLeft,
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                '${Locales.string(context, 'serie')} ${seriesIndex + 1}',
                              ),
                            ),
                          ),
                          TableCell(
                            child: Container(
                              height: 48.0, // Altura consistente
                              padding: const EdgeInsets.all(8.0),
                              child: TextField(
                                textAlign: TextAlign.center,
                                keyboardType: TextInputType.number,
                                onChanged: (value) {
                                  setState(() {
                                    exercise.weights[seriesIndex] =
                                        int.tryParse(value) ??
                                            exercise.weights[seriesIndex];
                                  });
                                },
                                controller: TextEditingController(
                                    text: '${exercise.weights[seriesIndex]}'),
                                decoration: const InputDecoration(
                                  border: InputBorder
                                      .none, // Elimina la línea debajo del campo
                                ),
                              ),
                            ),
                          ),
                          TableCell(
                            child: Container(
                              height: 48.0, // Altura consistente
                              padding: const EdgeInsets.all(8.0),
                              child: TextField(
                                textAlign: TextAlign.center,
                                keyboardType: TextInputType.number,
                                onChanged: (value) {
                                  setState(() {
                                    exercise.repetitions[seriesIndex] =
                                        int.tryParse(value) ??
                                            exercise.repetitions[seriesIndex];
                                  });
                                },
                                controller: TextEditingController(
                                    text:
                                        '${exercise.repetitions[seriesIndex]}'),
                                decoration: const InputDecoration(
                                  border: InputBorder
                                      .none, // Elimina la línea debajo del campo
                                ),
                              ),
                            ),
                          ),
                          TableCell(
                            child: Container(
                              height: 48.0, // Altura consistente
                              padding: const EdgeInsets.all(8.0),
                              child: Checkbox(
                                value: exercise.completionStatus[seriesIndex],
                                onChanged: (value) {
                                  _toggleCompletion(index, seriesIndex);
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: BottomAppBar(
        color: Theme.of(context).appBarTheme.backgroundColor,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                '${_hours.toString().padLeft(2, '0')}:${_minutes.toString().padLeft(2, '0')}:${_seconds.toString().padLeft(2, '0')}',
                style: TextStyle(
                  fontSize: 18,
                  color: Theme.of(context).appBarTheme.foregroundColor,
                ),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).appBarTheme.foregroundColor,
                foregroundColor: Theme.of(context).appBarTheme.backgroundColor,
              ),
              onPressed: _finishWorkout,
              child: Text(Locales.string(context, 'finished')),
            ),
          ],
        ),
      ),
    );
  }
}
