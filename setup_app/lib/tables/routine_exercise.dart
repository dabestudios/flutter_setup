class RoutineExercise {
  final String exerciseId;
  List<int> repetitions;
  List<int> weights;
  List<bool>
      isCompleted; // Añadimos esta lista para el estado de completado de cada serie

  RoutineExercise({
    required this.exerciseId,
    required this.repetitions,
    required this.weights,
    required this.isCompleted,
  });

  // Deserialización: convierte un mapa JSON en un objeto RoutineExercise
  factory RoutineExercise.fromJson(Map<String, dynamic> json) {
    return RoutineExercise(
      exerciseId: json['exerciseId'],
      repetitions: List<int>.from(json['repetitions']),
      weights: List<int>.from(json['weights']),
      isCompleted: List<bool>.from(json['isCompleted']),
    );
  }

  // Serialización: convierte un objeto RoutineExercise en un mapa JSON
  Map<String, dynamic> toJson() {
    return {
      'exerciseId': exerciseId,
      'repetitions': repetitions,
      'weights': weights,
      'isCompleted': isCompleted,
    };
  }
}
