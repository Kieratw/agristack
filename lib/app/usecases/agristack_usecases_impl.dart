// lib/app/usecases/agristack_usecases_impl.dart
import 'package:agristack/domain/usecases/agristack_usecases.dart';
import 'package:agristack/domain/value/result.dart';

import 'package:agristack/domain/services/llm_service.dart';
import 'package:agristack/domain/repositories/dictionary_repository.dart';
import 'package:agristack/app/prompt/prompt_builder.dart';

import 'package:agristack/domain/services/inference_service.dart';
import 'package:agristack/domain/repositories/diagnosis_repository.dart';
import 'package:agristack/domain/entities/entities.dart';

import 'package:agristack/domain/repositories/fields_repository.dart';


List<T> _listOrEmpty<T>(Result<List<T>> res) =>
    res.isOk && res.data != null ? res.data! : <T>[];

// =========================
//   GetFieldsOverviewUseCase
// =========================

class GetFieldsOverviewUseCaseImpl implements GetFieldsOverviewUseCase {
  final FieldsRepository _fields;

  GetFieldsOverviewUseCaseImpl(this._fields);

  @override
  Future<List<FieldListItem>> call() async {
    final res = await _fields.getAll();
    final list = _listOrEmpty<FieldEntity>(res);

    return list
        .map(
          (f) => FieldListItem(
            id: f.id,
            name: f.name,
            centerLat: f.centerLat,
            centerLng: f.centerLng,
          ),
        )
        .toList();
  }
}

// =========================
//   GetFieldDetailsUseCase
// =========================

class GetFieldDetailsUseCaseImpl implements GetFieldDetailsUseCase {
  final FieldsRepository _fields;
  final DiagnosisRepository _diag;

  GetFieldDetailsUseCaseImpl(this._fields, this._diag);

  @override
  Future<FieldDetails> call(int fieldId) async {
    // Nie mamy get(fieldId) w repo, więc bierzemy wszystkie i filtrujemy.
    final allRes = await _fields.getAll();
    final fields = _listOrEmpty<FieldEntity>(allRes);

    final field = fields.firstWhere(
      (f) => f.id == fieldId,
      orElse: () => throw StateError('Field $fieldId not found'),
    );

    final seasonsRes = await _fields.getSeasons(fieldId);
    final seasons = _listOrEmpty<FieldSeasonEntity>(seasonsRes);

    final seasonInfos = <FieldSeasonInfo>[];
    for (final s in seasons) {
      final diagRes = await _diag.listBySeason(s.id);
      final diags = _listOrEmpty<DiagnosisEntryEntity>(diagRes);

      seasonInfos.add(
        FieldSeasonInfo(
          id: s.id,
          year: s.year,
          crop: s.crop,
          diagnosisCount: diags.length,
        ),
      );
    }

    return FieldDetails(
      id: field.id,
      name: field.name,
      centerLat: field.centerLat,
      centerLng: field.centerLng,
      notes: field.notes,
      seasons: seasonInfos,
    );
  }
}

// =========================
//   ListDiagnosisUseCase
// =========================

class ListDiagnosisUseCaseImpl implements ListDiagnosisUseCase {
  final DiagnosisRepository _diag;

  ListDiagnosisUseCaseImpl(this._diag);

  @override
  Future<List<DiagnosisListItem>> call(DiagnosisFilter filter) async {
    Result<List<DiagnosisEntryEntity>> res;

    if (filter.fieldSeasonId != null) {
      // Lista diagnoz dla konkretnego sezonu pola
      res = await _diag.listBySeason(filter.fieldSeasonId!);
    } else if (filter.fieldId != null) {
      // Lista diagnoz dla pola (opcjonalnie z rokiem)
      res = await _diag.listByField(filter.fieldId!, year: filter.seasonYear);
    } else if (filter.from != null && filter.to != null) {
      // Historia w zakresie dat
      res = await _diag.listByDateRange(filter.from!, filter.to!);
    } else {
      // „Globalna” historia – szeroki zakres
      res = await _diag.listByDateRange(
        DateTime(2000, 1, 1),
        DateTime.now(),
      );
    }

    var entries = _listOrEmpty<DiagnosisEntryEntity>(res);

    // Jeszcze raz filtrujemy po dacie, gdyby repo oddało szerszy zakres
    if (filter.from != null) {
      entries = entries
          .where((e) => !e.timestamp.isBefore(filter.from!))
          .toList();
    }
    if (filter.to != null) {
      entries =
          entries.where((e) => !e.timestamp.isAfter(filter.to!)).toList();
    }

    // Na razie bez cropa – nie ma go w encji, a modelId można później zmapować z DictionaryRepository.
    return entries
        .map(
          (e) => DiagnosisListItem(
            id: e.id,
            timestamp: e.timestamp,
            modelId: e.modelId,
            canonicalDiseaseId: e.canonicalDiseaseId,
            displayLabelPl: e.displayLabelPl,
            confidence: e.confidence,
            fieldSeasonId: e.fieldSeasonId,
            lat: e.lat,
            lng: e.lng,
          ),
        )
        .toList();
  }
}

