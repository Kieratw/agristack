import 'package:isar/isar.dart';

import '../../domain/entities/entities.dart';
import '../../domain/repositories/diagnosis_repository.dart';
import '../../domain/value/result.dart';
import '../mappers/mappers.dart';
import '../sources/isar/schemas.dart';

class IsarDiagnosisRepository implements DiagnosisRepository {
  final Isar isar;
  IsarDiagnosisRepository(this.isar);

  @override
  Future<Result<DiagnosisEntryEntity>> save(DiagnosisEntryEntity draft) async {
    try {
      final d = DiagnosisEntry()
        ..timestamp = draft.timestamp
        ..imagePath = draft.imagePath
        ..lat = draft.lat
        ..lng = draft.lng
        ..modelId = draft.modelId
        ..rawLabel = draft.rawLabel
        ..canonicalDiseaseId = draft.canonicalDiseaseId
        ..displayLabelPl = draft.displayLabelPl
        ..confidence = draft.confidence
        ..recommendationKey = draft.recommendationKey
        ..notes = draft.notes
        ..createdAt = DateTime.now();

      await isar.writeTxn(() async {
        if (draft.fieldSeasonId != null) {
          final s = await isar.fieldSeasons.get(draft.fieldSeasonId!);
          if (s != null) d.fieldSeason.value = s;
        }
        await isar.diagnosisEntrys.put(d);
        await d.fieldSeason.save();
      });
      return Result.ok(d.toEntity());
    } catch (e) {
      return Result.err(AppError('db.write_failed', e.toString()));
    }
  }

  @override
  Future<Result<void>> update(DiagnosisEntryEntity entry) async {
    try {
      await isar.writeTxn(() async {
        final d = await isar.diagnosisEntrys.get(entry.id);
        if (d != null) {
          d
            ..timestamp = entry.timestamp
            ..imagePath = entry.imagePath
            ..lat = entry.lat
            ..lng = entry.lng
            ..modelId = entry.modelId
            ..rawLabel = entry.rawLabel
            ..canonicalDiseaseId = entry.canonicalDiseaseId
            ..displayLabelPl = entry.displayLabelPl
            ..confidence = entry.confidence
            ..recommendationKey = entry.recommendationKey
            ..notes = entry.notes;

          if (entry.fieldSeasonId != null) {
            final s = await isar.fieldSeasons.get(entry.fieldSeasonId!);
            if (s != null) d.fieldSeason.value = s;
          }

          await isar.diagnosisEntrys.put(d);
          await d.fieldSeason.save();
        }
      });
      return const Result.ok(null);
    } catch (e) {
      return Result.err(AppError('db.update_failed', e.toString()));
    }
  }

  @override
  Future<Result<void>> delete(int id) async {
    try {
      await isar.writeTxn(() async {
        await isar.diagnosisEntrys.delete(id);
      });
      return const Result.ok(null);
    } catch (e) {
      return Result.err(AppError('db.delete_failed', e.toString()));
    }
  }

  // ... (reszta metod 'listBySeason', 'listByField' itd. jest poprawna) ...
  @override
  Future<Result<List<DiagnosisEntryEntity>>> listBySeason(int seasonId) async {
    try {
      final list = await isar.diagnosisEntrys
          .filter()
          .fieldSeason((q) => q.idEqualTo(seasonId))
          .sortByTimestampDesc()
          .findAll();
      // Load links before mapping
      for (final item in list) {
        await item.fieldSeason.load();
      }
      return Result.ok(list.map((e) => e.toEntity()).toList());
    } catch (e) {
      return Result.err(AppError('db.read_failed', e.toString()));
    }
  }

  @override
  Future<Result<List<DiagnosisEntryEntity>>> listByField(
    int fieldId, {
    int? year,
  }) async {
    try {
      if (year == null) {
        final seasons = await isar.fieldSeasons
            .filter()
            .field((q) => q.idEqualTo(fieldId))
            .findAll();
        final ids = seasons.map((s) => s.id).toList();
        if (ids.isEmpty) return const Result.ok(<DiagnosisEntryEntity>[]);
        final list = await isar.diagnosisEntrys
            .filter()
            .fieldSeason((q) => q.anyOf(ids, (q2, id) => q2.idEqualTo(id)))
            .findAll();
        // Load links before mapping
        for (final item in list) {
          await item.fieldSeason.load();
        }
        return Result.ok(list.map((e) => e.toEntity()).toList());
      } else {
        final s = await isar.fieldSeasons
            .filter()
            .field((q) => q.idEqualTo(fieldId))
            .yearEqualTo(year)
            .findFirst();
        if (s == null) return const Result.ok(<DiagnosisEntryEntity>[]);
        final list = await isar.diagnosisEntrys
            .filter()
            .fieldSeason((q) => q.idEqualTo(s.id))
            .findAll();
        // Load links before mapping
        for (final item in list) {
          await item.fieldSeason.load();
        }
        return Result.ok(list.map((e) => e.toEntity()).toList());
      }
    } catch (e) {
      return Result.err(AppError('db.read_failed', e.toString()));
    }
  }

