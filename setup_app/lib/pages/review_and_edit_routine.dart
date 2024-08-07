import 'package:flutter/material.dart';
import 'package:setup_app/tables/exercise.dart'; // Asegúrate de que esto apunte al archivo correcto donde tienes la clase Exercise

class ReviewAndEditPage extends StatefulWidget {
  final List<Exercise> selectedExercises;
  final void Function() onSave;

  ReviewAndEditPage({required this.selectedExercises, required this.onSave});

  @override
  _ReviewAndEditPageState createState() => _ReviewAndEditPageState();
}

class _ReviewAndEditPageState extends State<ReviewAndEditPage> {
  late List<Exercise> _editableExercises;

  @override
  void initState() {
    super.initState();
    _editableExercises = List.from(widget.selectedExercises);
  }

  void _editExercise(int index) {
    // Implementa tu lógica de edición aquí
    // Por ejemplo, podrías mostrar un formulario de edición
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditExercisePage(
          exercise: _editableExercises[index],
          onSave: (updatedExercise) {
            setState(() {
              _editableExercises[index] = updatedExercise;
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Review and Edit Exercises'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Selected Exercises:',
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: _editableExercises.length,
                itemBuilder: (context, index) {
                  final exercise = _editableExercises[index];
                  return ListTile(
                    title: Text(exercise.name),
                    subtitle: Text(
                      exercise.primaryMuscles.isNotEmpty
                          ? exercise.primaryMuscles[0]
                          : 'No Primary Muscle',
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () => _editExercise(index),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: widget.onSave,
              child: Text('Save Routine'),
            ),
          ],
        ),
      ),
    );
  }
}

class EditExercisePage extends StatelessWidget {
  final Exercise exercise;
  final void Function(Exercise updatedExercise) onSave;

  EditExercisePage({required this.exercise, required this.onSave});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit ${exercise.name}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Implementa tu formulario de edición aquí
            TextFormField(
              initialValue: exercise.name,
              decoration: InputDecoration(labelText: 'Exercise Name'),
              onChanged: (value) {
                // Actualiza el nombre del ejercicio
              },
            ),
            // Agrega más campos según sea necesario
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Llama a onSave con el ejercicio actualizado
                onSave(exercise);
                Navigator.pop(context);
              },
              child: Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }
}
