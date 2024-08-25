import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:setup_app/tables/routine.dart';

class RoutineStorage {
  // Crear una instancia estática de RoutineStorage
  static final RoutineStorage _instance = RoutineStorage._internal();
  List<Routine>? _routines;

  // Constructor privado
  RoutineStorage._internal();

  // Retorna la instancia única de RoutineStorage
  factory RoutineStorage() {
    return _instance;
  }

  Future<String> _getLocalPath() async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> _getLocalFile() async {
    final path = await _getLocalPath();
    return File('$path/routines.json');
  }

  Future<void> _loadRoutines() async {
    try {
      final file = await _getLocalFile();
      String contents = await file.readAsString();
      List<dynamic> jsonList = jsonDecode(contents);
      _routines = jsonList.map((json) => Routine.fromJson(json)).toList();
    } catch (e) {
      print("Error loading routines: $e");
    }
  }

  Future<void> saveRoutines(Routine routine) async {
    try {
      // Cargar las rutinas existentes
      List<Routine> routines = await getRoutines();

      // Agregar la nueva rutina a la lista de rutinas existentes
      routines.add(routine);

      // Convertir la lista actualizada a JSON
      String jsonString = jsonEncode(routines.map((r) => r.toJson()).toList());

      // Guardar el JSON en el archivo local
      final file = await _getLocalFile();
      await file.writeAsString(jsonString);
    } catch (e) {
      print("Error saving routine: $e");
    }
  }

  Future<List<Routine>> getRoutines() async {
    if (_routines == null) {
      await _loadRoutines();
    }
    return _routines!;
  }

  Future<void> _saveRoutinesUpdated(List<Routine> routines) async {
    final file = await _getLocalFile();
    String jsonString = jsonEncode(routines.map((r) => r.toJson()).toList());
    await file.writeAsString(jsonString);
    await _loadRoutines(); // Recargar después de guardar para mantener el estado actualizado
  }

  Future<void> updateRoutine(String id, Routine updatedRoutine) async {
    await getRoutines(); // Asegurarse de que las rutinas estén cargadas

    // Asegurarse de que completionStatus sea false para todos los ejercicios
    for (var exercise in updatedRoutine.exercises) {
      exercise.completionStatus =
          List.filled(exercise.repetitions.length, false);
    }

    int routineIndex = _routines!.indexWhere((routine) => routine.id == id);

    if (routineIndex != -1) {
      // Si se encuentra la rutina, actualizarla
      _routines![routineIndex] = updatedRoutine;
      await _saveRoutinesUpdated(_routines!); // Guardar la lista actualizada
    } else {
      print("Routine with id $id not found.");
    }
  }
}
