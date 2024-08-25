import 'package:flutter/material.dart';
import 'package:setup_app/tables/routine.dart'; // Asegúrate de tener acceso a Routine

class RoutineModel extends ChangeNotifier {
  Routine? _currentRoutine;

  Routine? get currentRoutine => _currentRoutine;

  // Método para establecer una rutina
  Future<void> setRoutine(Routine routine) async {
    // Simula un proceso de guardado; en una aplicación real, esto podría ser una llamada a una base de datos o API

    _currentRoutine = routine;
    notifyListeners(); // Notifica a los consumidores del cambio
  }
}
