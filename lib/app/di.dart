// lib/app/di.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

// ====== ISAR ======
import '../data/sources/isar/schemas.dart';
import '../data/repositories/isar_fields_repository.dart';
import '../data/repositories/isar_diagnosis_repository.dart';
import '../domain/repositories/fields_repository.dart';
import '../domain/repositories/diagnosis_repository.dart';
import '../domain/entities/entities.dart';

// ====== STATIC JSON (diseases.json, models.json) ======
import '../domain/services/static_data_source.dart';
import '../data/services/asset_static_data_source.dart';
import '../domain/repositories/dictionary_repository.dart';
import '../data/repositories/json_dictionary_repository.dart';

// ====== INFERENCE (MethodChannel -> Kotlin / PyTorch) ======
import '../domain/services/inference_service.dart';
import '../data/services/mc_inference_service.dart';

// ====== SECRETS (API key do Gemini) ======
import '../domain/services/secrets_service.dart';
import '../data/services/secure_secrets_service.dart';

// ====== LLM (Gemini) ======
import '../domain/services/llm_service.dart';
import '../data/services/gemini_llm_service.dart';

// ====== USECASES (interfejsy + implementacje) ======
import '../domain/usecases/agristack_usecases.dart';
import '../app/usecases/agristack_usecases_impl.dart';
import '../app/usecases/preview_diagnosis_usecase_impl.dart';

/// =======================
///      ISAR
/// =======================

final isarProvider = FutureProvider<Isar>((ref) async {
  final dir = await getApplicationDocumentsDirectory();
  final isar = await Isar.open(
    [
      FieldSchema,
      FieldSeasonSchema,
      DiagnosisEntrySchema,
      DiseaseAliasIndexSchema,
      AppMetaSchema,
    ],
    name: 'agristack_db',
    directory: dir.path,
    inspector: true,
  );
  ref.onDispose(() => isar.close());
  return isar;
});

final fieldsRepoProvider = FutureProvider<FieldsRepository>((ref) async {
  final isar = await ref.watch(isarProvider.future);
  return IsarFieldsRepository(isar);
});

final fieldsListProvider = FutureProvider<List<FieldEntity>>((ref) async {
  final repo = await ref.watch(fieldsRepoProvider.future);
  final res = await repo.getAll(); // <-- tu jest zmiana

  if (!res.isOk || res.data == null) {
    throw Exception(res.error?.message ?? 'Nie udało się odczytać pól');
  }
  return res.data!;
});

/// Sezony dla danego pola (używa getSeasons(fieldId))
final fieldSeasonsByFieldProvider =
    FutureProvider.family<List<FieldSeasonEntity>, int>((ref, fieldId) async {
      final repo = await ref.watch(fieldsRepoProvider.future);
      final res = await repo.getSeasons(fieldId);
      if (!res.isOk || res.data == null) {
        throw Exception(res.error?.message ?? 'Nie udało się odczytać sezonów');
      }
      return res.data!;
    });

final diagnosisRepoProvider = FutureProvider<DiagnosisRepository>((ref) async {
  final isar = await ref.watch(isarProvider.future);
  return IsarDiagnosisRepository(isar);
});

/// =======================
///  STATIC JSON / SŁOWNIK
/// =======================

final staticDataSourceProvider = Provider<StaticDataSource>(
  (ref) => AssetStaticDataSource(),
);

final dictionaryRepoProvider = Provider<DictionaryRepository>((ref) {
  final src = ref.read(staticDataSourceProvider);
  return JsonDictionaryRepository(src);
});

/// Poczekaj na to w splashu razem z isarProvider
final dictionaryInitializerProvider = FutureProvider<void>((ref) async {
  await ref.read(dictionaryRepoProvider).initialize();
});

/// =======================
///   INFERENCE SERVICE
/// =======================

final inferenceServiceProvider = Provider<InferenceService>(
  (ref) => MethodChannelInferenceService(),
);

/// =======================
///   SECRETS + LLM
/// =======================

final secretsServiceProvider = Provider<SecretsService>(
  (ref) => SecureSecretsService(),
);

