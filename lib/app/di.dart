import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

// ====== ISAR ======
import 'package:agristack/data/sources/isar/schemas.dart';
import 'package:agristack/data/repositories/isar_fields_repository.dart';
import 'package:agristack/data/repositories/isar_diagnosis_repository.dart';
import 'package:agristack/domain/repositories/fields_repository.dart';
import 'package:agristack/domain/repositories/diagnosis_repository.dart';

// ====== SŁOWNIK (assets/static/*.json) ======
import 'package:agristack/domain/services/static_data_source.dart';
import 'package:agristack/data/services/asset_static_data_source.dart';
import 'package:agristack/domain/repositories/dictionary_repository.dart';
import 'package:agristack/data/repositories/json_dictionary_repository.dart';

// ====== INFERENCJA PTL (pytorch_lite) ======
import 'package:agristack/domain/services/inference_service.dart';
import 'package:agristack/data/services/ptl_inference_service.dart';

// ====== SECRETS (Keystore + --dart-define) ======
import 'package:agristack/domain/services/secrets_service.dart';
import 'package:agristack/data/services/secure_secrets_service.dart';

// ====== LLM (Gemini) ======
import 'package:agristack/domain/services/llm_service.dart';
import 'package:agristack/data/services/gemini_llm_service.dart';

// ====== USECASES (jeden plik z interfejsami) ======
import 'package:agristack/domain/usecases/agristack_usecases.dart';

// ====== IMPLEMENTACJE USECASE’ÓW (CNN + LLM) ======
import 'package:agristack/app/usecases/agristack_usecases_impl.dart';

/// Jedna instancja Isara na cały lifecycle aplikacji
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
    inspector: false,
  );
  ref.onDispose(() => isar.close());
  return isar;
});

final fieldsRepoProvider = FutureProvider<FieldsRepository>((ref) async {
  final isar = await ref.watch(isarProvider.future);
  return IsarFieldsRepository(isar);
});

final diagnosisRepoProvider = FutureProvider<DiagnosisRepository>((ref) async {
  final isar = await ref.watch(isarProvider.future);
  return IsarDiagnosisRepository(isar);
});

/// ====== SŁOWNIK: JSON + indeks aliasów w Isar ======

final staticDataSourceProvider = Provider<StaticDataSource>(
  (ref) => AssetStaticDataSource(),
);

final dictionaryRepoProvider = Provider<DictionaryRepository>((ref) {
  return JsonDictionaryRepository(ref.read(staticDataSourceProvider));
});

/// Czekamy na inicjalizację słownika (np. w splashu razem z isarProvider)
final dictionaryInitializerProvider = FutureProvider<void>((ref) async {
  await ref.read(dictionaryRepoProvider).initialize();
});

/// ====== INFERENCJA CNN (PTL) ======

final inferenceServiceProvider = Provider<InferenceService>(
  (ref) => PtlInferenceService(),
);

/// Use-case: od obrazka do wpisu w bazie
final saveDiagnosisUseCaseProvider =
    FutureProvider<SaveDiagnosisUseCase>((ref) async {
  final diagRepo = await ref.watch(diagnosisRepoProvider.future);
  await ref.watch(dictionaryInitializerProvider.future);
  final dict = ref.read(dictionaryRepoProvider);
  final inf = ref.read(inferenceServiceProvider);
  return SaveDiagnosisUseCaseImpl(diagRepo, dict, inf);
});

/// ====== SECRETS / KLUCZ GEMINI ======

final secretsServiceProvider = Provider<SecretsService>(
  (ref) => SecureSecretsService(),
);

final geminiApiKeyProvider = FutureProvider<String?>((ref) async {
  return ref.read(secretsServiceProvider).getGeminiApiKey();
});

/// ====== LLM (Gemini) + „Ekspert” ======

/// LLM jest FutureProvider, bo czekamy na klucz API
final llmServiceProvider = FutureProvider<LlmService>((ref) async {
  final key = await ref.watch(geminiApiKeyProvider.future) ?? '';
  return GeminiLlmService(apiKey: key);
});

final getEnhancedRecommendationUseCaseProvider =
    FutureProvider<GetEnhancedRecommendationUseCase>((ref) async {
  await ref.watch(dictionaryInitializerProvider.future);
  final llm = await ref.watch(llmServiceProvider.future);
  final dict = ref.read(dictionaryRepoProvider);
  return GetEnhancedRecommendationUseCaseImpl(llm, dict);
});
