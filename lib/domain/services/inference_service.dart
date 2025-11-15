class InferenceResult {
  final int classIndex;
  final String? rawLabel; // może być null, jeśli plugin nie zwróci nazwy
  final double confidence;
  const InferenceResult(this.classIndex, this.confidence, {this.rawLabel});
}

abstract class InferenceService {
  /// Zwraca top1 indeks klasy i confidence. Etykietę weźmiemy z classNames[c].
  Future<InferenceResult> infer({
    required String imagePath,
    required String assetPath,
    required int inputSize,
    required int numClasses, // na wszelki wypadek
  });
}
