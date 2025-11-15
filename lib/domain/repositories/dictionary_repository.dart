class ModelConfig {
  final String modelId;
  final String assetPath;
  final int inputSize;
  final List<String> classNames; // KOLEJNOŚĆ KLAS z treningu

  const ModelConfig({
    required this.modelId,
    required this.assetPath,
    required this.inputSize,
    required this.classNames,
  });
}

abstract class DictionaryRepository {
  Future<void> initialize();

  /// Zwraca canonicalId na podstawie surowej etykiety lub aliasu (zależnie od uprawy).
  String? mapRawLabelToId(String raw, {required String crop});

  /// Polska nazwa choroby dla canonicalId
  String? getDiseaseDisplay(String canonicalId);

  
  ModelConfig? getModelConfig(String crop);
}
