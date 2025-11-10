import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

import '../data/sources/isar/schemas.dart';
import '../data/repositories/isar_fields_repository.dart';
import '../data/repositories/isar_diagnosis_repository.dart';
import '../domain/repositories/fields_repository.dart';
import '../domain/repositories/diagnosis_repository.dart';

final isarProvider = FutureProvider<Isar>((ref) async {
  final dir = await getApplicationDocumentsDirectory();
  final isar = await Isar.open(
    [FieldSchema, FieldSeasonSchema, DiagnosisEntrySchema, DiseaseAliasIndexSchema, AppMetaSchema],
    name: 'agristack_db',
    directory: dir.path,
    inspector: false,
  );
  ref.onDispose(() => isar.close());
  return isar;
});

final fieldsRepoProvider = FutureProvider<FieldsRepository>((ref) async {
  final isar = await ref.watch(isarProvider.future);
  return IsarFieldsRepository(isar);
});

final diagnosisRepoProvider = FutureProvider<DiagnosisRepository>((ref) async {
  final isar = await ref.watch(isarProvider.future);
  return IsarDiagnosisRepository(isar);
});