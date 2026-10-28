// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_constants.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FastingDifficultyAdapter extends TypeAdapter<FastingDifficulty> {
  @override
  final int typeId = 1;

  @override
  FastingDifficulty read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return FastingDifficulty.beginner;
      case 1:
        return FastingDifficulty.intermediate;
      case 2:
        return FastingDifficulty.advanced;
      default:
        return FastingDifficulty.beginner;
    }
  }

  @override
  void write(BinaryWriter writer, FastingDifficulty obj) {
    switch (obj) {
      case FastingDifficulty.beginner:
        writer.writeByte(0);
        break;
      case FastingDifficulty.intermediate:
        writer.writeByte(1);
        break;
      case FastingDifficulty.advanced:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FastingDifficultyAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class FastingStatusAdapter extends TypeAdapter<FastingStatus> {
  @override
  final int typeId = 10;

  @override
  FastingStatus read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return FastingStatus.notStarted;
      case 1:
        return FastingStatus.active;
      case 2:
        return FastingStatus.paused;
      case 3:
        return FastingStatus.completed;
      case 4:
        return FastingStatus.cancelled;
      default:
        return FastingStatus.notStarted;
    }
  }

  @override
  void write(BinaryWriter writer, FastingStatus obj) {
    switch (obj) {
      case FastingStatus.notStarted:
        writer.writeByte(0);
        break;
      case FastingStatus.active:
        writer.writeByte(1);
        break;
      case FastingStatus.paused:
        writer.writeByte(2);
        break;
      case FastingStatus.completed:
        writer.writeByte(3);
        break;
      case FastingStatus.cancelled:
        writer.writeByte(4);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FastingStatusAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class SuggestionTypeAdapter extends TypeAdapter<SuggestionType> {
  @override
  final int typeId = 8;

  @override
  SuggestionType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return SuggestionType.fastingPlan;
      case 1:
        return SuggestionType.waterIntake;
      case 2:
        return SuggestionType.weightManagement;
      case 3:
        return SuggestionType.exercise;
      case 4:
        return SuggestionType.eatingWindow;
      case 5:
        return SuggestionType.healthRisk;
      default:
        return SuggestionType.fastingPlan;
    }
  }

  @override
  void write(BinaryWriter writer, SuggestionType obj) {
    switch (obj) {
      case SuggestionType.fastingPlan:
        writer.writeByte(0);
        break;
      case SuggestionType.waterIntake:
        writer.writeByte(1);
        break;
      case SuggestionType.weightManagement:
        writer.writeByte(2);
        break;
      case SuggestionType.exercise:
        writer.writeByte(3);
        break;
      case SuggestionType.eatingWindow:
        writer.writeByte(4);
        break;
      case SuggestionType.healthRisk:
        writer.writeByte(5);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SuggestionTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class SuggestionPriorityAdapter extends TypeAdapter<SuggestionPriority> {
  @override
  final int typeId = 9;

  @override
  SuggestionPriority read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return SuggestionPriority.low;
      case 1:
        return SuggestionPriority.medium;
      case 2:
        return SuggestionPriority.high;
      case 3:
        return SuggestionPriority.urgent;
      default:
        return SuggestionPriority.low;
    }
  }

  @override
  void write(BinaryWriter writer, SuggestionPriority obj) {
    switch (obj) {
      case SuggestionPriority.low:
        writer.writeByte(0);
        break;
      case SuggestionPriority.medium:
        writer.writeByte(1);
        break;
      case SuggestionPriority.high:
        writer.writeByte(2);
        break;
      case SuggestionPriority.urgent:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SuggestionPriorityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ExerciseTypeAdapter extends TypeAdapter<ExerciseType> {
  @override
  final int typeId = 17;

  @override
  ExerciseType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return ExerciseType.walking;
      case 1:
        return ExerciseType.running;
      case 2:
        return ExerciseType.cycling;
      case 3:
        return ExerciseType.swimming;
      case 4:
        return ExerciseType.yoga;
      case 5:
        return ExerciseType.weightTraining;
      case 6:
        return ExerciseType.other;
      default:
        return ExerciseType.walking;
    }
  }

  @override
  void write(BinaryWriter writer, ExerciseType obj) {
    switch (obj) {
      case ExerciseType.walking:
        writer.writeByte(0);
        break;
      case ExerciseType.running:
        writer.writeByte(1);
        break;
      case ExerciseType.cycling:
        writer.writeByte(2);
        break;
      case ExerciseType.swimming:
        writer.writeByte(3);
        break;
      case ExerciseType.yoga:
        writer.writeByte(4);
        break;
      case ExerciseType.weightTraining:
        writer.writeByte(5);
        break;
      case ExerciseType.other:
        writer.writeByte(6);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ExerciseTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
