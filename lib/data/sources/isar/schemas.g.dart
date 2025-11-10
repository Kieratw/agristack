// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'schemas.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetFieldCollection on Isar {
  IsarCollection<Field> get fields => this.collection();
}

const FieldSchema = CollectionSchema(
  name: r'Field',
  id: 256898425088394984,
  properties: {
    r'centerLat': PropertySchema(
      id: 0,
      name: r'centerLat',
      type: IsarType.double,
    ),
    r'centerLng': PropertySchema(
      id: 1,
      name: r'centerLng',
      type: IsarType.double,
    ),
    r'createdAt': PropertySchema(
      id: 2,
      name: r'createdAt',
      type: IsarType.dateTime,
    ),
    r'name': PropertySchema(
      id: 3,
      name: r'name',
      type: IsarType.string,
    ),
    r'notes': PropertySchema(
      id: 4,
      name: r'notes',
      type: IsarType.string,
    ),
    r'updatedAt': PropertySchema(
      id: 5,
      name: r'updatedAt',
      type: IsarType.dateTime,
    )
  },
  estimateSize: _fieldEstimateSize,
  serialize: _fieldSerialize,
  deserialize: _fieldDeserialize,
  deserializeProp: _fieldDeserializeProp,
  idName: r'id',
  indexes: {
    r'name': IndexSchema(
      id: 879695947855722453,
      name: r'name',
      unique: true,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'name',
          type: IndexType.hash,
          caseSensitive: false,
        )
      ],
    ),
    r'centerLat': IndexSchema(
      id: -308462701150055961,
      name: r'centerLat',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'centerLat',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    ),
    r'centerLng': IndexSchema(
      id: -7792736158321708187,
      name: r'centerLng',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'centerLng',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    )
  },
  links: {
    r'seasons': LinkSchema(
      id: -7884381456038685163,
      name: r'seasons',
      target: r'FieldSeason',
      single: false,
      linkName: r'field',
    )
  },
  embeddedSchemas: {},
  getId: _fieldGetId,
  getLinks: _fieldGetLinks,
  attach: _fieldAttach,
  version: '3.1.0+1',
);

int _fieldEstimateSize(
  Field object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.name.length * 3;
  {
    final value = object.notes;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _fieldSerialize(
  Field object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDouble(offsets[0], object.centerLat);
  writer.writeDouble(offsets[1], object.centerLng);
  writer.writeDateTime(offsets[2], object.createdAt);
  writer.writeString(offsets[3], object.name);
  writer.writeString(offsets[4], object.notes);
  writer.writeDateTime(offsets[5], object.updatedAt);
}

Field _fieldDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = Field();
  object.centerLat = reader.readDoubleOrNull(offsets[0]);
  object.centerLng = reader.readDoubleOrNull(offsets[1]);
  object.createdAt = reader.readDateTime(offsets[2]);
  object.id = id;
  object.name = reader.readString(offsets[3]);
  object.notes = reader.readStringOrNull(offsets[4]);
  object.updatedAt = reader.readDateTime(offsets[5]);
  return object;
}

P _fieldDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDoubleOrNull(offset)) as P;
    case 1:
      return (reader.readDoubleOrNull(offset)) as P;
    case 2:
      return (reader.readDateTime(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readStringOrNull(offset)) as P;
    case 5:
      return (reader.readDateTime(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _fieldGetId(Field object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _fieldGetLinks(Field object) {
  return [object.seasons];
}

void _fieldAttach(IsarCollection<dynamic> col, Id id, Field object) {
  object.id = id;
  object.seasons
      .attach(col, col.isar.collection<FieldSeason>(), r'seasons', id);
}

extension FieldByIndex on IsarCollection<Field> {
  Future<Field?> getByName(String name) {
    return getByIndex(r'name', [name]);
  }

  Field? getByNameSync(String name) {
    return getByIndexSync(r'name', [name]);
  }

  Future<bool> deleteByName(String name) {
    return deleteByIndex(r'name', [name]);
  }

  bool deleteByNameSync(String name) {
    return deleteByIndexSync(r'name', [name]);
  }

  Future<List<Field?>> getAllByName(List<String> nameValues) {
    final values = nameValues.map((e) => [e]).toList();
    return getAllByIndex(r'name', values);
  }

  List<Field?> getAllByNameSync(List<String> nameValues) {
    final values = nameValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'name', values);
  }

  Future<int> deleteAllByName(List<String> nameValues) {
    final values = nameValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'name', values);
  }

  int deleteAllByNameSync(List<String> nameValues) {
    final values = nameValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'name', values);
  }

  Future<Id> putByName(Field object) {
    return putByIndex(r'name', object);
  }

  Id putByNameSync(Field object, {bool saveLinks = true}) {
    return putByIndexSync(r'name', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByName(List<Field> objects) {
    return putAllByIndex(r'name', objects);
  }

  List<Id> putAllByNameSync(List<Field> objects, {bool saveLinks = true}) {
    return putAllByIndexSync(r'name', objects, saveLinks: saveLinks);
  }
}

extension FieldQueryWhereSort on QueryBuilder<Field, Field, QWhere> {
  QueryBuilder<Field, Field, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<Field, Field, QAfterWhere> anyCenterLat() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'centerLat'),
      );
    });
  }

  QueryBuilder<Field, Field, QAfterWhere> anyCenterLng() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'centerLng'),
      );
    });
  }
}

extension FieldQueryWhere on QueryBuilder<Field, Field, QWhereClause> {
  QueryBuilder<Field, Field, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<Field, Field, QAfterWhereClause> idNotEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<Field, Field, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<Field, Field, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<Field, Field, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Field, Field, QAfterWhereClause> nameEqualTo(String name) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'name',
        value: [name],
      ));
    });
  }

  QueryBuilder<Field, Field, QAfterWhereClause> nameNotEqualTo(String name) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'name',
              lower: [],
              upper: [name],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'name',
              lower: [name],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'name',
              lower: [name],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'name',
              lower: [],
              upper: [name],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<Field, Field, QAfterWhereClause> centerLatIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'centerLat',
        value: [null],
      ));
    });
  }

  QueryBuilder<Field, Field, QAfterWhereClause> centerLatIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'centerLat',
        lower: [null],
        includeLower: false,
        upper: [],
      ));
    });
  }

  QueryBuilder<Field, Field, QAfterWhereClause> centerLatEqualTo(
      double? centerLat) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'centerLat',
        value: [centerLat],
      ));
    });
  }

  QueryBuilder<Field, Field, QAfterWhereClause> centerLatNotEqualTo(
      double? centerLat) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'centerLat',
              lower: [],
              upper: [centerLat],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'centerLat',
              lower: [centerLat],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'centerLat',
              lower: [centerLat],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'centerLat',
              lower: [],
              upper: [centerLat],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<Field, Field, QAfterWhereClause> centerLatGreaterThan(
    double? centerLat, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'centerLat',
        lower: [centerLat],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<Field, Field, QAfterWhereClause> centerLatLessThan(
    double? centerLat, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'centerLat',
        lower: [],
        upper: [centerLat],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<Field, Field, QAfterWhereClause> centerLatBetween(
    double? lowerCenterLat,
    double? upperCenterLat, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'centerLat',
        lower: [lowerCenterLat],
        includeLower: includeLower,
        upper: [upperCenterLat],
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Field, Field, QAfterWhereClause> centerLngIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'centerLng',
        value: [null],
      ));
    });
  }

  QueryBuilder<Field, Field, QAfterWhereClause> centerLngIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'centerLng',
        lower: [null],
        includeLower: false,
        upper: [],
      ));
    });
  }

  QueryBuilder<Field, Field, QAfterWhereClause> centerLngEqualTo(
      double? centerLng) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'centerLng',
        value: [centerLng],
      ));
    });
  }

  QueryBuilder<Field, Field, QAfterWhereClause> centerLngNotEqualTo(
      double? centerLng) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'centerLng',
              lower: [],
              upper: [centerLng],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'centerLng',
              lower: [centerLng],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'centerLng',
              lower: [centerLng],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'centerLng',
              lower: [],
              upper: [centerLng],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<Field, Field, QAfterWhereClause> centerLngGreaterThan(
    double? centerLng, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'centerLng',
        lower: [centerLng],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<Field, Field, QAfterWhereClause> centerLngLessThan(
    double? centerLng, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'centerLng',
        lower: [],
        upper: [centerLng],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<Field, Field, QAfterWhereClause> centerLngBetween(
    double? lowerCenterLng,
    double? upperCenterLng, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'centerLng',
        lower: [lowerCenterLng],
        includeLower: includeLower,
        upper: [upperCenterLng],
        includeUpper: includeUpper,
      ));
    });
  }
}

extension FieldQueryFilter on QueryBuilder<Field, Field, QFilterCondition> {
  QueryBuilder<Field, Field, QAfterFilterCondition> centerLatIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'centerLat',
      ));
    });
  }

  QueryBuilder<Field, Field, QAfterFilterCondition> centerLatIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'centerLat',
      ));
    });
  }

  QueryBuilder<Field, Field, QAfterFilterCondition> centerLatEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'centerLat',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Field, Field, QAfterFilterCondition> centerLatGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'centerLat',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Field, Field, QAfterFilterCondition> centerLatLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'centerLat',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Field, Field, QAfterFilterCondition> centerLatBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'centerLat',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Field, Field, QAfterFilterCondition> centerLngIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'centerLng',
      ));
    });
  }

  QueryBuilder<Field, Field, QAfterFilterCondition> centerLngIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'centerLng',
      ));
    });
  }

  QueryBuilder<Field, Field, QAfterFilterCondition> centerLngEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'centerLng',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Field, Field, QAfterFilterCondition> centerLngGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'centerLng',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Field, Field, QAfterFilterCondition> centerLngLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'centerLng',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Field, Field, QAfterFilterCondition> centerLngBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'centerLng',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Field, Field, QAfterFilterCondition> createdAtEqualTo(
      DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<Field, Field, QAfterFilterCondition> createdAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<Field, Field, QAfterFilterCondition> createdAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<Field, Field, QAfterFilterCondition> createdAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'createdAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Field, Field, QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Field, Field, QAfterFilterCondition> idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Field, Field, QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Field, Field, QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Field, Field, QAfterFilterCondition> nameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Field, Field, QAfterFilterCondition> nameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Field, Field, QAfterFilterCondition> nameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Field, Field, QAfterFilterCondition> nameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'name',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Field, Field, QAfterFilterCondition> nameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Field, Field, QAfterFilterCondition> nameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Field, Field, QAfterFilterCondition> nameContains(String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Field, Field, QAfterFilterCondition> nameMatches(String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'name',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Field, Field, QAfterFilterCondition> nameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<Field, Field, QAfterFilterCondition> nameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<Field, Field, QAfterFilterCondition> notesIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'notes',
      ));
    });
  }

  QueryBuilder<Field, Field, QAfterFilterCondition> notesIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'notes',
      ));
    });
  }

  QueryBuilder<Field, Field, QAfterFilterCondition> notesEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'notes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Field, Field, QAfterFilterCondition> notesGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'notes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Field, Field, QAfterFilterCondition> notesLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'notes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Field, Field, QAfterFilterCondition> notesBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'notes',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Field, Field, QAfterFilterCondition> notesStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'notes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Field, Field, QAfterFilterCondition> notesEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'notes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Field, Field, QAfterFilterCondition> notesContains(String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'notes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Field, Field, QAfterFilterCondition> notesMatches(String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'notes',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Field, Field, QAfterFilterCondition> notesIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'notes',
        value: '',
      ));
    });
  }

  QueryBuilder<Field, Field, QAfterFilterCondition> notesIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'notes',
        value: '',
      ));
    });
  }

  QueryBuilder<Field, Field, QAfterFilterCondition> updatedAtEqualTo(
      DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<Field, Field, QAfterFilterCondition> updatedAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<Field, Field, QAfterFilterCondition> updatedAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<Field, Field, QAfterFilterCondition> updatedAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'updatedAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension FieldQueryObject on QueryBuilder<Field, Field, QFilterCondition> {}

extension FieldQueryLinks on QueryBuilder<Field, Field, QFilterCondition> {
  QueryBuilder<Field, Field, QAfterFilterCondition> seasons(
      FilterQuery<FieldSeason> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'seasons');
    });
  }

  QueryBuilder<Field, Field, QAfterFilterCondition> seasonsLengthEqualTo(
      int length) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'seasons', length, true, length, true);
    });
  }

  QueryBuilder<Field, Field, QAfterFilterCondition> seasonsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'seasons', 0, true, 0, true);
    });
  }

  QueryBuilder<Field, Field, QAfterFilterCondition> seasonsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'seasons', 0, false, 999999, true);
    });
  }

  QueryBuilder<Field, Field, QAfterFilterCondition> seasonsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'seasons', 0, true, length, include);
    });
  }

  QueryBuilder<Field, Field, QAfterFilterCondition> seasonsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'seasons', length, include, 999999, true);
    });
  }

  QueryBuilder<Field, Field, QAfterFilterCondition> seasonsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(
          r'seasons', lower, includeLower, upper, includeUpper);
    });
  }
}

