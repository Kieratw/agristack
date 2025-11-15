import 'package:flutter/services.dart' show rootBundle;
import 'package:agristack/domain/services/static_data_source.dart';

class AssetStaticDataSource implements StaticDataSource {
  @override
  Future<String> loadDiseasesJson() =>
      rootBundle.loadString('assets/static/diseases.json');

  @override
  Future<String> loadModelsJson() =>
      rootBundle.loadString('assets/static/models.json');
}
