import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/meal.dart';

class FavoritesStorage {
  static const String _key = 'favorite_meals';

  Future<List<Meal>> getFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> jsonList = prefs.getStringList(_key) ?? [];
    return jsonList.map((str) => Meal.fromJson(jsonDecode(str))).toList();
  }

  Future<bool> isFavorite(String mealId) async {
    final favorites = await getFavorites();
    return favorites.any((meal) => meal.id == mealId);
  }

  Future<void> toggleFavorite(Meal meal) async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = await getFavorites();
    final exists = favorites.any((item) => item.id == meal.id);

    if (exists) {
      favorites.removeWhere((item) => item.id == meal.id);
    } else {
      favorites.add(meal);
    }

    final encodedList = favorites.map((item) => jsonEncode(item.toJson())).toList();
    await prefs.setStringList(_key, encodedList);
  }
}
