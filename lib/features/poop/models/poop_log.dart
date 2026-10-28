class PoopLog {
  final String id;
  final int type; // 1 to 7
  final String color; // Brown, Green, Black, Red, Pale
  final String notes;
  final DateTime timestamp;

  PoopLog({
    required this.id,
    required this.type,
    required this.color,
    required this.notes,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type,
      'color': color,
      'notes': notes,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory PoopLog.fromMap(Map<String, dynamic> map) {
    return PoopLog(
      id: map['id'] as String? ?? '',
      type: map['type'] as int? ?? 4,
      color: map['color'] as String? ?? 'Brown',
      notes: map['notes'] as String? ?? '',
      timestamp: map['timestamp'] != null
          ? DateTime.parse(map['timestamp'] as String)
          : DateTime.now(),
    );
  }
}
