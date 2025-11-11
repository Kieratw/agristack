
import 'package:flutter_test/flutter_test.dart';
import 'package:isar/isar.dart';

import 'test_harness.dart';

import 'package:agristack/data/repositories/isar_fields_repository.dart';
import 'package:agristack/data/repositories/isar_diagnosis_repository.dart';
import 'package:agristack/domain/repositories/fields_repository.dart';
import 'package:agristack/domain/repositories/diagnosis_repository.dart';
import 'package:agristack/domain/entities/entities.dart';

void main() {
  late Isar isar;
  late FieldsRepository fields;
  late DiagnosisRepository diagnosis;

 
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    isar = await openTestIsar();
  });

 
  tearDownAll(() async {
    await isar.close();
  });

  
  setUp(() {
    
    fields = IsarFieldsRepository(isar);
    diagnosis = IsarDiagnosisRepository(isar);
  });


  tearDown(() async {
   
    await wipe(isar);
  });

 

  Future<(FieldEntity, FieldSeasonEntity)> _seedFieldSeason({
    String name = 'Pole X',
    int year = 2025,
    String crop = 'wheat',
  }) async {
    // Ten helper zakłada, że POLE jeszcze nie istnieje
    final f = await fields.add(name: name, lat: 50, lng: 20, notes: null);
    if (!f.isOk) {
      throw Exception('Błąd seedFieldSeason (Field): ${f.error?.message}');
    }
    final s = await fields.addSeason(fieldId: f.data!.id, year: year, crop: crop);
    if (!s.isOk) {
      throw Exception('Błąd seedFieldSeason (Season): ${s.error?.message}');
    }
    return (f.data!, s.data!);
  }

  DiagnosisEntryEntity _draft({
    required int? seasonId,
    String raw = 'leaf_rust',
    String canon = 'wheat_leaf_rust',
    String labelPl = 'Rdza liści',
    double conf = 0.9,
    DateTime? ts,
  }) {
    return DiagnosisEntryEntity(
      id: 0,
      timestamp: ts ?? DateTime.now(),
      imagePath: '/tmp/img.jpg',
      fieldSeasonId: seasonId,
      lat: 50.0001,
      lng: 20.0001,
      modelId: 'mobilenetv3_wheat_v1',
      rawLabel: raw,
      canonicalDiseaseId: canon,
      displayLabelPl: labelPl,
      confidence: conf,
      recommendationKey: 'wheat_leaf_rust_v1',
      notes: null,
      createdAt: DateTime.now(),
    );
  }

  // --- TESTY ---

  test('save: tworzy diagnozę przypiętą do sezonu', () async {
    final (_, season) = await _seedFieldSeason();
    final r = await diagnosis.save(_draft(seasonId: season.id));
    expect(r.isOk, true);
    expect(r.data!.fieldSeasonId, season.id);
  });

  test('listBySeason: zwraca diagnozy tylko z danego sezonu', () async {
    final (f1, s1) = await _seedFieldSeason(name: 'A', year: 2025);
    final (f2, s2) = await _seedFieldSeason(name: 'B', year: 2025);

    await diagnosis.save(_draft(seasonId: s1.id));
    await diagnosis.save(_draft(seasonId: s1.id));
    await diagnosis.save(_draft(seasonId: s2.id));

    final r1 = await diagnosis.listBySeason(s1.id);
    final r2 = await diagnosis.listBySeason(s2.id);

    expect(r1.isOk && r2.isOk, true);
    expect(r1.data!.length, 2);
    expect(r2.data!.length, 1);
  });

  // --- POPRAWIONY TEST ---
  test('listByField(fieldId, year): filtr po polu i roku', () async {
    // 1. Stwórz pole i pierwszy sezon za pomocą helpera
    final (f, s2025) = await _seedFieldSeason(name: 'C', year: 2025);

    // 2. Ręcznie dodaj drugi sezon do TEGO SAMEGO pola
    final s2026_res = await fields.addSeason(fieldId: f.id, year: 2026, crop: 'potato');
    expect(s2026_res.isOk, true, reason: 'Dodanie drugiego sezonu powinno się udać');
    final s2026 = s2026_res.data!;

    // 3. Dodaj diagnozy do obu sezonów
    await diagnosis.save(_draft(seasonId: s2025.id));
    await diagnosis.save(_draft(seasonId: s2026.id));

    // 4. Testuj logikę listByField
    final r2025 = await diagnosis.listByField(f.id, year: 2025);
    final rAll = await diagnosis.listByField(f.id); // Test bez podania roku

    expect(r2025.isOk, true);
    expect(r2025.data!.length, 1, reason: 'Powinien znaleźć 1 diagnozę dla roku 2025');
    expect(rAll.isOk, true);
    expect(rAll.data!.length, 2, reason: 'Powinien znaleźć 2 diagnozy dla całego pola');
  });

  test('listByDateRange: zwraca tylko w zakresie', () async {
    final (_, s) = await _seedFieldSeason();
    final t1 = DateTime(2025, 1, 1);
    final t2 = DateTime(2025, 1, 10);
    final t3 = DateTime(2025, 1, 20);

    await diagnosis.save(_draft(seasonId: s.id, ts: t1));
    await diagnosis.save(_draft(seasonId: s.id, ts: t2));
    await diagnosis.save(_draft(seasonId: s.id, ts: t3));

    final r = await diagnosis.listByDateRange(DateTime(2025, 1, 5), DateTime(2025, 1, 15));
    expect(r.isOk, true);
    expect(r.data!.length, 1);
    expect(r.data!.first.timestamp, t2);
  });

  test('statsByDisease: poprawnie agreguje', () async {
    final (f, s) = await _seedFieldSeason(crop: 'wheat');

    await diagnosis.save(_draft(seasonId: s.id, canon: 'wheat_leaf_rust'));
    await diagnosis.save(_draft(seasonId: s.id, canon: 'wheat_leaf_rust'));
    await diagnosis.save(_draft(seasonId: s.id, canon: 'wheat_blight'));

    final r = await diagnosis.statsByDisease(f.id, 2025);
    expect(r.isOk, true);
    final counts = r.data!;
    expect(counts['wheat_leaf_rust'], 2);
    expect(counts['wheat_blight'], 1);
  });

  test('listOrphaned: pusto gdy zapis poprawny', () async {
    final (_, s) = await _seedFieldSeason();
    await diagnosis.save(_draft(seasonId: s.id));
    final r = await diagnosis.listOrphaned();
    expect(r.isOk, true);
    expect(r.data, isEmpty);
  });

  // --- POPRAWIONY TEST ---
  test('update: zmienia pola i sezon', () async {
    // 1. Stwórz pole i pierwszy sezon
    final (f, s1) = await _seedFieldSeason(name: 'U', year: 2025);

    // 2. Ręcznie dodaj drugi sezon do TEGO SAMEGO pola
    final s2_res = await fields.addSeason(fieldId: f.id, year: 2026, crop: 'potato');
    expect(s2_res.isOk, true);
    final s2 = s2_res.data!;

    // 3. Stwórz diagnozę w sezonie 1
    final created = await diagnosis.save(_draft(seasonId: s1.id, conf: 0.7));
    final e0 = created.data!;

    // 4. Stwórz zaktualizowaną encję, która przenosi diagnozę do sezonu 2
    final e1 = DiagnosisEntryEntity(
      id: e0.id,
      timestamp: e0.timestamp,
      imagePath: e0.imagePath,
      fieldSeasonId: s2.id, // <-- Kluczowa zmiana
      lat: e0.lat,
      lng: e0.lng,
      modelId: e0.modelId,
      rawLabel: e0.rawLabel,
      canonicalDiseaseId: e0.canonicalDiseaseId,
      displayLabelPl: e0.displayLabelPl,
      confidence: 0.95, // <-- Inna zmiana
      recommendationKey: e0.recommendationKey,
      notes: 'poprawka', // <-- Inna zmiana
      createdAt: e0.createdAt,
    );

    // 5. Wykonaj aktualizację
    final upd = await diagnosis.update(e1);
    expect(upd.isOk, true);

    // 6. Sprawdź, czy diagnoza jest w NOWYM sezonie (s2)
    final back = await diagnosis.listBySeason(s2.id);
    expect(back.isOk, true);
    expect(back.data!.length, 1);
    expect(back.data!.first.confidence, 0.95);
    expect(back.data!.first.notes, 'poprawka');

    // 7. Sprawdź, czy diagnoza zniknęła ze STAREGO sezonu (s1)
    final old = await diagnosis.listBySeason(s1.id);
    expect(old.isOk, true);
    expect(old.data, isEmpty);
  });

  // --- NOWY TEST ---
  test('listOrphaned: znajduje diagnozy bez sezonu', () async {
    // 1. Stwórz diagnozę bez przypisanego sezonu
    await diagnosis.save(_draft(seasonId: null, canon: 'orphan_1'));
    await diagnosis.save(_draft(seasonId: null, canon: 'orphan_2'));

    // 2. Stwórz normalną diagnozę
    final (_, s) = await _seedFieldSeason();
    await diagnosis.save(_draft(seasonId: s.id));

    // 3. Sprawdź
    final r = await diagnosis.listOrphaned();
    expect(r.isOk, true);
    expect(r.data!.length, 2);
    expect(r.data!.any((d) => d.canonicalDiseaseId == 'orphan_1'), true);
  });

  // --- NOWY TEST ---
  test('update: potrafi "uosierocić" diagnozę (ustawić sezon na null)', () async {
    // 1. Stwórz normalną diagnozę
    final (_, s) = await _seedFieldSeason();
    final created = await diagnosis.save(_draft(seasonId: s.id));
    final e0 = created.data!;

    // 2. Stwórz encję update, która usuwa link do sezonu
    final e1 = DiagnosisEntryEntity(
      id: e0.id,
      timestamp: e0.timestamp,
      imagePath: e0.imagePath,
      fieldSeasonId: null, // <-- Kluczowa zmiana
      lat: e0.lat,
      lng: e0.lng,
      modelId: e0.modelId,
      rawLabel: e0.rawLabel,
      canonicalDiseaseId: e0.canonicalDiseaseId,
      displayLabelPl: e0.displayLabelPl,
      confidence: e0.confidence,
      recommendationKey: e0.recommendationKey,
      notes: 'usunięto sezon',
      createdAt: e0.createdAt,
    );

    // 3. Wykonaj update
    final upd = await diagnosis.update(e1);
    expect(upd.isOk, true);

    // 4. Sprawdź, czy diagnoza jest na liście sierot
    final orphans = await diagnosis.listOrphaned();
    expect(orphans.isOk, true);
    expect(orphans.data!.length, 1);
    expect(orphans.data!.first.notes, 'usunięto sezon');

    // 5. Sprawdź, czy zniknęła z pierwotnego sezonu
    final old = await diagnosis.listBySeason(s.id);
    expect(old.isOk, true);
    expect(old.data, isEmpty);
  });

  // --- NOWY TEST ---
  test('statsByDisease: zwraca pustą mapę dla pustego sezonu', () async {
    // 1. Stwórz pole i sezon, ale bez diagnoz
    final (f, s) = await _seedFieldSeason();

    // 2. Sprawdź statystyki
    final r = await diagnosis.statsByDisease(f.id, s.year);
    expect(r.isOk, true);
    expect(r.data, isEmpty);
  });
}