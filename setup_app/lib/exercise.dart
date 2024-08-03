import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:setup_app/main.dart';

// Clase Exercise
class Exercise {
  final String? name;
  final String? force;
  final String? level;
  final String? mechanic;
  final String? equipment;
  final List<String>? primaryMuscles;
  final List<String>? secondaryMuscles;
  final List<String>? instructions;
  final String? category;
  final List<String>? images;
  final String? id;

  Exercise({
    this.name,
    this.force,
    this.level,
    this.mechanic,
    this.equipment,
    this.primaryMuscles,
    this.secondaryMuscles,
    this.instructions,
    this.category,
    this.images,
    this.id,
  });

  factory Exercise.fromJson(Map<String, dynamic> json) {
    return Exercise(
      name: json['name'] as String?,
      force: json['force'] as String?,
      level: json['level'] as String?,
      mechanic: json['mechanic'] as String?,
      equipment: json['equipment'] as String?,
      primaryMuscles: (json['primaryMuscles'] as List<dynamic>?)
          ?.map((item) => item as String)
          .toList(),
      secondaryMuscles: (json['secondaryMuscles'] as List<dynamic>?)
          ?.map((item) => item as String)
          .toList(),
      instructions: (json['instructions'] as List<dynamic>?)
          ?.map((item) => item as String)
          .toList(),
      category: json['category'] as String?,
      images: (json['images'] as List<dynamic>?)
          ?.map((item) => item as String)
          .toList(),
      id: json['id'] as String?,
    );
  }
}

// Función para cargar los ejercicios
Future<void> loadExercises() async {
  try {
    final String response =
        await rootBundle.loadString('assets/exercises.json');
    final List<dynamic> data = json.decode(response);
    globalExercises = data.map((json) => Exercise.fromJson(json)).toList();
  } catch (error) {
    print("Error loading exercises: $error");
  }
}
