// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'signed_event_db_isar.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetSignedEventDBISARCollection on Isar {
  IsarCollection<SignedEventDBISAR> get signedEventDBISARs => this.collection();
}

const SignedEventDBISARSchema = CollectionSchema(
  name: r'SignedEventDBISAR',
  id: -2955418331038017423,
  properties: {
    r'applicationName': PropertySchema(
      id: 0,
      name: r'applicationName',
      type: IsarType.string,
    ),
    r'applicationPubkey': PropertySchema(
      id: 1,
      name: r'applicationPubkey',
      type: IsarType.string,
    ),
    r'eventContent': PropertySchema(
      id: 2,
      name: r'eventContent',
      type: IsarType.string,
    ),
    r'eventId': PropertySchema(
      id: 3,
      name: r'eventId',
      type: IsarType.string,
    ),
    r'eventKind': PropertySchema(
      id: 4,
      name: r'eventKind',
      type: IsarType.long,
    ),
    r'metadata': PropertySchema(
      id: 5,
      name: r'metadata',
      type: IsarType.string,
    ),
    r'signedTimestamp': PropertySchema(
      id: 6,
      name: r'signedTimestamp',
      type: IsarType.long,
    ),
    r'status': PropertySchema(
      id: 7,
      name: r'status',
      type: IsarType.long,
    ),
    r'userPubkey': PropertySchema(
      id: 8,
      name: r'userPubkey',
      type: IsarType.string,
    )
  },
  estimateSize: _signedEventDBISAREstimateSize,
  serialize: _signedEventDBISARSerialize,
  deserialize: _signedEventDBISARDeserialize,
  deserializeProp: _signedEventDBISARDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _signedEventDBISARGetId,
  getLinks: _signedEventDBISARGetLinks,
  attach: _signedEventDBISARAttach,
  version: '3.1.0+1',
);

int _signedEventDBISAREstimateSize(
  SignedEventDBISAR object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.applicationName;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.applicationPubkey;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.eventContent.length * 3;
  bytesCount += 3 + object.eventId.length * 3;
  {
    final value = object.metadata;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.userPubkey.length * 3;
  return bytesCount;
}

void _signedEventDBISARSerialize(
  SignedEventDBISAR object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.applicationName);
  writer.writeString(offsets[1], object.applicationPubkey);
  writer.writeString(offsets[2], object.eventContent);
  writer.writeString(offsets[3], object.eventId);
  writer.writeLong(offsets[4], object.eventKind);
  writer.writeString(offsets[5], object.metadata);
  writer.writeLong(offsets[6], object.signedTimestamp);
  writer.writeLong(offsets[7], object.status);
  writer.writeString(offsets[8], object.userPubkey);
}

SignedEventDBISAR _signedEventDBISARDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = SignedEventDBISAR(
    applicationName: reader.readStringOrNull(offsets[0]),
    applicationPubkey: reader.readStringOrNull(offsets[1]),
    eventContent: reader.readString(offsets[2]),
    eventId: reader.readString(offsets[3]),
    eventKind: reader.readLong(offsets[4]),
    metadata: reader.readStringOrNull(offsets[5]),
    signedTimestamp: reader.readLong(offsets[6]),
    status: reader.readLong(offsets[7]),
    userPubkey: reader.readString(offsets[8]),
  );
  object.id = id;
  return object;
}

