import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart'; // Asegúrate de importar flutter_locales
import 'package:setup_app/pages/routine_detail_page.dart';
import 'package:setup_app/tables/routine.dart';
import 'package:setup_app/model/routine_storage.dart';

class RoutineListPage extends StatefulWidget {
  const RoutineListPage({super.key});

  @override
  State<RoutineListPage> createState() => _RoutineListPageState();
}

class _RoutineListPageState extends State<RoutineListPage> {
  // Usar la instancia singleton de RoutineStorage
  final RoutineStorage _routineStorage = RoutineStorage();
  late Future<List<Routine>> _routinesFuture;

  @override
  void initState() {
    super.initState();
    _routinesFuture = _routineStorage.getRoutines();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Locales.string(context, 'my_routines')), // Traducción
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              // Agrega una nueva rutina (implementar esta funcionalidad)
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Routine>>(
        future: _routinesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
                child: Text(Locales.string(
                    context, 'no_routines_found'))); // Traducción
          }

          final routines = snapshot.data!;

          return ListView.builder(
            itemCount: routines.length,
            itemBuilder: (context, index) {
              final routine = routines[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RoutineDetailPage(routine: routine),
                    ),
                  );
                },
                child: Card(
                  margin: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 16.0),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16.0),
                    leading: const Icon(Icons.fitness_center, size: 40),
                    title: Text(
                      routine.name,
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      '${Locales.string(context, 'last_updated')} ${routine.lastDate.toLocal()}', // Traducción
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        // Navega a la pantalla de edición
                      },
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