final geminiApiKeyProvider = FutureProvider<String?>((ref) async {
  return ref.read(secretsServiceProvider).getGeminiApiKey();
});

final llmServiceProvider = FutureProvider<LlmService>((ref) async {
  final key = await ref.watch(geminiApiKeyProvider.future) ?? '';
  return GeminiLlmService(apiKey: key);
});

/// =======================
///     USECASES – pola
/// =======================

final getFieldsOverviewUseCaseProvider =
    FutureProvider<GetFieldsOverviewUseCase>((ref) async {
      final fieldsRepo = await ref.watch(fieldsRepoProvider.future);
      return GetFieldsOverviewUseCaseImpl(fieldsRepo);
    });

final getFieldDetailsUseCaseProvider = FutureProvider<GetFieldDetailsUseCase>((
  ref,
) async {
  final fieldsRepo = await ref.watch(fieldsRepoProvider.future);
  final diagRepo = await ref.watch(diagnosisRepoProvider.future);
  return GetFieldDetailsUseCaseImpl(fieldsRepo, diagRepo);
});

/// =======================
///   USECASES – diagnozy
/// =======================

final listDiagnosisUseCaseProvider = FutureProvider<ListDiagnosisUseCase>((
  ref,
) async {
  final diagRepo = await ref.watch(diagnosisRepoProvider.future);
  return ListDiagnosisUseCaseImpl(diagRepo);
});

final getMapPointsUseCaseProvider = FutureProvider<GetMapPointsUseCase>((
  ref,
) async {
  final diagRepo = await ref.watch(diagnosisRepoProvider.future);
  return GetMapPointsUseCaseImpl(diagRepo);
});

/// =======================
///   USECASE – LLM
/// =======================

final getEnhancedRecommendationUseCaseProvider =
    FutureProvider<GetEnhancedRecommendationUseCase>((ref) async {
      await ref.watch(dictionaryInitializerProvider.future);
      final llm = await ref.watch(llmServiceProvider.future);
      final dict = ref.read(dictionaryRepoProvider);
      return GetEnhancedRecommendationUseCaseImpl(llm, dict);
    });

/// =======================
///   USECASE – zapis diagnozy
/// =======================

final saveDiagnosisUseCaseProvider = FutureProvider<SaveDiagnosisUseCase>((
  ref,
) async {
  final diagRepo = await ref.watch(diagnosisRepoProvider.future);
  await ref.watch(dictionaryInitializerProvider.future);
  final dict = ref.read(dictionaryRepoProvider);
  final inf = ref.read(inferenceServiceProvider);
  return SaveDiagnosisUseCaseImpl(diagRepo, dict, inf);
});

final previewDiagnosisUseCaseProvider = FutureProvider<PreviewDiagnosisUseCase>(
  (ref) async {
    await ref.watch(dictionaryInitializerProvider.future);
    final dict = ref.read(dictionaryRepoProvider);
    final inf = ref.read(inferenceServiceProvider);
    return PreviewDiagnosisUseCaseImpl(dict, inf);
  },
);

/// =======================
///   FASADA USECASES
/// =======================

final agristackUsecasesProvider = FutureProvider<AgristackUsecases>((
  ref,
) async {
  final save = await ref.watch(saveDiagnosisUseCaseProvider.future);
  final enhanced = await ref.watch(
    getEnhancedRecommendationUseCaseProvider.future,
  );
  final fieldsOverview = await ref.watch(
    getFieldsOverviewUseCaseProvider.future,
  );
  final fieldDetails = await ref.watch(getFieldDetailsUseCaseProvider.future);
  final listDiagnosis = await ref.watch(listDiagnosisUseCaseProvider.future);
  final mapPoints = await ref.watch(getMapPointsUseCaseProvider.future);
  final preview = await ref.watch(previewDiagnosisUseCaseProvider.future);

  return AgristackUsecases(
    saveDiagnosis: save,
    enhancedRecommendation: enhanced,
    fieldsOverview: fieldsOverview,
    fieldDetails: fieldDetails,
    listDiagnosis: listDiagnosis,
    mapPoints: mapPoints,
    previewDiagnosis: preview,
  );
});
