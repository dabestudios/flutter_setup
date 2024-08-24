class RoutineExercise {
  final String exerciseId;
  List<int> repetitions;
  List<int> weights;
  List<bool> completionStatus;

  RoutineExercise({
    required this.exerciseId,
    required this.repetitions,
    required this.weights,
    required this.completionStatus,
  });

  factory RoutineExercise.fromJson(Map<String, dynamic> json) {
    return RoutineExercise(
      exerciseId: json['exerciseId'],
      repetitions: List<int>.from(json['repetitions']),
      weights: List<int>.from(json['weights']),
      completionStatus: List<bool>.from(json['completionStatus']),
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'exerciseId': exerciseId,
      'repetitions': repetitions,
      'weights': weights,
      'completionStatus': completionStatus,
    };
  }

  Map<String, dynamic> toJson() {
    return {
      'exerciseId': exerciseId,
      'repetitions': repetitions,
      'weights': weights,
      'completionStatus': completionStatus,
    };
  }

  factory RoutineExercise.fromMap(Map<String, dynamic> map) {
    return RoutineExercise(
      exerciseId: map['exerciseId'],
      repetitions: List<int>.from(map['repetitions']),
      weights: List<int>.from(map['weights']),
      completionStatus: List<bool>.from(map['completionStatus']),
    );
  }
}
