// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'userDB_isar.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetUserDBISARCollection on Isar {
  IsarCollection<UserDBISAR> get userDBISARs => this.collection();
}

const UserDBISARSchema = CollectionSchema(
  name: r'UserDBISAR',
  id: 3624421458299562443,
  properties: {
    r'encryptedPrivkey': PropertySchema(
      id: 0,
      name: r'encryptedPrivkey',
      type: IsarType.string,
    ),
    r'privkey': PropertySchema(
      id: 1,
      name: r'privkey',
      type: IsarType.string,
    ),
    r'pubkey': PropertySchema(
      id: 2,
      name: r'pubkey',
      type: IsarType.string,
    )
  },
  estimateSize: _userDBISAREstimateSize,
  serialize: _userDBISARSerialize,
  deserialize: _userDBISARDeserialize,
  deserializeProp: _userDBISARDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _userDBISARGetId,
  getLinks: _userDBISARGetLinks,
  attach: _userDBISARAttach,
  version: '3.1.0+1',
);

int _userDBISAREstimateSize(
  UserDBISAR object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.encryptedPrivkey.length * 3;
  bytesCount += 3 + object.privkey.length * 3;
  bytesCount += 3 + object.pubkey.length * 3;
  return bytesCount;
}

void _userDBISARSerialize(
  UserDBISAR object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.encryptedPrivkey);
  writer.writeString(offsets[1], object.privkey);
  writer.writeString(offsets[2], object.pubkey);
}

UserDBISAR _userDBISARDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = UserDBISAR(
    encryptedPrivkey: reader.readString(offsets[0]),
    privkey: reader.readString(offsets[1]),
    pubkey: reader.readString(offsets[2]),
  );
  object.id = id;
  return object;
}

P _userDBISARDeserializeProp<P>(
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
    case 2:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _userDBISARGetId(UserDBISAR object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _userDBISARGetLinks(UserDBISAR object) {
  return [];
}

void _userDBISARAttach(IsarCollection<dynamic> col, Id id, UserDBISAR object) {
  object.id = id;
}

extension UserDBISARQueryWhereSort
    on QueryBuilder<UserDBISAR, UserDBISAR, QWhere> {
  QueryBuilder<UserDBISAR, UserDBISAR, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension UserDBISARQueryWhere
    on QueryBuilder<UserDBISAR, UserDBISAR, QWhereClause> {
  QueryBuilder<UserDBISAR, UserDBISAR, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterWhereClause> idBetween(
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

extension UserDBISARQueryFilter
    on QueryBuilder<UserDBISAR, UserDBISAR, QFilterCondition> {
  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      encryptedPrivkeyEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'encryptedPrivkey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      encryptedPrivkeyGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'encryptedPrivkey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      encryptedPrivkeyLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'encryptedPrivkey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      encryptedPrivkeyBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'encryptedPrivkey',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      encryptedPrivkeyStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'encryptedPrivkey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      encryptedPrivkeyEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'encryptedPrivkey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      encryptedPrivkeyContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'encryptedPrivkey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      encryptedPrivkeyMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'encryptedPrivkey',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      encryptedPrivkeyIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'encryptedPrivkey',
        value: '',
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      encryptedPrivkeyIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'encryptedPrivkey',
        value: '',
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition> idBetween(
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

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition> privkeyEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'privkey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      privkeyGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'privkey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition> privkeyLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'privkey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition> privkeyBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'privkey',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition> privkeyStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'privkey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition> privkeyEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'privkey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition> privkeyContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'privkey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition> privkeyMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'privkey',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition> privkeyIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'privkey',
        value: '',
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      privkeyIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'privkey',
        value: '',
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition> pubkeyEqualTo(
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

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition> pubkeyGreaterThan(
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

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition> pubkeyLessThan(
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

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition> pubkeyBetween(
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

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition> pubkeyStartsWith(
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

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition> pubkeyEndsWith(
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

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition> pubkeyContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'pubkey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition> pubkeyMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'pubkey',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition> pubkeyIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'pubkey',
        value: '',
      ));
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterFilterCondition>
      pubkeyIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'pubkey',
        value: '',
      ));
    });
  }
}

extension UserDBISARQueryObject
    on QueryBuilder<UserDBISAR, UserDBISAR, QFilterCondition> {}

extension UserDBISARQueryLinks
    on QueryBuilder<UserDBISAR, UserDBISAR, QFilterCondition> {}

extension UserDBISARQuerySortBy
    on QueryBuilder<UserDBISAR, UserDBISAR, QSortBy> {
  QueryBuilder<UserDBISAR, UserDBISAR, QAfterSortBy> sortByEncryptedPrivkey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'encryptedPrivkey', Sort.asc);
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterSortBy>
      sortByEncryptedPrivkeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'encryptedPrivkey', Sort.desc);
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterSortBy> sortByPrivkey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'privkey', Sort.asc);
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterSortBy> sortByPrivkeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'privkey', Sort.desc);
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterSortBy> sortByPubkey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pubkey', Sort.asc);
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterSortBy> sortByPubkeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pubkey', Sort.desc);
    });
  }
}

extension UserDBISARQuerySortThenBy
    on QueryBuilder<UserDBISAR, UserDBISAR, QSortThenBy> {
  QueryBuilder<UserDBISAR, UserDBISAR, QAfterSortBy> thenByEncryptedPrivkey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'encryptedPrivkey', Sort.asc);
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterSortBy>
      thenByEncryptedPrivkeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'encryptedPrivkey', Sort.desc);
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterSortBy> thenByPrivkey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'privkey', Sort.asc);
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterSortBy> thenByPrivkeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'privkey', Sort.desc);
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterSortBy> thenByPubkey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pubkey', Sort.asc);
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QAfterSortBy> thenByPubkeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pubkey', Sort.desc);
    });
  }
}

extension UserDBISARQueryWhereDistinct
    on QueryBuilder<UserDBISAR, UserDBISAR, QDistinct> {
  QueryBuilder<UserDBISAR, UserDBISAR, QDistinct> distinctByEncryptedPrivkey(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'encryptedPrivkey',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QDistinct> distinctByPrivkey(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'privkey', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<UserDBISAR, UserDBISAR, QDistinct> distinctByPubkey(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'pubkey', caseSensitive: caseSensitive);
    });
  }
}

extension UserDBISARQueryProperty
    on QueryBuilder<UserDBISAR, UserDBISAR, QQueryProperty> {
  QueryBuilder<UserDBISAR, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<UserDBISAR, String, QQueryOperations>
      encryptedPrivkeyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'encryptedPrivkey');
    });
  }

  QueryBuilder<UserDBISAR, String, QQueryOperations> privkeyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'privkey');
    });
  }

  QueryBuilder<UserDBISAR, String, QQueryOperations> pubkeyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'pubkey');
    });
  }
}
