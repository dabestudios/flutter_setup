// routine_storage.dart
import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:setup_app/tables/routine.dart';

class RoutineStorage {
  Future<String> _getLocalPath() async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  // Cambiar a público
  Future<File> getLocalFile() async {
    final path = await _getLocalPath();
    return File('$path/routines.json');
  }

  Future<List<Routine>> loadRoutines() async {
    try {
      final file = await getLocalFile();
      String contents = await file.readAsString();
      List<dynamic> jsonList = jsonDecode(contents);
      return jsonList.map((json) => Routine.fromJson(json)).toList();
    } catch (e) {
      print("Error loading routines: $e");
      return [];
    }
  }

  Future<void> saveRoutines(List<Routine> routines) async {
    final file = await getLocalFile();
    String jsonRoutines =
        jsonEncode(routines.map((routine) => routine.toJson()).toList());
    await file.writeAsString(jsonRoutines);
  }
}
