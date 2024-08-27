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
      if (!await file.exists()) {
        _routines = [];
        return;
      }
      String contents = await file.readAsString();
      List<dynamic> jsonList = jsonDecode(contents);
      _routines = jsonList.map((json) => Routine.fromJson(json)).toList();
    } catch (e) {
      print("Error loading routines: $e");
      _routines = []; // Asegurarse de que _routines no sea null
    }
  }

  Future<void> _saveRoutinesUpdated(List<Routine> routines) async {
    try {
      final file = await _getLocalFile();
      String jsonString = jsonEncode(routines.map((r) => r.toJson()).toList());
      await file.writeAsString(jsonString);
      _routines = routines;
      _loadRoutines(); // Actualizar la lista de rutinas
    } catch (e) {
      print("Error saving routines: $e");
    }
  }

  Future<void> saveRoutines(Routine routine) async {
    try {
      // Cargar las rutinas existentes
      List<Routine> routines = await getRoutines();

      // Agregar la nueva rutina a la lista de rutinas existentes
      routines.add(routine);

      // Guardar la lista actualizada
      await _saveRoutinesUpdated(routines);
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

  Future<void> replaceCurrentRoutine(Routine currentRoutine) async {
    try {
      await getRoutines(); // Asegúrate de que las rutinas estén cargadas

      int routineIndex =
          _routines!.indexWhere((routine) => routine.id == currentRoutine.id);

      if (routineIndex != -1) {
        // Si se encuentra la rutina, reemplazarla
        _routines![routineIndex] = currentRoutine;
        await _saveRoutinesUpdated(_routines!); // Guardar la lista actualizada
      } else {
        print("Routine with id ${currentRoutine.id} not found.");
      }
    } catch (e) {
      print("Error replacing routine: $e");
    }
  }
}
