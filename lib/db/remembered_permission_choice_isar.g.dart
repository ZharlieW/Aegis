// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'remembered_permission_choice_isar.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetRememberedPermissionChoiceDBISARCollection on Isar {
  IsarCollection<RememberedPermissionChoiceDBISAR>
      get rememberedPermissionChoiceDBISARs => this.collection();
}

const RememberedPermissionChoiceDBISARSchema = CollectionSchema(
  name: r'RememberedPermissionChoiceDBISAR',
  id: 5845900753945841556,
  properties: {
    r'clientPubkey': PropertySchema(
      id: 0,
      name: r'clientPubkey',
      type: IsarType.string,
    ),
    r'expiresAtMs': PropertySchema(
      id: 1,
      name: r'expiresAtMs',
      type: IsarType.long,
    ),
    r'methodKey': PropertySchema(
      id: 2,
      name: r'methodKey',
      type: IsarType.string,
    )
  },
  estimateSize: _rememberedPermissionChoiceDBISAREstimateSize,
  serialize: _rememberedPermissionChoiceDBISARSerialize,
  deserialize: _rememberedPermissionChoiceDBISARDeserialize,
  deserializeProp: _rememberedPermissionChoiceDBISARDeserializeProp,
  idName: r'id',
  indexes: {
    r'clientPubkey': IndexSchema(
      id: -8083150296402950608,
      name: r'clientPubkey',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'clientPubkey',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _rememberedPermissionChoiceDBISARGetId,
  getLinks: _rememberedPermissionChoiceDBISARGetLinks,
  attach: _rememberedPermissionChoiceDBISARAttach,
  version: '3.1.0+1',
);

int _rememberedPermissionChoiceDBISAREstimateSize(
  RememberedPermissionChoiceDBISAR object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.clientPubkey.length * 3;
  bytesCount += 3 + object.methodKey.length * 3;
  return bytesCount;
}

void _rememberedPermissionChoiceDBISARSerialize(
  RememberedPermissionChoiceDBISAR object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.clientPubkey);
  writer.writeLong(offsets[1], object.expiresAtMs);
  writer.writeString(offsets[2], object.methodKey);
}

RememberedPermissionChoiceDBISAR _rememberedPermissionChoiceDBISARDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = RememberedPermissionChoiceDBISAR(
    clientPubkey: reader.readString(offsets[0]),
    expiresAtMs: reader.readLong(offsets[1]),
    methodKey: reader.readString(offsets[2]),
  );
  object.id = id;
  return object;
}

P _rememberedPermissionChoiceDBISARDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readLong(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _rememberedPermissionChoiceDBISARGetId(
    RememberedPermissionChoiceDBISAR object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _rememberedPermissionChoiceDBISARGetLinks(
    RememberedPermissionChoiceDBISAR object) {
  return [];
}

void _rememberedPermissionChoiceDBISARAttach(IsarCollection<dynamic> col, Id id,
    RememberedPermissionChoiceDBISAR object) {
  object.id = id;
}

extension RememberedPermissionChoiceDBISARQueryWhereSort on QueryBuilder<
    RememberedPermissionChoiceDBISAR,
    RememberedPermissionChoiceDBISAR,
    QWhere> {
  QueryBuilder<RememberedPermissionChoiceDBISAR,
      RememberedPermissionChoiceDBISAR, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension RememberedPermissionChoiceDBISARQueryWhere on QueryBuilder<
    RememberedPermissionChoiceDBISAR,
    RememberedPermissionChoiceDBISAR,
    QWhereClause> {
  QueryBuilder<RememberedPermissionChoiceDBISAR,
      RememberedPermissionChoiceDBISAR, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<RememberedPermissionChoiceDBISAR,
      RememberedPermissionChoiceDBISAR, QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<
      RememberedPermissionChoiceDBISAR,
      RememberedPermissionChoiceDBISAR,
      QAfterWhereClause> idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<
      RememberedPermissionChoiceDBISAR,
      RememberedPermissionChoiceDBISAR,
      QAfterWhereClause> idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<RememberedPermissionChoiceDBISAR,
      RememberedPermissionChoiceDBISAR, QAfterWhereClause> idBetween(
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

  QueryBuilder<
      RememberedPermissionChoiceDBISAR,
      RememberedPermissionChoiceDBISAR,
      QAfterWhereClause> clientPubkeyEqualTo(String clientPubkey) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'clientPubkey',
        value: [clientPubkey],
      ));
    });
  }

  QueryBuilder<
      RememberedPermissionChoiceDBISAR,
      RememberedPermissionChoiceDBISAR,
      QAfterWhereClause> clientPubkeyNotEqualTo(String clientPubkey) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'clientPubkey',
              lower: [],
              upper: [clientPubkey],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'clientPubkey',
              lower: [clientPubkey],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'clientPubkey',
              lower: [clientPubkey],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'clientPubkey',
              lower: [],
              upper: [clientPubkey],
              includeUpper: false,
            ));
      }
    });
  }
}

