import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:setup_app/model/work_out_service.dart';

class RoutineStatisticsPage extends StatefulWidget {
  @override
  _RoutineStatisticsPageState createState() => _RoutineStatisticsPageState();
}

class _RoutineStatisticsPageState extends State<RoutineStatisticsPage> {
  final WorkoutService _workoutService = WorkoutService();
  List<Map<String, dynamic>> _routines = [];

  @override
  void initState() {
    super.initState();
    _loadRoutines();
  }

  Future<void> _loadRoutines() async {
    try {
      File file = await _workoutService.getRoutineFile();
      String content = await file.readAsString();
      setState(() {
        _routines = List<Map<String, dynamic>>.from(jsonDecode(content));
      });
    } catch (e) {
      // Manejo de error si el archivo no existe o está vacío
      setState(() {
        _routines = [];
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
            Text(
                'Duración: ${routine['duration']['hours']}h ${routine['duration']['minutes']}m ${routine['duration']['seconds']}s'),
            SizedBox(height: 8.0),
            Text('Ejercicios: ${routine['exercises'].length}'),
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
        title: Text('Estadísticas de Rutinas'),
      ),
      body: _routines.isEmpty
          ? Center(child: Text('No hay rutinas guardadas.'))
          : ListView.builder(
              itemCount: _routines.length,
              itemBuilder: (context, index) {
                return _buildRoutineCard(_routines[index]);
              },
            ),
    );
  }
}
