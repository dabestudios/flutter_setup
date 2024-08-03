class SelectedExercise {
  final String exerciseId;
  int series;
  int repetitions;

  SelectedExercise({
    required this.exerciseId,
    this.series = 0,
    this.repetitions = 0,
  });

  // Método para convertir la clase a JSON
  Map<String, dynamic> toJson() {
    return {
      'exerciseId': exerciseId,
      'series': series,
      'repetitions': repetitions,
    };
  }

  // Método para crear una instancia de la clase desde JSON
  factory SelectedExercise.fromJson(Map<String, dynamic> json) {
    return SelectedExercise(
      exerciseId: json['exerciseId'],
      series: json['series'],
      repetitions: json['repetitions'],
    );
  }
}
