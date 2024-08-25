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

  // Hacer público el acceso al archivo local
  Future<File> getLocalFile() async {
    final path = await _getLocalPath();
    return File('$path/routines.json');
  }

  Future<void> _loadRoutines() async {
    try {
      final file = await getLocalFile();
      String contents = await file.readAsString();
      List<dynamic> jsonList = jsonDecode(contents);
      _routines = jsonList.map((json) => Routine.fromJson(json)).toList();
    } catch (e) {
      print("Error loading routines: $e");
    }
  }

  Future<void> saveRoutines(List<Routine> routines) async {
    final file = await getLocalFile();
    String jsonRoutines =
        jsonEncode(routines.map((routine) => routine.toJson()).toList());
    await file.writeAsString(jsonRoutines);
  }

  Future<List<Routine>> getRoutines() async {
    if (_routines == null) {
      await _loadRoutines();
    }
    return _routines!;
  }
}
