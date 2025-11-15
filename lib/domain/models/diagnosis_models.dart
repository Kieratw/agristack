class DiagnosisListItem {
  final int id;
  final DateTime timestamp;
  final String crop;               // 'wheat', ...
  final String canonicalDiseaseId; // np. 'wheat_leaf_rust'
  final String displayLabelPl;     // np. 'Rdza liści'
  final double confidence;
  final int? fieldId;
  final int? fieldSeasonId;
  final String? fieldName;
  final String? imagePath;
  DiagnosisListItem({
    required this.id,
    required this.timestamp,
    required this.crop,
    required this.canonicalDiseaseId,
    required this.displayLabelPl,
    required this.confidence,
    this.fieldId,
    this.fieldSeasonId,
    this.fieldName,
    this.imagePath,
  });
}

class DiagnosisFilter {
  final int? fieldId;
  final int? fieldSeasonId;
  final String? crop;     // 'wheat' / 'potato' / 'oilseed_rape'
  final DateTime? from;
  final DateTime? to;
  DiagnosisFilter({this.fieldId, this.fieldSeasonId, this.crop, this.from, this.to});
}
