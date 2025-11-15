class FieldListItem {
  final int id;
  final String name;
  final double? areaHa;
  final int? activeSeasonYear;
  final int diagnosisCount;
  FieldListItem({
    required this.id,
    required this.name,
    this.areaHa,
    this.activeSeasonYear,
    this.diagnosisCount = 0,
  });
}

class FieldSeasonInfo {
  final int id;
  final int year;
  final String crop; // 'wheat', 'potato', ...
  final int diagnosisCount;
  FieldSeasonInfo({
    required this.id,
    required this.year,
    required this.crop,
    required this.diagnosisCount,
  });
}

class FieldDetails {
  final int id;
  final String name;
  final double? areaHa;
  final List<FieldSeasonInfo> seasons;
  FieldDetails({
    required this.id,
    required this.name,
    this.areaHa,
    required this.seasons,
  });
}
