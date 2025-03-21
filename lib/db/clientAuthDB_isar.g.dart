// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'clientAuthDB_isar.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetClientAuthDBISARCollection on Isar {
  IsarCollection<ClientAuthDBISAR> get clientAuthDBISARs => this.collection();
}

const ClientAuthDBISARSchema = CollectionSchema(
  name: r'ClientAuthDBISAR',
  id: 5001039612412717542,
  properties: {
    r'clientPubkey': PropertySchema(
      id: 0,
      name: r'clientPubkey',
      type: IsarType.string,
    ),
    r'isAuthorized': PropertySchema(
      id: 1,
      name: r'isAuthorized',
      type: IsarType.bool,
    ),
    r'pubkey': PropertySchema(
      id: 2,
      name: r'pubkey',
      type: IsarType.string,
    )
  },
  estimateSize: _clientAuthDBISAREstimateSize,
  serialize: _clientAuthDBISARSerialize,
  deserialize: _clientAuthDBISARDeserialize,
  deserializeProp: _clientAuthDBISARDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _clientAuthDBISARGetId,
  getLinks: _clientAuthDBISARGetLinks,
  attach: _clientAuthDBISARAttach,
  version: '3.1.0+1',
);

int _clientAuthDBISAREstimateSize(
  ClientAuthDBISAR object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.clientPubkey.length * 3;
  bytesCount += 3 + object.pubkey.length * 3;
  return bytesCount;
}

void _clientAuthDBISARSerialize(
  ClientAuthDBISAR object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.clientPubkey);
  writer.writeBool(offsets[1], object.isAuthorized);
  writer.writeString(offsets[2], object.pubkey);
}

ClientAuthDBISAR _clientAuthDBISARDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = ClientAuthDBISAR(
    clientPubkey: reader.readString(offsets[0]),
    isAuthorized: reader.readBool(offsets[1]),
    pubkey: reader.readString(offsets[2]),
  );
  object.id = id;
  return object;
}

P _clientAuthDBISARDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readBool(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _clientAuthDBISARGetId(ClientAuthDBISAR object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _clientAuthDBISARGetLinks(ClientAuthDBISAR object) {
  return [];
}

void _clientAuthDBISARAttach(
    IsarCollection<dynamic> col, Id id, ClientAuthDBISAR object) {
  object.id = id;
}

extension ClientAuthDBISARQueryWhereSort
    on QueryBuilder<ClientAuthDBISAR, ClientAuthDBISAR, QWhere> {
  QueryBuilder<ClientAuthDBISAR, ClientAuthDBISAR, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension ClientAuthDBISARQueryWhere
    on QueryBuilder<ClientAuthDBISAR, ClientAuthDBISAR, QWhereClause> {
  QueryBuilder<ClientAuthDBISAR, ClientAuthDBISAR, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<ClientAuthDBISAR, ClientAuthDBISAR, QAfterWhereClause>
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

  QueryBuilder<ClientAuthDBISAR, ClientAuthDBISAR, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<ClientAuthDBISAR, ClientAuthDBISAR, QAfterWhereClause>
      idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<ClientAuthDBISAR, ClientAuthDBISAR, QAfterWhereClause> idBetween(
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

extension ClientAuthDBISARQueryFilter
    on QueryBuilder<ClientAuthDBISAR, ClientAuthDBISAR, QFilterCondition> {
  QueryBuilder<ClientAuthDBISAR, ClientAuthDBISAR, QAfterFilterCondition>
      clientPubkeyEqualTo(
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

  QueryBuilder<ClientAuthDBISAR, ClientAuthDBISAR, QAfterFilterCondition>
      clientPubkeyGreaterThan(
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

  QueryBuilder<ClientAuthDBISAR, ClientAuthDBISAR, QAfterFilterCondition>
      clientPubkeyLessThan(
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

  QueryBuilder<ClientAuthDBISAR, ClientAuthDBISAR, QAfterFilterCondition>
      clientPubkeyBetween(
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

  QueryBuilder<ClientAuthDBISAR, ClientAuthDBISAR, QAfterFilterCondition>
      clientPubkeyStartsWith(
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

  QueryBuilder<ClientAuthDBISAR, ClientAuthDBISAR, QAfterFilterCondition>
      clientPubkeyEndsWith(
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

  QueryBuilder<ClientAuthDBISAR, ClientAuthDBISAR, QAfterFilterCondition>
      clientPubkeyContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'clientPubkey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ClientAuthDBISAR, ClientAuthDBISAR, QAfterFilterCondition>
      clientPubkeyMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'clientPubkey',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ClientAuthDBISAR, ClientAuthDBISAR, QAfterFilterCondition>
      clientPubkeyIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'clientPubkey',
        value: '',
      ));
    });
  }

  QueryBuilder<ClientAuthDBISAR, ClientAuthDBISAR, QAfterFilterCondition>
      clientPubkeyIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'clientPubkey',
        value: '',
      ));
    });
  }

  QueryBuilder<ClientAuthDBISAR, ClientAuthDBISAR, QAfterFilterCondition>
      idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<ClientAuthDBISAR, ClientAuthDBISAR, QAfterFilterCondition>
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

  QueryBuilder<ClientAuthDBISAR, ClientAuthDBISAR, QAfterFilterCondition>
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

  QueryBuilder<ClientAuthDBISAR, ClientAuthDBISAR, QAfterFilterCondition>
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

  QueryBuilder<ClientAuthDBISAR, ClientAuthDBISAR, QAfterFilterCondition>
      isAuthorizedEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isAuthorized',
        value: value,
      ));
    });
  }

  QueryBuilder<ClientAuthDBISAR, ClientAuthDBISAR, QAfterFilterCondition>
      pubkeyEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'pubkey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ClientAuthDBISAR, ClientAuthDBISAR, QAfterFilterCondition>
      pubkeyGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'pubkey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ClientAuthDBISAR, ClientAuthDBISAR, QAfterFilterCondition>
      pubkeyLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'pubkey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ClientAuthDBISAR, ClientAuthDBISAR, QAfterFilterCondition>
      pubkeyBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'pubkey',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ClientAuthDBISAR, ClientAuthDBISAR, QAfterFilterCondition>
      pubkeyStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'pubkey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ClientAuthDBISAR, ClientAuthDBISAR, QAfterFilterCondition>
      pubkeyEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'pubkey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ClientAuthDBISAR, ClientAuthDBISAR, QAfterFilterCondition>
      pubkeyContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'pubkey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ClientAuthDBISAR, ClientAuthDBISAR, QAfterFilterCondition>
      pubkeyMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'pubkey',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ClientAuthDBISAR, ClientAuthDBISAR, QAfterFilterCondition>
      pubkeyIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'pubkey',
        value: '',
      ));
    });
  }

  QueryBuilder<ClientAuthDBISAR, ClientAuthDBISAR, QAfterFilterCondition>
      pubkeyIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'pubkey',
        value: '',
      ));
    });
  }
}

