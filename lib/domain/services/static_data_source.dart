
abstract class StaticDataSource {
  /// Zwraca zawartość assets/static/diseases.json jako String
  Future<String> loadDiseasesJson();

  /// Zwraca zawartość assets/static/models.json jako String
  Future<String> loadModelsJson();
}
