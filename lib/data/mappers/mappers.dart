import '../../domain/entities/entities.dart';
import '../sources/isar/schemas.dart';

extension FieldX on Field {
  FieldEntity toEntity() => FieldEntity(
    id: id,
    name: name,
    centerLat: centerLat,
    centerLng: centerLng,
    notes: notes,
    createdAt: createdAt,
    updatedAt: updatedAt,
  );
}

extension FieldSeasonX on FieldSeason {
  FieldSeasonEntity toEntity() => FieldSeasonEntity(
    id: id,
    year: year,
    crop: crop,
    fieldId: field.value?.id ?? 0,
    createdAt: createdAt,
  );
}

extension DiagnosisX on DiagnosisEntry {
  DiagnosisEntryEntity toEntity() => DiagnosisEntryEntity(
    id: id,
    timestamp: timestamp,
    imagePath: imagePath,
    fieldSeasonId: fieldSeason.value?.id,
    lat: lat,
    lng: lng,
    modelId: modelId,
    rawLabel: rawLabel,
    canonicalDiseaseId: canonicalDiseaseId,
    displayLabelPl: displayLabelPl,
    confidence: confidence,
    recommendationKey: recommendationKey,
    notes: notes,
    createdAt: createdAt,
  );
}