extension FieldQuerySortBy on QueryBuilder<Field, Field, QSortBy> {
  QueryBuilder<Field, Field, QAfterSortBy> sortByCenterLat() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'centerLat', Sort.asc);
    });
  }

  QueryBuilder<Field, Field, QAfterSortBy> sortByCenterLatDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'centerLat', Sort.desc);
    });
  }

  QueryBuilder<Field, Field, QAfterSortBy> sortByCenterLng() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'centerLng', Sort.asc);
    });
  }

  QueryBuilder<Field, Field, QAfterSortBy> sortByCenterLngDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'centerLng', Sort.desc);
    });
  }

  QueryBuilder<Field, Field, QAfterSortBy> sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<Field, Field, QAfterSortBy> sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<Field, Field, QAfterSortBy> sortByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<Field, Field, QAfterSortBy> sortByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<Field, Field, QAfterSortBy> sortByNotes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notes', Sort.asc);
    });
  }

  QueryBuilder<Field, Field, QAfterSortBy> sortByNotesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notes', Sort.desc);
    });
  }

  QueryBuilder<Field, Field, QAfterSortBy> sortByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<Field, Field, QAfterSortBy> sortByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension FieldQuerySortThenBy on QueryBuilder<Field, Field, QSortThenBy> {
  QueryBuilder<Field, Field, QAfterSortBy> thenByCenterLat() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'centerLat', Sort.asc);
    });
  }

  QueryBuilder<Field, Field, QAfterSortBy> thenByCenterLatDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'centerLat', Sort.desc);
    });
  }

  QueryBuilder<Field, Field, QAfterSortBy> thenByCenterLng() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'centerLng', Sort.asc);
    });
  }

  QueryBuilder<Field, Field, QAfterSortBy> thenByCenterLngDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'centerLng', Sort.desc);
    });
  }

  QueryBuilder<Field, Field, QAfterSortBy> thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<Field, Field, QAfterSortBy> thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<Field, Field, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<Field, Field, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<Field, Field, QAfterSortBy> thenByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<Field, Field, QAfterSortBy> thenByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<Field, Field, QAfterSortBy> thenByNotes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notes', Sort.asc);
    });
  }

  QueryBuilder<Field, Field, QAfterSortBy> thenByNotesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notes', Sort.desc);
    });
  }

  QueryBuilder<Field, Field, QAfterSortBy> thenByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<Field, Field, QAfterSortBy> thenByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension FieldQueryWhereDistinct on QueryBuilder<Field, Field, QDistinct> {
  QueryBuilder<Field, Field, QDistinct> distinctByCenterLat() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'centerLat');
    });
  }

  QueryBuilder<Field, Field, QDistinct> distinctByCenterLng() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'centerLng');
    });
  }

  QueryBuilder<Field, Field, QDistinct> distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<Field, Field, QDistinct> distinctByName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'name', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Field, Field, QDistinct> distinctByNotes(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'notes', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Field, Field, QDistinct> distinctByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'updatedAt');
    });
  }
}

extension FieldQueryProperty on QueryBuilder<Field, Field, QQueryProperty> {
  QueryBuilder<Field, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<Field, double?, QQueryOperations> centerLatProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'centerLat');
    });
  }

  QueryBuilder<Field, double?, QQueryOperations> centerLngProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'centerLng');
    });
  }

  QueryBuilder<Field, DateTime, QQueryOperations> createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<Field, String, QQueryOperations> nameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'name');
    });
  }

  QueryBuilder<Field, String?, QQueryOperations> notesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'notes');
    });
  }

  QueryBuilder<Field, DateTime, QQueryOperations> updatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'updatedAt');
    });
  }
}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetFieldSeasonCollection on Isar {
  IsarCollection<FieldSeason> get fieldSeasons => this.collection();
}

const FieldSeasonSchema = CollectionSchema(
  name: r'FieldSeason',
  id: 6127493895009234534,
  properties: {
    r'createdAt': PropertySchema(
      id: 0,
      name: r'createdAt',
      type: IsarType.dateTime,
    ),
    r'crop': PropertySchema(
      id: 1,
      name: r'crop',
      type: IsarType.string,
    ),
    r'year': PropertySchema(
      id: 2,
      name: r'year',
      type: IsarType.long,
    )
  },
  estimateSize: _fieldSeasonEstimateSize,
  serialize: _fieldSeasonSerialize,
  deserialize: _fieldSeasonDeserialize,
  deserializeProp: _fieldSeasonDeserializeProp,
  idName: r'id',
  indexes: {
    r'year': IndexSchema(
      id: -875522826430421864,
      name: r'year',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'year',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    ),
    r'crop': IndexSchema(
      id: -6806321652993641230,
      name: r'crop',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'crop',
          type: IndexType.hash,
          caseSensitive: false,
        )
      ],
    )
  },
  links: {
    r'field': LinkSchema(
      id: -3200472094581527880,
      name: r'field',
      target: r'Field',
      single: true,
    ),
    r'diagnoses': LinkSchema(
      id: -4426145528185441212,
      name: r'diagnoses',
      target: r'DiagnosisEntry',
      single: false,
      linkName: r'fieldSeason',
    )
  },
  embeddedSchemas: {},
  getId: _fieldSeasonGetId,
  getLinks: _fieldSeasonGetLinks,
  attach: _fieldSeasonAttach,
  version: '3.1.0+1',
);

int _fieldSeasonEstimateSize(
  FieldSeason object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.crop.length * 3;
  return bytesCount;
}

void _fieldSeasonSerialize(
  FieldSeason object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDateTime(offsets[0], object.createdAt);
  writer.writeString(offsets[1], object.crop);
  writer.writeLong(offsets[2], object.year);
}

FieldSeason _fieldSeasonDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = FieldSeason();
  object.createdAt = reader.readDateTime(offsets[0]);
  object.crop = reader.readString(offsets[1]);
  object.id = id;
  object.year = reader.readLong(offsets[2]);
  return object;
}

P _fieldSeasonDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDateTime(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _fieldSeasonGetId(FieldSeason object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _fieldSeasonGetLinks(FieldSeason object) {
  return [object.field, object.diagnoses];
}

void _fieldSeasonAttach(
    IsarCollection<dynamic> col, Id id, FieldSeason object) {
  object.id = id;
  object.field.attach(col, col.isar.collection<Field>(), r'field', id);
  object.diagnoses
      .attach(col, col.isar.collection<DiagnosisEntry>(), r'diagnoses', id);
}

extension FieldSeasonQueryWhereSort
    on QueryBuilder<FieldSeason, FieldSeason, QWhere> {
  QueryBuilder<FieldSeason, FieldSeason, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<FieldSeason, FieldSeason, QAfterWhere> anyYear() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'year'),
      );
    });
  }
}

extension FieldSeasonQueryWhere
    on QueryBuilder<FieldSeason, FieldSeason, QWhereClause> {
  QueryBuilder<FieldSeason, FieldSeason, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<FieldSeason, FieldSeason, QAfterWhereClause> idNotEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<FieldSeason, FieldSeason, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<FieldSeason, FieldSeason, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<FieldSeason, FieldSeason, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<FieldSeason, FieldSeason, QAfterWhereClause> yearEqualTo(
      int year) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'year',
        value: [year],
      ));
    });
  }

  QueryBuilder<FieldSeason, FieldSeason, QAfterWhereClause> yearNotEqualTo(
      int year) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'year',
              lower: [],
              upper: [year],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'year',
              lower: [year],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'year',
              lower: [year],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'year',
              lower: [],
              upper: [year],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<FieldSeason, FieldSeason, QAfterWhereClause> yearGreaterThan(
    int year, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'year',
        lower: [year],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<FieldSeason, FieldSeason, QAfterWhereClause> yearLessThan(
    int year, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'year',
        lower: [],
        upper: [year],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<FieldSeason, FieldSeason, QAfterWhereClause> yearBetween(
    int lowerYear,
    int upperYear, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'year',
        lower: [lowerYear],
        includeLower: includeLower,
        upper: [upperYear],
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<FieldSeason, FieldSeason, QAfterWhereClause> cropEqualTo(
      String crop) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'crop',
        value: [crop],
      ));
    });
  }

  QueryBuilder<FieldSeason, FieldSeason, QAfterWhereClause> cropNotEqualTo(
      String crop) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'crop',
              lower: [],
              upper: [crop],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'crop',
              lower: [crop],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'crop',
              lower: [crop],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'crop',
              lower: [],
              upper: [crop],
              includeUpper: false,
            ));
      }
    });
  }
}

extension FieldSeasonQueryFilter
    on QueryBuilder<FieldSeason, FieldSeason, QFilterCondition> {
  QueryBuilder<FieldSeason, FieldSeason, QAfterFilterCondition>
      createdAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<FieldSeason, FieldSeason, QAfterFilterCondition>
      createdAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<FieldSeason, FieldSeason, QAfterFilterCondition>
      createdAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<FieldSeason, FieldSeason, QAfterFilterCondition>
      createdAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'createdAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<FieldSeason, FieldSeason, QAfterFilterCondition> cropEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'crop',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FieldSeason, FieldSeason, QAfterFilterCondition> cropGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'crop',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FieldSeason, FieldSeason, QAfterFilterCondition> cropLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'crop',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FieldSeason, FieldSeason, QAfterFilterCondition> cropBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'crop',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FieldSeason, FieldSeason, QAfterFilterCondition> cropStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'crop',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FieldSeason, FieldSeason, QAfterFilterCondition> cropEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'crop',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FieldSeason, FieldSeason, QAfterFilterCondition> cropContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'crop',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FieldSeason, FieldSeason, QAfterFilterCondition> cropMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'crop',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FieldSeason, FieldSeason, QAfterFilterCondition> cropIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'crop',
        value: '',
      ));
    });
  }

  QueryBuilder<FieldSeason, FieldSeason, QAfterFilterCondition>
      cropIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'crop',
        value: '',
      ));
    });
  }

  QueryBuilder<FieldSeason, FieldSeason, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<FieldSeason, FieldSeason, QAfterFilterCondition> idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<FieldSeason, FieldSeason, QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<FieldSeason, FieldSeason, QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<FieldSeason, FieldSeason, QAfterFilterCondition> yearEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'year',
        value: value,
      ));
    });
  }

  QueryBuilder<FieldSeason, FieldSeason, QAfterFilterCondition> yearGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'year',
        value: value,
      ));
    });
  }

  QueryBuilder<FieldSeason, FieldSeason, QAfterFilterCondition> yearLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'year',
        value: value,
      ));
    });
  }

  QueryBuilder<FieldSeason, FieldSeason, QAfterFilterCondition> yearBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'year',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension FieldSeasonQueryObject
    on QueryBuilder<FieldSeason, FieldSeason, QFilterCondition> {}