P _signedEventDBISARDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readStringOrNull(offset)) as P;
    case 1:
      return (reader.readStringOrNull(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readLong(offset)) as P;
    case 5:
      return (reader.readStringOrNull(offset)) as P;
    case 6:
      return (reader.readLong(offset)) as P;
    case 7:
      return (reader.readLong(offset)) as P;
    case 8:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _signedEventDBISARGetId(SignedEventDBISAR object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _signedEventDBISARGetLinks(
    SignedEventDBISAR object) {
  return [];
}

void _signedEventDBISARAttach(
    IsarCollection<dynamic> col, Id id, SignedEventDBISAR object) {
  object.id = id;
}

extension SignedEventDBISARQueryWhereSort
    on QueryBuilder<SignedEventDBISAR, SignedEventDBISAR, QWhere> {
  QueryBuilder<SignedEventDBISAR, SignedEventDBISAR, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension SignedEventDBISARQueryWhere
    on QueryBuilder<SignedEventDBISAR, SignedEventDBISAR, QWhereClause> {
  QueryBuilder<SignedEventDBISAR, SignedEventDBISAR, QAfterWhereClause>
      idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<SignedEventDBISAR, SignedEventDBISAR, QAfterWhereClause>
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

  QueryBuilder<SignedEventDBISAR, SignedEventDBISAR, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<SignedEventDBISAR, SignedEventDBISAR, QAfterWhereClause>
      idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<SignedEventDBISAR, SignedEventDBISAR, QAfterWhereClause>
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
}

extension SignedEventDBISARQueryFilter
    on QueryBuilder<SignedEventDBISAR, SignedEventDBISAR, QFilterCondition> {
  QueryBuilder<SignedEventDBISAR, SignedEventDBISAR, QAfterFilterCondition>
      applicationNameIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'applicationName',
      ));
    });
  }

  QueryBuilder<SignedEventDBISAR, SignedEventDBISAR, QAfterFilterCondition>
      applicationNameIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'applicationName',
      ));
    });
  }

  QueryBuilder<SignedEventDBISAR, SignedEventDBISAR, QAfterFilterCondition>
      applicationNameEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'applicationName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SignedEventDBISAR, SignedEventDBISAR, QAfterFilterCondition>
      applicationNameGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'applicationName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SignedEventDBISAR, SignedEventDBISAR, QAfterFilterCondition>
      applicationNameLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'applicationName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SignedEventDBISAR, SignedEventDBISAR, QAfterFilterCondition>
      applicationNameBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'applicationName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SignedEventDBISAR, SignedEventDBISAR, QAfterFilterCondition>
      applicationNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'applicationName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SignedEventDBISAR, SignedEventDBISAR, QAfterFilterCondition>
      applicationNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'applicationName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SignedEventDBISAR, SignedEventDBISAR, QAfterFilterCondition>
      applicationNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'applicationName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SignedEventDBISAR, SignedEventDBISAR, QAfterFilterCondition>
      applicationNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'applicationName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SignedEventDBISAR, SignedEventDBISAR, QAfterFilterCondition>
      applicationNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'applicationName',
        value: '',
      ));
    });
  }

  QueryBuilder<SignedEventDBISAR, SignedEventDBISAR, QAfterFilterCondition>
      applicationNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'applicationName',
        value: '',
      ));
    });
  }

  QueryBuilder<SignedEventDBISAR, SignedEventDBISAR, QAfterFilterCondition>
      applicationPubkeyIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'applicationPubkey',
      ));
    });
  }

  QueryBuilder<SignedEventDBISAR, SignedEventDBISAR, QAfterFilterCondition>
      applicationPubkeyIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'applicationPubkey',
      ));
    });
  }

  QueryBuilder<SignedEventDBISAR, SignedEventDBISAR, QAfterFilterCondition>
      applicationPubkeyEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'applicationPubkey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SignedEventDBISAR, SignedEventDBISAR, QAfterFilterCondition>
      applicationPubkeyGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'applicationPubkey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SignedEventDBISAR, SignedEventDBISAR, QAfterFilterCondition>
      applicationPubkeyLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'applicationPubkey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SignedEventDBISAR, SignedEventDBISAR, QAfterFilterCondition>
      applicationPubkeyBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'applicationPubkey',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SignedEventDBISAR, SignedEventDBISAR, QAfterFilterCondition>
      applicationPubkeyStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'applicationPubkey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SignedEventDBISAR, SignedEventDBISAR, QAfterFilterCondition>
      applicationPubkeyEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'applicationPubkey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SignedEventDBISAR, SignedEventDBISAR, QAfterFilterCondition>
      applicationPubkeyContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'applicationPubkey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SignedEventDBISAR, SignedEventDBISAR, QAfterFilterCondition>
      applicationPubkeyMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'applicationPubkey',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SignedEventDBISAR, SignedEventDBISAR, QAfterFilterCondition>
      applicationPubkeyIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'applicationPubkey',
        value: '',
      ));
    });
  }

  QueryBuilder<SignedEventDBISAR, SignedEventDBISAR, QAfterFilterCondition>
      applicationPubkeyIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'applicationPubkey',
        value: '',
      ));
    });
  }

  QueryBuilder<SignedEventDBISAR, SignedEventDBISAR, QAfterFilterCondition>
      eventContentEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'eventContent',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SignedEventDBISAR, SignedEventDBISAR, QAfterFilterCondition>
      eventContentGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'eventContent',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SignedEventDBISAR, SignedEventDBISAR, QAfterFilterCondition>
      eventContentLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'eventContent',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SignedEventDBISAR, SignedEventDBISAR, QAfterFilterCondition>
      eventContentBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'eventContent',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SignedEventDBISAR, SignedEventDBISAR, QAfterFilterCondition>
      eventContentStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'eventContent',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SignedEventDBISAR, SignedEventDBISAR, QAfterFilterCondition>
      eventContentEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'eventContent',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SignedEventDBISAR, SignedEventDBISAR, QAfterFilterCondition>
      eventContentContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'eventContent',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SignedEventDBISAR, SignedEventDBISAR, QAfterFilterCondition>
      eventContentMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'eventContent',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SignedEventDBISAR, SignedEventDBISAR, QAfterFilterCondition>
      eventContentIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'eventContent',
        value: '',
      ));
    });
  }

  QueryBuilder<SignedEventDBISAR, SignedEventDBISAR, QAfterFilterCondition>
      eventContentIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'eventContent',
        value: '',
      ));
    });
  }

  QueryBuilder<SignedEventDBISAR, SignedEventDBISAR, QAfterFilterCondition>
      eventIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'eventId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SignedEventDBISAR, SignedEventDBISAR, QAfterFilterCondition>
      eventIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'eventId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SignedEventDBISAR, SignedEventDBISAR, QAfterFilterCondition>
      eventIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'eventId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SignedEventDBISAR, SignedEventDBISAR, QAfterFilterCondition>
      eventIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'eventId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SignedEventDBISAR, SignedEventDBISAR, QAfterFilterCondition>
      eventIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'eventId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SignedEventDBISAR, SignedEventDBISAR, QAfterFilterCondition>
      eventIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'eventId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SignedEventDBISAR, SignedEventDBISAR, QAfterFilterCondition>
      eventIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'eventId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SignedEventDBISAR, SignedEventDBISAR, QAfterFilterCondition>
      eventIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'eventId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SignedEventDBISAR, SignedEventDBISAR, QAfterFilterCondition>
      eventIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'eventId',
        value: '',
      ));
    });
  }

  QueryBuilder<SignedEventDBISAR, SignedEventDBISAR, QAfterFilterCondition>
      eventIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'eventId',
        value: '',
      ));
    });
  }

  QueryBuilder<SignedEventDBISAR, SignedEventDBISAR, QAfterFilterCondition>
      eventKindEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'eventKind',
        value: value,
      ));
    });
  }

  QueryBuilder<SignedEventDBISAR, SignedEventDBISAR, QAfterFilterCondition>
      eventKindGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'eventKind',
        value: value,
      ));
    });
  }

  QueryBuilder<SignedEventDBISAR, SignedEventDBISAR, QAfterFilterCondition>
      eventKindLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'eventKind',
        value: value,
      ));
    });
  }

  QueryBuilder<SignedEventDBISAR, SignedEventDBISAR, QAfterFilterCondition>
      eventKindBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'eventKind',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SignedEventDBISAR, SignedEventDBISAR, QAfterFilterCondition>
      idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<SignedEventDBISAR, SignedEventDBISAR, QAfterFilterCondition>
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

  QueryBuilder<SignedEventDBISAR, SignedEventDBISAR, QAfterFilterCondition>
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

  QueryBuilder<SignedEventDBISAR, SignedEventDBISAR, QAfterFilterCondition>
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

  QueryBuilder<SignedEventDBISAR, SignedEventDBISAR, QAfterFilterCondition>
      metadataIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'metadata',
      ));
    });
  }

  QueryBuilder<SignedEventDBISAR, SignedEventDBISAR, QAfterFilterCondition>
      metadataIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'metadata',
      ));
    });
  }

  QueryBuilder<SignedEventDBISAR, SignedEventDBISAR, QAfterFilterCondition>
      metadataEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'metadata',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SignedEventDBISAR, SignedEventDBISAR, QAfterFilterCondition>
      metadataGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'metadata',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SignedEventDBISAR, SignedEventDBISAR, QAfterFilterCondition>
      metadataLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'metadata',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SignedEventDBISAR, SignedEventDBISAR, QAfterFilterCondition>
      metadataBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'metadata',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SignedEventDBISAR, SignedEventDBISAR, QAfterFilterCondition>
      metadataStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'metadata',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SignedEventDBISAR, SignedEventDBISAR, QAfterFilterCondition>
      metadataEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'metadata',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SignedEventDBISAR, SignedEventDBISAR, QAfterFilterCondition>
      metadataContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'metadata',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SignedEventDBISAR, SignedEventDBISAR, QAfterFilterCondition>
      metadataMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'metadata',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SignedEventDBISAR, SignedEventDBISAR, QAfterFilterCondition>
      metadataIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'metadata',
        value: '',
      ));
    });
  }

  QueryBuilder<SignedEventDBISAR, SignedEventDBISAR, QAfterFilterCondition>
      metadataIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'metadata',
        value: '',
      ));
    });
  }

  QueryBuilder<SignedEventDBISAR, SignedEventDBISAR, QAfterFilterCondition>
      signedTimestampEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'signedTimestamp',
        value: value,
      ));
    });
  }

  QueryBuilder<SignedEventDBISAR, SignedEventDBISAR, QAfterFilterCondition>
      signedTimestampGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'signedTimestamp',
        value: value,
      ));
    });
  }

  QueryBuilder<SignedEventDBISAR, SignedEventDBISAR, QAfterFilterCondition>
      signedTimestampLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'signedTimestamp',
        value: value,
      ));
    });
  }

  QueryBuilder<SignedEventDBISAR, SignedEventDBISAR, QAfterFilterCondition>
      signedTimestampBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'signedTimestamp',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SignedEventDBISAR, SignedEventDBISAR, QAfterFilterCondition>
      statusEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'status',
        value: value,
      ));
    });
  }

  QueryBuilder<SignedEventDBISAR, SignedEventDBISAR, QAfterFilterCondition>
      statusGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'status',
        value: value,
      ));
    });
  }

  QueryBuilder<SignedEventDBISAR, SignedEventDBISAR, QAfterFilterCondition>
      statusLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'status',
        value: value,
      ));
    });
  }

  QueryBuilder<SignedEventDBISAR, SignedEventDBISAR, QAfterFilterCondition>
      statusBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'status',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SignedEventDBISAR, SignedEventDBISAR, QAfterFilterCondition>
      userPubkeyEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'userPubkey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SignedEventDBISAR, SignedEventDBISAR, QAfterFilterCondition>
      userPubkeyGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'userPubkey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SignedEventDBISAR, SignedEventDBISAR, QAfterFilterCondition>
      userPubkeyLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'userPubkey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SignedEventDBISAR, SignedEventDBISAR, QAfterFilterCondition>
      userPubkeyBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'userPubkey',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SignedEventDBISAR, SignedEventDBISAR, QAfterFilterCondition>
      userPubkeyStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'userPubkey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SignedEventDBISAR, SignedEventDBISAR, QAfterFilterCondition>
      userPubkeyEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'userPubkey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SignedEventDBISAR, SignedEventDBISAR, QAfterFilterCondition>
      userPubkeyContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'userPubkey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SignedEventDBISAR, SignedEventDBISAR, QAfterFilterCondition>
      userPubkeyMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'userPubkey',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SignedEventDBISAR, SignedEventDBISAR, QAfterFilterCondition>
      userPubkeyIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'userPubkey',
        value: '',
      ));
    });
  }

  QueryBuilder<SignedEventDBISAR, SignedEventDBISAR, QAfterFilterCondition>
      userPubkeyIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'userPubkey',
        value: '',
      ));
    });
  }
}

