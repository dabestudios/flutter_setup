import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:setup_app/tables/routine.dart';
import 'package:setup_app/tables/routine_exercise.dart';
import 'package:setup_app/tables/exercise_stats.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() {
    return _instance;
  }

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'fitness_app.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE routines (
            id TEXT PRIMARY KEY,
            name TEXT,
            lastDate TEXT
          )
        ''');
        await db.execute('''
          CREATE TABLE routine_exercises (
            id TEXT PRIMARY KEY,
            routineId TEXT,
            exerciseId TEXT,
            repetitions TEXT,
            weights TEXT,
            FOREIGN KEY(routineId) REFERENCES routines(id)
          )
        ''');
      },
    );
  }

  Future<void> insertRoutine(Routine routine) async {
    final db = await database;
    await db.insert('routines', routine.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> insertRoutineExercise(RoutineExercise exercise) async {
    final db = await database;
    await db.insert('routine_exercises', exercise.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> insertExerciseStats(ExerciseStats stats) async {
    final db = await database;
    await db.insert('exercise_stats', stats.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Routine>> getRoutines() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('routines');

    return List.generate(maps.length, (i) {
      return Routine.fromJson(maps[i]);
    });
  }

  // Métodos para insertar rutinas, ejercicios y estadísticas
}