extension FieldSeasonQueryLinks
    on QueryBuilder<FieldSeason, FieldSeason, QFilterCondition> {
  QueryBuilder<FieldSeason, FieldSeason, QAfterFilterCondition> field(
      FilterQuery<Field> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'field');
    });
  }

  QueryBuilder<FieldSeason, FieldSeason, QAfterFilterCondition> fieldIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'field', 0, true, 0, true);
    });
  }

  QueryBuilder<FieldSeason, FieldSeason, QAfterFilterCondition> diagnoses(
      FilterQuery<DiagnosisEntry> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'diagnoses');
    });
  }

  QueryBuilder<FieldSeason, FieldSeason, QAfterFilterCondition>
      diagnosesLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'diagnoses', length, true, length, true);
    });
  }

  QueryBuilder<FieldSeason, FieldSeason, QAfterFilterCondition>
      diagnosesIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'diagnoses', 0, true, 0, true);
    });
  }

  QueryBuilder<FieldSeason, FieldSeason, QAfterFilterCondition>
      diagnosesIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'diagnoses', 0, false, 999999, true);
    });
  }

  QueryBuilder<FieldSeason, FieldSeason, QAfterFilterCondition>
      diagnosesLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'diagnoses', 0, true, length, include);
    });
  }

  QueryBuilder<FieldSeason, FieldSeason, QAfterFilterCondition>
      diagnosesLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'diagnoses', length, include, 999999, true);
    });
  }

  QueryBuilder<FieldSeason, FieldSeason, QAfterFilterCondition>
      diagnosesLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(
          r'diagnoses', lower, includeLower, upper, includeUpper);
    });
  }
}

extension FieldSeasonQuerySortBy
    on QueryBuilder<FieldSeason, FieldSeason, QSortBy> {
  QueryBuilder<FieldSeason, FieldSeason, QAfterSortBy> sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<FieldSeason, FieldSeason, QAfterSortBy> sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<FieldSeason, FieldSeason, QAfterSortBy> sortByCrop() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'crop', Sort.asc);
    });
  }

  QueryBuilder<FieldSeason, FieldSeason, QAfterSortBy> sortByCropDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'crop', Sort.desc);
    });
  }

  QueryBuilder<FieldSeason, FieldSeason, QAfterSortBy> sortByYear() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'year', Sort.asc);
    });
  }

  QueryBuilder<FieldSeason, FieldSeason, QAfterSortBy> sortByYearDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'year', Sort.desc);
    });
  }
}

extension FieldSeasonQuerySortThenBy
    on QueryBuilder<FieldSeason, FieldSeason, QSortThenBy> {
  QueryBuilder<FieldSeason, FieldSeason, QAfterSortBy> thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<FieldSeason, FieldSeason, QAfterSortBy> thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<FieldSeason, FieldSeason, QAfterSortBy> thenByCrop() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'crop', Sort.asc);
    });
  }

  QueryBuilder<FieldSeason, FieldSeason, QAfterSortBy> thenByCropDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'crop', Sort.desc);
    });
  }

  QueryBuilder<FieldSeason, FieldSeason, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<FieldSeason, FieldSeason, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<FieldSeason, FieldSeason, QAfterSortBy> thenByYear() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'year', Sort.asc);
    });
  }

  QueryBuilder<FieldSeason, FieldSeason, QAfterSortBy> thenByYearDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'year', Sort.desc);
    });
  }
}

extension FieldSeasonQueryWhereDistinct
    on QueryBuilder<FieldSeason, FieldSeason, QDistinct> {
  QueryBuilder<FieldSeason, FieldSeason, QDistinct> distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<FieldSeason, FieldSeason, QDistinct> distinctByCrop(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'crop', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<FieldSeason, FieldSeason, QDistinct> distinctByYear() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'year');
    });
  }
}

extension FieldSeasonQueryProperty
    on QueryBuilder<FieldSeason, FieldSeason, QQueryProperty> {
  QueryBuilder<FieldSeason, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<FieldSeason, DateTime, QQueryOperations> createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<FieldSeason, String, QQueryOperations> cropProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'crop');
    });
  }

  QueryBuilder<FieldSeason, int, QQueryOperations> yearProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'year');
    });
  }
}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetDiagnosisEntryCollection on Isar {
  IsarCollection<DiagnosisEntry> get diagnosisEntrys => this.collection();
}

const DiagnosisEntrySchema = CollectionSchema(
  name: r'DiagnosisEntry',
  id: 4019785161326144789,
  properties: {
    r'canonicalDiseaseId': PropertySchema(
      id: 0,
      name: r'canonicalDiseaseId',
      type: IsarType.string,
    ),
    r'confidence': PropertySchema(
      id: 1,
      name: r'confidence',
      type: IsarType.double,
    ),
    r'createdAt': PropertySchema(
      id: 2,
      name: r'createdAt',
      type: IsarType.dateTime,
    ),
    r'displayLabelPl': PropertySchema(
      id: 3,
      name: r'displayLabelPl',
      type: IsarType.string,
    ),
    r'imagePath': PropertySchema(
      id: 4,
      name: r'imagePath',
      type: IsarType.string,
    ),
    r'lat': PropertySchema(
      id: 5,
      name: r'lat',
      type: IsarType.double,
    ),
    r'lng': PropertySchema(
      id: 6,
      name: r'lng',
      type: IsarType.double,
    ),
    r'modelId': PropertySchema(
      id: 7,
      name: r'modelId',
      type: IsarType.string,
    ),
    r'notes': PropertySchema(
      id: 8,
      name: r'notes',
      type: IsarType.string,
    ),
    r'rawLabel': PropertySchema(
      id: 9,
      name: r'rawLabel',
      type: IsarType.string,
    ),
    r'recommendationKey': PropertySchema(
      id: 10,
      name: r'recommendationKey',
      type: IsarType.string,
    ),
    r'timestamp': PropertySchema(
      id: 11,
      name: r'timestamp',
      type: IsarType.dateTime,
    )
  },
  estimateSize: _diagnosisEntryEstimateSize,
  serialize: _diagnosisEntrySerialize,
  deserialize: _diagnosisEntryDeserialize,
  deserializeProp: _diagnosisEntryDeserializeProp,
  idName: r'id',
  indexes: {
    r'timestamp': IndexSchema(
      id: 1852253767416892198,
      name: r'timestamp',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'timestamp',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    ),
    r'lat': IndexSchema(
      id: 3038781890822997334,
      name: r'lat',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'lat',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    ),
    r'lng': IndexSchema(
      id: 428885709538637475,
      name: r'lng',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'lng',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    ),
    r'modelId': IndexSchema(
      id: -1910745378942518156,
      name: r'modelId',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'modelId',
          type: IndexType.hash,
          caseSensitive: false,
        )
      ],
    ),
    r'rawLabel': IndexSchema(
      id: 2168166862674260521,
      name: r'rawLabel',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'rawLabel',
          type: IndexType.hash,
          caseSensitive: false,
        )
      ],
    ),
    r'canonicalDiseaseId': IndexSchema(
      id: 4393757072982292984,
      name: r'canonicalDiseaseId',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'canonicalDiseaseId',
          type: IndexType.hash,
          caseSensitive: false,
        )
      ],
    )
  },
  links: {
    r'fieldSeason': LinkSchema(
      id: 6666734650757020734,
      name: r'fieldSeason',
      target: r'FieldSeason',
      single: true,
    )
  },
  embeddedSchemas: {},
  getId: _diagnosisEntryGetId,
  getLinks: _diagnosisEntryGetLinks,
  attach: _diagnosisEntryAttach,
  version: '3.1.0+1',
);

int _diagnosisEntryEstimateSize(
  DiagnosisEntry object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.canonicalDiseaseId.length * 3;
  bytesCount += 3 + object.displayLabelPl.length * 3;
  bytesCount += 3 + object.imagePath.length * 3;
  bytesCount += 3 + object.modelId.length * 3;
  {
    final value = object.notes;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.rawLabel.length * 3;
  {
    final value = object.recommendationKey;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _diagnosisEntrySerialize(
  DiagnosisEntry object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.canonicalDiseaseId);
  writer.writeDouble(offsets[1], object.confidence);
  writer.writeDateTime(offsets[2], object.createdAt);
  writer.writeString(offsets[3], object.displayLabelPl);
  writer.writeString(offsets[4], object.imagePath);
  writer.writeDouble(offsets[5], object.lat);
  writer.writeDouble(offsets[6], object.lng);
  writer.writeString(offsets[7], object.modelId);
  writer.writeString(offsets[8], object.notes);
  writer.writeString(offsets[9], object.rawLabel);
  writer.writeString(offsets[10], object.recommendationKey);
  writer.writeDateTime(offsets[11], object.timestamp);
}

DiagnosisEntry _diagnosisEntryDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = DiagnosisEntry();
  object.canonicalDiseaseId = reader.readString(offsets[0]);
  object.confidence = reader.readDouble(offsets[1]);
  object.createdAt = reader.readDateTime(offsets[2]);
  object.displayLabelPl = reader.readString(offsets[3]);
  object.id = id;
  object.imagePath = reader.readString(offsets[4]);
  object.lat = reader.readDoubleOrNull(offsets[5]);
  object.lng = reader.readDoubleOrNull(offsets[6]);
  object.modelId = reader.readString(offsets[7]);
  object.notes = reader.readStringOrNull(offsets[8]);
  object.rawLabel = reader.readString(offsets[9]);
  object.recommendationKey = reader.readStringOrNull(offsets[10]);
  object.timestamp = reader.readDateTime(offsets[11]);
  return object;
}

P _diagnosisEntryDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readDouble(offset)) as P;
    case 2:
      return (reader.readDateTime(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readString(offset)) as P;
    case 5:
      return (reader.readDoubleOrNull(offset)) as P;
    case 6:
      return (reader.readDoubleOrNull(offset)) as P;
    case 7:
      return (reader.readString(offset)) as P;
    case 8:
      return (reader.readStringOrNull(offset)) as P;
    case 9:
      return (reader.readString(offset)) as P;
    case 10:
      return (reader.readStringOrNull(offset)) as P;
    case 11:
      return (reader.readDateTime(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _diagnosisEntryGetId(DiagnosisEntry object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _diagnosisEntryGetLinks(DiagnosisEntry object) {
  return [object.fieldSeason];
}

void _diagnosisEntryAttach(
    IsarCollection<dynamic> col, Id id, DiagnosisEntry object) {
  object.id = id;
  object.fieldSeason
      .attach(col, col.isar.collection<FieldSeason>(), r'fieldSeason', id);
}

extension DiagnosisEntryQueryWhereSort
    on QueryBuilder<DiagnosisEntry, DiagnosisEntry, QWhere> {
  QueryBuilder<DiagnosisEntry, DiagnosisEntry, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<DiagnosisEntry, DiagnosisEntry, QAfterWhere> anyTimestamp() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'timestamp'),
      );
    });
  }

  QueryBuilder<DiagnosisEntry, DiagnosisEntry, QAfterWhere> anyLat() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'lat'),
      );
    });
  }

  QueryBuilder<DiagnosisEntry, DiagnosisEntry, QAfterWhere> anyLng() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'lng'),
      );
    });
  }
}

