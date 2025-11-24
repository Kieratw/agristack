import 'dart:async';
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
      return MapController(ref, fieldId);
    });

class MapController
    extends StateNotifier<AsyncValue<List<DiagnosisEntryEntity>>> {
  final Ref ref;
  final int? fieldId;
  StreamSubscription? _subscription;

  MapController(this.ref, this.fieldId) : super(const AsyncValue.loading()) {
    _init();
  }

  Future<void> _init() async {
    try {
      final repo = await ref.read(diagnosisRepoProvider.future);
      Stream<List<DiagnosisEntryEntity>> stream;

      if (fieldId != null) {
        stream = repo.watchByField(fieldId!);
      } else {
        stream = repo.watchByDateRange(DateTime(2000, 1, 1), DateTime.now());
      }

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
