import '../models/drink_record.dart';
import '../models/nutrition.dart';
import 'ocr_service.dart';

class RecordDraft {
  final String name;
  final String category;
  final String size;
  final String volumeText;
  final String sugarText;
  final String fatText;
  final String proteinText;
  final String caffeineText;
  final String caloriesText;

  const RecordDraft({
    required this.name,
    required this.category,
    required this.size,
    required this.volumeText,
    required this.sugarText,
    required this.fatText,
    required this.proteinText,
    required this.caffeineText,
    required this.caloriesText,
  });
}

class RecordDraftService {
  RecordDraft draftFromOcr({
    required OCRResult result,
    required String currentName,
    required String currentCategory,
    required String currentSize,
    required List<String> categories,
    required List<String> sizes,
  }) {
    final nutrition = result.nutrition;
    final category = categories.contains(result.category)
        ? result.category!
        : currentCategory;
    final size = sizes.contains(result.size) ? result.size! : currentSize;

    return RecordDraft(
      name: result.drinkName ?? currentName,
      category: category,
      size: size,
      volumeText: (result.volume ?? 500).toStringAsFixed(0),
      sugarText: (nutrition?.sugar ?? 0).toStringAsFixed(0),
      fatText: (nutrition?.fat ?? 0).toStringAsFixed(1),
      proteinText: (nutrition?.protein ?? 0).toStringAsFixed(1),
      caffeineText: (nutrition?.caffeine ?? 0).toStringAsFixed(0),
      caloriesText: (nutrition?.calories ?? 0).toStringAsFixed(0),
    );
  }

  DrinkRecord buildRecord({
    required String name,
    required String category,
    required String volumeText,
    required String size,
    required String sugarText,
    required String fatText,
    required String proteinText,
    required String caffeineText,
    required String caloriesText,
    required String userId,
    String? imagePath,
    DateTime? recordTime,
    String? notes,
    String? brand,
    double? price,
  }) {
    return DrinkRecord(
      name: name.trim(),
      category: category,
      volume: _toDouble(volumeText),
      size: size,
      sugar: _toDouble(sugarText),
      fat: _toDouble(fatText),
      protein: _toDouble(proteinText),
      caffeine: _toDouble(caffeineText),
      calories: _toDouble(caloriesText),
      imagePath: imagePath,
      recordTime: recordTime ?? DateTime.now(),
      notes: notes,
      userId: userId,
      brand: brand,
      price: price,
    );
  }

  Nutrition nutritionFromTextFields({
    required String sugarText,
    required String fatText,
    required String proteinText,
    required String caffeineText,
    required String caloriesText,
  }) {
    return Nutrition(
      sugar: _toDouble(sugarText),
      fat: _toDouble(fatText),
      protein: _toDouble(proteinText),
      caffeine: _toDouble(caffeineText),
      calories: _toDouble(caloriesText),
    );
  }

  double _toDouble(String text) {
    return double.tryParse(text.trim()) ?? 0;
  }
}
