import '../entities/entities.dart';
import '../value/result.dart';

abstract class FieldsRepository {
  Future<Result<List<FieldEntity>>> getAll();
  Future<Result<FieldEntity>> add({
    required String name,
    double? lat,
    double? lng,
    String? notes,
  });
  Future<Result<void>> update(FieldEntity field);
  Future<Result<void>> delete(int fieldId);
  Future<Result<List<FieldSeasonEntity>>> getSeasons(int fieldId);
  Future<Result<FieldSeasonEntity>> addSeason({
    required int fieldId,
    required int year,
    required String crop,
  });
  Future<Result<FieldSeasonEntity?>> findSeason(int fieldId, int year);
  Future<Result<FieldEntity?>> get(int fieldId);
  Future<Result<FieldSeasonEntity?>> getSeason(int seasonId);
  Stream<List<FieldEntity>> watchAll();
}