extension DiagnosisEntryQueryWhere
    on QueryBuilder<DiagnosisEntry, DiagnosisEntry, QWhereClause> {
  QueryBuilder<DiagnosisEntry, DiagnosisEntry, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<DiagnosisEntry, DiagnosisEntry, QAfterWhereClause> idNotEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<DiagnosisEntry, DiagnosisEntry, QAfterWhereClause> idGreaterThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<DiagnosisEntry, DiagnosisEntry, QAfterWhereClause> idLessThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<DiagnosisEntry, DiagnosisEntry, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<DiagnosisEntry, DiagnosisEntry, QAfterWhereClause>
      timestampEqualTo(DateTime timestamp) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'timestamp',
        value: [timestamp],
      ));
    });
  }

  QueryBuilder<DiagnosisEntry, DiagnosisEntry, QAfterWhereClause>
      timestampNotEqualTo(DateTime timestamp) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'timestamp',
              lower: [],
              upper: [timestamp],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'timestamp',
              lower: [timestamp],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'timestamp',
              lower: [timestamp],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'timestamp',
              lower: [],
              upper: [timestamp],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<DiagnosisEntry, DiagnosisEntry, QAfterWhereClause>
      timestampGreaterThan(
    DateTime timestamp, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'timestamp',
        lower: [timestamp],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<DiagnosisEntry, DiagnosisEntry, QAfterWhereClause>
      timestampLessThan(
    DateTime timestamp, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'timestamp',
        lower: [],
        upper: [timestamp],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<DiagnosisEntry, DiagnosisEntry, QAfterWhereClause>
      timestampBetween(
    DateTime lowerTimestamp,
    DateTime upperTimestamp, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'timestamp',
        lower: [lowerTimestamp],
        includeLower: includeLower,
        upper: [upperTimestamp],
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<DiagnosisEntry, DiagnosisEntry, QAfterWhereClause> latIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'lat',
        value: [null],
      ));
    });
  }

  QueryBuilder<DiagnosisEntry, DiagnosisEntry, QAfterWhereClause>
      latIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'lat',
        lower: [null],
        includeLower: false,
        upper: [],
      ));
    });
  }

  QueryBuilder<DiagnosisEntry, DiagnosisEntry, QAfterWhereClause> latEqualTo(
      double? lat) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'lat',
        value: [lat],
      ));
    });
  }

  QueryBuilder<DiagnosisEntry, DiagnosisEntry, QAfterWhereClause> latNotEqualTo(
      double? lat) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'lat',
              lower: [],
              upper: [lat],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'lat',
              lower: [lat],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'lat',
              lower: [lat],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'lat',
              lower: [],
              upper: [lat],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<DiagnosisEntry, DiagnosisEntry, QAfterWhereClause>
      latGreaterThan(
    double? lat, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'lat',
        lower: [lat],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<DiagnosisEntry, DiagnosisEntry, QAfterWhereClause> latLessThan(
    double? lat, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'lat',
        lower: [],
        upper: [lat],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<DiagnosisEntry, DiagnosisEntry, QAfterWhereClause> latBetween(
    double? lowerLat,
    double? upperLat, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'lat',
        lower: [lowerLat],
        includeLower: includeLower,
        upper: [upperLat],
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<DiagnosisEntry, DiagnosisEntry, QAfterWhereClause> lngIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'lng',
        value: [null],
      ));
    });
  }

  QueryBuilder<DiagnosisEntry, DiagnosisEntry, QAfterWhereClause>
      lngIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'lng',
        lower: [null],
        includeLower: false,
        upper: [],
      ));
    });
  }

  QueryBuilder<DiagnosisEntry, DiagnosisEntry, QAfterWhereClause> lngEqualTo(
      double? lng) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'lng',
        value: [lng],
      ));
    });
  }

  QueryBuilder<DiagnosisEntry, DiagnosisEntry, QAfterWhereClause> lngNotEqualTo(
      double? lng) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'lng',
              lower: [],
              upper: [lng],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'lng',
              lower: [lng],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'lng',
              lower: [lng],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'lng',
              lower: [],
              upper: [lng],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<DiagnosisEntry, DiagnosisEntry, QAfterWhereClause>
      lngGreaterThan(
    double? lng, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'lng',
        lower: [lng],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<DiagnosisEntry, DiagnosisEntry, QAfterWhereClause> lngLessThan(
    double? lng, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'lng',
        lower: [],
        upper: [lng],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<DiagnosisEntry, DiagnosisEntry, QAfterWhereClause> lngBetween(
    double? lowerLng,
    double? upperLng, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'lng',
        lower: [lowerLng],
        includeLower: includeLower,
        upper: [upperLng],
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<DiagnosisEntry, DiagnosisEntry, QAfterWhereClause>
      modelIdEqualTo(String modelId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'modelId',
        value: [modelId],
      ));
    });
  }

  QueryBuilder<DiagnosisEntry, DiagnosisEntry, QAfterWhereClause>
      modelIdNotEqualTo(String modelId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'modelId',
              lower: [],
              upper: [modelId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'modelId',
              lower: [modelId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'modelId',
              lower: [modelId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'modelId',
              lower: [],
              upper: [modelId],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<DiagnosisEntry, DiagnosisEntry, QAfterWhereClause>
      rawLabelEqualTo(String rawLabel) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'rawLabel',
        value: [rawLabel],
      ));
    });
  }

  QueryBuilder<DiagnosisEntry, DiagnosisEntry, QAfterWhereClause>
      rawLabelNotEqualTo(String rawLabel) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'rawLabel',
              lower: [],
              upper: [rawLabel],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'rawLabel',
              lower: [rawLabel],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'rawLabel',
              lower: [rawLabel],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'rawLabel',
              lower: [],
              upper: [rawLabel],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<DiagnosisEntry, DiagnosisEntry, QAfterWhereClause>
      canonicalDiseaseIdEqualTo(String canonicalDiseaseId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'canonicalDiseaseId',
        value: [canonicalDiseaseId],
      ));
    });
  }

  QueryBuilder<DiagnosisEntry, DiagnosisEntry, QAfterWhereClause>
      canonicalDiseaseIdNotEqualTo(String canonicalDiseaseId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'canonicalDiseaseId',
              lower: [],
              upper: [canonicalDiseaseId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'canonicalDiseaseId',
              lower: [canonicalDiseaseId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'canonicalDiseaseId',
              lower: [canonicalDiseaseId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'canonicalDiseaseId',
              lower: [],
              upper: [canonicalDiseaseId],
              includeUpper: false,
            ));
      }
    });
  }
}

