// lib/data/services/mc_inference_service.dart
import 'package:flutter/services.dart';
import 'package:agristack/domain/services/inference_service.dart';

class MethodChannelInferenceService implements InferenceService {
  static const _channel = MethodChannel('agristack/pytorch');

  @override
  Future<InferenceResult> infer({
    required String imagePath,
    required String assetPath,
    required int inputSize,
    required int numClasses,
  }) async {
    final raw = await _channel.invokeMethod<List<dynamic>>('runModel', {
      'imagePath': imagePath,
      'assetPath': assetPath,
      'inputSize': inputSize,
    });

    if (raw == null || raw.isEmpty) {
      throw StateError('Brak danych z PyTorcha (runModel zwrócił null/empty)');
    }

    if (raw.length < numClasses) {
      throw StateError(
        'PyTorch zwrócił ${raw.length} wyników, ale numClasses=$numClasses',
      );
    }

    final probs = raw
        .take(numClasses)
        .map((e) => (e as num).toDouble())
        .toList(growable: false);

    if (probs.isEmpty) {
      // Fallback or Error
      if (numClasses == 0)
        throw StateError('numClasses is 0 - Check models.json');
      return InferenceResult(0, 0.0, rawLabel: null); // Safe fallback
    }

    var bestIdx = 0;
    var bestVal = probs[0];
    for (var i = 1; i < probs.length; i++) {
      if (probs[i] > bestVal) {
        bestVal = probs[i];
        bestIdx = i;
      }
    }

    return InferenceResult(bestIdx, bestVal, rawLabel: null);
  }
}
