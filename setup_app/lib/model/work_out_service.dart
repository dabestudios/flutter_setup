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
  Future<File> getRoutineFile() async {
    final path = await _getLocalPath();
    return File('$path/routines.json');
  }

  // Método para guardar las rutinas
  Future<void> saveRoutine(
      String routineId, Map<String, dynamic> routineData) async {
    final file = await getRoutineFile();
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
}