extension ClientAuthDBISARQueryObject
    on QueryBuilder<ClientAuthDBISAR, ClientAuthDBISAR, QFilterCondition> {}

extension ClientAuthDBISARQueryLinks
    on QueryBuilder<ClientAuthDBISAR, ClientAuthDBISAR, QFilterCondition> {}

extension ClientAuthDBISARQuerySortBy
    on QueryBuilder<ClientAuthDBISAR, ClientAuthDBISAR, QSortBy> {
  QueryBuilder<ClientAuthDBISAR, ClientAuthDBISAR, QAfterSortBy>
      sortByClientPubkey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'clientPubkey', Sort.asc);
    });
  }

  QueryBuilder<ClientAuthDBISAR, ClientAuthDBISAR, QAfterSortBy>
      sortByClientPubkeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'clientPubkey', Sort.desc);
    });
  }

  QueryBuilder<ClientAuthDBISAR, ClientAuthDBISAR, QAfterSortBy>
      sortByIsAuthorized() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isAuthorized', Sort.asc);
    });
  }

  QueryBuilder<ClientAuthDBISAR, ClientAuthDBISAR, QAfterSortBy>
      sortByIsAuthorizedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isAuthorized', Sort.desc);
    });
  }

  QueryBuilder<ClientAuthDBISAR, ClientAuthDBISAR, QAfterSortBy>
      sortByPubkey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pubkey', Sort.asc);
    });
  }

  QueryBuilder<ClientAuthDBISAR, ClientAuthDBISAR, QAfterSortBy>
      sortByPubkeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pubkey', Sort.desc);
    });
  }
}

extension ClientAuthDBISARQuerySortThenBy
    on QueryBuilder<ClientAuthDBISAR, ClientAuthDBISAR, QSortThenBy> {
  QueryBuilder<ClientAuthDBISAR, ClientAuthDBISAR, QAfterSortBy>
      thenByClientPubkey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'clientPubkey', Sort.asc);
    });
  }

  QueryBuilder<ClientAuthDBISAR, ClientAuthDBISAR, QAfterSortBy>
      thenByClientPubkeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'clientPubkey', Sort.desc);
    });
  }

  QueryBuilder<ClientAuthDBISAR, ClientAuthDBISAR, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<ClientAuthDBISAR, ClientAuthDBISAR, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<ClientAuthDBISAR, ClientAuthDBISAR, QAfterSortBy>
      thenByIsAuthorized() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isAuthorized', Sort.asc);
    });
  }

  QueryBuilder<ClientAuthDBISAR, ClientAuthDBISAR, QAfterSortBy>
      thenByIsAuthorizedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isAuthorized', Sort.desc);
    });
  }

  QueryBuilder<ClientAuthDBISAR, ClientAuthDBISAR, QAfterSortBy>
      thenByPubkey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pubkey', Sort.asc);
    });
  }

  QueryBuilder<ClientAuthDBISAR, ClientAuthDBISAR, QAfterSortBy>
      thenByPubkeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pubkey', Sort.desc);
    });
  }
}

extension ClientAuthDBISARQueryWhereDistinct
    on QueryBuilder<ClientAuthDBISAR, ClientAuthDBISAR, QDistinct> {
  QueryBuilder<ClientAuthDBISAR, ClientAuthDBISAR, QDistinct>
      distinctByClientPubkey({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'clientPubkey', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ClientAuthDBISAR, ClientAuthDBISAR, QDistinct>
      distinctByIsAuthorized() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isAuthorized');
    });
  }

  QueryBuilder<ClientAuthDBISAR, ClientAuthDBISAR, QDistinct> distinctByPubkey(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'pubkey', caseSensitive: caseSensitive);
    });
  }
}

extension ClientAuthDBISARQueryProperty
    on QueryBuilder<ClientAuthDBISAR, ClientAuthDBISAR, QQueryProperty> {
  QueryBuilder<ClientAuthDBISAR, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<ClientAuthDBISAR, String, QQueryOperations>
      clientPubkeyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'clientPubkey');
    });
  }

  QueryBuilder<ClientAuthDBISAR, bool, QQueryOperations>
      isAuthorizedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isAuthorized');
    });
  }

  QueryBuilder<ClientAuthDBISAR, String, QQueryOperations> pubkeyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'pubkey');
    });
  }
}
