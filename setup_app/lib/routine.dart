import 'package:setup_app/selected_exercise.dart';

class Routine {
  final String name;
  final List<SelectedExercise> exercises;

  Routine({
    required this.name,
    required this.exercises,
  });

  // Método para convertir la clase a JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'exercises': exercises.map((exercise) => exercise.toJson()).toList(),
    };
  }

  // Método para crear una instancia de la clase desde JSON
  factory Routine.fromJson(Map<String, dynamic> json) {
    return Routine(
      name: json['name'],
      exercises: (json['exercises'] as List<dynamic>)
          .map((item) => SelectedExercise.fromJson(item))
          .toList(),
    );
  }
}
