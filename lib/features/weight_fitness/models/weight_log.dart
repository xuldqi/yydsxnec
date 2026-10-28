class WeightLog {
  final String id;
  final double weight; // kg
  final double? bodyFat; // optional %
  final String notes;
  final DateTime timestamp;

  WeightLog({
    required this.id,
    required this.weight,
    this.bodyFat,
    required this.notes,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'weight': weight,
      'bodyFat': bodyFat,
      'notes': notes,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory WeightLog.fromMap(Map<String, dynamic> map) {
    return WeightLog(
      id: map['id'] as String? ?? '',
      weight: (map['weight'] as num? ?? 65.0).toDouble(),
      bodyFat: map['bodyFat'] != null ? (map['bodyFat'] as num).toDouble() : null,
      notes: map['notes'] as String? ?? '',
      timestamp: map['timestamp'] != null
          ? DateTime.parse(map['timestamp'] as String)
          : DateTime.now(),
    );
  }
}