extension SignedEventDBISARQueryObject
    on QueryBuilder<SignedEventDBISAR, SignedEventDBISAR, QFilterCondition> {}

extension SignedEventDBISARQueryLinks
    on QueryBuilder<SignedEventDBISAR, SignedEventDBISAR, QFilterCondition> {}

extension SignedEventDBISARQuerySortBy
    on QueryBuilder<SignedEventDBISAR, SignedEventDBISAR, QSortBy> {
  QueryBuilder<SignedEventDBISAR, SignedEventDBISAR, QAfterSortBy>
      sortByApplicationName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'applicationName', Sort.asc);
    });
  }

  QueryBuilder<SignedEventDBISAR, SignedEventDBISAR, QAfterSortBy>
      sortByApplicationNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'applicationName', Sort.desc);
    });
  }

  QueryBuilder<SignedEventDBISAR, SignedEventDBISAR, QAfterSortBy>
      sortByApplicationPubkey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'applicationPubkey', Sort.asc);
    });
  }

  QueryBuilder<SignedEventDBISAR, SignedEventDBISAR, QAfterSortBy>
      sortByApplicationPubkeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'applicationPubkey', Sort.desc);
    });
  }

  QueryBuilder<SignedEventDBISAR, SignedEventDBISAR, QAfterSortBy>
      sortByEventContent() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'eventContent', Sort.asc);
    });
  }

  QueryBuilder<SignedEventDBISAR, SignedEventDBISAR, QAfterSortBy>
      sortByEventContentDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'eventContent', Sort.desc);
    });
  }

  QueryBuilder<SignedEventDBISAR, SignedEventDBISAR, QAfterSortBy>
      sortByEventId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'eventId', Sort.asc);
    });
  }

  QueryBuilder<SignedEventDBISAR, SignedEventDBISAR, QAfterSortBy>
      sortByEventIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'eventId', Sort.desc);
    });
  }

  QueryBuilder<SignedEventDBISAR, SignedEventDBISAR, QAfterSortBy>
      sortByEventKind() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'eventKind', Sort.asc);
    });
  }

  QueryBuilder<SignedEventDBISAR, SignedEventDBISAR, QAfterSortBy>
      sortByEventKindDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'eventKind', Sort.desc);
    });
  }

  QueryBuilder<SignedEventDBISAR, SignedEventDBISAR, QAfterSortBy>
      sortByMetadata() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'metadata', Sort.asc);
    });
  }

  QueryBuilder<SignedEventDBISAR, SignedEventDBISAR, QAfterSortBy>
      sortByMetadataDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'metadata', Sort.desc);
    });
  }

  QueryBuilder<SignedEventDBISAR, SignedEventDBISAR, QAfterSortBy>
      sortBySignedTimestamp() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'signedTimestamp', Sort.asc);
    });
  }

  QueryBuilder<SignedEventDBISAR, SignedEventDBISAR, QAfterSortBy>
      sortBySignedTimestampDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'signedTimestamp', Sort.desc);
    });
  }

  QueryBuilder<SignedEventDBISAR, SignedEventDBISAR, QAfterSortBy>
      sortByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.asc);
    });
  }

  QueryBuilder<SignedEventDBISAR, SignedEventDBISAR, QAfterSortBy>
      sortByStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.desc);
    });
  }

  QueryBuilder<SignedEventDBISAR, SignedEventDBISAR, QAfterSortBy>
      sortByUserPubkey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userPubkey', Sort.asc);
    });
  }

  QueryBuilder<SignedEventDBISAR, SignedEventDBISAR, QAfterSortBy>
      sortByUserPubkeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userPubkey', Sort.desc);
    });
  }
}

