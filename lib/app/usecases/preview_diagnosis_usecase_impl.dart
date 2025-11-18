import 'package:agristack/domain/entities/entities.dart';
import 'package:agristack/domain/repositories/dictionary_repository.dart';
import 'package:agristack/domain/services/inference_service.dart';
import 'package:agristack/domain/usecases/agristack_usecases.dart';

class PreviewDiagnosisUseCaseImpl implements PreviewDiagnosisUseCase {
  final DictionaryRepository _dict;
  final InferenceService _inf;

  PreviewDiagnosisUseCaseImpl(this._dict, this._inf);

  @override
  Future<DiagnosisEntryEntity> call(SaveDiagnosisParams p) async {
    final cfg = _dict.getModelConfig(p.crop);
    if (cfg == null) {
      throw StateError('Brak modelu dla crop=${p.crop}');
    }
    if (cfg.classNames.isEmpty) {
      throw StateError('models.json: brak classNames dla ${cfg.modelId}');
    }

    // 1. Inferencja
    final res = await _inf.infer(
      imagePath: p.imagePath,
      assetPath: cfg.assetPath,
      inputSize: cfg.inputSize,
      numClasses: cfg.classNames.length,
    );

    // 2. Surowa etykieta z modelu
    final raw = res.rawLabel ?? cfg.classNames[res.classIndex];

    // 3. mapowanie na canonicalId + label PL
    final canonical = _dict.mapRawLabelToId(raw, crop: p.crop) ?? raw;
    final displayPl = _dict.getDiseaseDisplay(canonical) ?? canonical;

    final now = DateTime.now();

    // Zwracamy encję, ale NIE zapisujemy jej w bazie
    return DiagnosisEntryEntity(
      id: 0, // tymczasowe ID
      timestamp: now,
      imagePath: p.imagePath,
      fieldSeasonId: p.fieldSeasonId,
      lat: p.lat,
      lng: p.lng,
      modelId: cfg.modelId,
      rawLabel: raw,
      canonicalDiseaseId: canonical,
      displayLabelPl: displayPl,
      confidence: res.confidence,
      recommendationKey: canonical,
      notes: null,
      createdAt: now,
    );
  }
}
