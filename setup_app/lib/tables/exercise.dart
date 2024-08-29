import 'dart:convert';
import 'package:flutter/services.dart';

class Exercise {
  final String id;
  final String name;
  final String? force;
  final String? level;
  final String? mechanic;
  final String? equipment;
  final List<String> primaryMuscles;
  final List<String> secondaryMuscles;
  final List<String> instructions;
  final String category;
  final String? images;

  Exercise({
    required this.id,
    required this.name,
    this.force,
    required this.level,
    this.mechanic,
    this.equipment,
    required this.primaryMuscles,
    required this.secondaryMuscles,
    required this.instructions,
    required this.category,
    required this.images,
  });

  factory Exercise.fromJson(Map<String, dynamic> json) {
    return Exercise(
      id: json['id'],
      name: json['name'],
      force: json['force'],
      level: json['level'],
      mechanic: json['mechanic'],
      equipment: json['equipment'],
      primaryMuscles: List<String>.from(json['primaryMuscles']),
      secondaryMuscles: List<String>.from(json['secondaryMuscles']),
      instructions: List<String>.from(json['instructions']),
      category: json['category'],
      images: json['images'],
    );
  }
}

class ExerciseLoader {
  static final ExerciseLoader _instance = ExerciseLoader._internal();
  List<Exercise>? _exercises;

  factory ExerciseLoader() {
    return _instance;
  }

  ExerciseLoader._internal();

  Future<void> _loadExercises() async {
    final String response =
        await rootBundle.loadString('assets/exercises_actualizado.json');
    final List<dynamic> data = json.decode(response);
    _exercises = data.map((json) => Exercise.fromJson(json)).toList();
  }

  Future<List<Exercise>> getExercises() async {
    if (_exercises == null) {
      await _loadExercises();
    }
    return _exercises!;
  }

  Future<Exercise?> getExerciseById(String id) async {
    final exercises = await getExercises();
    return exercises.firstWhere((exercise) => exercise.id == id);
  }
}
