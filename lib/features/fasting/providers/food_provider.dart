import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/food.dart';
import '../repositories/food_repository.dart';

final foodRepositoryProvider = Provider<FoodRepository>(
  (ref) => FoodRepository(),
);

final foodDatasetProvider = FutureProvider<FoodDataset>((ref) async {
  final repo = ref.watch(foodRepositoryProvider);
  return repo.loadDataset();
});

final rootFoodCategoriesProvider = FutureProvider<List<FoodCategory>>((
  ref,
) async {
  final repo = ref.watch(foodRepositoryProvider);
  return repo.getRootCategories();
});

final foodSearchProvider =
    FutureProvider.family<List<FoodItem>, (String keyword, String? categoryId)>(
      (ref, params) async {
        final (keyword, categoryId) = params;
        final repo = ref.watch(foodRepositoryProvider);
        return repo.searchFoods(keyword, categoryId: categoryId);
      },
    );
