import 'package:agristack/domain/value/result.dart';
// ======= LLM: GetEnhancedRecommendationUseCase =======

class GetEnhancedParams {
  final String crop;                 // 'wheat' / 'potato' / ...
  final String canonicalDiseaseId;   // np. 'wheat_leaf_rust'
  final String? bbch;
  final String? userQuery;
  final List<String> kb;             // kontekst lokalny (opcjonalny)
  final String locale;               // 'pl' / 'en'

  const GetEnhancedParams({
    required this.crop,
    required this.canonicalDiseaseId,
    this.bbch,
    this.userQuery,
    this.kb = const [],
    this.locale = 'pl',
  });
}

abstract class GetEnhancedRecommendationUseCase {
  Future<Result<String>> call(GetEnhancedParams p);
  Stream<String> stream(GetEnhancedParams p);
}

// ======= CNN: SaveDiagnosisUseCase =======

class SaveDiagnosisParams {
  final String crop;        // 'wheat' / 'potato' / 'oilseed_rape'
  final String imagePath;
  final int? fieldSeasonId;
  final double? lat;
  final double? lng;

  const SaveDiagnosisParams({
    required this.crop,
    required this.imagePath,
    this.fieldSeasonId,
    this.lat,
    this.lng,
  });
}

abstract class SaveDiagnosisUseCase {
  Future<void> call(SaveDiagnosisParams params);
}

// lib/domain/usecases/agristack_usecases.dart

// ======= FIELDS =======

class FieldListItem {
  final int id;
  final String name;
  final double? centerLat;
  final double? centerLng;

  const FieldListItem({
    required this.id,
    required this.name,
    this.centerLat,
    this.centerLng,
  });
}

class FieldSeasonInfo {
  final int id;
  final int year;
  final String crop; // 'wheat', 'potato', 'oilseed_rape' itd.
  final int diagnosisCount;

  const FieldSeasonInfo({
    required this.id,
    required this.year,
    required this.crop,
    required this.diagnosisCount,
  });
}

class FieldDetails {
  final int id;
  final String name;
  final double? centerLat;
  final double? centerLng;
  final String? notes;
  final List<FieldSeasonInfo> seasons;

  const FieldDetails({
    required this.id,
    required this.name,
    this.centerLat,
    this.centerLng,
    this.notes,
    required this.seasons,
  });
}

// ======= DIAGNOSIS LIST / HISTORY =======

class DiagnosisFilter {
  final int? fieldId;
  final int? fieldSeasonId;
  final int? seasonYear;
  final DateTime? from;
  final DateTime? to;

  const DiagnosisFilter({
    this.fieldId,
    this.fieldSeasonId,
    this.seasonYear,
    this.from,
    this.to,
  });
}

class DiagnosisListItem {
  final int id;
  final DateTime timestamp;
  final String modelId;
  final String canonicalDiseaseId;
  final String displayLabelPl;
  final double confidence;
  final int? fieldSeasonId;
  final double? lat;
  final double? lng;

  const DiagnosisListItem({
    required this.id,
    required this.timestamp,
    required this.modelId,
    required this.canonicalDiseaseId,
    required this.displayLabelPl,
    required this.confidence,
    this.fieldSeasonId,
    this.lat,
    this.lng,
  });
}

// ======= MAPA =======

class MapFilter {
  final int? seasonYear;
  final DateTime? from;
  final DateTime? to;

  const MapFilter({
    this.seasonYear,
    this.from,
    this.to,
  });
}

class MapDiagnosisPoint {
  final int diagnosisId;
  final double lat;
  final double lng;
  final String canonicalDiseaseId;
  final String displayLabelPl;
  final String modelId;
  final DateTime timestamp;
  final int? fieldSeasonId;

  const MapDiagnosisPoint({
    required this.diagnosisId,
    required this.lat,
    required this.lng,
    required this.canonicalDiseaseId,
    required this.displayLabelPl,
    required this.modelId,
    required this.timestamp,
    this.fieldSeasonId,
  });
}

// ======= USECASES (INTERFEJSY) =======

abstract class GetFieldsOverviewUseCase {
  Future<List<FieldListItem>> call();
}

abstract class GetFieldDetailsUseCase {
  Future<FieldDetails> call(int fieldId);
}

abstract class ListDiagnosisUseCase {
  Future<List<DiagnosisListItem>> call(DiagnosisFilter filter);
}

abstract class GetMapPointsUseCase {
  Future<List<MapDiagnosisPoint>> call(MapFilter filter);
}
