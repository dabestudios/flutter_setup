import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class WorkoutService {
  // Campo estático para almacenar la instancia singleton
  static final WorkoutService _instance = WorkoutService._internal();
  Map<String, dynamic>? _exerciseStats;
  List<Map<String, dynamic>>? _routineStats;
  // Constructor privado para evitar la creación de instancias externas

  // Fábrica que devuelve la misma instancia siempre
  factory WorkoutService() {
    return _instance;
  }

  WorkoutService._internal();

  // Método para obtener el directorio donde se guardan los datos
  Future<String> _getLocalPath() async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  // Método para obtener el archivo de rutinas
  Future<File> _getRoutineFile() async {
    final path = await _getLocalPath();
    return File('$path/routines_stats.json');
  }

  // Método para obtener el archivo de estadísticas de ejercicios
  Future<File> _getExerciseStatsFile() async {
    final path = await _getLocalPath();
    return File('$path/exercise_stats.json');
  }

  // Método para guardar las rutinas
  Future<void> saveRoutineStats(
      String routineId, Map<String, dynamic> routineData) async {
    final file = await _getRoutineFile();
    List<Map<String, dynamic>> routines = [];

    try {
      // Leer el contenido existente
      if (await file.exists()) {
        String content = await file.readAsString();
        routines = List<Map<String, dynamic>>.from(jsonDecode(content));
      }
    } catch (e) {
      // Manejar errores de lectura (si el archivo está vacío o corrupto)
      print('Error al leer el archivo de rutinas: $e');
    }

    // Actualizar o añadir la rutina
    routines.removeWhere((routine) => routine['id'] == routineId);
    routines.add(routineData);

    // Guardar el contenido actualizado
    await file.writeAsString(jsonEncode(routines));
  }

  // Método para guardar las estadísticas de ejercicios
  Future<void> saveExerciseStats(Map<String, dynamic> exerciseStatsData) async {
    final file = await _getExerciseStatsFile();
    Map<String, dynamic> exerciseStats = {};

    try {
      // Leer el contenido existente del archivo
      if (await file.exists()) {
        String content = await file.readAsString();
        exerciseStats = Map<String, dynamic>.from(jsonDecode(content));
      }
    } catch (e) {
      print('Error al leer el archivo de estadísticas de ejercicios: $e');
    }

    String exerciseId = exerciseStatsData['exerciseId'];

    // Si ya existe una entrada para este exerciseId, agregamos los nuevos datos
    if (exerciseStats.containsKey(exerciseId)) {
      List<dynamic> existingData = exerciseStats[exerciseId]['data'];
      existingData.add(exerciseStatsData);
    } else {
      // Si no existe, creamos una nueva entrada
      exerciseStats[exerciseId] = {
        'exerciseId': exerciseId,
        'data': [exerciseStatsData]
      };
    }

    // Guardar el contenido actualizado en el archivo
    await file.writeAsString(jsonEncode(exerciseStats));
  }

  // Método para cargar las estadísticas de ejercicios desde una lista
  Future<void> loadExerciseStats() async {
    final file = await _getExerciseStatsFile();

    try {
      if (await file.exists()) {
        String content = await file.readAsString();
        _exerciseStats = Map<String, dynamic>.from(jsonDecode(content));
      }
    } catch (e) {
      print('Error al cargar el archivo de estadísticas de ejercicios: $e');
    }
  }

  // Método para cargar las rutinas
  Future<void> loadRoutinesStats() async {
    final file = await _getRoutineFile();

    try {
      if (await file.exists()) {
        String content = await file.readAsString();
        _routineStats = List<Map<String, dynamic>>.from(jsonDecode(content));
      }
    } catch (e) {
      print('Error al cargar las rutinas: $e');
    }
  }

  // Método para obtener las estadísticas de rutinas
  Future<List<Map<String, dynamic>>> getRoutineStats() async {
    if (_routineStats == null) {
      await loadRoutinesStats();
    }
    return _routineStats!;
  }

  // Método para obtener las estadísticas de ejercicios
  Future<Map<String, dynamic>> getExerciseStats() async {
    if (_exerciseStats == null) {
      await loadExerciseStats();
    }
    return _exerciseStats ?? {}; // Asegurarse de que nunca devuelva null
  }
}