extension RememberedPermissionChoiceDBISARQueryFilter on QueryBuilder<
    RememberedPermissionChoiceDBISAR,
    RememberedPermissionChoiceDBISAR,
    QFilterCondition> {
  QueryBuilder<
      RememberedPermissionChoiceDBISAR,
      RememberedPermissionChoiceDBISAR,
      QAfterFilterCondition> clientPubkeyEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'clientPubkey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<
      RememberedPermissionChoiceDBISAR,
      RememberedPermissionChoiceDBISAR,
      QAfterFilterCondition> clientPubkeyGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'clientPubkey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<
      RememberedPermissionChoiceDBISAR,
      RememberedPermissionChoiceDBISAR,
      QAfterFilterCondition> clientPubkeyLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'clientPubkey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<
      RememberedPermissionChoiceDBISAR,
      RememberedPermissionChoiceDBISAR,
      QAfterFilterCondition> clientPubkeyBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'clientPubkey',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<
      RememberedPermissionChoiceDBISAR,
      RememberedPermissionChoiceDBISAR,
      QAfterFilterCondition> clientPubkeyStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'clientPubkey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<
      RememberedPermissionChoiceDBISAR,
      RememberedPermissionChoiceDBISAR,
      QAfterFilterCondition> clientPubkeyEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'clientPubkey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RememberedPermissionChoiceDBISAR,
          RememberedPermissionChoiceDBISAR, QAfterFilterCondition>
      clientPubkeyContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'clientPubkey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RememberedPermissionChoiceDBISAR,
          RememberedPermissionChoiceDBISAR, QAfterFilterCondition>
      clientPubkeyMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'clientPubkey',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<
      RememberedPermissionChoiceDBISAR,
      RememberedPermissionChoiceDBISAR,
      QAfterFilterCondition> clientPubkeyIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'clientPubkey',
        value: '',
      ));
    });
  }

  QueryBuilder<
      RememberedPermissionChoiceDBISAR,
      RememberedPermissionChoiceDBISAR,
      QAfterFilterCondition> clientPubkeyIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'clientPubkey',
        value: '',
      ));
    });
  }

  QueryBuilder<
      RememberedPermissionChoiceDBISAR,
      RememberedPermissionChoiceDBISAR,
      QAfterFilterCondition> expiresAtMsEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'expiresAtMs',
        value: value,
      ));
    });
  }

  QueryBuilder<
      RememberedPermissionChoiceDBISAR,
      RememberedPermissionChoiceDBISAR,
      QAfterFilterCondition> expiresAtMsGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'expiresAtMs',
        value: value,
      ));
    });
  }

  QueryBuilder<
      RememberedPermissionChoiceDBISAR,
      RememberedPermissionChoiceDBISAR,
      QAfterFilterCondition> expiresAtMsLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'expiresAtMs',
        value: value,
      ));
    });
  }

  QueryBuilder<
      RememberedPermissionChoiceDBISAR,
      RememberedPermissionChoiceDBISAR,
      QAfterFilterCondition> expiresAtMsBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'expiresAtMs',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<
      RememberedPermissionChoiceDBISAR,
      RememberedPermissionChoiceDBISAR,
      QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<RememberedPermissionChoiceDBISAR,
      RememberedPermissionChoiceDBISAR, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<RememberedPermissionChoiceDBISAR,
      RememberedPermissionChoiceDBISAR, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<RememberedPermissionChoiceDBISAR,
      RememberedPermissionChoiceDBISAR, QAfterFilterCondition> idBetween(
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

  QueryBuilder<RememberedPermissionChoiceDBISAR,
      RememberedPermissionChoiceDBISAR, QAfterFilterCondition> methodKeyEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'methodKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<
      RememberedPermissionChoiceDBISAR,
      RememberedPermissionChoiceDBISAR,
      QAfterFilterCondition> methodKeyGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'methodKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<
      RememberedPermissionChoiceDBISAR,
      RememberedPermissionChoiceDBISAR,
      QAfterFilterCondition> methodKeyLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'methodKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RememberedPermissionChoiceDBISAR,
      RememberedPermissionChoiceDBISAR, QAfterFilterCondition> methodKeyBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'methodKey',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<
      RememberedPermissionChoiceDBISAR,
      RememberedPermissionChoiceDBISAR,
      QAfterFilterCondition> methodKeyStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'methodKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<
      RememberedPermissionChoiceDBISAR,
      RememberedPermissionChoiceDBISAR,
      QAfterFilterCondition> methodKeyEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'methodKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RememberedPermissionChoiceDBISAR,
          RememberedPermissionChoiceDBISAR, QAfterFilterCondition>
      methodKeyContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'methodKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RememberedPermissionChoiceDBISAR,
          RememberedPermissionChoiceDBISAR, QAfterFilterCondition>
      methodKeyMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'methodKey',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<
      RememberedPermissionChoiceDBISAR,
      RememberedPermissionChoiceDBISAR,
      QAfterFilterCondition> methodKeyIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'methodKey',
        value: '',
      ));
    });
  }

  QueryBuilder<
      RememberedPermissionChoiceDBISAR,
      RememberedPermissionChoiceDBISAR,
      QAfterFilterCondition> methodKeyIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'methodKey',
        value: '',
      ));
    });
  }
}

