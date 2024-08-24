import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:setup_app/model/work_out_service.dart';

class StatisticsPage extends StatefulWidget {
  @override
  _StatisticsPageState createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage> {
  final WorkoutService _workoutService = WorkoutService();
  List<Map<String, dynamic>> _routines = [];
  List<Map<String, dynamic>> _exerciseStats = [];

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
        _exerciseStats = [];
      });
    }
  }

  Widget _buildRoutineCard(Map<String, dynamic> routine) {
    return Card(
      child: ListTile(
        title: Text(routine['name']),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Duración: ${routine['totalDuration']}'),
            SizedBox(height: 8.0),
            Text('Ejercicios: ${routine['exercises'].length}'),
            Text('Fecha: ${routine['date']}'),
          ],
        ),
        onTap: () {
          // Aquí podrías abrir una nueva página con más detalles sobre la rutina específica
        },
      ),
    );
  }

  Widget _buildExerciseStatsCard(Map<String, dynamic> exerciseStats) {
    return Card(
      child: ListTile(
        title: Text('Exercise ID: ${exerciseStats['exerciseId']}'),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Fecha: ${exerciseStats['date']}'),
            Text('Repeticiones: ${exerciseStats['repetitions'].join(', ')}'),
            Text('Pesos: ${exerciseStats['weights'].join(', ')}'),
            Text(
                'Completado: ${exerciseStats['completionStatus'].map((status) => status ? "Sí" : "No").join(', ')}'),
          ],
        ),
        onTap: () {
          // Aquí podrías abrir una nueva página con más detalles sobre la rutina específica
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
                ..._exerciseStats
                    .map((exerciseStats) =>
                        _buildExerciseStatsCard(exerciseStats))
                    .toList(),
              ],
            ),
    );
  }
}
