// lib/domain/usecases/agristack_usecases.dart
import 'package:agristack/domain/entities/entities.dart';
import 'package:agristack/domain/value/result.dart';
import 'package:agristack/data/models/advice_dtos.dart';

/// =======================
///   PARAMS / FILTRY
/// =======================

class SaveDiagnosisParams {
  final String crop; // 'wheat' / 'potato' / 'oilseed_rape' / 'tomato'
  final String imagePath;
  final int? fieldSeasonId; // może być null (diagnoza „luźna”)
  final double? lat;
  final double? lng;
  final DiagnosisEntryEntity? precomputedResult;

  SaveDiagnosisParams({
    required this.crop,
    required this.imagePath,
    this.fieldSeasonId,
    this.lat,
    this.lng,
    this.precomputedResult,
  });
}

class GetEnhancedParams {
  final String crop; // 'wheat', 'potato', ...
  final String canonicalDiseaseId; // np. 'wheat_leaf_rust'
  final String? bbch;
  final String? userQuery;
  final List<String> kb; // kontekst lokalny (opcjonalny)
  final String locale; // 'pl' / 'en'

  // New fields for Advice API
  final String seasonContext;
  final int? timeSinceLastSprayDays;
  final String situationDescription;

  GetEnhancedParams({
    required this.crop,
    required this.canonicalDiseaseId,
    this.bbch,
    this.userQuery,
    this.kb = const [],
    this.locale = 'pl',
    required this.seasonContext,
    this.timeSinceLastSprayDays,
    required this.situationDescription,
  });
}

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

class MapFilter {
  final int? seasonYear;
  final DateTime? from;
  final DateTime? to;

  const MapFilter({this.seasonYear, this.from, this.to});
}

/// =======================
///    DTO do widoków
/// =======================

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
  final String crop;
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

/// =======================
///       USE-CASE'y
/// =======================

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

abstract class GetEnhancedRecommendationUseCase {
  Future<Result<AdviceResponse>> call(GetEnhancedParams p);
}

abstract class SaveDiagnosisUseCase {
  /// Zwraca pełną encję zapisaną w bazie (tak jak w implementacji).
  Future<DiagnosisEntryEntity> call(SaveDiagnosisParams params);
}

abstract class PreviewDiagnosisUseCase {
  Future<DiagnosisEntryEntity> call(SaveDiagnosisParams params);
}

/// =======================
///     FASADA: AgristackUsecases
/// =======================

class AgristackUsecases {
  final SaveDiagnosisUseCase saveDiagnosis;
  final GetEnhancedRecommendationUseCase enhancedRecommendation;
  final GetFieldsOverviewUseCase fieldsOverview;
  final GetFieldDetailsUseCase fieldDetails;
  final ListDiagnosisUseCase listDiagnosis;
  final GetMapPointsUseCase mapPoints;
  final PreviewDiagnosisUseCase previewDiagnosis;

  const AgristackUsecases({
    required this.saveDiagnosis,
    required this.enhancedRecommendation,
    required this.fieldsOverview,
    required this.fieldDetails,
    required this.listDiagnosis,
    required this.mapPoints,
    required this.previewDiagnosis,
  });
}

/// =======================
///  DODATKOWE ALIASY
///  (żeby kontrolery się nie pluły)
/// =======================

extension AgristackUsecasesX on AgristackUsecases {
  /// Stary styl: usecases.save(params)
  Future<DiagnosisEntryEntity> save(SaveDiagnosisParams p) {
    // saveDiagnosis jest callable, bo SaveDiagnosisUseCase ma metodę call(...)
    return saveDiagnosis(p);
  }

  /// Stary styl: usecases.inferPreview(params)
  Future<DiagnosisEntryEntity> inferPreview(SaveDiagnosisParams p) {
    return previewDiagnosis(p);
  }
}
