class MapDiagnosisPoint {
  final int diagnosisId;
  final double lat;
  final double lng;
  final String crop;
  final String canonicalDiseaseId;
  final String displayLabelPl;
  final DateTime timestamp;
  final int? fieldId;
  final int? fieldSeasonId;

  MapDiagnosisPoint({
    required this.diagnosisId,
    required this.lat,
    required this.lng,
    required this.crop,
    required this.canonicalDiseaseId,
    required this.displayLabelPl,
    required this.timestamp,
    this.fieldId,
    this.fieldSeasonId,
  });
}

class MapFilter {
  final String? crop;
  final int? seasonYear;
  final DateTime? from;
  final DateTime? to;
  MapFilter({this.crop, this.seasonYear, this.from, this.to});
}
