import 'package:flutter/material.dart';
import 'package:setup_app/tables/data_base_helper.dart';
import 'package:setup_app/tables/routine.dart';

class SavedRoutinesPage extends StatefulWidget {
  @override
  _SavedRoutinesPageState createState() => _SavedRoutinesPageState();
}

class _SavedRoutinesPageState extends State<SavedRoutinesPage> {
  late Future<List<Routine>> _savedRoutines;

  @override
  void initState() {
    super.initState();
    _loadSavedRoutines();
  }

  void _loadSavedRoutines() {
    setState(() {
      _savedRoutines = _fetchRoutinesFromDatabase();
    });
  }

  Future<List<Routine>> _fetchRoutinesFromDatabase() async {
    // SQLite
    final dbHelper = DatabaseHelper();
    return await dbHelper.getRoutines();

    // Firebase
    //final firestoreService = FirestoreService();
    //return await firestoreService.getRoutines();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Saved Routines'),
      ),
      body: FutureBuilder<List<Routine>>(
        future: _savedRoutines,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error loading routines'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No routines found'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final routine = snapshot.data![index];
                return ListTile(
                  title: Text(routine.name),
                  subtitle:
                      Text('Last performed: ${routine.lastDate.toLocal()}'),
                  onTap: () {
                    _onRoutineSelected(routine);
                  },
                );
              },
            );
          }
        },
      ),
    );
  }

  void _onRoutineSelected(Routine routine) {
    // Aquí puedes navegar a una página de detalles o volver a una página anterior con la rutina seleccionada
    Navigator.pop(context, routine);
  }
}