extension DiagnosisEntryQueryFilter
    on QueryBuilder<DiagnosisEntry, DiagnosisEntry, QFilterCondition> {
  QueryBuilder<DiagnosisEntry, DiagnosisEntry, QAfterFilterCondition>
      canonicalDiseaseIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'canonicalDiseaseId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DiagnosisEntry, DiagnosisEntry, QAfterFilterCondition>
      canonicalDiseaseIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'canonicalDiseaseId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DiagnosisEntry, DiagnosisEntry, QAfterFilterCondition>
      canonicalDiseaseIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'canonicalDiseaseId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DiagnosisEntry, DiagnosisEntry, QAfterFilterCondition>
      canonicalDiseaseIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'canonicalDiseaseId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DiagnosisEntry, DiagnosisEntry, QAfterFilterCondition>
      canonicalDiseaseIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'canonicalDiseaseId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DiagnosisEntry, DiagnosisEntry, QAfterFilterCondition>
      canonicalDiseaseIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'canonicalDiseaseId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DiagnosisEntry, DiagnosisEntry, QAfterFilterCondition>
      canonicalDiseaseIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'canonicalDiseaseId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DiagnosisEntry, DiagnosisEntry, QAfterFilterCondition>
      canonicalDiseaseIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'canonicalDiseaseId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DiagnosisEntry, DiagnosisEntry, QAfterFilterCondition>
      canonicalDiseaseIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'canonicalDiseaseId',
        value: '',
      ));
    });
  }

  QueryBuilder<DiagnosisEntry, DiagnosisEntry, QAfterFilterCondition>
      canonicalDiseaseIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'canonicalDiseaseId',
        value: '',
      ));
    });
  }

  QueryBuilder<DiagnosisEntry, DiagnosisEntry, QAfterFilterCondition>
      confidenceEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'confidence',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<DiagnosisEntry, DiagnosisEntry, QAfterFilterCondition>
      confidenceGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'confidence',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<DiagnosisEntry, DiagnosisEntry, QAfterFilterCondition>
      confidenceLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'confidence',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<DiagnosisEntry, DiagnosisEntry, QAfterFilterCondition>
      confidenceBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'confidence',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<DiagnosisEntry, DiagnosisEntry, QAfterFilterCondition>
      createdAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<DiagnosisEntry, DiagnosisEntry, QAfterFilterCondition>
      createdAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<DiagnosisEntry, DiagnosisEntry, QAfterFilterCondition>
      createdAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<DiagnosisEntry, DiagnosisEntry, QAfterFilterCondition>
      createdAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'createdAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<DiagnosisEntry, DiagnosisEntry, QAfterFilterCondition>
      displayLabelPlEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'displayLabelPl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DiagnosisEntry, DiagnosisEntry, QAfterFilterCondition>
      displayLabelPlGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'displayLabelPl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DiagnosisEntry, DiagnosisEntry, QAfterFilterCondition>
      displayLabelPlLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'displayLabelPl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DiagnosisEntry, DiagnosisEntry, QAfterFilterCondition>
      displayLabelPlBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'displayLabelPl',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DiagnosisEntry, DiagnosisEntry, QAfterFilterCondition>
      displayLabelPlStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'displayLabelPl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DiagnosisEntry, DiagnosisEntry, QAfterFilterCondition>
      displayLabelPlEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'displayLabelPl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DiagnosisEntry, DiagnosisEntry, QAfterFilterCondition>
      displayLabelPlContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'displayLabelPl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DiagnosisEntry, DiagnosisEntry, QAfterFilterCondition>
      displayLabelPlMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'displayLabelPl',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DiagnosisEntry, DiagnosisEntry, QAfterFilterCondition>
      displayLabelPlIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'displayLabelPl',
        value: '',
      ));
    });
  }

  QueryBuilder<DiagnosisEntry, DiagnosisEntry, QAfterFilterCondition>
      displayLabelPlIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'displayLabelPl',
        value: '',
      ));
    });
  }

  QueryBuilder<DiagnosisEntry, DiagnosisEntry, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<DiagnosisEntry, DiagnosisEntry, QAfterFilterCondition>
      idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<DiagnosisEntry, DiagnosisEntry, QAfterFilterCondition>
      idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<DiagnosisEntry, DiagnosisEntry, QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<DiagnosisEntry, DiagnosisEntry, QAfterFilterCondition>
      imagePathEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'imagePath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DiagnosisEntry, DiagnosisEntry, QAfterFilterCondition>
      imagePathGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'imagePath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DiagnosisEntry, DiagnosisEntry, QAfterFilterCondition>
      imagePathLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'imagePath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DiagnosisEntry, DiagnosisEntry, QAfterFilterCondition>
      imagePathBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'imagePath',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DiagnosisEntry, DiagnosisEntry, QAfterFilterCondition>
      imagePathStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'imagePath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DiagnosisEntry, DiagnosisEntry, QAfterFilterCondition>
      imagePathEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'imagePath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DiagnosisEntry, DiagnosisEntry, QAfterFilterCondition>
      imagePathContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'imagePath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DiagnosisEntry, DiagnosisEntry, QAfterFilterCondition>
      imagePathMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'imagePath',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DiagnosisEntry, DiagnosisEntry, QAfterFilterCondition>
      imagePathIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'imagePath',
        value: '',
      ));
    });
  }

  QueryBuilder<DiagnosisEntry, DiagnosisEntry, QAfterFilterCondition>
      imagePathIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'imagePath',
        value: '',
      ));
    });
  }

  QueryBuilder<DiagnosisEntry, DiagnosisEntry, QAfterFilterCondition>
      latIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'lat',
      ));
    });
  }

  QueryBuilder<DiagnosisEntry, DiagnosisEntry, QAfterFilterCondition>
      latIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'lat',
      ));
    });
  }

  QueryBuilder<DiagnosisEntry, DiagnosisEntry, QAfterFilterCondition>
      latEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lat',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<DiagnosisEntry, DiagnosisEntry, QAfterFilterCondition>
      latGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lat',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<DiagnosisEntry, DiagnosisEntry, QAfterFilterCondition>
      latLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lat',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<DiagnosisEntry, DiagnosisEntry, QAfterFilterCondition>
      latBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lat',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<DiagnosisEntry, DiagnosisEntry, QAfterFilterCondition>
      lngIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'lng',
      ));
    });
  }

  QueryBuilder<DiagnosisEntry, DiagnosisEntry, QAfterFilterCondition>
      lngIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'lng',
      ));
    });
  }

  QueryBuilder<DiagnosisEntry, DiagnosisEntry, QAfterFilterCondition>
      lngEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lng',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<DiagnosisEntry, DiagnosisEntry, QAfterFilterCondition>
      lngGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lng',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<DiagnosisEntry, DiagnosisEntry, QAfterFilterCondition>
      lngLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lng',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<DiagnosisEntry, DiagnosisEntry, QAfterFilterCondition>
      lngBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lng',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<DiagnosisEntry, DiagnosisEntry, QAfterFilterCondition>
      modelIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'modelId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DiagnosisEntry, DiagnosisEntry, QAfterFilterCondition>
      modelIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'modelId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DiagnosisEntry, DiagnosisEntry, QAfterFilterCondition>
      modelIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'modelId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DiagnosisEntry, DiagnosisEntry, QAfterFilterCondition>
      modelIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'modelId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DiagnosisEntry, DiagnosisEntry, QAfterFilterCondition>
      modelIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'modelId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DiagnosisEntry, DiagnosisEntry, QAfterFilterCondition>
      modelIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'modelId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DiagnosisEntry, DiagnosisEntry, QAfterFilterCondition>
      modelIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'modelId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DiagnosisEntry, DiagnosisEntry, QAfterFilterCondition>
      modelIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'modelId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DiagnosisEntry, DiagnosisEntry, QAfterFilterCondition>
      modelIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'modelId',
        value: '',
      ));
    });
  }

  QueryBuilder<DiagnosisEntry, DiagnosisEntry, QAfterFilterCondition>
      modelIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'modelId',
        value: '',
      ));
    });
  }

  QueryBuilder<DiagnosisEntry, DiagnosisEntry, QAfterFilterCondition>
      notesIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'notes',
      ));
    });
  }

  QueryBuilder<DiagnosisEntry, DiagnosisEntry, QAfterFilterCondition>
      notesIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'notes',
      ));
    });
  }

  QueryBuilder<DiagnosisEntry, DiagnosisEntry, QAfterFilterCondition>
      notesEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'notes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DiagnosisEntry, DiagnosisEntry, QAfterFilterCondition>
      notesGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'notes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DiagnosisEntry, DiagnosisEntry, QAfterFilterCondition>
      notesLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'notes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DiagnosisEntry, DiagnosisEntry, QAfterFilterCondition>
      notesBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'notes',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DiagnosisEntry, DiagnosisEntry, QAfterFilterCondition>
      notesStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'notes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DiagnosisEntry, DiagnosisEntry, QAfterFilterCondition>
      notesEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'notes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DiagnosisEntry, DiagnosisEntry, QAfterFilterCondition>
      notesContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'notes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DiagnosisEntry, DiagnosisEntry, QAfterFilterCondition>
      notesMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'notes',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DiagnosisEntry, DiagnosisEntry, QAfterFilterCondition>
      notesIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'notes',
        value: '',
      ));
    });
  }

  QueryBuilder<DiagnosisEntry, DiagnosisEntry, QAfterFilterCondition>
      notesIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'notes',
        value: '',
      ));
    });
  }

  QueryBuilder<DiagnosisEntry, DiagnosisEntry, QAfterFilterCondition>
      rawLabelEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'rawLabel',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DiagnosisEntry, DiagnosisEntry, QAfterFilterCondition>
      rawLabelGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'rawLabel',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DiagnosisEntry, DiagnosisEntry, QAfterFilterCondition>
      rawLabelLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'rawLabel',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DiagnosisEntry, DiagnosisEntry, QAfterFilterCondition>
      rawLabelBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'rawLabel',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DiagnosisEntry, DiagnosisEntry, QAfterFilterCondition>
      rawLabelStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'rawLabel',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DiagnosisEntry, DiagnosisEntry, QAfterFilterCondition>
      rawLabelEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'rawLabel',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DiagnosisEntry, DiagnosisEntry, QAfterFilterCondition>
      rawLabelContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'rawLabel',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DiagnosisEntry, DiagnosisEntry, QAfterFilterCondition>
      rawLabelMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'rawLabel',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DiagnosisEntry, DiagnosisEntry, QAfterFilterCondition>
      rawLabelIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'rawLabel',
        value: '',
      ));
    });
  }

  QueryBuilder<DiagnosisEntry, DiagnosisEntry, QAfterFilterCondition>
      rawLabelIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'rawLabel',
        value: '',
      ));
    });
  }

  QueryBuilder<DiagnosisEntry, DiagnosisEntry, QAfterFilterCondition>
      recommendationKeyIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'recommendationKey',
      ));
    });
  }

  QueryBuilder<DiagnosisEntry, DiagnosisEntry, QAfterFilterCondition>
      recommendationKeyIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'recommendationKey',
      ));
    });
  }

  QueryBuilder<DiagnosisEntry, DiagnosisEntry, QAfterFilterCondition>
      recommendationKeyEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'recommendationKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DiagnosisEntry, DiagnosisEntry, QAfterFilterCondition>
      recommendationKeyGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'recommendationKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DiagnosisEntry, DiagnosisEntry, QAfterFilterCondition>
      recommendationKeyLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'recommendationKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DiagnosisEntry, DiagnosisEntry, QAfterFilterCondition>
      recommendationKeyBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'recommendationKey',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DiagnosisEntry, DiagnosisEntry, QAfterFilterCondition>
      recommendationKeyStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'recommendationKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DiagnosisEntry, DiagnosisEntry, QAfterFilterCondition>
      recommendationKeyEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'recommendationKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DiagnosisEntry, DiagnosisEntry, QAfterFilterCondition>
      recommendationKeyContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'recommendationKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DiagnosisEntry, DiagnosisEntry, QAfterFilterCondition>
      recommendationKeyMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'recommendationKey',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DiagnosisEntry, DiagnosisEntry, QAfterFilterCondition>
      recommendationKeyIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'recommendationKey',
        value: '',
      ));
    });
  }

  QueryBuilder<DiagnosisEntry, DiagnosisEntry, QAfterFilterCondition>
      recommendationKeyIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'recommendationKey',
        value: '',
      ));
    });
  }

  QueryBuilder<DiagnosisEntry, DiagnosisEntry, QAfterFilterCondition>
      timestampEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'timestamp',
        value: value,
      ));
    });
  }

  QueryBuilder<DiagnosisEntry, DiagnosisEntry, QAfterFilterCondition>
      timestampGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'timestamp',
        value: value,
      ));
    });
  }

  QueryBuilder<DiagnosisEntry, DiagnosisEntry, QAfterFilterCondition>
      timestampLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'timestamp',
        value: value,
      ));
    });
  }

  QueryBuilder<DiagnosisEntry, DiagnosisEntry, QAfterFilterCondition>
      timestampBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'timestamp',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension DiagnosisEntryQueryObject
    on QueryBuilder<DiagnosisEntry, DiagnosisEntry, QFilterCondition> {}

extension DiagnosisEntryQueryLinks
    on QueryBuilder<DiagnosisEntry, DiagnosisEntry, QFilterCondition> {
  QueryBuilder<DiagnosisEntry, DiagnosisEntry, QAfterFilterCondition>
      fieldSeason(FilterQuery<FieldSeason> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'fieldSeason');
    });
  }

  QueryBuilder<DiagnosisEntry, DiagnosisEntry, QAfterFilterCondition>
      fieldSeasonIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'fieldSeason', 0, true, 0, true);
    });
  }
}

extension DiagnosisEntryQuerySortBy
    on QueryBuilder<DiagnosisEntry, DiagnosisEntry, QSortBy> {
  QueryBuilder<DiagnosisEntry, DiagnosisEntry, QAfterSortBy>
      sortByCanonicalDiseaseId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'canonicalDiseaseId', Sort.asc);
    });
  }

  QueryBuilder<DiagnosisEntry, DiagnosisEntry, QAfterSortBy>
      sortByCanonicalDiseaseIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'canonicalDiseaseId', Sort.desc);
    });
  }

  QueryBuilder<DiagnosisEntry, DiagnosisEntry, QAfterSortBy>
      sortByConfidence() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'confidence', Sort.asc);
    });
  }

  QueryBuilder<DiagnosisEntry, DiagnosisEntry, QAfterSortBy>
      sortByConfidenceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'confidence', Sort.desc);
    });
  }

  QueryBuilder<DiagnosisEntry, DiagnosisEntry, QAfterSortBy> sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<DiagnosisEntry, DiagnosisEntry, QAfterSortBy>
      sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<DiagnosisEntry, DiagnosisEntry, QAfterSortBy>
      sortByDisplayLabelPl() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'displayLabelPl', Sort.asc);
    });
  }

  QueryBuilder<DiagnosisEntry, DiagnosisEntry, QAfterSortBy>
      sortByDisplayLabelPlDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'displayLabelPl', Sort.desc);
    });
  }

  QueryBuilder<DiagnosisEntry, DiagnosisEntry, QAfterSortBy> sortByImagePath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'imagePath', Sort.asc);
    });
  }

  QueryBuilder<DiagnosisEntry, DiagnosisEntry, QAfterSortBy>
      sortByImagePathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'imagePath', Sort.desc);
    });
  }

  QueryBuilder<DiagnosisEntry, DiagnosisEntry, QAfterSortBy> sortByLat() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lat', Sort.asc);
    });
  }

  QueryBuilder<DiagnosisEntry, DiagnosisEntry, QAfterSortBy> sortByLatDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lat', Sort.desc);
    });
  }

  QueryBuilder<DiagnosisEntry, DiagnosisEntry, QAfterSortBy> sortByLng() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lng', Sort.asc);
    });
  }

  QueryBuilder<DiagnosisEntry, DiagnosisEntry, QAfterSortBy> sortByLngDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lng', Sort.desc);
    });
  }

  QueryBuilder<DiagnosisEntry, DiagnosisEntry, QAfterSortBy> sortByModelId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'modelId', Sort.asc);
    });
  }

  QueryBuilder<DiagnosisEntry, DiagnosisEntry, QAfterSortBy>
      sortByModelIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'modelId', Sort.desc);
    });
  }

  QueryBuilder<DiagnosisEntry, DiagnosisEntry, QAfterSortBy> sortByNotes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notes', Sort.asc);
    });
  }

  QueryBuilder<DiagnosisEntry, DiagnosisEntry, QAfterSortBy> sortByNotesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notes', Sort.desc);
    });
  }

  QueryBuilder<DiagnosisEntry, DiagnosisEntry, QAfterSortBy> sortByRawLabel() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rawLabel', Sort.asc);
    });
  }

  QueryBuilder<DiagnosisEntry, DiagnosisEntry, QAfterSortBy>
      sortByRawLabelDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rawLabel', Sort.desc);
    });
  }

  QueryBuilder<DiagnosisEntry, DiagnosisEntry, QAfterSortBy>
      sortByRecommendationKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'recommendationKey', Sort.asc);
    });
  }

  QueryBuilder<DiagnosisEntry, DiagnosisEntry, QAfterSortBy>
      sortByRecommendationKeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'recommendationKey', Sort.desc);
    });
  }

  QueryBuilder<DiagnosisEntry, DiagnosisEntry, QAfterSortBy> sortByTimestamp() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timestamp', Sort.asc);
    });
  }

  QueryBuilder<DiagnosisEntry, DiagnosisEntry, QAfterSortBy>
      sortByTimestampDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timestamp', Sort.desc);
    });
  }
}

