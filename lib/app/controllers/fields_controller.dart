import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:agristack/app/di.dart';
import 'package:agristack/domain/entities/entities.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:agristack/app/utils/geometry_utils.dart';

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
      return FieldsController(ref);
    });

class FieldsController extends StateNotifier<FieldsState> {
  final Ref _ref;
  StreamSubscription? _subscription;

  FieldsController(this._ref) : super(const FieldsState(isLoading: true)) {
    _init();
  }

  Future<void> _init() async {
    try {
      final repo = await _ref.read(fieldsRepoProvider.future);
      _subscription = repo.watchAll().listen(
        (fields) {
          // Transform fields to FieldRowState
          final currentExpanded = {
            for (final item in state.items)
              if (item.expanded) item.field.id,
          };

          final newItems = fields.map((f) {
            final existingRow = state.items.firstWhere(
              (item) => item.field.id == f.id,
              orElse: () => FieldRowState(field: f),
            );
            return existingRow.copyWith(
              field: f, // Update field data
              expanded: currentExpanded.contains(f.id),
              seasons: existingRow.expanded ? existingRow.seasons : const [],
              diagnoses: existingRow.expanded
                  ? existingRow.diagnoses
                  : const [],
            );
          }).toList();

          state = state.copyWith(items: newItems, isLoading: false);

          // Trigger load for details for currently expanded items
          for (var i = 0; i < newItems.length; i++) {
            if (newItems[i].expanded) {
              _loadFieldDetails(i, newItems[i].field.id);
            }
          }
        },
        onError: (e) {
          state = state.copyWith(error: e.toString(), isLoading: false);
        },
      );
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  Future<void> load() async {
    // No-op, handled by watchAll stream
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
    if (index >= items.length) return;

    items[index] = items[index].copyWith(
      loadingDetails: true,
      clearError: true,
    );
    state = state.copyWith(items: items);

    try {
      final fieldsRepo = await _ref.read(fieldsRepoProvider.future);
      final diagRepo = await _ref.read(diagnosisRepoProvider.future);

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
    final repo = await _ref.read(fieldsRepoProvider.future);
    final res = await repo.add(name: name);
    if (!res.isOk) {
      state = state.copyWith(
        error: res.error?.message ?? 'Błąd dodawania pola',
      );
    }
  }

  Future<void> renameField(FieldEntity field, String newName) async {
    final repo = await _ref.read(fieldsRepoProvider.future);
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
    if (!res.isOk) {
      state = state.copyWith(error: res.error?.message ?? 'Błąd zmiany nazwy');
    }
  }

  Future<void> deleteField(int fieldId) async {
    final repo = await _ref.read(fieldsRepoProvider.future);
    final res = await repo.delete(fieldId);
    if (!res.isOk) {
      state = state.copyWith(error: res.error?.message ?? 'Błąd usuwania pola');
    }
  }

  Future<void> addSeason({
    required int fieldId,
    required int year,
    required String crop,
  }) async {
    final repo = await _ref.read(fieldsRepoProvider.future);
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

  Future<void> updateFieldPolygon(int fieldId, List<LatLng> points) async {
    final area = GeometryUtils.calculatePolygonArea(points);
    final geoPoints = points
        .map((p) => GeoPoint(p.latitude, p.longitude))
        .toList();

    final repo = await _ref.read(fieldsRepoProvider.future);

    // Fetch current field
    final row = state.items.firstWhere(
      (r) => r.field.id == fieldId,
      orElse: () => throw Exception('Field not found'),
    );
    final currentField = row.field;

    final updated = FieldEntity(
      id: currentField.id,
      name: currentField.name,
      centerLat: currentField.centerLat,
      centerLng: currentField.centerLng,
      notes: currentField.notes,
      createdAt: currentField.createdAt,
      updatedAt: DateTime.now(),
      polygon: geoPoints,
      area: area,
    );

    final res = await repo.update(updated);
    if (!res.isOk) {
      state = state.copyWith(
        error: res.error?.message ?? 'Błąd zapisu poligonu',
      );
    }
  }

  Future<void> deleteDiagnosis(int diagnosisId, int fieldId) async {
    final repo = await _ref.read(diagnosisRepoProvider.future);
    final res = await repo.delete(diagnosisId);

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
          error: res.error?.message ?? 'Błąd usuwania diagnozy',
        );
        state = state.copyWith(items: items);
      }
    }
  }
}
