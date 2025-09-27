import 'package:flutter/foundation.dart';

@immutable
class Nutrition {
  final int calories; // kcal
  final double carbs; // g
  final double protein; // g
  final double fat; // g
  final double fiber; // g
  final int potassium; // mg
  final double vitaminC; // mg

  const Nutrition({
    required this.calories,
    required this.carbs,
    required this.protein,
    required this.fat,
    required this.fiber,
    required this.potassium,
    required this.vitaminC,
  });
}

@immutable
class Recipe {
  final String id;
  final String titleBn, titleEn;
  final String imageAsset;
  final String? imageUrl;
  final List<String> ingredientsBn, ingredientsEn;
  final List<String> stepsBn, stepsEn;
  final Nutrition nutritionPerServing;
  final String youtubeId;
  final List<String> refs;

  const Recipe({
    required this.id,
    required this.titleBn,
    required this.titleEn,
    required this.imageAsset,
    this.imageUrl,
    required this.ingredientsBn,
    required this.ingredientsEn,
    required this.stepsBn,
    required this.stepsEn,
    required this.nutritionPerServing,
    required this.youtubeId,
    this.refs = const [],
  });
}
