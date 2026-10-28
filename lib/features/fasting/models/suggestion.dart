import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';
import '../core/constants/app_constants.dart';

part 'suggestion.freezed.dart';
part 'suggestion.g.dart';

@freezed
@HiveType(typeId: 7)
class Suggestion with _$Suggestion {
  const factory Suggestion({
    @HiveField(0) required String id,
    @HiveField(1) required SuggestionType type,
    @HiveField(2) required String title,
    @HiveField(3) required String content,
    @HiveField(4) required SuggestionPriority priority,
    @HiveField(5) String? scientificBasis,
    @HiveField(6) @Default([]) List<String> actionItems,
    @HiveField(7) @Default(false) bool isRead,
    @HiveField(8) @Default(false) bool isAdopted,
    @HiveField(9) @Default(false) bool isIgnored,
    @HiveField(10) DateTime? adoptedAt,
    @HiveField(11) DateTime? ignoredAt,
    @HiveField(12) DateTime? expiresAt,
    @HiveField(13) required DateTime createdAt,
    @HiveField(14) DateTime? updatedAt,
    @HiveField(15) Map<String, dynamic>? metadata, // 额外数据
  }) = _Suggestion;

  factory Suggestion.fromJson(Map<String, dynamic> json) =>
      _$SuggestionFromJson(json);
}
