import 'package:flutter/material.dart';
import 'package:setup_app/pages/routine_detail_page.dart';
import 'package:setup_app/tables/routine.dart';
import 'package:setup_app/model/routine_storage.dart';

class RoutineListPage extends StatefulWidget {
  @override
  _RoutineListPageState createState() => _RoutineListPageState();
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
        title: const Text('My Routines'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
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
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No routines found.'));
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
                  margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  child: ListTile(
                    contentPadding: EdgeInsets.all(16.0),
                    leading: Icon(Icons.fitness_center, size: 40),
                    title: Text(
                      routine.name,
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    subtitle:
                        Text('Last updated: ${routine.lastDate.toLocal()}'),
                    trailing: IconButton(
                      icon: Icon(Icons.edit),
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