extension DiagnosisEntryQuerySortThenBy
    on QueryBuilder<DiagnosisEntry, DiagnosisEntry, QSortThenBy> {
  QueryBuilder<DiagnosisEntry, DiagnosisEntry, QAfterSortBy>
      thenByCanonicalDiseaseId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'canonicalDiseaseId', Sort.asc);
    });
  }

  QueryBuilder<DiagnosisEntry, DiagnosisEntry, QAfterSortBy>
      thenByCanonicalDiseaseIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'canonicalDiseaseId', Sort.desc);
    });
  }

  QueryBuilder<DiagnosisEntry, DiagnosisEntry, QAfterSortBy>
      thenByConfidence() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'confidence', Sort.asc);
    });
  }

  QueryBuilder<DiagnosisEntry, DiagnosisEntry, QAfterSortBy>
      thenByConfidenceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'confidence', Sort.desc);
    });
  }

  QueryBuilder<DiagnosisEntry, DiagnosisEntry, QAfterSortBy> thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<DiagnosisEntry, DiagnosisEntry, QAfterSortBy>
      thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<DiagnosisEntry, DiagnosisEntry, QAfterSortBy>
      thenByDisplayLabelPl() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'displayLabelPl', Sort.asc);
    });
  }

  QueryBuilder<DiagnosisEntry, DiagnosisEntry, QAfterSortBy>
      thenByDisplayLabelPlDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'displayLabelPl', Sort.desc);
    });
  }

  QueryBuilder<DiagnosisEntry, DiagnosisEntry, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<DiagnosisEntry, DiagnosisEntry, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<DiagnosisEntry, DiagnosisEntry, QAfterSortBy> thenByImagePath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'imagePath', Sort.asc);
    });
  }

  QueryBuilder<DiagnosisEntry, DiagnosisEntry, QAfterSortBy>
      thenByImagePathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'imagePath', Sort.desc);
    });
  }

  QueryBuilder<DiagnosisEntry, DiagnosisEntry, QAfterSortBy> thenByLat() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lat', Sort.asc);
    });
  }

  QueryBuilder<DiagnosisEntry, DiagnosisEntry, QAfterSortBy> thenByLatDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lat', Sort.desc);
    });
  }

  QueryBuilder<DiagnosisEntry, DiagnosisEntry, QAfterSortBy> thenByLng() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lng', Sort.asc);
    });
  }

  QueryBuilder<DiagnosisEntry, DiagnosisEntry, QAfterSortBy> thenByLngDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lng', Sort.desc);
    });
  }

  QueryBuilder<DiagnosisEntry, DiagnosisEntry, QAfterSortBy> thenByModelId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'modelId', Sort.asc);
    });
  }

  QueryBuilder<DiagnosisEntry, DiagnosisEntry, QAfterSortBy>
      thenByModelIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'modelId', Sort.desc);
    });
  }

  QueryBuilder<DiagnosisEntry, DiagnosisEntry, QAfterSortBy> thenByNotes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notes', Sort.asc);
    });
  }

  QueryBuilder<DiagnosisEntry, DiagnosisEntry, QAfterSortBy> thenByNotesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notes', Sort.desc);
    });
  }

  QueryBuilder<DiagnosisEntry, DiagnosisEntry, QAfterSortBy> thenByRawLabel() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rawLabel', Sort.asc);
    });
  }

  QueryBuilder<DiagnosisEntry, DiagnosisEntry, QAfterSortBy>
      thenByRawLabelDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rawLabel', Sort.desc);
    });
  }

  QueryBuilder<DiagnosisEntry, DiagnosisEntry, QAfterSortBy>
      thenByRecommendationKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'recommendationKey', Sort.asc);
    });
  }

  QueryBuilder<DiagnosisEntry, DiagnosisEntry, QAfterSortBy>
      thenByRecommendationKeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'recommendationKey', Sort.desc);
    });
  }

  QueryBuilder<DiagnosisEntry, DiagnosisEntry, QAfterSortBy> thenByTimestamp() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timestamp', Sort.asc);
    });
  }

  QueryBuilder<DiagnosisEntry, DiagnosisEntry, QAfterSortBy>
      thenByTimestampDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timestamp', Sort.desc);
    });
  }
}

extension DiagnosisEntryQueryWhereDistinct
    on QueryBuilder<DiagnosisEntry, DiagnosisEntry, QDistinct> {
  QueryBuilder<DiagnosisEntry, DiagnosisEntry, QDistinct>
      distinctByCanonicalDiseaseId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'canonicalDiseaseId',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DiagnosisEntry, DiagnosisEntry, QDistinct>
      distinctByConfidence() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'confidence');
    });
  }

  QueryBuilder<DiagnosisEntry, DiagnosisEntry, QDistinct>
      distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<DiagnosisEntry, DiagnosisEntry, QDistinct>
      distinctByDisplayLabelPl({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'displayLabelPl',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DiagnosisEntry, DiagnosisEntry, QDistinct> distinctByImagePath(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'imagePath', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DiagnosisEntry, DiagnosisEntry, QDistinct> distinctByLat() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lat');
    });
  }

  QueryBuilder<DiagnosisEntry, DiagnosisEntry, QDistinct> distinctByLng() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lng');
    });
  }

  QueryBuilder<DiagnosisEntry, DiagnosisEntry, QDistinct> distinctByModelId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'modelId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DiagnosisEntry, DiagnosisEntry, QDistinct> distinctByNotes(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'notes', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DiagnosisEntry, DiagnosisEntry, QDistinct> distinctByRawLabel(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'rawLabel', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DiagnosisEntry, DiagnosisEntry, QDistinct>
      distinctByRecommendationKey({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'recommendationKey',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DiagnosisEntry, DiagnosisEntry, QDistinct>
      distinctByTimestamp() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'timestamp');
    });
  }
}

extension DiagnosisEntryQueryProperty
    on QueryBuilder<DiagnosisEntry, DiagnosisEntry, QQueryProperty> {
  QueryBuilder<DiagnosisEntry, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<DiagnosisEntry, String, QQueryOperations>
      canonicalDiseaseIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'canonicalDiseaseId');
    });
  }

  QueryBuilder<DiagnosisEntry, double, QQueryOperations> confidenceProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'confidence');
    });
  }

  QueryBuilder<DiagnosisEntry, DateTime, QQueryOperations> createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<DiagnosisEntry, String, QQueryOperations>
      displayLabelPlProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'displayLabelPl');
    });
  }

  QueryBuilder<DiagnosisEntry, String, QQueryOperations> imagePathProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'imagePath');
    });
  }

  QueryBuilder<DiagnosisEntry, double?, QQueryOperations> latProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lat');
    });
  }

  QueryBuilder<DiagnosisEntry, double?, QQueryOperations> lngProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lng');
    });
  }

  QueryBuilder<DiagnosisEntry, String, QQueryOperations> modelIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'modelId');
    });
  }

  QueryBuilder<DiagnosisEntry, String?, QQueryOperations> notesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'notes');
    });
  }

  QueryBuilder<DiagnosisEntry, String, QQueryOperations> rawLabelProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'rawLabel');
    });
  }

  QueryBuilder<DiagnosisEntry, String?, QQueryOperations>
      recommendationKeyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'recommendationKey');
    });
  }

  QueryBuilder<DiagnosisEntry, DateTime, QQueryOperations> timestampProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'timestamp');
    });
  }
}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetDiseaseAliasIndexCollection on Isar {
  IsarCollection<DiseaseAliasIndex> get diseaseAliasIndexs => this.collection();
}

const DiseaseAliasIndexSchema = CollectionSchema(
  name: r'DiseaseAliasIndex',
  id: 6655629361284866771,
  properties: {
    r'alias': PropertySchema(
      id: 0,
      name: r'alias',
      type: IsarType.string,
    ),
    r'canonicalDiseaseId': PropertySchema(
      id: 1,
      name: r'canonicalDiseaseId',
      type: IsarType.string,
    )
  },
  estimateSize: _diseaseAliasIndexEstimateSize,
  serialize: _diseaseAliasIndexSerialize,
  deserialize: _diseaseAliasIndexDeserialize,
  deserializeProp: _diseaseAliasIndexDeserializeProp,
  idName: r'id',
  indexes: {
    r'alias': IndexSchema(
      id: 5319372933673974885,
      name: r'alias',
      unique: true,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'alias',
          type: IndexType.hash,
          caseSensitive: false,
        )
      ],
    ),
    r'canonicalDiseaseId': IndexSchema(
      id: 4393757072982292984,
      name: r'canonicalDiseaseId',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'canonicalDiseaseId',
          type: IndexType.hash,
          caseSensitive: false,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _diseaseAliasIndexGetId,
  getLinks: _diseaseAliasIndexGetLinks,
  attach: _diseaseAliasIndexAttach,
  version: '3.1.0+1',
);

int _diseaseAliasIndexEstimateSize(
  DiseaseAliasIndex object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.alias.length * 3;
  bytesCount += 3 + object.canonicalDiseaseId.length * 3;
  return bytesCount;
}

void _diseaseAliasIndexSerialize(
  DiseaseAliasIndex object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.alias);
  writer.writeString(offsets[1], object.canonicalDiseaseId);
}

DiseaseAliasIndex _diseaseAliasIndexDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = DiseaseAliasIndex();
  object.alias = reader.readString(offsets[0]);
  object.canonicalDiseaseId = reader.readString(offsets[1]);
  object.id = id;
  return object;
}

P _diseaseAliasIndexDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _diseaseAliasIndexGetId(DiseaseAliasIndex object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _diseaseAliasIndexGetLinks(
    DiseaseAliasIndex object) {
  return [];
}

void _diseaseAliasIndexAttach(
    IsarCollection<dynamic> col, Id id, DiseaseAliasIndex object) {
  object.id = id;
}

extension DiseaseAliasIndexByIndex on IsarCollection<DiseaseAliasIndex> {
  Future<DiseaseAliasIndex?> getByAlias(String alias) {
    return getByIndex(r'alias', [alias]);
  }

  DiseaseAliasIndex? getByAliasSync(String alias) {
    return getByIndexSync(r'alias', [alias]);
  }

  Future<bool> deleteByAlias(String alias) {
    return deleteByIndex(r'alias', [alias]);
  }

  bool deleteByAliasSync(String alias) {
    return deleteByIndexSync(r'alias', [alias]);
  }

  Future<List<DiseaseAliasIndex?>> getAllByAlias(List<String> aliasValues) {
    final values = aliasValues.map((e) => [e]).toList();
    return getAllByIndex(r'alias', values);
  }

  List<DiseaseAliasIndex?> getAllByAliasSync(List<String> aliasValues) {
    final values = aliasValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'alias', values);
  }

  Future<int> deleteAllByAlias(List<String> aliasValues) {
    final values = aliasValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'alias', values);
  }

  int deleteAllByAliasSync(List<String> aliasValues) {
    final values = aliasValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'alias', values);
  }

  Future<Id> putByAlias(DiseaseAliasIndex object) {
    return putByIndex(r'alias', object);
  }

  Id putByAliasSync(DiseaseAliasIndex object, {bool saveLinks = true}) {
    return putByIndexSync(r'alias', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByAlias(List<DiseaseAliasIndex> objects) {
    return putAllByIndex(r'alias', objects);
  }

  List<Id> putAllByAliasSync(List<DiseaseAliasIndex> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'alias', objects, saveLinks: saveLinks);
  }
}

