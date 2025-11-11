
import 'package:flutter_test/flutter_test.dart';
import 'package:isar/isar.dart';

import 'test_harness.dart';


import 'package:agristack/data/repositories/isar_fields_repository.dart';
import 'package:agristack/domain/repositories/fields_repository.dart';
import 'package:agristack/domain/entities/entities.dart';

void main() {
  late Isar isar;
  late FieldsRepository fields;

  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    isar = await openTestIsar();
  });

  tearDown(() async {
    await wipe(isar);
  });

  tearDownAll(() async {
    await isar.close();
  });

  setUp(() {
    fields = IsarFieldsRepository(isar);
  });

  test('add: tworzy pole i zwraca OK', () async {
    final r = await fields.add(name: 'Pole A', lat: 50.1, lng: 19.9, notes: 'test');
    expect(r.isOk, true);
    expect(r.data!.name, 'Pole A');
  });

  test('add: unikalność nazwy pola', () async {
    final a = await fields.add(name: 'Pole A', lat: 0, lng: 0, notes: null);
    expect(a.isOk, true);
    final b = await fields.add(name: 'Pole A', lat: 1, lng: 1, notes: null);
    expect(b.isOk, false, reason: 'drugi insert o tej samej nazwie powinien paść');
  });

  test('addSeason + getSeasons: link do pola działa', () async {
    final f = await fields.add(name: 'XYZ', lat: 1, lng: 2, notes: null);
    final fieldId = f.data!.id;

    final s1 = await fields.addSeason(fieldId: fieldId, year: 2025, crop: 'wheat');
    final s2 = await fields.addSeason(fieldId: fieldId, year: 2026, crop: 'tomato');
    expect(s1.isOk && s2.isOk, true);

    final seasons = await fields.getSeasons(fieldId);
    expect(seasons.isOk, true);
    expect(seasons.data!.length, 2);
  });

  test('findSeason: znajduje po fieldId + year', () async {
  final f = await fields.add(name: 'Pole B', lat: 0, lng: 0, notes: null);
  await fields.addSeason(fieldId: f.data!.id, year: 2025, crop: 'wheat');

  // Test, czy ZNAJDUJE
  final found = await fields.findSeason(f.data!.id, 2025);
  expect(found.isOk, true);
  expect(found.data, isNotNull); // <--- Poprawnie
  expect(found.data!.year, 2025);

  // Test, czy NIE ZNAJDUJE
  final notFound = await fields.findSeason(f.data!.id, 2024);
  expect(notFound.isOk, true);   // <--- Operacja się udała
  expect(notFound.data, isNull); // <--- Ale nic nie zwróciła
});

  test('update(field): modyfikuje dane i updatedAt', () async {
    final f = await fields.add(name: 'Pole C', lat: 1, lng: 1, notes: null);
    final e = f.data!;
    final updatedEntity = FieldEntity(
      id: e.id,
      name: 'Pole C1',
      centerLat: e.centerLat,
      centerLng: e.centerLng,
      notes: 'zmiana',
      createdAt: e.createdAt,
      updatedAt: e.updatedAt,
    );

    final r = await fields.update(updatedEntity);
    expect(r.isOk, true);

    final all = await fields.getAll();
    final after = all.data!.firstWhere((x) => x.id == e.id);
    expect(after.name, 'Pole C1');
    expect(after.notes, 'zmiana');
    expect(after.updatedAt.isAfter(e.updatedAt), true);
  });

  test('delete(field): kaskadowo usuwa sezony i diagnozy', () async {
    final f = await fields.add(name: 'Pole D', lat: 0, lng: 0, notes: null);
    final s = await fields.addSeason(fieldId: f.data!.id, year: 2025, crop: 'wheat');
    expect(s.isOk, true);

    final del = await fields.delete(f.data!.id);
    expect(del.isOk, true);

    final seasons = await fields.getSeasons(f.data!.id);
    expect(seasons.isOk, true);
    expect(seasons.data, isEmpty);
  });
}