// =========================
//   GetMapPointsUseCase
// =========================

class GetMapPointsUseCaseImpl implements GetMapPointsUseCase {
  final DiagnosisRepository _diag;

  GetMapPointsUseCaseImpl(this._diag);

  @override
  Future<List<MapDiagnosisPoint>> call(MapFilter filter) async {
    Result<List<DiagnosisEntryEntity>> res;

    if (filter.from != null && filter.to != null) {
      res = await _diag.listByDateRange(filter.from!, filter.to!);
    } else {
      res = await _diag.listByDateRange(
        DateTime(2000, 1, 1),
        DateTime.now(),
      );
    }

    var entries = _listOrEmpty<DiagnosisEntryEntity>(res);

    if (filter.seasonYear != null) {
      entries = entries
          .where((e) => e.timestamp.year == filter.seasonYear)
          .toList();
    }

    final withCoords =
        entries.where((e) => e.lat != null && e.lng != null);

    return withCoords
        .map(
          (e) => MapDiagnosisPoint(
            diagnosisId: e.id,
            lat: e.lat!,
            lng: e.lng!,
            canonicalDiseaseId: e.canonicalDiseaseId,
            displayLabelPl: e.displayLabelPl,
            modelId: e.modelId,
            timestamp: e.timestamp,
            fieldSeasonId: e.fieldSeasonId,
          ),
        )
        .toList();
  }
}

// =========================
//   GetEnhancedRecommendationUseCaseImpl (LLM)
// =========================

class GetEnhancedRecommendationUseCaseImpl
    implements GetEnhancedRecommendationUseCase {
  final LlmService _llm;
  final DictionaryRepository _dict;

  GetEnhancedRecommendationUseCaseImpl(this._llm, this._dict);

  @override
  Future<Result<String>> call(GetEnhancedParams p) async {
    final display =
        _dict.getDiseaseDisplay(p.canonicalDiseaseId) ?? p.canonicalDiseaseId;

    final prompt = ExpertPromptBuilder(locale: p.locale).build(
      crop: p.crop,
      canonicalDiseaseId: p.canonicalDiseaseId,
      diseaseDisplayPl: display,
      bbch: p.bbch,
      userQuery: p.userQuery,
      kb: p.kb,
    );

    return _llm.generateContent(prompt);
  }

  @override
  Stream<String> stream(GetEnhancedParams p) {
    final display =
        _dict.getDiseaseDisplay(p.canonicalDiseaseId) ?? p.canonicalDiseaseId;

    final prompt = ExpertPromptBuilder(locale: p.locale).build(
      crop: p.crop,
      canonicalDiseaseId: p.canonicalDiseaseId,
      diseaseDisplayPl: display,
      bbch: p.bbch,
      userQuery: p.userQuery,
      kb: p.kb,
    );

    return _llm.streamContent(prompt);
  }
}

// =========================
//   SaveDiagnosisUseCaseImpl (CNN -> DB)
// =========================

class SaveDiagnosisUseCaseImpl implements SaveDiagnosisUseCase {
  final DiagnosisRepository _diag;
  final DictionaryRepository _dict;
  final InferenceService _inf;

  SaveDiagnosisUseCaseImpl(this._diag, this._dict, this._inf);

  @override
  Future<void> call(SaveDiagnosisParams p) async {
    final cfg = _dict.getModelConfig(p.crop);
    if (cfg == null) {
      throw StateError('Brak modelu dla crop=${p.crop}');
    }
    if (cfg.classNames.isEmpty) {
      throw StateError('models.json: brak classNames dla ${cfg.modelId}');
    }

    final res = await _inf.infer(
      imagePath: p.imagePath,
      assetPath: cfg.assetPath,
      inputSize: cfg.inputSize,
      numClasses: cfg.classNames.length,
    );

    final raw = res.rawLabel ?? cfg.classNames[res.classIndex];
    final canonical = _dict.mapRawLabelToId(raw, crop: p.crop) ?? raw;
    final displayPl = _dict.getDiseaseDisplay(canonical) ?? canonical;

    final entity = DiagnosisEntryEntity(
      id: 0,
      timestamp: DateTime.now(),
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
      createdAt: DateTime.now(),
    );

    final r = await _diag.save(entity);
    if (!r.isOk) {
      throw StateError('Nie udało się zapisać diagnozy: ${r.error}');
    }
  }
}
