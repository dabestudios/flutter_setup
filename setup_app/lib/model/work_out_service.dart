import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class WorkoutService {
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
  Future<Map<String, dynamic>> loadExerciseStats() async {
    final file = await _getExerciseStatsFile();
    Map<String, dynamic> exerciseStats = {};

    try {
      if (await file.exists()) {
        String content = await file.readAsString();
        exerciseStats = Map<String, dynamic>.from(jsonDecode(content));
      }
    } catch (e) {
      print('Error al cargar el archivo de estadísticas de ejercicios: $e');
    }

    return exerciseStats;
  }

  // Método para cargar las rutinas
  Future<List<Map<String, dynamic>>> loadRoutines() async {
    final file = await _getRoutineFile();
    List<Map<String, dynamic>> routines = [];

    try {
      if (await file.exists()) {
        String content = await file.readAsString();
        routines = List<Map<String, dynamic>>.from(jsonDecode(content));
      }
    } catch (e) {
      print('Error al cargar las rutinas: $e');
    }

    return routines;
  }
}
