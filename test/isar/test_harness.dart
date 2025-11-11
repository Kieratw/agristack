import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:isar/isar.dart';
import 'package:agristack/data/sources/isar/schemas.dart';

Future<Isar> openTestIsar() async {

  TestWidgetsFlutterBinding.ensureInitialized();


  HttpOverrides.global = null; 


  await Isar.initializeIsarCore(download: true);

  final tmp = await Directory.systemTemp.createTemp('isar_test_');
  
  return Isar.open(
    [
      FieldSchema,
      FieldSeasonSchema,
      DiagnosisEntrySchema,
      DiseaseAliasIndexSchema,
      AppMetaSchema,
    ],
    directory: tmp.path,
    inspector: false,
  );
}

Future<void> wipe(Isar isar) async {
 
  await isar.writeTxn(() async {
    await isar.clear();
  });
}