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
    // ... (ta metoda jest poprawna, bez zmian) ...
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
        if (d == null) throw Exception('diagnosis.not_found');
        
        // 1. Skopiuj właściwości
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

        // --- POCZĄTEK POPRAWKI ---

        // 2. JAWNIE ZAŁADUJ aktualny stan linku z bazy
        await d.fieldSeason.load();

        // 3. Teraz modyfikuj link (gdy jest już "obudzony")
        if (entry.fieldSeasonId != null) {
          // Przypisz nowy sezon (jeśli istnieje)
          final s = await isar.fieldSeasons.get(entry.fieldSeasonId!);
          d.fieldSeason.value = s;
        } else {
          // Ustaw na null (aby "uosierocić")
          d.fieldSeason.value = null;
        }
        
        // 4. Zapisz obiekt ORAZ link
        await isar.diagnosisEntrys.put(d);
        await d.fieldSeason.save();

        // --- KONIEC POPRAWKI ---
      });
      return const Result.ok(null);
    } catch (e) {
      return Result.err(AppError('db.update_failed', e.toString()));
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
      return Result.ok(list.map((e) => e.toEntity()).toList());
    } catch (e) {
      return Result.err(AppError('db.read_failed', e.toString()));
    }
  }

  @override
  Future<Result<List<DiagnosisEntryEntity>>> listByField(int fieldId, {int? year}) async {
    try {
      if (year == null) {
        final seasons = await isar.fieldSeasons.filter().field((q) => q.idEqualTo(fieldId)).findAll();
        final ids = seasons.map((s) => s.id).toList();
        if (ids.isEmpty) return const Result.ok(<DiagnosisEntryEntity>[]);
        final list = await isar.diagnosisEntrys
            .filter()
            .fieldSeason((q) => q.anyOf(ids, (q2, id) => q2.idEqualTo(id)))
            .findAll();
        return Result.ok(list.map((e) => e.toEntity()).toList());
      } else {
        final s = await isar.fieldSeasons
            .filter()
            .field((q) => q.idEqualTo(fieldId))
            .yearEqualTo(year)
            .findFirst();
        if (s == null) return const Result.ok(<DiagnosisEntryEntity>[]);
        final list = await isar.diagnosisEntrys.filter().fieldSeason((q) => q.idEqualTo(s.id)).findAll();
        return Result.ok(list.map((e) => e.toEntity()).toList());
      }
    } catch (e) {
      return Result.err(AppError('db.read_failed', e.toString()));
    }
  }

  @override
  Future<Result<List<DiagnosisEntryEntity>>> listByDateRange(DateTime from, DateTime to) async {
    try {
      final list = await isar.diagnosisEntrys
          .filter()
          .timestampBetween(from, to, includeLower: true, includeUpper: true)
          .findAll();
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
      final list = await isar.diagnosisEntrys.filter().fieldSeason((q) => q.idEqualTo(s.id)).findAll();
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
      final list = await isar.diagnosisEntrys.filter().fieldSeasonIsNull().findAll();
      return Result.ok(list.map((e) => e.toEntity()).toList());
    } catch (e) {
      return Result.err(AppError('db.read_failed', e.toString()));
    }
  }
}