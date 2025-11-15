import 'dart:io';
import 'package:pytorch_lite/pytorch_lite.dart';
import 'package:agristack/domain/services/inference_service.dart';

class PtlInferenceService implements InferenceService {
  ClassificationModel? _model;
  String? _assetLoaded;
  int? _sizeLoaded;
  int? _classesLoaded;

  @override
  Future<InferenceResult> infer({
    required String imagePath,
    required String assetPath,
    required int inputSize,
    required int numClasses,
  }) async {
    final needReload = _model == null
        || _assetLoaded != assetPath
        || _sizeLoaded != inputSize
        || _classesLoaded != numClasses;

    if (needReload) {
      _model = await PytorchLite.loadClassificationModel(
        assetPath,      // path w assets
        inputSize,      // width
        inputSize,      // height
        numClasses,     // liczba klas
        // labelPath: nie podajemy, bo classNames masz w models.json
      );
      _assetLoaded   = assetPath;
      _sizeLoaded    = inputSize;
      _classesLoaded = numClasses;
    }

    final bytes = await File(imagePath).readAsBytes();

    // Zwraca Future<List<double?>?> — pojedynczy wektor prawdopodobieństw
    final List<double?>? probsN =
        await _model!.getImagePredictionListProbabilities(bytes);

    if (probsN == null || probsN.isEmpty) {
      return const InferenceResult(0, 0.0);
    }

    // argmax z null-safe
    int best = 0;
    double bestVal = double.negativeInfinity;
    for (int i = 0; i < probsN.length; i++) {
      final v = probsN[i] ?? double.negativeInfinity;
      if (v > bestVal) {
        bestVal = v;
        best = i;
      }
    }
    if (best < 0) best = 0;
    if (best >= numClasses) best = numClasses - 1;

    final conf = bestVal.isFinite ? bestVal : 0.0;
    return InferenceResult(best, conf);
  }
}
