import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:agristack/app/di.dart';
import 'package:agristack/domain/entities/entities.dart';
import 'package:agristack/domain/usecases/agristack_usecases.dart';

class DiagnosisState {
  final String? imagePath;
  final String crop; // 'wheat' / 'potato' / 'oilseed_rape' / 'tomato'
  final bool isRunning;
  final String? label;
  final double? manualLat;
  final double? manualLng;
  final double? confidence;

  final int? selectedFieldId;
  final int? selectedFieldSeasonId;

  final bool isSaving;
  final bool isSaved;
  final DiagnosisEntryEntity? lastSavedEntry;
  // --- NEW ---
  final DiagnosisEntryEntity? previewResult;
  final String? error;

  DiagnosisState({
    this.imagePath,
    this.crop = 'wheat',
    this.isRunning = false,
    this.label,
    this.confidence,
    this.selectedFieldId,
    this.selectedFieldSeasonId,
    this.isSaving = false,
    this.isSaved = false,
    this.lastSavedEntry,
    this.previewResult,
    this.error,
    this.manualLat,
    this.manualLng,
  });

  DiagnosisState copyWith({
    String? imagePath,
    String? crop,
    bool? isRunning,
    String? label,
    double? confidence,
    int? selectedFieldId,
    int? selectedFieldSeasonId,
    bool? isSaving,
    bool? isSaved,
    DiagnosisEntryEntity? lastSavedEntry,
    DiagnosisEntryEntity? previewResult,
    String? error,
    double? manualLat,
    double? manualLng,
  }) {
    return DiagnosisState(
      imagePath: imagePath ?? this.imagePath,
      crop: crop ?? this.crop,
      isRunning: isRunning ?? this.isRunning,
      label: label ?? this.label,
      confidence: confidence ?? this.confidence,
      selectedFieldId: selectedFieldId ?? this.selectedFieldId,
      selectedFieldSeasonId:
          selectedFieldSeasonId ?? this.selectedFieldSeasonId,
      isSaving: isSaving ?? this.isSaving,
      isSaved: isSaved ?? this.isSaved,
      lastSavedEntry: lastSavedEntry ?? this.lastSavedEntry,
      previewResult: previewResult ?? this.previewResult,
      error: error,
      manualLat: manualLat ?? this.manualLat,
      manualLng: manualLng ?? this.manualLng,
    );
  }
}

class DiagnosisController extends StateNotifier<DiagnosisState> {
  final Ref _ref;

  DiagnosisController(this._ref) : super(DiagnosisState());

  void reset() {
    state = DiagnosisState();
  }

  void setCrop(String crop) {
    state = state.copyWith(crop: crop);
  }

  void setImagePath(String? path) {
    state = state.copyWith(imagePath: path);
  }

  void setManualLocation(double? lat, double? lng) {
    state = state.copyWith(manualLat: lat, manualLng: lng);
  }

  Future<void> setFieldId(int? fieldId) async {
    // 1. Ustaw pole i zresetuj sezon
    state = state.copyWith(
      selectedFieldId: fieldId,
      selectedFieldSeasonId: null,
    );

    if (fieldId == null) return;

    // 2. Pobierz sezony dla tego pola i spróbuj wybrać domyślny
    try {
      final fieldsRepo = await _ref.read(fieldsRepoProvider.future);
      final res = await fieldsRepo.getSeasons(fieldId);

      if (res.isOk && res.data != null && res.data!.isNotEmpty) {
        final seasons = res.data!;
        // Sortuj malejąco po roku (zakładamy, że nowsze są ważniejsze)
        seasons.sort((a, b) => b.year.compareTo(a.year));

        // Wybierz pierwszy (najnowszy)
        final latest = seasons.first;
        state = state.copyWith(selectedFieldSeasonId: latest.id);
      }
    } catch (e) {
      // Cicho ignorujemy błąd automatycznego wyboru - użytkownik może wybrać ręcznie
      // ewentualnie można zalogować
    }
  }

  void setFieldSeasonId(int? seasonId) {
    state = state.copyWith(selectedFieldSeasonId: seasonId);
  }

  /// Uruchamia model, zwraca wynik i (w obecnej implementacji) też zapisuje w bazie.
  /// Jeśli chcesz czysty preview bez zapisu, później zrobimy osobny use-case.
  Future<void> runInferencePreview() async {
    final imagePath = state.imagePath;
    if (imagePath == null) {
      state = state.copyWith(error: 'Brak zdjęcia');
      return;
    }

    state = state.copyWith(isRunning: true, error: null);

    try {
      final usecases = await _ref.read(agristackUsecasesProvider.future);

      // używamy aliasu inferPreview(SaveDiagnosisParams)
      final entry = await usecases.inferPreview(
        SaveDiagnosisParams(
          crop: state.crop,
          imagePath: imagePath,
          fieldSeasonId: state.selectedFieldSeasonId,
          // preview: bez GPS
        ),
      );

      state = state.copyWith(
        isRunning: false,
        label: entry.displayLabelPl,
        confidence: entry.confidence,
        previewResult: entry, // Save for later reuse
      );
    } catch (e) {
      state = state.copyWith(isRunning: false, error: e.toString());
    }
  }

  /// Faktyczny zapis do bazy z GPS (tutaj zakładamy, że to „drugi krok”).
  Future<DiagnosisEntryEntity?> saveDiagnosis({
    double? lat,
    double? lng,
  }) async {
    // 1. Protection against double-click (save in progress)
    if (state.isSaving) return null;

    // 2. Idempotency (already saved)
    if (state.isSaved && state.lastSavedEntry != null) {
      return state.lastSavedEntry;
    }

    final imagePath = state.imagePath;
    if (imagePath == null) {
      state = state.copyWith(error: 'Brak zdjęcia, nie mogę zapisać');
      return null;
    }

    state = state.copyWith(isSaving: true, error: null);

    try {
      final usecases = await _ref.read(agristackUsecasesProvider.future);

      final savedEntry = await usecases.save(
        SaveDiagnosisParams(
          crop: state.crop,
          imagePath: imagePath,
          fieldSeasonId: state.selectedFieldSeasonId,
          lat: lat,
          lng: lng,
          precomputedResult: state.previewResult, // --- Reuse Inference! ---
        ),
      );

      state = state.copyWith(
        isSaving: false,
        isSaved: true,
        lastSavedEntry: savedEntry,
      );
      return savedEntry;
    } catch (e) {
      state = state.copyWith(isSaving: false, error: e.toString());
      return null;
    }
  }
}

final diagnosisControllerProvider =
    StateNotifierProvider<DiagnosisController, DiagnosisState>(
      (ref) => DiagnosisController(ref),
    );