  @override
  Future<Result<List<DiagnosisEntryEntity>>> listByDateRange(
    DateTime from,
    DateTime to,
  ) async {
    try {
      final list = await isar.diagnosisEntrys
          .filter()
          .timestampBetween(from, to, includeLower: true, includeUpper: true)
          .findAll();
      // Load links before mapping
      for (final item in list) {
        await item.fieldSeason.load();
      }
      return Result.ok(list.map((e) => e.toEntity()).toList());
    } catch (e) {
      return Result.err(AppError('db.read_failed', e.toString()));
    }
  }

  @override
  Future<Result<Map<String, int>>> statsByDisease(int fieldId, int year) async {
    try {
      final s = await isar.fieldSeasons
          .filter()
          .field((q) => q.idEqualTo(fieldId))
          .yearEqualTo(year)
          .findFirst();
      if (s == null) return const Result.ok(<String, int>{});
      final list = await isar.diagnosisEntrys
          .filter()
          .fieldSeason((q) => q.idEqualTo(s.id))
          .findAll();
      final map = <String, int>{};
      for (final d in list) {
        map[d.canonicalDiseaseId] = (map[d.canonicalDiseaseId] ?? 0) + 1;
      }
      return Result.ok(map);
    } catch (e) {
      return Result.err(AppError('db.read_failed', e.toString()));
    }
  }

  @override
  Future<Result<List<DiagnosisEntryEntity>>> listOrphaned() async {
    try {
      final list = await isar.diagnosisEntrys
          .filter()
          .fieldSeasonIsNull()
          .findAll();
      // Load links before mapping (though they should be null)
      for (final item in list) {
        await item.fieldSeason.load();
      }
      return Result.ok(list.map((e) => e.toEntity()).toList());
    } catch (e) {
      return Result.err(AppError('db.read_failed', e.toString()));
    }
  }

  @override
  Stream<List<DiagnosisEntryEntity>> watchByField(
    int fieldId, {
    int? year,
  }) async* {
    QueryBuilder<DiagnosisEntry, DiagnosisEntry, QAfterFilterCondition> query;

    if (year == null) {
      // We need to find all seasons for this field first
      // But Isar watchers on links are tricky.
      // Instead, we can watch all diagnosis entries and filter manually or use a complex query if possible.
      // A simpler approach for Isar 3: watch the query.
      // But we need the season IDs first.
      // If seasons change, this query might be outdated.
      // For now, let's assume seasons don't change often enough to break this stream immediately,
      // OR we can just watch all diagnoses and filter in Dart (less efficient but safer).

      // Better approach:
      // 1. Get seasons for field.
      // 2. Watch diagnoses linked to those seasons.
      // Note: If a new season is added, we won't see it.
      // Ideally we should watch seasons too.

      // Let's try to use the link filter if possible.
      // Isar supports filtering by link.

      query = isar.diagnosisEntrys.filter().fieldSeason(
        (q) => q.field((f) => f.idEqualTo(fieldId)),
      );
    } else {
      query = isar.diagnosisEntrys.filter().fieldSeason(
        (q) => q.field((f) => f.idEqualTo(fieldId)).yearEqualTo(year),
      );
    }

    yield* query.watch(fireImmediately: true).asyncMap((list) async {
      for (final item in list) {
        await item.fieldSeason.load();
      }
      return list.map((e) => e.toEntity()).toList();
    });
  }

  @override
  Stream<List<DiagnosisEntryEntity>> watchByDateRange(
    DateTime from,
    DateTime to,
  ) async* {
    yield* isar.diagnosisEntrys
        .filter()
        .timestampBetween(from, to, includeLower: true, includeUpper: true)
        .watch(fireImmediately: true)
        .asyncMap((list) async {
          for (final item in list) {
            await item.fieldSeason.load();
          }
          return list.map((e) => e.toEntity()).toList();
        });
  }
}