extension DiseaseAliasIndexQueryWhereSort
    on QueryBuilder<DiseaseAliasIndex, DiseaseAliasIndex, QWhere> {
  QueryBuilder<DiseaseAliasIndex, DiseaseAliasIndex, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension DiseaseAliasIndexQueryWhere
    on QueryBuilder<DiseaseAliasIndex, DiseaseAliasIndex, QWhereClause> {
  QueryBuilder<DiseaseAliasIndex, DiseaseAliasIndex, QAfterWhereClause>
      idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<DiseaseAliasIndex, DiseaseAliasIndex, QAfterWhereClause>
      idNotEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<DiseaseAliasIndex, DiseaseAliasIndex, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<DiseaseAliasIndex, DiseaseAliasIndex, QAfterWhereClause>
      idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<DiseaseAliasIndex, DiseaseAliasIndex, QAfterWhereClause>
      idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<DiseaseAliasIndex, DiseaseAliasIndex, QAfterWhereClause>
      aliasEqualTo(String alias) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'alias',
        value: [alias],
      ));
    });
  }

  QueryBuilder<DiseaseAliasIndex, DiseaseAliasIndex, QAfterWhereClause>
      aliasNotEqualTo(String alias) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'alias',
              lower: [],
              upper: [alias],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'alias',
              lower: [alias],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'alias',
              lower: [alias],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'alias',
              lower: [],
              upper: [alias],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<DiseaseAliasIndex, DiseaseAliasIndex, QAfterWhereClause>
      canonicalDiseaseIdEqualTo(String canonicalDiseaseId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'canonicalDiseaseId',
        value: [canonicalDiseaseId],
      ));
    });
  }

  QueryBuilder<DiseaseAliasIndex, DiseaseAliasIndex, QAfterWhereClause>
      canonicalDiseaseIdNotEqualTo(String canonicalDiseaseId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'canonicalDiseaseId',
              lower: [],
              upper: [canonicalDiseaseId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'canonicalDiseaseId',
              lower: [canonicalDiseaseId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'canonicalDiseaseId',
              lower: [canonicalDiseaseId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'canonicalDiseaseId',
              lower: [],
              upper: [canonicalDiseaseId],
              includeUpper: false,
            ));
      }
    });
  }
}

extension DiseaseAliasIndexQueryFilter
    on QueryBuilder<DiseaseAliasIndex, DiseaseAliasIndex, QFilterCondition> {
  QueryBuilder<DiseaseAliasIndex, DiseaseAliasIndex, QAfterFilterCondition>
      aliasEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'alias',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DiseaseAliasIndex, DiseaseAliasIndex, QAfterFilterCondition>
      aliasGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'alias',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DiseaseAliasIndex, DiseaseAliasIndex, QAfterFilterCondition>
      aliasLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'alias',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DiseaseAliasIndex, DiseaseAliasIndex, QAfterFilterCondition>
      aliasBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'alias',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DiseaseAliasIndex, DiseaseAliasIndex, QAfterFilterCondition>
      aliasStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'alias',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DiseaseAliasIndex, DiseaseAliasIndex, QAfterFilterCondition>
      aliasEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'alias',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DiseaseAliasIndex, DiseaseAliasIndex, QAfterFilterCondition>
      aliasContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'alias',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DiseaseAliasIndex, DiseaseAliasIndex, QAfterFilterCondition>
      aliasMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'alias',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DiseaseAliasIndex, DiseaseAliasIndex, QAfterFilterCondition>
      aliasIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'alias',
        value: '',
      ));
    });
  }

  QueryBuilder<DiseaseAliasIndex, DiseaseAliasIndex, QAfterFilterCondition>
      aliasIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'alias',
        value: '',
      ));
    });
  }

  QueryBuilder<DiseaseAliasIndex, DiseaseAliasIndex, QAfterFilterCondition>
      canonicalDiseaseIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'canonicalDiseaseId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DiseaseAliasIndex, DiseaseAliasIndex, QAfterFilterCondition>
      canonicalDiseaseIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'canonicalDiseaseId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DiseaseAliasIndex, DiseaseAliasIndex, QAfterFilterCondition>
      canonicalDiseaseIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'canonicalDiseaseId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DiseaseAliasIndex, DiseaseAliasIndex, QAfterFilterCondition>
      canonicalDiseaseIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'canonicalDiseaseId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DiseaseAliasIndex, DiseaseAliasIndex, QAfterFilterCondition>
      canonicalDiseaseIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'canonicalDiseaseId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DiseaseAliasIndex, DiseaseAliasIndex, QAfterFilterCondition>
      canonicalDiseaseIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'canonicalDiseaseId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DiseaseAliasIndex, DiseaseAliasIndex, QAfterFilterCondition>
      canonicalDiseaseIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'canonicalDiseaseId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DiseaseAliasIndex, DiseaseAliasIndex, QAfterFilterCondition>
      canonicalDiseaseIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'canonicalDiseaseId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DiseaseAliasIndex, DiseaseAliasIndex, QAfterFilterCondition>
      canonicalDiseaseIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'canonicalDiseaseId',
        value: '',
      ));
    });
  }

  QueryBuilder<DiseaseAliasIndex, DiseaseAliasIndex, QAfterFilterCondition>
      canonicalDiseaseIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'canonicalDiseaseId',
        value: '',
      ));
    });
  }

  QueryBuilder<DiseaseAliasIndex, DiseaseAliasIndex, QAfterFilterCondition>
      idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<DiseaseAliasIndex, DiseaseAliasIndex, QAfterFilterCondition>
      idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<DiseaseAliasIndex, DiseaseAliasIndex, QAfterFilterCondition>
      idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<DiseaseAliasIndex, DiseaseAliasIndex, QAfterFilterCondition>
      idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension DiseaseAliasIndexQueryObject
    on QueryBuilder<DiseaseAliasIndex, DiseaseAliasIndex, QFilterCondition> {}

extension DiseaseAliasIndexQueryLinks
    on QueryBuilder<DiseaseAliasIndex, DiseaseAliasIndex, QFilterCondition> {}

extension DiseaseAliasIndexQuerySortBy
    on QueryBuilder<DiseaseAliasIndex, DiseaseAliasIndex, QSortBy> {
  QueryBuilder<DiseaseAliasIndex, DiseaseAliasIndex, QAfterSortBy>
      sortByAlias() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'alias', Sort.asc);
    });
  }

  QueryBuilder<DiseaseAliasIndex, DiseaseAliasIndex, QAfterSortBy>
      sortByAliasDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'alias', Sort.desc);
    });
  }

  QueryBuilder<DiseaseAliasIndex, DiseaseAliasIndex, QAfterSortBy>
      sortByCanonicalDiseaseId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'canonicalDiseaseId', Sort.asc);
    });
  }

  QueryBuilder<DiseaseAliasIndex, DiseaseAliasIndex, QAfterSortBy>
      sortByCanonicalDiseaseIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'canonicalDiseaseId', Sort.desc);
    });
  }
}

extension DiseaseAliasIndexQuerySortThenBy
    on QueryBuilder<DiseaseAliasIndex, DiseaseAliasIndex, QSortThenBy> {
  QueryBuilder<DiseaseAliasIndex, DiseaseAliasIndex, QAfterSortBy>
      thenByAlias() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'alias', Sort.asc);
    });
  }

  QueryBuilder<DiseaseAliasIndex, DiseaseAliasIndex, QAfterSortBy>
      thenByAliasDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'alias', Sort.desc);
    });
  }

  QueryBuilder<DiseaseAliasIndex, DiseaseAliasIndex, QAfterSortBy>
      thenByCanonicalDiseaseId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'canonicalDiseaseId', Sort.asc);
    });
  }

  QueryBuilder<DiseaseAliasIndex, DiseaseAliasIndex, QAfterSortBy>
      thenByCanonicalDiseaseIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'canonicalDiseaseId', Sort.desc);
    });
  }

  QueryBuilder<DiseaseAliasIndex, DiseaseAliasIndex, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<DiseaseAliasIndex, DiseaseAliasIndex, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }
}

extension DiseaseAliasIndexQueryWhereDistinct
    on QueryBuilder<DiseaseAliasIndex, DiseaseAliasIndex, QDistinct> {
  QueryBuilder<DiseaseAliasIndex, DiseaseAliasIndex, QDistinct> distinctByAlias(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'alias', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DiseaseAliasIndex, DiseaseAliasIndex, QDistinct>
      distinctByCanonicalDiseaseId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'canonicalDiseaseId',
          caseSensitive: caseSensitive);
    });
  }
}

extension DiseaseAliasIndexQueryProperty
    on QueryBuilder<DiseaseAliasIndex, DiseaseAliasIndex, QQueryProperty> {
  QueryBuilder<DiseaseAliasIndex, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<DiseaseAliasIndex, String, QQueryOperations> aliasProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'alias');
    });
  }

  QueryBuilder<DiseaseAliasIndex, String, QQueryOperations>
      canonicalDiseaseIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'canonicalDiseaseId');
    });
  }
}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetAppMetaCollection on Isar {
  IsarCollection<AppMeta> get appMetas => this.collection();
}

const AppMetaSchema = CollectionSchema(
  name: r'AppMeta',
  id: 7451756037581955749,
  properties: {
    r'createdAt': PropertySchema(
      id: 0,
      name: r'createdAt',
      type: IsarType.dateTime,
    ),
    r'diseasesJsonHash': PropertySchema(
      id: 1,
      name: r'diseasesJsonHash',
      type: IsarType.string,
    ),
    r'modelsJsonHash': PropertySchema(
      id: 2,
      name: r'modelsJsonHash',
      type: IsarType.string,
    ),
    r'recsJsonHash': PropertySchema(
      id: 3,
      name: r'recsJsonHash',
      type: IsarType.string,
    ),
    r'schemaVersion': PropertySchema(
      id: 4,
      name: r'schemaVersion',
      type: IsarType.long,
    ),
    r'updatedAt': PropertySchema(
      id: 5,
      name: r'updatedAt',
      type: IsarType.dateTime,
    )
  },
  estimateSize: _appMetaEstimateSize,
  serialize: _appMetaSerialize,
  deserialize: _appMetaDeserialize,
  deserializeProp: _appMetaDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _appMetaGetId,
  getLinks: _appMetaGetLinks,
  attach: _appMetaAttach,
  version: '3.1.0+1',
);

int _appMetaEstimateSize(
  AppMeta object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.diseasesJsonHash;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.modelsJsonHash;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.recsJsonHash;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _appMetaSerialize(
  AppMeta object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDateTime(offsets[0], object.createdAt);
  writer.writeString(offsets[1], object.diseasesJsonHash);
  writer.writeString(offsets[2], object.modelsJsonHash);
  writer.writeString(offsets[3], object.recsJsonHash);
  writer.writeLong(offsets[4], object.schemaVersion);
  writer.writeDateTime(offsets[5], object.updatedAt);
}

AppMeta _appMetaDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = AppMeta();
  object.createdAt = reader.readDateTime(offsets[0]);
  object.diseasesJsonHash = reader.readStringOrNull(offsets[1]);
  object.id = id;
  object.modelsJsonHash = reader.readStringOrNull(offsets[2]);
  object.recsJsonHash = reader.readStringOrNull(offsets[3]);
  object.schemaVersion = reader.readLong(offsets[4]);
  object.updatedAt = reader.readDateTime(offsets[5]);
  return object;
}

