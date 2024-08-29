class ExerciseInstance {
  final String routineId;
  final DateTime date;
  final List<int> repetitions;
  final List<int> weights;
  final List<bool> completionStatus;

  ExerciseInstance({
    required this.routineId,
    required this.date,
    required this.repetitions,
    required this.weights,
    required this.completionStatus,
  });

  Map<String, dynamic> toMap() {
    return {
      'routineId': routineId,
      'date': date.toIso8601String(),
      'repetitions': repetitions,
      'weights': weights,
      'completionStatus': completionStatus,
    };
  }

  factory ExerciseInstance.fromMap(Map<String, dynamic> map) {
    return ExerciseInstance(
      routineId: map['routineId'],
      date: DateTime.parse(map['date']),
      repetitions: List<int>.from(map['repetitions']),
      weights: List<int>.from(map['weights']),
      completionStatus: List<bool>.from(map['completionStatus']),
    );
  }
}
