class RoutineExercise {
  final String routineId;
  final String exerciseId;
  final List<int> repetitions; // Lista de repeticiones por serie
  final List<int> weights; // Lista de pesos (kg) por serie

  RoutineExercise({
    required this.routineId,
    required this.exerciseId,
    required this.repetitions,
    required this.weights,
  });

  factory RoutineExercise.fromJson(Map<String, dynamic> json) {
    return RoutineExercise(
      routineId: json['routineId'],
      exerciseId: json['exerciseId'],
      repetitions: List<int>.from(json['repetitions']),
      weights: List<int>.from(json['weights']), // Deserializar pesos
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'routineId': routineId,
      'exerciseId': exerciseId,
      'repetitions': repetitions,
      'weights': weights, // Serializar pesos
    };
  }
}
