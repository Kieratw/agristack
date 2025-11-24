import 'package:isar/isar.dart';

part 'schemas.g.dart';

@collection
class Field {
  Id id = Isar.autoIncrement;

  @Index(unique: true, caseSensitive: false)
  late String name;

  @Index()
  double? centerLat;

  @Index()
  double? centerLng;

  String? notes;

  // List of "lat,lng" strings
  List<String>? polygonPoints;

  // Area in hectares
  double? area;

  late DateTime createdAt = DateTime.now();
  late DateTime updatedAt = DateTime.now();

  @Backlink(to: 'field')
  final seasons = IsarLinks<FieldSeason>();
}

@collection
class FieldSeason {
  Id id = Isar.autoIncrement;

  @Index()
  late int year;

  // Kanoniczny klucz: wheat|tomato|potato|rapeseed
  @Index(caseSensitive: false)
  late String crop;

  // Strona właścicielska relacji
  final field = IsarLink<Field>();

  late DateTime createdAt = DateTime.now();

  // Backlink do DiagnosisEntry.fieldSeason
  @Backlink(to: 'fieldSeason')
  final diagnoses = IsarLinks<DiagnosisEntry>();
}

@collection
class DiagnosisEntry {
  Id id = Isar.autoIncrement;

  @Index()
  late DateTime timestamp;

  late String imagePath;

  // Strona właścicielska relacji
  final fieldSeason = IsarLink<FieldSeason>();

  @Index()
  double? lat;

  @Index()
  double? lng;

  @Index(caseSensitive: false)
  late String modelId;

  @Index(caseSensitive: false)
  late String rawLabel;

  @Index(caseSensitive: false)
  late String canonicalDiseaseId;

  late String displayLabelPl;
  late double confidence;

  String? recommendationKey;
  String? notes;

  late DateTime createdAt = DateTime.now();
}

/// Odwrócony indeks aliasów (alias -> canonicalDiseaseId)
@collection
class DiseaseAliasIndex {
  Id id = Isar.autoIncrement;

  @Index(unique: true, caseSensitive: false)
  late String alias;

  @Index(caseSensitive: false)
  late String canonicalDiseaseId;
}

/// Metadane aplikacji/schematu
@collection
class AppMeta {
  Id id = 0;

  late int schemaVersion;
  String? diseasesJsonHash;
  String? recsJsonHash;
  String? modelsJsonHash;

  late DateTime createdAt = DateTime.now();
  late DateTime updatedAt = DateTime.now();
}