extension RememberedPermissionChoiceDBISARQueryObject on QueryBuilder<
    RememberedPermissionChoiceDBISAR,
    RememberedPermissionChoiceDBISAR,
    QFilterCondition> {}

extension RememberedPermissionChoiceDBISARQueryLinks on QueryBuilder<
    RememberedPermissionChoiceDBISAR,
    RememberedPermissionChoiceDBISAR,
    QFilterCondition> {}

extension RememberedPermissionChoiceDBISARQuerySortBy on QueryBuilder<
    RememberedPermissionChoiceDBISAR,
    RememberedPermissionChoiceDBISAR,
    QSortBy> {
  QueryBuilder<RememberedPermissionChoiceDBISAR,
      RememberedPermissionChoiceDBISAR, QAfterSortBy> sortByClientPubkey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'clientPubkey', Sort.asc);
    });
  }

  QueryBuilder<RememberedPermissionChoiceDBISAR,
      RememberedPermissionChoiceDBISAR, QAfterSortBy> sortByClientPubkeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'clientPubkey', Sort.desc);
    });
  }

  QueryBuilder<RememberedPermissionChoiceDBISAR,
      RememberedPermissionChoiceDBISAR, QAfterSortBy> sortByExpiresAtMs() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'expiresAtMs', Sort.asc);
    });
  }

  QueryBuilder<RememberedPermissionChoiceDBISAR,
      RememberedPermissionChoiceDBISAR, QAfterSortBy> sortByExpiresAtMsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'expiresAtMs', Sort.desc);
    });
  }

  QueryBuilder<RememberedPermissionChoiceDBISAR,
      RememberedPermissionChoiceDBISAR, QAfterSortBy> sortByMethodKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'methodKey', Sort.asc);
    });
  }

  QueryBuilder<RememberedPermissionChoiceDBISAR,
      RememberedPermissionChoiceDBISAR, QAfterSortBy> sortByMethodKeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'methodKey', Sort.desc);
    });
  }
}

