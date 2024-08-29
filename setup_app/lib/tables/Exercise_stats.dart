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

  // Crear una instancia de ExerciseStats desde un mapa (para cargar desde JSON)
  factory ExerciseStats.fromMap(Map<String, dynamic> map) {
    return ExerciseStats(
      id: map['id'],
      exerciseId: map['exerciseId'],
      routineId: map['routineId'],
      date: DateTime.parse(map['date']),
      repetitions: List<int>.from(map['repetitions']),
      weights: List<int>.from(map['weights']),
      completionStatus: List<bool>.from(map['completionStatus']),
    );
  }
}
