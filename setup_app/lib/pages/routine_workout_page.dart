import 'dart:async';
import 'package:flutter/material.dart';
import 'package:setup_app/model/exercise_service.dart';
import 'package:setup_app/tables/routine.dart';
import 'package:setup_app/tables/routine_exercise.dart';
import 'package:audioplayers/audioplayers.dart';

class RoutineWorkoutPage extends StatefulWidget {
  final Routine routine;

  RoutineWorkoutPage({required this.routine});

  @override
  _RoutineWorkoutPageState createState() => _RoutineWorkoutPageState();
}

class _RoutineWorkoutPageState extends State<RoutineWorkoutPage> {
  late List<RoutineExercise> _editableExercises;
  final ExerciseService _exerciseService = ExerciseService();
  int _hours = 0;
  int _minutes = 0;
  int _seconds = 0;
  late Timer _timer;
  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    _startTimer();
    _editableExercises = widget.routine.exercises
        .map((exercise) => RoutineExercise(
            exerciseId: exercise.exerciseId,
            repetitions: List<int>.from(exercise.repetitions, growable: true),
            weights: List<int>.from(exercise.weights, growable: true),
            isCompleted: List<bool>.filled(exercise.repetitions.length, false,
                growable: true)))
        .toList();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
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
      _editableExercises[exerciseIndex].isCompleted[seriesIndex] =
          !_editableExercises[exerciseIndex].isCompleted[seriesIndex];
    });

    if (_editableExercises[exerciseIndex].isCompleted[seriesIndex]) {
      await _audioPlayer.play(AssetSource('sounds/victory.mp3'));
    }
  }

  void _addSeries(int exerciseIndex) {
    setState(() {
      _editableExercises[exerciseIndex].repetitions.add(0);
      _editableExercises[exerciseIndex].weights.add(0);
      _editableExercises[exerciseIndex].isCompleted.add(false);
    });
  }

  void _removeSeries(int exerciseIndex, int seriesIndex) {
    setState(() {
      _editableExercises[exerciseIndex].repetitions.removeAt(seriesIndex);
      _editableExercises[exerciseIndex].weights.removeAt(seriesIndex);
      _editableExercises[exerciseIndex].isCompleted.removeAt(seriesIndex);
    });
  }

  void _removeExercise(int exerciseIndex) {
    setState(() {
      _editableExercises.removeAt(exerciseIndex);
    });
  }

  void _finishWorkout() {
    Navigator.pop(context);
  }

  void _stopTimer() {
    if (_timer != null) {
      _timer.cancel();
    }
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
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Exercise: ${exercise.exerciseId}',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                          child: Text('Add Serie'),
                        ),
                        PopupMenuItem<String>(
                          value: 'remove_exercise',
                          child: Text('Remove Exercise'),
                        ),
                        PopupMenuItem<String>(
                          value: 'remove_serie',
                          child: Text('Remove Serie'),
                        ),
                        PopupMenuItem<String>(
                          value: 'info',
                          child: Text('Info'),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 8.0),
                Table(
                  columnWidths: {
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
                              'Serie',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                        TableCell(
                          child: Container(
                            alignment: Alignment.center,
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'Kg',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                        TableCell(
                          child: Container(
                            alignment: Alignment.center,
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'Reps',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                        TableCell(
                          child: Container(
                            alignment: Alignment.center,
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'Confirm',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                    ...List<TableRow>.generate(
                      exercise.repetitions.length,
                      (seriesIndex) => TableRow(
                        decoration: BoxDecoration(
                          color: exercise.isCompleted[seriesIndex]
                              ? Colors.greenAccent
                              : null,
                        ),
                        children: [
                          TableCell(
                            child: Container(
                              height: 48.0, // Altura consistente
                              alignment: Alignment.centerLeft,
                              padding: const EdgeInsets.all(8.0),
                              child: Text('Serie ${seriesIndex + 1}',
                                  style: TextStyle(
                                    color: Colors.black,
                                    shadows: [], // Elimina la sombra del texto
                                  )),
                            ),
                          ),
                          TableCell(
                            child: Container(
                              height: 48.0, // Altura consistente
                              padding: const EdgeInsets.all(8.0),
                              child: TextField(
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
                                decoration: InputDecoration(
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
                                decoration: InputDecoration(
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
                                value: exercise.isCompleted[seriesIndex],
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
            IconButton(
              icon: Icon(Icons.stop),
              color: Colors.red,
              onPressed: () {
                _stopTimer();
                _finishWorkout();
              },
            ),
          ],
        ),
      ),
    );
  }
}
