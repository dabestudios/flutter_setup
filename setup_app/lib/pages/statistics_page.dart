import 'package:flutter/material.dart';
import 'package:setup_app/model/work_out_service.dart';
import 'package:flutter_locales/flutter_locales.dart'; // Importa flutter_locales

class StatisticsPage extends StatefulWidget {
  const StatisticsPage({super.key});

  @override
  State<StatisticsPage> createState() => _StatisticsPageState();
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
      _routines = await _workoutService.getRoutineStats();
      _exerciseStats = await _workoutService.getExerciseStats();
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
    String routineName = routine['name'] ?? Locales.string(context, 'no_name');
    String lastDate =
        routine['lastDate'] ?? Locales.string(context, 'last_date');
    int exerciseCount = routine['exercises']?.length ?? 0;

    return Card(
      child: ListTile(
        title: Text(
          routineName,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8.0),
            Text('${Locales.string(context, 'last_date')}: $lastDate'),
            Text(
                '${Locales.string(context, 'exercise_count')}: $exerciseCount'),
            const SizedBox(height: 8.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: routine['exercises']?.map<Widget>((exercise) {
                    String exerciseId = exercise['exerciseId'] ??
                        Locales.string(context, 'exercise');
                    List<dynamic> repetitions = exercise['repetitions'] ?? [];
                    List<dynamic> weights = exercise['weights'] ?? [];
                    List<dynamic> completionStatus =
                        exercise['completionStatus'] ?? [];

                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                              '${Locales.string(context, 'exercise')}: $exerciseId'),
                          Text(
                              '${Locales.string(context, 'repetitions')}: ${repetitions.join(", ")}'),
                          Text(
                              '${Locales.string(context, 'weights')}: ${weights.join(", ")}'),
                          Text(
                              '${Locales.string(context, 'completed')}: ${completionStatus.map((status) => status ? Locales.string(context, 'yes') : Locales.string(context, 'no')).join(", ")}'),
                          const Divider(),
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
                Text('${Locales.string(context, 'date')}: ${stat['date']}'),
                Text(
                    '${Locales.string(context, 'repetitions')}: ${stat['repetitions'].join(", ")}'),
                Text(
                    '${Locales.string(context, 'weights')}: ${stat['weights'].join(", ")}'),
                Text(
                    '${Locales.string(context, 'completed')}: ${stat['completionStatus'].map((status) => status ? Locales.string(context, 'yes') : Locales.string(context, 'no')).join(", ")}'),
                const SizedBox(height: 8.0),
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
        title: Text(Locales.string(context, 'statistics')),
      ),
      body: _routines.isEmpty && _exerciseStats.isEmpty
          ? Center(child: Text(Locales.string(context, 'no_statistics')))
          : ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    Locales.string(context, 'routine_statistics'),
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                ..._routines.map((routine) => _buildRoutineCard(routine)),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    Locales.string(context, 'exercise_statistics'),
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                ..._exerciseStats.entries.map((entry) {
                  return _buildExerciseStatsCard(
                      entry.key, List<dynamic>.from(entry.value['data']));
                }),
              ],
            ),
    );
  }
}
