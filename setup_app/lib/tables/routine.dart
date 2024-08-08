import 'package:setup_app/tables/routine_exercise.dart';

class Routine {
  final String id;
  final String name;
  final DateTime lastDate;
  final List<RoutineExercise> exercises; // Agregar la lista de ejercicios

  Routine({
    required this.id,
    required this.name,
    required this.lastDate,
    required this.exercises, // Inicializar la lista de ejercicios
  });

  factory Routine.fromJson(Map<String, dynamic> json) {
    return Routine(
      id: json['id'],
      name: json['name'],
      lastDate: DateTime.parse(json['lastDate']),
      exercises: (json['exercises'] as List<dynamic>)
          .map((e) => RoutineExercise.fromJson(e))
          .toList(), // Deserializar la lista de ejercicios
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'lastDate': lastDate.toIso8601String(),
      'exercises': exercises
          .map((e) => e.toJson())
          .toList(), // Serializar la lista de ejercicios
    };
  }
}
