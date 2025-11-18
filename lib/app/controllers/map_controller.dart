import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:agristack/app/di.dart';
import 'package:agristack/domain/entities/entities.dart';
import 'package:agristack/domain/value/result.dart';

final mapControllerProvider =
    StateNotifierProvider.family<
      MapController,
      AsyncValue<List<DiagnosisEntryEntity>>,
      int?
    >((ref, fieldId) {
      final c = MapController(ref, fieldId);
      c.load();
      return c;
    });

class MapController
    extends StateNotifier<AsyncValue<List<DiagnosisEntryEntity>>> {
  final Ref ref;
  final int? fieldId;

  MapController(this.ref, this.fieldId) : super(const AsyncValue.loading());

  Future<void> load() async {
    try {
      state = const AsyncValue.loading();
      final repo = await ref.read(diagnosisRepoProvider.future);

      Result<List<DiagnosisEntryEntity>> res;

      if (fieldId != null) {
        // Filtrowanie po polu
        res = await repo.listByField(fieldId!);
      } else {
        // Cała historia
        res = await repo.listByDateRange(DateTime(2000, 1, 1), DateTime.now());
      }

      if (res.isOk && res.data != null) {
        // Filtrowanie tylko tych z koordynatami
        final withCoords = res.data!
            .where((e) => e.lat != null && e.lng != null)
            .toList();
        state = AsyncValue.data(withCoords);
      } else if (res.error != null) {
        state = AsyncValue.error(res.error!, StackTrace.current);
      } else {
        state = const AsyncValue.data([]);
      }
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> refresh() => load();
}