P _appMetaDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDateTime(offset)) as P;
    case 1:
      return (reader.readStringOrNull(offset)) as P;
    case 2:
      return (reader.readStringOrNull(offset)) as P;
    case 3:
      return (reader.readStringOrNull(offset)) as P;
    case 4:
      return (reader.readLong(offset)) as P;
    case 5:
      return (reader.readDateTime(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _appMetaGetId(AppMeta object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _appMetaGetLinks(AppMeta object) {
  return [];
}

void _appMetaAttach(IsarCollection<dynamic> col, Id id, AppMeta object) {
  object.id = id;
}

extension AppMetaQueryWhereSort on QueryBuilder<AppMeta, AppMeta, QWhere> {
  QueryBuilder<AppMeta, AppMeta, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension AppMetaQueryWhere on QueryBuilder<AppMeta, AppMeta, QWhereClause> {
  QueryBuilder<AppMeta, AppMeta, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<AppMeta, AppMeta, QAfterWhereClause> idNotEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<AppMeta, AppMeta, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<AppMeta, AppMeta, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<AppMeta, AppMeta, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension AppMetaQueryFilter
    on QueryBuilder<AppMeta, AppMeta, QFilterCondition> {
  QueryBuilder<AppMeta, AppMeta, QAfterFilterCondition> createdAtEqualTo(
      DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<AppMeta, AppMeta, QAfterFilterCondition> createdAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<AppMeta, AppMeta, QAfterFilterCondition> createdAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<AppMeta, AppMeta, QAfterFilterCondition> createdAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'createdAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<AppMeta, AppMeta, QAfterFilterCondition>
      diseasesJsonHashIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'diseasesJsonHash',
      ));
    });
  }

  QueryBuilder<AppMeta, AppMeta, QAfterFilterCondition>
      diseasesJsonHashIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'diseasesJsonHash',
      ));
    });
  }

  QueryBuilder<AppMeta, AppMeta, QAfterFilterCondition> diseasesJsonHashEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'diseasesJsonHash',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppMeta, AppMeta, QAfterFilterCondition>
      diseasesJsonHashGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'diseasesJsonHash',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppMeta, AppMeta, QAfterFilterCondition>
      diseasesJsonHashLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'diseasesJsonHash',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppMeta, AppMeta, QAfterFilterCondition> diseasesJsonHashBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'diseasesJsonHash',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppMeta, AppMeta, QAfterFilterCondition>
      diseasesJsonHashStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'diseasesJsonHash',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppMeta, AppMeta, QAfterFilterCondition>
      diseasesJsonHashEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'diseasesJsonHash',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppMeta, AppMeta, QAfterFilterCondition>
      diseasesJsonHashContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'diseasesJsonHash',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppMeta, AppMeta, QAfterFilterCondition> diseasesJsonHashMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'diseasesJsonHash',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppMeta, AppMeta, QAfterFilterCondition>
      diseasesJsonHashIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'diseasesJsonHash',
        value: '',
      ));
    });
  }

  QueryBuilder<AppMeta, AppMeta, QAfterFilterCondition>
      diseasesJsonHashIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'diseasesJsonHash',
        value: '',
      ));
    });
  }

  QueryBuilder<AppMeta, AppMeta, QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<AppMeta, AppMeta, QAfterFilterCondition> idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<AppMeta, AppMeta, QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<AppMeta, AppMeta, QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<AppMeta, AppMeta, QAfterFilterCondition> modelsJsonHashIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'modelsJsonHash',
      ));
    });
  }

  QueryBuilder<AppMeta, AppMeta, QAfterFilterCondition>
      modelsJsonHashIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'modelsJsonHash',
      ));
    });
  }

  QueryBuilder<AppMeta, AppMeta, QAfterFilterCondition> modelsJsonHashEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'modelsJsonHash',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppMeta, AppMeta, QAfterFilterCondition>
      modelsJsonHashGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'modelsJsonHash',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppMeta, AppMeta, QAfterFilterCondition> modelsJsonHashLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'modelsJsonHash',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppMeta, AppMeta, QAfterFilterCondition> modelsJsonHashBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'modelsJsonHash',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppMeta, AppMeta, QAfterFilterCondition>
      modelsJsonHashStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'modelsJsonHash',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppMeta, AppMeta, QAfterFilterCondition> modelsJsonHashEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'modelsJsonHash',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppMeta, AppMeta, QAfterFilterCondition> modelsJsonHashContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'modelsJsonHash',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppMeta, AppMeta, QAfterFilterCondition> modelsJsonHashMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'modelsJsonHash',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppMeta, AppMeta, QAfterFilterCondition>
      modelsJsonHashIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'modelsJsonHash',
        value: '',
      ));
    });
  }

  QueryBuilder<AppMeta, AppMeta, QAfterFilterCondition>
      modelsJsonHashIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'modelsJsonHash',
        value: '',
      ));
    });
  }

  QueryBuilder<AppMeta, AppMeta, QAfterFilterCondition> recsJsonHashIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'recsJsonHash',
      ));
    });
  }

  QueryBuilder<AppMeta, AppMeta, QAfterFilterCondition>
      recsJsonHashIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'recsJsonHash',
      ));
    });
  }

  QueryBuilder<AppMeta, AppMeta, QAfterFilterCondition> recsJsonHashEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'recsJsonHash',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppMeta, AppMeta, QAfterFilterCondition> recsJsonHashGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'recsJsonHash',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppMeta, AppMeta, QAfterFilterCondition> recsJsonHashLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'recsJsonHash',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppMeta, AppMeta, QAfterFilterCondition> recsJsonHashBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'recsJsonHash',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppMeta, AppMeta, QAfterFilterCondition> recsJsonHashStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'recsJsonHash',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppMeta, AppMeta, QAfterFilterCondition> recsJsonHashEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'recsJsonHash',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppMeta, AppMeta, QAfterFilterCondition> recsJsonHashContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'recsJsonHash',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppMeta, AppMeta, QAfterFilterCondition> recsJsonHashMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'recsJsonHash',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppMeta, AppMeta, QAfterFilterCondition> recsJsonHashIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'recsJsonHash',
        value: '',
      ));
    });
  }

  QueryBuilder<AppMeta, AppMeta, QAfterFilterCondition>
      recsJsonHashIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'recsJsonHash',
        value: '',
      ));
    });
  }

  QueryBuilder<AppMeta, AppMeta, QAfterFilterCondition> schemaVersionEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'schemaVersion',
        value: value,
      ));
    });
  }

  QueryBuilder<AppMeta, AppMeta, QAfterFilterCondition>
      schemaVersionGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'schemaVersion',
        value: value,
      ));
    });
  }

  QueryBuilder<AppMeta, AppMeta, QAfterFilterCondition> schemaVersionLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'schemaVersion',
        value: value,
      ));
    });
  }

  QueryBuilder<AppMeta, AppMeta, QAfterFilterCondition> schemaVersionBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'schemaVersion',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<AppMeta, AppMeta, QAfterFilterCondition> updatedAtEqualTo(
      DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<AppMeta, AppMeta, QAfterFilterCondition> updatedAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<AppMeta, AppMeta, QAfterFilterCondition> updatedAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<AppMeta, AppMeta, QAfterFilterCondition> updatedAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'updatedAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension AppMetaQueryObject
    on QueryBuilder<AppMeta, AppMeta, QFilterCondition> {}

extension AppMetaQueryLinks
    on QueryBuilder<AppMeta, AppMeta, QFilterCondition> {}

extension AppMetaQuerySortBy on QueryBuilder<AppMeta, AppMeta, QSortBy> {
  QueryBuilder<AppMeta, AppMeta, QAfterSortBy> sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<AppMeta, AppMeta, QAfterSortBy> sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<AppMeta, AppMeta, QAfterSortBy> sortByDiseasesJsonHash() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'diseasesJsonHash', Sort.asc);
    });
  }

  QueryBuilder<AppMeta, AppMeta, QAfterSortBy> sortByDiseasesJsonHashDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'diseasesJsonHash', Sort.desc);
    });
  }

  QueryBuilder<AppMeta, AppMeta, QAfterSortBy> sortByModelsJsonHash() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'modelsJsonHash', Sort.asc);
    });
  }

  QueryBuilder<AppMeta, AppMeta, QAfterSortBy> sortByModelsJsonHashDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'modelsJsonHash', Sort.desc);
    });
  }

  QueryBuilder<AppMeta, AppMeta, QAfterSortBy> sortByRecsJsonHash() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'recsJsonHash', Sort.asc);
    });
  }

  QueryBuilder<AppMeta, AppMeta, QAfterSortBy> sortByRecsJsonHashDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'recsJsonHash', Sort.desc);
    });
  }

  QueryBuilder<AppMeta, AppMeta, QAfterSortBy> sortBySchemaVersion() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'schemaVersion', Sort.asc);
    });
  }

  QueryBuilder<AppMeta, AppMeta, QAfterSortBy> sortBySchemaVersionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'schemaVersion', Sort.desc);
    });
  }

  QueryBuilder<AppMeta, AppMeta, QAfterSortBy> sortByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<AppMeta, AppMeta, QAfterSortBy> sortByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension AppMetaQuerySortThenBy
    on QueryBuilder<AppMeta, AppMeta, QSortThenBy> {
  QueryBuilder<AppMeta, AppMeta, QAfterSortBy> thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<AppMeta, AppMeta, QAfterSortBy> thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<AppMeta, AppMeta, QAfterSortBy> thenByDiseasesJsonHash() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'diseasesJsonHash', Sort.asc);
    });
  }

  QueryBuilder<AppMeta, AppMeta, QAfterSortBy> thenByDiseasesJsonHashDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'diseasesJsonHash', Sort.desc);
    });
  }

  QueryBuilder<AppMeta, AppMeta, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<AppMeta, AppMeta, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<AppMeta, AppMeta, QAfterSortBy> thenByModelsJsonHash() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'modelsJsonHash', Sort.asc);
    });
  }

  QueryBuilder<AppMeta, AppMeta, QAfterSortBy> thenByModelsJsonHashDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'modelsJsonHash', Sort.desc);
    });
  }

  QueryBuilder<AppMeta, AppMeta, QAfterSortBy> thenByRecsJsonHash() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'recsJsonHash', Sort.asc);
    });
  }

  QueryBuilder<AppMeta, AppMeta, QAfterSortBy> thenByRecsJsonHashDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'recsJsonHash', Sort.desc);
    });
  }

  QueryBuilder<AppMeta, AppMeta, QAfterSortBy> thenBySchemaVersion() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'schemaVersion', Sort.asc);
    });
  }

  QueryBuilder<AppMeta, AppMeta, QAfterSortBy> thenBySchemaVersionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'schemaVersion', Sort.desc);
    });
  }

  QueryBuilder<AppMeta, AppMeta, QAfterSortBy> thenByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<AppMeta, AppMeta, QAfterSortBy> thenByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension AppMetaQueryWhereDistinct
    on QueryBuilder<AppMeta, AppMeta, QDistinct> {
  QueryBuilder<AppMeta, AppMeta, QDistinct> distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<AppMeta, AppMeta, QDistinct> distinctByDiseasesJsonHash(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'diseasesJsonHash',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<AppMeta, AppMeta, QDistinct> distinctByModelsJsonHash(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'modelsJsonHash',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<AppMeta, AppMeta, QDistinct> distinctByRecsJsonHash(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'recsJsonHash', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<AppMeta, AppMeta, QDistinct> distinctBySchemaVersion() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'schemaVersion');
    });
  }

  QueryBuilder<AppMeta, AppMeta, QDistinct> distinctByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'updatedAt');
    });
  }
}

extension AppMetaQueryProperty
    on QueryBuilder<AppMeta, AppMeta, QQueryProperty> {
  QueryBuilder<AppMeta, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<AppMeta, DateTime, QQueryOperations> createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<AppMeta, String?, QQueryOperations> diseasesJsonHashProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'diseasesJsonHash');
    });
  }

  QueryBuilder<AppMeta, String?, QQueryOperations> modelsJsonHashProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'modelsJsonHash');
    });
  }

  QueryBuilder<AppMeta, String?, QQueryOperations> recsJsonHashProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'recsJsonHash');
    });
  }

  QueryBuilder<AppMeta, int, QQueryOperations> schemaVersionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'schemaVersion');
    });
  }

  QueryBuilder<AppMeta, DateTime, QQueryOperations> updatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'updatedAt');
    });
  }
}
