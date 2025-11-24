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

// ====== SECRETS (API key do Gemini - opcjonalne, jeśli używamy Advice API to może niepotrzebne, ale zostawiam serwis) ======
import '../domain/services/secrets_service.dart';
import '../data/services/secure_secrets_service.dart';

// ====== ADVICE API ======
import 'package:agristack/domain/services/advice_service.dart';
import 'package:agristack/data/services/http_advice_service.dart';

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

final fieldsListProvider = StreamProvider<List<FieldEntity>>((ref) async* {
  final repo = await ref.watch(fieldsRepoProvider.future);

  if (repo is IsarFieldsRepository) {
    yield* repo.watchAll();
  } else {
    final res = await repo.getAll();
    if (!res.isOk || res.data == null) {
      throw Exception(res.error?.message ?? 'Nie udało się odczytać pól');
    }
    yield res.data!;
  }
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
///   SECRETS
/// =======================

final secretsServiceProvider = Provider<SecretsService>(
  (ref) => SecureSecretsService(),
);

// (Opcjonalnie) Provider klucza Gemini - jeśli potrzebny gdzie indziej, zostawiam.
// Jeśli nie, można usunąć. InfoPage go używał, ale usunąłem.
final geminiApiKeyProvider = FutureProvider<String?>((ref) async {
  return ref.read(secretsServiceProvider).getGeminiApiKey();
});

/// =======================
///   ADVICE SERVICE
/// =======================

final adviceServiceProvider = Provider<AdviceService>((ref) {
  return HttpAdviceService();
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
///   USECASE – LLM / ADVICE
/// =======================

final getEnhancedRecommendationUseCaseProvider =
    FutureProvider<GetEnhancedRecommendationUseCase>((ref) async {
      await ref.watch(dictionaryInitializerProvider.future);
      final adviceService = ref.read(adviceServiceProvider);
      // final dict = ref.read(dictionaryRepoProvider); // Unused now
      return GetEnhancedRecommendationUseCaseImpl(adviceService);
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