extension SignedEventDBISARQuerySortThenBy
    on QueryBuilder<SignedEventDBISAR, SignedEventDBISAR, QSortThenBy> {
  QueryBuilder<SignedEventDBISAR, SignedEventDBISAR, QAfterSortBy>
      thenByApplicationName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'applicationName', Sort.asc);
    });
  }

  QueryBuilder<SignedEventDBISAR, SignedEventDBISAR, QAfterSortBy>
      thenByApplicationNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'applicationName', Sort.desc);
    });
  }

  QueryBuilder<SignedEventDBISAR, SignedEventDBISAR, QAfterSortBy>
      thenByApplicationPubkey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'applicationPubkey', Sort.asc);
    });
  }

  QueryBuilder<SignedEventDBISAR, SignedEventDBISAR, QAfterSortBy>
      thenByApplicationPubkeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'applicationPubkey', Sort.desc);
    });
  }

  QueryBuilder<SignedEventDBISAR, SignedEventDBISAR, QAfterSortBy>
      thenByEventContent() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'eventContent', Sort.asc);
    });
  }

  QueryBuilder<SignedEventDBISAR, SignedEventDBISAR, QAfterSortBy>
      thenByEventContentDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'eventContent', Sort.desc);
    });
  }

  QueryBuilder<SignedEventDBISAR, SignedEventDBISAR, QAfterSortBy>
      thenByEventId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'eventId', Sort.asc);
    });
  }

  QueryBuilder<SignedEventDBISAR, SignedEventDBISAR, QAfterSortBy>
      thenByEventIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'eventId', Sort.desc);
    });
  }

  QueryBuilder<SignedEventDBISAR, SignedEventDBISAR, QAfterSortBy>
      thenByEventKind() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'eventKind', Sort.asc);
    });
  }

  QueryBuilder<SignedEventDBISAR, SignedEventDBISAR, QAfterSortBy>
      thenByEventKindDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'eventKind', Sort.desc);
    });
  }

  QueryBuilder<SignedEventDBISAR, SignedEventDBISAR, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<SignedEventDBISAR, SignedEventDBISAR, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<SignedEventDBISAR, SignedEventDBISAR, QAfterSortBy>
      thenByMetadata() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'metadata', Sort.asc);
    });
  }

  QueryBuilder<SignedEventDBISAR, SignedEventDBISAR, QAfterSortBy>
      thenByMetadataDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'metadata', Sort.desc);
    });
  }

  QueryBuilder<SignedEventDBISAR, SignedEventDBISAR, QAfterSortBy>
      thenBySignedTimestamp() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'signedTimestamp', Sort.asc);
    });
  }

  QueryBuilder<SignedEventDBISAR, SignedEventDBISAR, QAfterSortBy>
      thenBySignedTimestampDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'signedTimestamp', Sort.desc);
    });
  }

  QueryBuilder<SignedEventDBISAR, SignedEventDBISAR, QAfterSortBy>
      thenByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.asc);
    });
  }

  QueryBuilder<SignedEventDBISAR, SignedEventDBISAR, QAfterSortBy>
      thenByStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.desc);
    });
  }

  QueryBuilder<SignedEventDBISAR, SignedEventDBISAR, QAfterSortBy>
      thenByUserPubkey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userPubkey', Sort.asc);
    });
  }

  QueryBuilder<SignedEventDBISAR, SignedEventDBISAR, QAfterSortBy>
      thenByUserPubkeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userPubkey', Sort.desc);
    });
  }
}

