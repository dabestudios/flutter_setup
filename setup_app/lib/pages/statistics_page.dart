import 'package:flutter/material.dart';
import 'package:setup_app/model/work_out_service.dart';

class StatisticsPage extends StatefulWidget {
  @override
  _StatisticsPageState createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage> {
  final WorkoutService _workoutService = WorkoutService();
  List<Map<String, dynamic>> _routines = [];
  Map<String, dynamic> _exerciseStats = {};

  @override
  void initState() {
    super.initState();
    _loadStatistics();
  }

  Future<void> _loadStatistics() async {
    try {
      _routines = await _workoutService.loadRoutines();
      _exerciseStats = await _workoutService.loadExerciseStats();
      setState(() {});
    } catch (e) {
      // Manejo de error si los archivos no existen o están vacíos
      setState(() {
        _routines = [];
        _exerciseStats = {};
      });
    }
  }

  Widget _buildRoutineCard(Map<String, dynamic> routine) {
    // Obteniendo los datos relevantes de la rutina
    String routineName = routine['name'] ?? 'Sin nombre';
    String lastDate = routine['lastDate'] ?? 'Fecha no disponible';
    int exerciseCount = routine['exercises']?.length ?? 0;

    return Card(
      child: ListTile(
        title: Text(
          routineName,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 8.0),
            Text('Fecha de la última rutina: $lastDate'),
            Text('Número de ejercicios: $exerciseCount'),
            SizedBox(height: 8.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: routine['exercises']?.map<Widget>((exercise) {
                    String exerciseId =
                        exercise['exerciseId'] ?? 'ID no disponible';
                    List<dynamic> repetitions = exercise['repetitions'] ?? [];
                    List<dynamic> weights = exercise['weights'] ?? [];
                    List<dynamic> completionStatus =
                        exercise['completionStatus'] ?? [];

                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Ejercicio: $exerciseId'),
                          Text('Repeticiones: ${repetitions.join(", ")}'),
                          Text('Pesos: ${weights.join(", ")}'),
                          Text(
                              'Completado: ${completionStatus.map((status) => status ? "Sí" : "No").join(", ")}'),
                          Divider(),
                        ],
                      ),
                    );
                  })?.toList() ??
                  [],
            ),
          ],
        ),
        onTap: () {
          // Aquí podrías abrir una nueva página con más detalles sobre la rutina específica
        },
      ),
    );
  }

  Widget _buildExerciseStatsCard(String exerciseId, List<dynamic> stats) {
    return Card(
      child: ListTile(
        title: Text(exerciseId),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: stats.map((stat) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Fecha: ${stat['date']}'),
                Text('Repeticiones: ${stat['repetitions'].join(", ")}'),
                Text('Pesos: ${stat['weights'].join(", ")}'),
                Text('Completado: ${stat['completionStatus'].join(", ")}'),
                SizedBox(height: 8.0),
              ],
            );
          }).toList(),
        ),
        onTap: () {
          // Aquí podrías abrir una nueva página con más detalles sobre el ejercicio específico
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Estadísticas'),
      ),
      body: _routines.isEmpty && _exerciseStats.isEmpty
          ? Center(child: Text('No hay estadísticas guardadas.'))
          : ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Estadísticas de Rutinas',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                ..._routines
                    .map((routine) => _buildRoutineCard(routine))
                    .toList(),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Estadísticas de Ejercicios',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                ..._exerciseStats.entries.map((entry) {
                  return _buildExerciseStatsCard(
                      entry.key, List<dynamic>.from(entry.value['data']));
                }).toList(),
              ],
            ),
    );
  }
}
