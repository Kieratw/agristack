import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:agristack/app/di.dart';
import 'package:agristack/domain/entities/entities.dart';
import 'package:agristack/domain/value/result.dart';

// State for a single row (field + details)
class FieldRowState {
  final FieldEntity field;
  final bool expanded;
  final bool loadingDetails;
  final String? error;
  final List<FieldSeasonEntity> seasons;
  final List<DiagnosisEntryEntity> diagnoses;

  FieldRowState({
    required this.field,
    this.expanded = false,
    this.loadingDetails = false,
    this.error,
    this.seasons = const [],
    this.diagnoses = const [],
  });

  FieldRowState copyWith({
    FieldEntity? field,
    bool? expanded,
    bool? loadingDetails,
    String? error,
    bool clearError = false,
    List<FieldSeasonEntity>? seasons,
    List<DiagnosisEntryEntity>? diagnoses,
  }) {
    return FieldRowState(
      field: field ?? this.field,
      expanded: expanded ?? this.expanded,
      loadingDetails: loadingDetails ?? this.loadingDetails,
      error: clearError ? null : (error ?? this.error),
      seasons: seasons ?? this.seasons,
      diagnoses: diagnoses ?? this.diagnoses,
    );
  }
}

// Global state for the list
class FieldsState {
  final bool isLoading;
  final String error;
  final List<FieldRowState> items;

  const FieldsState({
    this.isLoading = false,
    this.error = '',
    this.items = const [],
  });

  FieldsState copyWith({
    bool? isLoading,
    String? error,
    List<FieldRowState>? items,
  }) {
    return FieldsState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      items: items ?? this.items,
    );
  }
}

final fieldsControllerProvider =
    StateNotifierProvider<FieldsController, FieldsState>((ref) {
      final c = FieldsController(ref);
      c.load();
      return c;
    });

class FieldsController extends StateNotifier<FieldsState> {
  final Ref ref;

  FieldsController(this.ref) : super(const FieldsState(isLoading: true));

  Future<void> load() async {
    try {
      state = state.copyWith(isLoading: true, error: '');
      final repo = await ref.read(fieldsRepoProvider.future);
      final res = await repo.getAll();

      if (res.isOk && res.data != null) {
        // Map entities to RowStates
        final rows = res.data!.map((f) => FieldRowState(field: f)).toList();
        state = state.copyWith(isLoading: false, items: rows);
      } else {
        state = state.copyWith(
          isLoading: false,
          error: res.error?.message ?? 'Błąd pobierania pól',
        );
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> toggleExpanded(int fieldId) async {
    // 1. Toggle expanded state locally
    final index = state.items.indexWhere((r) => r.field.id == fieldId);
    if (index == -1) return;

    var row = state.items[index];
    final isExpanding = !row.expanded;

    // Update immediate state
    var newItems = List<FieldRowState>.from(state.items);
    newItems[index] = row.copyWith(expanded: isExpanding);
    state = state.copyWith(items: newItems);

    // 2. If expanding, fetch details (seasons, diagnoses)
    if (isExpanding) {
      await _loadFieldDetails(index, fieldId);
    }
  }

  Future<void> _loadFieldDetails(int index, int fieldId) async {
    // Set loadingDetails = true
    var items = List<FieldRowState>.from(state.items);
    items[index] = items[index].copyWith(
      loadingDetails: true,
      clearError: true,
    );
    state = state.copyWith(items: items);

    try {
      final fieldsRepo = await ref.read(fieldsRepoProvider.future);
      final diagRepo = await ref.read(diagnosisRepoProvider.future);

      // Fetch seasons
      final seasonsRes = await fieldsRepo.getSeasons(fieldId);
      // Fetch diagnoses
      final diagRes = await diagRepo.listByField(fieldId);

      final seasons = (seasonsRes.isOk && seasonsRes.data != null)
          ? seasonsRes.data!
          : <FieldSeasonEntity>[];

      final diagnoses = (diagRes.isOk && diagRes.data != null)
          ? diagRes.data!
          : <DiagnosisEntryEntity>[];

      // Update state
      items = List<FieldRowState>.from(state.items);
      // Check if row still exists/index valid (simple check)
      if (index < items.length && items[index].field.id == fieldId) {
        items[index] = items[index].copyWith(
          loadingDetails: false,
          seasons: seasons,
          diagnoses: diagnoses,
        );
        state = state.copyWith(items: items);
      }
    } catch (e) {
      // Handle error
      items = List<FieldRowState>.from(state.items);
      if (index < items.length && items[index].field.id == fieldId) {
        items[index] = items[index].copyWith(
          loadingDetails: false,
          error: 'Błąd szczegółów: $e',
        );
        state = state.copyWith(items: items);
      }
    }
  }

  Future<void> addField(String name) async {
    final repo = await ref.read(fieldsRepoProvider.future);
    final res = await repo.add(name: name);
    if (res.isOk) {
      await load(); // Reload list
    } else {
      // Show global error or toast? For now just set error in state
      state = state.copyWith(
        error: res.error?.message ?? 'Błąd dodawania pola',
      );
    }
  }

  Future<void> renameField(FieldEntity field, String newName) async {
    final repo = await ref.read(fieldsRepoProvider.future);
    final updated = FieldEntity(
      id: field.id,
      name: newName,
      centerLat: field.centerLat,
      centerLng: field.centerLng,
      notes: field.notes,
      createdAt: field.createdAt,
      updatedAt: DateTime.now(),
    );
    final res = await repo.update(updated);
    if (res.isOk) {
      await load();
    } else {
      state = state.copyWith(error: res.error?.message ?? 'Błąd zmiany nazwy');
    }
  }

  Future<void> deleteField(int fieldId) async {
    final repo = await ref.read(fieldsRepoProvider.future);
    final res = await repo.delete(fieldId);
    if (res.isOk) {
      await load();
    } else {
      state = state.copyWith(error: res.error?.message ?? 'Błąd usuwania pola');
    }
  }

  Future<void> addSeason({
    required int fieldId,
    required int year,
    required String crop,
  }) async {
    final repo = await ref.read(fieldsRepoProvider.future);
    final res = await repo.addSeason(fieldId: fieldId, year: year, crop: crop);

    if (res.isOk) {
      // Refresh details for this field if it's expanded
      final index = state.items.indexWhere((r) => r.field.id == fieldId);
      if (index != -1 && state.items[index].expanded) {
        await _loadFieldDetails(index, fieldId);
      }
    } else {
      // Find row and set error
      final index = state.items.indexWhere((r) => r.field.id == fieldId);
      if (index != -1) {
        var items = List<FieldRowState>.from(state.items);
        items[index] = items[index].copyWith(
          error: res.error?.message ?? 'Błąd dodawania sezonu',
        );
        state = state.copyWith(items: items);
      }
    }
  }
}
