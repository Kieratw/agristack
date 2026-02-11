import 'dart:convert';
import 'package:isar/isar.dart';
import '../sources/isar/schemas.dart';

import 'package:agristack/domain/repositories/dictionary_repository.dart';
import 'package:agristack/domain/services/static_data_source.dart';

class JsonDictionaryRepository implements DictionaryRepository {
  final StaticDataSource _src;
  JsonDictionaryRepository(this._src);

  // "crop|alias_lower" -> canonicalId
  final Map<String, String> _alias = {};
  // canonicalId -> PL
  final Map<String, String> _displayPl = {};
  // crop -> ModelConfig
  final Map<String, ModelConfig> _models = {};
  bool _ready = false;

  @override
  Future<void> initialize() async {
    final diseasesTxt = await _src.loadDiseasesJson();
    final modelsTxt = await _src.loadModelsJson();

    // diseases.json: canonicalId -> { pl, aliases[], crops[] }
    final dMap = json.decode(diseasesTxt) as Map<String, dynamic>;
    _alias.clear();
    _displayPl.clear();
    dMap.forEach((canonicalId, v) {
      final m = v as Map<String, dynamic>;
      final pl = (m['pl'] ?? canonicalId) as String;
      final aliases = ((m['aliases'] ?? []) as List).cast<String>();
      final crops = ((m['crops'] ?? []) as List).cast<String>();
      _displayPl[canonicalId] = pl;

      for (final crop in crops) {
        // aliasy
        for (final a in aliases) {
          _alias['$crop|${a.toLowerCase()}'] = canonicalId;
        }
        // także mapowanie samego canonicalId jako aliasu
        _alias['$crop|${canonicalId.toLowerCase()}'] = canonicalId;
      }
    });

    // models.json: crop -> { assetPath, modelId, inputSize, classNames[] }
    final mMap = json.decode(modelsTxt) as Map<String, dynamic>;
    _models.clear();
    mMap.forEach((crop, v) {
      final m = v as Map<String, dynamic>;
      _models[crop] = ModelConfig(
        modelId: m['modelId'] as String,
        assetPath: m['assetPath'] as String,
        inputSize: (m['inputSize'] as num).toInt(),
        classNames: ((m['classNames'] ?? []) as List).cast<String>(),
      );
    });

    _ready = true;
  }

  void _check() {
    if (!_ready) throw StateError('DictionaryRepository not initialized');
  }

  @override
  String? mapRawLabelToId(String raw, {required String crop}) {
    _check();
    return _alias['$crop|${raw.toLowerCase()}'];
  }

  @override
  String? getDiseaseDisplay(String canonicalId) {
    _check();
    return _displayPl[canonicalId];
  }

  @override
  ModelConfig? getModelConfig(String crop) {
    _check();
    return _models[crop] ?? _models['default'];
  }

  /// Inicjalizacja z wykorzystaniem bazy Isar jako cache/weryfikatora.
  Future<void> initializeWithIsar(Isar isar) async {
    final diseasesTxt = await _src.loadDiseasesJson();
    final modelsTxt = await _src.loadModelsJson();
    final currentHash = diseasesTxt.hashCode.toString();

    // 1. Sprawdź metadane
    final meta = await isar.appMetas.get(1); // Singleton ID=1
    final isCacheValid = meta != null && meta.diseasesJsonHash == currentHash;

    if (isCacheValid) {
      // 2a. Cache ważny -> Ładujemy indeksy z bazy (Szybciej)
      final aliases = await isar.diseaseAliasIndexs.where().findAll();
      _alias.clear();
      for (final a in aliases) {
        _alias[a.alias] = a.canonicalDiseaseId;
      }
    } else {
      // 2b. Cache nieważny lub brak -> Parsujemy JSON i zapisujemy do bazy (Wolniej)
      final dMap = json.decode(diseasesTxt) as Map<String, dynamic>;
      _alias.clear();

      final newIndexes = <DiseaseAliasIndex>[];

      // Używamy Set aby uniknąć duplikatów (Unique Index constraint)
      final addedKeys = <String>{};

      dMap.forEach((canonicalId, v) {
        final m = v as Map<String, dynamic>;
        final aliases = ((m['aliases'] ?? []) as List).cast<String>();
        final crops = ((m['crops'] ?? []) as List).cast<String>();

        for (final crop in crops) {
          // aliasy
          for (final a in aliases) {
            final key = '$crop|${a.toLowerCase()}';
            _alias[key] = canonicalId;

            if (!addedKeys.contains(key)) {
              addedKeys.add(key);
              newIndexes.add(
                DiseaseAliasIndex()
                  ..alias = key
                  ..canonicalDiseaseId = canonicalId,
              );
            }
          }
          // canonicalId jako alias
          final keySelf = '$crop|${canonicalId.toLowerCase()}';
          _alias[keySelf] = canonicalId;

          if (!addedKeys.contains(keySelf)) {
            addedKeys.add(keySelf);
            newIndexes.add(
              DiseaseAliasIndex()
                ..alias = keySelf
                ..canonicalDiseaseId = canonicalId,
            );
          }
        }
      });

      // Zapis do bazy (transakcja)
      await isar.writeTxn(() async {
        await isar.diseaseAliasIndexs.clear();
        await isar.diseaseAliasIndexs.putAll(newIndexes);
        final newMeta = AppMeta()
          ..id = 1
          ..schemaVersion = 1
          ..diseasesJsonHash = currentHash
          ..updatedAt = DateTime.now();
        await isar.appMetas.put(newMeta);
      });
    }

    // 3. Ładowanie pozostałych danych (displayPl, models)
    final dMap = json.decode(diseasesTxt) as Map<String, dynamic>;
    _displayPl.clear();
    dMap.forEach((canonicalId, v) {
      final m = v as Map<String, dynamic>;
      _displayPl[canonicalId] = (m['pl'] ?? canonicalId) as String;
    });

    final mMap = json.decode(modelsTxt) as Map<String, dynamic>;
    _models.clear();
    mMap.forEach((crop, v) {
      final m = v as Map<String, dynamic>;
      _models[crop] = ModelConfig(
        modelId: m['modelId'] as String,
        assetPath: m['assetPath'] as String,
        inputSize: (m['inputSize'] as num).toInt(),
        classNames: ((m['classNames'] ?? []) as List).cast<String>(),
      );
    });

    _ready = true;
  }
}
