import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:setup_app/model/work_out_service.dart';
import 'package:setup_app/pages/navbar.dart';
import 'package:setup_app/pages/new_page.dart';
import 'package:setup_app/pages/routine_list_page.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart'; // Para formatear las fechas

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final WorkoutService _workoutService = WorkoutService();

  Map<DateTime, List<String>> _markedDates =
      {}; // Inicializamos como un mapa vacío
  late List<Map<String, dynamic>> _routines; // Rutas con datos de entreno

  @override
  void initState() {
    super.initState();
    _loadRoutineStats(); // Cargar las rutinas
  }

  Future<void> _loadRoutineStats() async {
    // Aquí llamas a tu servicio para obtener los datos de entreno
    _routines = await _workoutService.getRoutineStats();

    // Marcamos los días de entreno en el calendario
    setState(() {
      _markedDates = {}; // Reiniciamos antes de agregar los nuevos datos
      for (var routine in _routines) {
        // Recorta la parte de la fracción de segundos si es necesario
        String dateString = routine['date'].split('.')[0];
        DateTime fullDate = DateTime.parse(dateString);

        // Normaliza la fecha ignorando la hora
        DateTime normalizedDate =
            DateTime(fullDate.year, fullDate.month, fullDate.day);

        // Agrega al mapa marcado solo la fecha (sin la hora)
        if (_markedDates[normalizedDate] == null) {
          _markedDates[normalizedDate] = [];
        }
        _markedDates[normalizedDate]?.add(routine['name']);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const NavBar(),
      appBar: AppBar(
        title: const LocaleText('app_name'),
      ),
      body: Column(
        children: <Widget>[
          // Calendario que muestra los días marcados
          TableCalendar(
            focusedDay: DateTime.now(),
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            calendarFormat: CalendarFormat.month,
            eventLoader: _getEventsForDay, // Cargamos los eventos por día
            calendarStyle: const CalendarStyle(
              markerDecoration: BoxDecoration(
                color: Colors.blue, // Color de los marcadores
                shape: BoxShape.circle,
              ),
            ),
            onDaySelected: (selectedDay, focusedDay) {
              // Opcional: Acciones cuando seleccionas un día
              _showRoutinesDialog(context, selectedDay);
            },
          ),
          const SizedBox(height: 20),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const NewPage()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 50, vertical: 20),
                    textStyle: const TextStyle(fontSize: 18),
                  ),
                  child: const LocaleText('create_routine'),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const RoutineListPage()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 50, vertical: 20),
                    textStyle: const TextStyle(fontSize: 18),
                  ),
                  child: const LocaleText('start_routine'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Función para obtener eventos por día
  // Función para obtener eventos por día
  List<String> _getEventsForDay(DateTime day) {
    DateTime normalizedDay = DateTime(
        day.year, day.month, day.day); // Normaliza la fecha seleccionada
    return _markedDates[normalizedDay] ?? [];
  }

  // Mostrar diálogo con las rutinas del día seleccionado
  void _showRoutinesDialog(BuildContext context, DateTime day) {
    print(day);
    final routines = _getEventsForDay(day);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
              'Entrenamientos del ${DateFormat('dd/MM/yyyy').format(day)}'),
          content: routines.isNotEmpty
              ? Column(
                  mainAxisSize: MainAxisSize.min,
                  children: routines.map((routine) => Text(routine)).toList(),
                )
              : const Text('No entrenaste este día.'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cerrar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
