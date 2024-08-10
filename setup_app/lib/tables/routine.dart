import 'package:setup_app/tables/routine_exercise.dart';

class Routine {
  final String id;
  final String name;
  final DateTime lastDate;
  final List<RoutineExercise> exercises;

  Routine({
    required this.id,
    required this.name,
    required this.lastDate,
    required this.exercises,
  });

  // Método para convertir a un formato de mapa si estás guardando en una base de datos
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'lastDate': lastDate.toIso8601String(),
      'exercises': exercises.map((e) => e.toJson()).toList(),
    };
  }
}
