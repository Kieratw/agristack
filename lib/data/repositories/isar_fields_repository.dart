import 'package:isar/isar.dart';

import '../../domain/entities/entities.dart';
import '../../domain/repositories/fields_repository.dart';
import '../../domain/value/result.dart';
import '../mappers/mappers.dart';
import '../sources/isar/schemas.dart';

class IsarFieldsRepository implements FieldsRepository {
  final Isar isar;
  IsarFieldsRepository(this.isar);

  @override
  Future<Result<FieldEntity>> add({required String name, double? lat, double? lng, String? notes}) async {
    try {
      final exists = await isar.fields.filter().nameEqualTo(name, caseSensitive: false).isNotEmpty();
      if (exists) return const Result.err(AppError('field.duplicate', 'Pole o tej nazwie już istnieje.'));
      final f = Field()
        ..name = name
        ..centerLat = lat
        ..centerLng = lng
        ..notes = notes
        ..createdAt = DateTime.now()
        ..updatedAt = DateTime.now();
      await isar.writeTxn(() async => isar.fields.put(f));
      return Result.ok(f.toEntity());
    } catch (e) {
      return Result.err(AppError('db.write_failed', e.toString()));
    }
  }

  @override
  Future<Result<void>> delete(int fieldId) async {
    try {
      await isar.writeTxn(() async {
        final field = await isar.fields.get(fieldId);
        if (field == null) return;

        // Kaskada: sezony i ich diagnozy
        final seasons = await isar.fieldSeasons.filter().field((q) => q.idEqualTo(fieldId)).findAll();
        for (final s in seasons) {
          final diags = await isar.diagnosisEntrys.filter().fieldSeason((q) => q.idEqualTo(s.id)).findAll();
          if (diags.isNotEmpty) {
            await isar.diagnosisEntrys.deleteAll(diags.map((d) => d.id).toList());
          }
        }
        if (seasons.isNotEmpty) {
          await isar.fieldSeasons.deleteAll(seasons.map((s) => s.id).toList());
        }
        await isar.fields.delete(fieldId);
      });
      return const Result.ok(null);
    } catch (e) {
      return Result.err(AppError('db.delete_failed', e.toString()));
    }
  }

  @override
  Future<Result<List<FieldEntity>>> getAll() async {
    try {
      final list = await isar.fields.where().sortByName().findAll();
      return Result.ok(list.map((e) => e.toEntity()).toList());
    } catch (e) {
      return Result.err(AppError('db.read_failed', e.toString()));
    }
  }

  @override
  Future<Result<List<FieldSeasonEntity>>> getSeasons(int fieldId) async {
    try {
      final list = await isar.fieldSeasons.filter().field((q) => q.idEqualTo(fieldId)).sortByYear().findAll();
      return Result.ok(list.map((e) => e.toEntity()).toList());
    } catch (e) {
      return Result.err(AppError('db.read_failed', e.toString()));
    }
  }

  @override
  Future<Result<FieldSeasonEntity>> addSeason({required int fieldId, required int year, required String crop}) async {
    try {
      final field = await isar.fields.get(fieldId);
      if (field == null) return const Result.err(AppError('field.not_found', 'Pole nie istnieje.'));

      final dup = await isar.fieldSeasons
          .filter()
          .field((q) => q.idEqualTo(fieldId))
          .yearEqualTo(year)
          .isNotEmpty();
      if (dup) return const Result.err(AppError('season.duplicate', 'Sezon dla tego roku już istnieje.'));

      final s = FieldSeason()
        ..year = year
        ..crop = crop
        ..createdAt = DateTime.now()
        ..field.value = field;

      await isar.writeTxn(() async {
        await isar.fieldSeasons.put(s);
        await s.field.save();
      });
      return Result.ok(s.toEntity());
    } catch (e) {
      return Result.err(AppError('db.write_failed', e.toString()));
    }
  }

  @override
  Future<Result<FieldSeasonEntity?>> findSeason(int fieldId, int year) async {
    try {
      final s = await isar.fieldSeasons
          .filter()
          .field((q) => q.idEqualTo(fieldId))
          .yearEqualTo(year)
          .findFirst();
      return Result.ok(s?.toEntity());
    } catch (e) {
      return Result.err(AppError('db.read_failed', e.toString()));
    }
  }

  @override
  Future<Result<void>> update(FieldEntity field) async {
    try {
      await isar.writeTxn(() async {
        final f = await isar.fields.get(field.id);
        if (f == null) {
          throw Exception('field.not_found');
        }
        f
          ..name = field.name
          ..centerLat = field.centerLat
          ..centerLng = field.centerLng
          ..notes = field.notes
          ..updatedAt = DateTime.now();
        await isar.fields.put(f);
      });
      return const Result.ok(null);
    } catch (e) {
      return Result.err(AppError('db.update_failed', e.toString()));
    }
  }
}