extension SignedEventDBISARQueryWhereDistinct
    on QueryBuilder<SignedEventDBISAR, SignedEventDBISAR, QDistinct> {
  QueryBuilder<SignedEventDBISAR, SignedEventDBISAR, QDistinct>
      distinctByApplicationName({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'applicationName',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SignedEventDBISAR, SignedEventDBISAR, QDistinct>
      distinctByApplicationPubkey({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'applicationPubkey',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SignedEventDBISAR, SignedEventDBISAR, QDistinct>
      distinctByEventContent({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'eventContent', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SignedEventDBISAR, SignedEventDBISAR, QDistinct>
      distinctByEventId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'eventId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SignedEventDBISAR, SignedEventDBISAR, QDistinct>
      distinctByEventKind() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'eventKind');
    });
  }

  QueryBuilder<SignedEventDBISAR, SignedEventDBISAR, QDistinct>
      distinctByMetadata({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'metadata', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SignedEventDBISAR, SignedEventDBISAR, QDistinct>
      distinctBySignedTimestamp() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'signedTimestamp');
    });
  }

  QueryBuilder<SignedEventDBISAR, SignedEventDBISAR, QDistinct>
      distinctByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'status');
    });
  }

  QueryBuilder<SignedEventDBISAR, SignedEventDBISAR, QDistinct>
      distinctByUserPubkey({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'userPubkey', caseSensitive: caseSensitive);
    });
  }
}