extension RememberedPermissionChoiceDBISARQuerySortThenBy on QueryBuilder<
    RememberedPermissionChoiceDBISAR,
    RememberedPermissionChoiceDBISAR,
    QSortThenBy> {
  QueryBuilder<RememberedPermissionChoiceDBISAR,
      RememberedPermissionChoiceDBISAR, QAfterSortBy> thenByClientPubkey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'clientPubkey', Sort.asc);
    });
  }

  QueryBuilder<RememberedPermissionChoiceDBISAR,
      RememberedPermissionChoiceDBISAR, QAfterSortBy> thenByClientPubkeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'clientPubkey', Sort.desc);
    });
  }

  QueryBuilder<RememberedPermissionChoiceDBISAR,
      RememberedPermissionChoiceDBISAR, QAfterSortBy> thenByExpiresAtMs() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'expiresAtMs', Sort.asc);
    });
  }

  QueryBuilder<RememberedPermissionChoiceDBISAR,
      RememberedPermissionChoiceDBISAR, QAfterSortBy> thenByExpiresAtMsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'expiresAtMs', Sort.desc);
    });
  }

  QueryBuilder<RememberedPermissionChoiceDBISAR,
      RememberedPermissionChoiceDBISAR, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<RememberedPermissionChoiceDBISAR,
      RememberedPermissionChoiceDBISAR, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<RememberedPermissionChoiceDBISAR,
      RememberedPermissionChoiceDBISAR, QAfterSortBy> thenByMethodKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'methodKey', Sort.asc);
    });
  }

  QueryBuilder<RememberedPermissionChoiceDBISAR,
      RememberedPermissionChoiceDBISAR, QAfterSortBy> thenByMethodKeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'methodKey', Sort.desc);
    });
  }
}

extension RememberedPermissionChoiceDBISARQueryWhereDistinct on QueryBuilder<
    RememberedPermissionChoiceDBISAR,
    RememberedPermissionChoiceDBISAR,
    QDistinct> {
  QueryBuilder<
      RememberedPermissionChoiceDBISAR,
      RememberedPermissionChoiceDBISAR,
      QDistinct> distinctByClientPubkey({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'clientPubkey', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<RememberedPermissionChoiceDBISAR,
      RememberedPermissionChoiceDBISAR, QDistinct> distinctByExpiresAtMs() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'expiresAtMs');
    });
  }

  QueryBuilder<
      RememberedPermissionChoiceDBISAR,
      RememberedPermissionChoiceDBISAR,
      QDistinct> distinctByMethodKey({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'methodKey', caseSensitive: caseSensitive);
    });
  }
}

extension RememberedPermissionChoiceDBISARQueryProperty on QueryBuilder<
    RememberedPermissionChoiceDBISAR,
    RememberedPermissionChoiceDBISAR,
    QQueryProperty> {
  QueryBuilder<RememberedPermissionChoiceDBISAR, int, QQueryOperations>
      idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<RememberedPermissionChoiceDBISAR, String, QQueryOperations>
      clientPubkeyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'clientPubkey');
    });
  }

  QueryBuilder<RememberedPermissionChoiceDBISAR, int, QQueryOperations>
      expiresAtMsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'expiresAtMs');
    });
  }

  QueryBuilder<RememberedPermissionChoiceDBISAR, String, QQueryOperations>
      methodKeyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'methodKey');
    });
  }
}
