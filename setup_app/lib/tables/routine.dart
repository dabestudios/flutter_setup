class Routine {
  final String id;
  final String name;
  final DateTime lastDate;

  Routine({
    required this.id,
    required this.name,
    required this.lastDate,
  });

  factory Routine.fromJson(Map<String, dynamic> json) {
    return Routine(
      id: json['id'],
      name: json['name'],
      lastDate: DateTime.parse(json['lastDate']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'lastDate': lastDate.toIso8601String(),
    };
  }
}
