import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/category.dart';
import '../models/meal.dart';

class MealApi {
  static const String baseUrl = 'https://www.themealdb.com/api/json/v1/1';

  Future<List<Category>> fetchCategories() async {
    final response = await http.get(Uri.parse('$baseUrl/categories.php'));
    if (response.statusCode != 200) {
      throw Exception('Failed to load categories');
    }
    final data = jsonDecode(response.body);
    final List list = data['categories'] ?? [];
    return list.map((json) => Category.fromJson(json)).toList();
  }

  Future<List<Meal>> fetchMealsByCategory(String category) async {
    final response = await http.get(Uri.parse('$baseUrl/filter.php?c=$category'));
    if (response.statusCode != 200) {
      throw Exception('Failed to load meals for $category');
    }
    final data = jsonDecode(response.body);
    if (data['meals'] == null) return [];
    final List list = data['meals'];
    return list.map((json) => Meal.fromJson(json)).toList();
  }

  Future<Meal> fetchMealDetail(String id) async {
    final response = await http.get(Uri.parse('$baseUrl/lookup.php?i=$id'));
    if (response.statusCode != 200) {
      throw Exception('Failed to load recipe details');
    }
    final data = jsonDecode(response.body);
    if (data['meals'] == null || (data['meals'] as List).isEmpty) {
      throw Exception('Recipe not found');
    }
    return Meal.fromJson(data['meals'][0]);
  }

  Future<List<Meal>> searchMeals(String query) async {
    final response = await http.get(Uri.parse('$baseUrl/search.php?s=$query'));
    if (response.statusCode != 200) {
      throw Exception('Search request failed');
    }
    final data = jsonDecode(response.body);
    if (data['meals'] == null) return [];
    final List list = data['meals'];
    return list.map((json) => Meal.fromJson(json)).toList();
  }
}
