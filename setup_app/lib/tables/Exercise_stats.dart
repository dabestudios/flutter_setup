class ExerciseStats {
  final String id;
  final String exerciseId;
  final String routineId;
  final DateTime date;
  final List<int> repetitions;
  final List<int> weights;
  final List<bool> completionStatus; // Añadido para el estado de completado

  ExerciseStats({
    required this.id,
    required this.exerciseId,
    required this.routineId,
    required this.date,
    required this.repetitions,
    required this.weights,
    required this.completionStatus,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'exerciseId': exerciseId,
      'routineId': routineId,
      'date': date.toIso8601String(),
      'repetitions': repetitions,
      'weights': weights,
      'completionStatus': completionStatus,
    };
  }
}
