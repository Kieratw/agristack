class FieldEntity {
  final int id;
  final String name;
  final double? centerLat;
  final double? centerLng;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;
  FieldEntity({
    required this.id,
    required this.name,
    this.centerLat,
    this.centerLng,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
  });
}

class FieldSeasonEntity {
  final int id;
  final int year;
  final String crop;
  final int fieldId;
  final DateTime createdAt;
  FieldSeasonEntity({
    required this.id,
    required this.year,
    required this.crop,
    required this.fieldId,
    required this.createdAt,
  });
}

class DiagnosisEntryEntity {
  final int id;
  final DateTime timestamp;
  final String imagePath;
  final int? fieldSeasonId;
  final double? lat;
  final double? lng;
  final String modelId;
  final String rawLabel;
  final String canonicalDiseaseId;
  final String displayLabelPl;
  final double confidence;
  final String? recommendationKey;
  final String? notes;
  final DateTime createdAt;
  DiagnosisEntryEntity({
    required this.id,
    required this.timestamp,
    required this.imagePath,
    required this.fieldSeasonId,
    required this.lat,
    required this.lng,
    required this.modelId,
    required this.rawLabel,
    required this.canonicalDiseaseId,
    required this.displayLabelPl,
    required this.confidence,
    this.recommendationKey,
    this.notes,
    required this.createdAt,
  });
}