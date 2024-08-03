class RoutineExercise {
  final String routineId;
  final String exerciseId;
  final int series;
  final int repetitions;

  RoutineExercise({
    required this.routineId,
    required this.exerciseId,
    required this.series,
    required this.repetitions,
  });

  factory RoutineExercise.fromJson(Map<String, dynamic> json) {
    return RoutineExercise(
      routineId: json['routineId'],
      exerciseId: json['exerciseId'],
      series: json['series'],
      repetitions: json['repetitions'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'routineId': routineId,
      'exerciseId': exerciseId,
      'series': series,
      'repetitions': repetitions,
    };
  }
}
