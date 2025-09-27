import 'package:flutter/foundation.dart';

@immutable
class Dose {
  final String label;
  final String amount;
  final String notes;
  final List<String> sources;
  const Dose({
    required this.label,
    required this.amount,
    this.notes = '',
    this.sources = const [],
  });
}

@immutable
class Pest {
  final String id;
  final String nameBn, nameEn;
  final String shortSymptomBn, shortSymptomEn;
  final String imageAsset;
  final String? imageUrl;
  final String symptomsBn, symptomsEn;
  final String preventionBn, preventionEn;
  final String safetyBn, safetyEn;
  final List<Dose> organic, chemical;
  final List<String> references;

  const Pest({
    required this.id,
    required this.nameBn,
    required this.nameEn,
    required this.shortSymptomBn,
    required this.shortSymptomEn,
    required this.imageAsset,
    this.imageUrl,
    required this.symptomsBn,
    required this.symptomsEn,
    required this.preventionBn,
    required this.preventionEn,
    required this.safetyBn,
    required this.safetyEn,
    this.organic = const [],
    this.chemical = const [],
    this.references = const [],
  });
}
