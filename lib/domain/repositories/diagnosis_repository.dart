import '../entities/entities.dart';
import '../value/result.dart';

abstract class DiagnosisRepository {
  Future<Result<DiagnosisEntryEntity>> save(DiagnosisEntryEntity draft);
  Future<Result<void>> update(DiagnosisEntryEntity entry);
  Future<Result<List<DiagnosisEntryEntity>>> listBySeason(int seasonId);
  Future<Result<List<DiagnosisEntryEntity>>> listByField(int fieldId, {int? year});
  Future<Result<List<DiagnosisEntryEntity>>> listByDateRange(DateTime from, DateTime to);
  Future<Result<Map<String,int>>> statsByDisease(int fieldId, int year);
  Future<Result<List<DiagnosisEntryEntity>>> listOrphaned();
}