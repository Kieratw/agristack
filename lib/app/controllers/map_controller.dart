import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:agristack/app/di.dart';
import 'package:agristack/domain/entities/entities.dart';

final mapControllerProvider =
    StateNotifierProvider.family<
      MapController,
      AsyncValue<List<DiagnosisEntryEntity>>,
      int?
    >((ref, fieldId) {
      return MapController(ref, fieldId);
    });

class MapController
    extends StateNotifier<AsyncValue<List<DiagnosisEntryEntity>>> {
  final Ref ref;
  final int? fieldId;
  StreamSubscription? _subscription;
  int? _year;

  MapController(this.ref, this.fieldId) : super(const AsyncValue.loading()) {
    _init();
  }

  void setYear(int? year) {
    if (_year == year) return;
    _year = year;
    _init();
  }

  Future<void> _init() async {
    try {
      final repo = await ref.read(diagnosisRepoProvider.future);
      Stream<List<DiagnosisEntryEntity>> stream;

      if (fieldId != null) {
        // For specific field, we usually show all history or filter by year if needed
        // Use the same logic: if _year is set, filter by it.
        stream = repo.watchByField(fieldId!, year: _year);
      } else {
        // Global map
        if (_year != null) {
          stream = repo.watchByDateRange(
            DateTime(_year!, 1, 1),
            DateTime(_year!, 12, 31, 23, 59, 59),
          );
        } else {
          stream = repo.watchByDateRange(DateTime(2000, 1, 1), DateTime.now());
        }
      }

      await _subscription?.cancel();
      _subscription = stream.listen(
        (data) {
          final withCoords = data
              .where((e) => e.lat != null && e.lng != null)
              .toList();
          state = AsyncValue.data(withCoords);
        },
        onError: (e, st) {
          state = AsyncValue.error(e, st);
        },
      );
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  Future<void> load() async {
    // No-op, handled by stream
  }

  Future<void> refresh() async {
    // No-op, handled by stream
  }
}

final mapFieldsProvider = StreamProvider.autoDispose<List<FieldEntity>>((
  ref,
) async* {
  final repo = await ref.watch(fieldsRepoProvider.future);
  yield* repo.watchAll();
});

final availableMapYearsProvider = FutureProvider<List<int>>((ref) async {
  final repo = await ref.watch(fieldsRepoProvider.future);
  // Get all seasons to extract years
  // Ideally we should modify repo to distinct years, but fetching all fields+seasons is fine for now
  final allFields = await repo.getAll();
  if (!allFields.isOk || allFields.data == null) return [];

  final years = <int>{};
  for (final f in allFields.data!) {
    final seasons = await repo.getSeasons(f.id);
    if (seasons.isOk && seasons.data != null) {
      years.addAll(seasons.data!.map((s) => s.year));
    }
  }
  final sorted = years.toList()..sort((a, b) => b.compareTo(a)); // Descending
  return sorted;
});
