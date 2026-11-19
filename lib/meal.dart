class Meal {
  final String id;
  final String name;
  final String thumbnail;
  final String category;
  final String area;
  final String instructions;
  final List<String> ingredients;

  Meal({
    required this.id,
    required this.name,
    required this.thumbnail,
    this.category = '',
    this.area = '',
    this.instructions = '',
    this.ingredients = const [],
  });

  factory Meal.fromJson(Map<String, dynamic> json) {
    final extractedIngredients = <String>[];
    for (int i = 1; i <= 20; i++) {
      final ingredient = json['strIngredient$i'];
      final measure = json['strMeasure$i'];
      if (ingredient != null && ingredient.toString().trim().isNotEmpty) {
        final formattedMeasure = (measure != null) ? measure.toString().trim() : '';
        extractedIngredients.add('$formattedMeasure ${ingredient.toString().trim()}'.trim());
      }
    }

    return Meal(
      id: json['idMeal'] ?? '',
      name: json['strMeal'] ?? '',
      thumbnail: json['strMealThumb'] ?? '',
      category: json['strCategory'] ?? '',
      area: json['strArea'] ?? '',
      instructions: json['strInstructions'] ?? '',
      ingredients: extractedIngredients,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idMeal': id,
      'strMeal': name,
      'strMealThumb': thumbnail,
      'strCategory': category,
      'strArea': area,
      'strInstructions': instructions,
      // Store ingredients back into strIngredient1..20 format so fromJson works seamlessly
      for (int i = 0; i < ingredients.length; i++) 'strIngredient${i + 1}': ingredients[i],
    };
  }
}