extension SignedEventDBISARQueryProperty
    on QueryBuilder<SignedEventDBISAR, SignedEventDBISAR, QQueryProperty> {
  QueryBuilder<SignedEventDBISAR, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<SignedEventDBISAR, String?, QQueryOperations>
      applicationNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'applicationName');
    });
  }

  QueryBuilder<SignedEventDBISAR, String?, QQueryOperations>
      applicationPubkeyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'applicationPubkey');
    });
  }

  QueryBuilder<SignedEventDBISAR, String, QQueryOperations>
      eventContentProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'eventContent');
    });
  }

  QueryBuilder<SignedEventDBISAR, String, QQueryOperations> eventIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'eventId');
    });
  }

  QueryBuilder<SignedEventDBISAR, int, QQueryOperations> eventKindProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'eventKind');
    });
  }

  QueryBuilder<SignedEventDBISAR, String?, QQueryOperations>
      metadataProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'metadata');
    });
  }

  QueryBuilder<SignedEventDBISAR, int, QQueryOperations>
      signedTimestampProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'signedTimestamp');
    });
  }

  QueryBuilder<SignedEventDBISAR, int, QQueryOperations> statusProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'status');
    });
  }

  QueryBuilder<SignedEventDBISAR, String, QQueryOperations>
      userPubkeyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'userPubkey');
    });
  }
}
