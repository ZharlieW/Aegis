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
    r'connectionType': PropertySchema(
      id: 1,
      name: r'connectionType',
      type: IsarType.long,
    ),
    r'createTimestamp': PropertySchema(
      id: 2,
      name: r'createTimestamp',
      type: IsarType.long,
    ),
    r'image': PropertySchema(
      id: 3,
      name: r'image',
      type: IsarType.string,
    ),
    r'name': PropertySchema(
      id: 4,
      name: r'name',
      type: IsarType.string,
    ),
    r'pubkey': PropertySchema(
      id: 5,
      name: r'pubkey',
      type: IsarType.string,
    ),
    r'relay': PropertySchema(
      id: 6,
      name: r'relay',
      type: IsarType.string,
    ),
    r'scheme': PropertySchema(
      id: 7,
      name: r'scheme',
      type: IsarType.string,
    ),
    r'secret': PropertySchema(
      id: 8,
      name: r'secret',
      type: IsarType.string,
    ),
    r'server': PropertySchema(
      id: 9,
      name: r'server',
      type: IsarType.string,
    ),
    r'updateTimestamp': PropertySchema(
      id: 10,
      name: r'updateTimestamp',
      type: IsarType.long,
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
  {
    final value = object.image;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.name;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.pubkey.length * 3;
  {
    final value = object.relay;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.scheme;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.secret;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.server;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _clientAuthDBISARSerialize(
  ClientAuthDBISAR object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.clientPubkey);
  writer.writeLong(offsets[1], object.connectionType);
  writer.writeLong(offsets[2], object.createTimestamp);
  writer.writeString(offsets[3], object.image);
  writer.writeString(offsets[4], object.name);
  writer.writeString(offsets[5], object.pubkey);
  writer.writeString(offsets[6], object.relay);
  writer.writeString(offsets[7], object.scheme);
  writer.writeString(offsets[8], object.secret);
  writer.writeString(offsets[9], object.server);
  writer.writeLong(offsets[10], object.updateTimestamp);
}

ClientAuthDBISAR _clientAuthDBISARDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = ClientAuthDBISAR(
    clientPubkey: reader.readString(offsets[0]),
    connectionType: reader.readLong(offsets[1]),
    createTimestamp: reader.readLongOrNull(offsets[2]),
    image: reader.readStringOrNull(offsets[3]),
    name: reader.readStringOrNull(offsets[4]),
    pubkey: reader.readString(offsets[5]),
    relay: reader.readStringOrNull(offsets[6]),
    scheme: reader.readStringOrNull(offsets[7]),
    secret: reader.readStringOrNull(offsets[8]),
    server: reader.readStringOrNull(offsets[9]),
    updateTimestamp: reader.readLongOrNull(offsets[10]),
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
      return (reader.readLong(offset)) as P;
    case 2:
      return (reader.readLongOrNull(offset)) as P;
    case 3:
      return (reader.readStringOrNull(offset)) as P;
    case 4:
      return (reader.readStringOrNull(offset)) as P;
    case 5:
      return (reader.readString(offset)) as P;
    case 6:
      return (reader.readStringOrNull(offset)) as P;
    case 7:
      return (reader.readStringOrNull(offset)) as P;
    case 8:
      return (reader.readStringOrNull(offset)) as P;
    case 9:
      return (reader.readStringOrNull(offset)) as P;
    case 10:
      return (reader.readLongOrNull(offset)) as P;
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
      connectionTypeEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'connectionType',
        value: value,
      ));
    });
  }

  QueryBuilder<ClientAuthDBISAR, ClientAuthDBISAR, QAfterFilterCondition>
      connectionTypeGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'connectionType',
        value: value,
      ));
    });
  }

  QueryBuilder<ClientAuthDBISAR, ClientAuthDBISAR, QAfterFilterCondition>
      connectionTypeLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'connectionType',
        value: value,
      ));
    });
  }

  QueryBuilder<ClientAuthDBISAR, ClientAuthDBISAR, QAfterFilterCondition>
      connectionTypeBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'connectionType',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ClientAuthDBISAR, ClientAuthDBISAR, QAfterFilterCondition>
      createTimestampIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'createTimestamp',
      ));
    });
  }

  QueryBuilder<ClientAuthDBISAR, ClientAuthDBISAR, QAfterFilterCondition>
      createTimestampIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'createTimestamp',
      ));
    });
  }

  QueryBuilder<ClientAuthDBISAR, ClientAuthDBISAR, QAfterFilterCondition>
      createTimestampEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createTimestamp',
        value: value,
      ));
    });
  }

  QueryBuilder<ClientAuthDBISAR, ClientAuthDBISAR, QAfterFilterCondition>
      createTimestampGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'createTimestamp',
        value: value,
      ));
    });
  }

  QueryBuilder<ClientAuthDBISAR, ClientAuthDBISAR, QAfterFilterCondition>
      createTimestampLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'createTimestamp',
        value: value,
      ));
    });
  }

  QueryBuilder<ClientAuthDBISAR, ClientAuthDBISAR, QAfterFilterCondition>
      createTimestampBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'createTimestamp',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
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
      imageIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'image',
      ));
    });
  }

  QueryBuilder<ClientAuthDBISAR, ClientAuthDBISAR, QAfterFilterCondition>
      imageIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'image',
      ));
    });
  }

  QueryBuilder<ClientAuthDBISAR, ClientAuthDBISAR, QAfterFilterCondition>
      imageEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'image',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ClientAuthDBISAR, ClientAuthDBISAR, QAfterFilterCondition>
      imageGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'image',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ClientAuthDBISAR, ClientAuthDBISAR, QAfterFilterCondition>
      imageLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'image',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ClientAuthDBISAR, ClientAuthDBISAR, QAfterFilterCondition>
      imageBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'image',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ClientAuthDBISAR, ClientAuthDBISAR, QAfterFilterCondition>
      imageStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'image',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ClientAuthDBISAR, ClientAuthDBISAR, QAfterFilterCondition>
      imageEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'image',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ClientAuthDBISAR, ClientAuthDBISAR, QAfterFilterCondition>
      imageContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'image',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ClientAuthDBISAR, ClientAuthDBISAR, QAfterFilterCondition>
      imageMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'image',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ClientAuthDBISAR, ClientAuthDBISAR, QAfterFilterCondition>
      imageIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'image',
        value: '',
      ));
    });
  }

  QueryBuilder<ClientAuthDBISAR, ClientAuthDBISAR, QAfterFilterCondition>
      imageIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'image',
        value: '',
      ));
    });
  }

  QueryBuilder<ClientAuthDBISAR, ClientAuthDBISAR, QAfterFilterCondition>
      nameIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'name',
      ));
    });
  }

  QueryBuilder<ClientAuthDBISAR, ClientAuthDBISAR, QAfterFilterCondition>
      nameIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'name',
      ));
    });
  }

  QueryBuilder<ClientAuthDBISAR, ClientAuthDBISAR, QAfterFilterCondition>
      nameEqualTo(
    String? value, {
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

  QueryBuilder<ClientAuthDBISAR, ClientAuthDBISAR, QAfterFilterCondition>
      nameGreaterThan(
    String? value, {
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

  QueryBuilder<ClientAuthDBISAR, ClientAuthDBISAR, QAfterFilterCondition>
      nameLessThan(
    String? value, {
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

  QueryBuilder<ClientAuthDBISAR, ClientAuthDBISAR, QAfterFilterCondition>
      nameBetween(
    String? lower,
    String? upper, {
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

  QueryBuilder<ClientAuthDBISAR, ClientAuthDBISAR, QAfterFilterCondition>
      nameStartsWith(
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

  QueryBuilder<ClientAuthDBISAR, ClientAuthDBISAR, QAfterFilterCondition>
      nameEndsWith(
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

  QueryBuilder<ClientAuthDBISAR, ClientAuthDBISAR, QAfterFilterCondition>
      nameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ClientAuthDBISAR, ClientAuthDBISAR, QAfterFilterCondition>
      nameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'name',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ClientAuthDBISAR, ClientAuthDBISAR, QAfterFilterCondition>
      nameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<ClientAuthDBISAR, ClientAuthDBISAR, QAfterFilterCondition>
      nameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'name',
        value: '',
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

  QueryBuilder<ClientAuthDBISAR, ClientAuthDBISAR, QAfterFilterCondition>
      relayIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'relay',
      ));
    });
  }

  QueryBuilder<ClientAuthDBISAR, ClientAuthDBISAR, QAfterFilterCondition>
      relayIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'relay',
      ));
    });
  }

  QueryBuilder<ClientAuthDBISAR, ClientAuthDBISAR, QAfterFilterCondition>
      relayEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'relay',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ClientAuthDBISAR, ClientAuthDBISAR, QAfterFilterCondition>
      relayGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'relay',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ClientAuthDBISAR, ClientAuthDBISAR, QAfterFilterCondition>
      relayLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'relay',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ClientAuthDBISAR, ClientAuthDBISAR, QAfterFilterCondition>
      relayBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'relay',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ClientAuthDBISAR, ClientAuthDBISAR, QAfterFilterCondition>
      relayStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'relay',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ClientAuthDBISAR, ClientAuthDBISAR, QAfterFilterCondition>
      relayEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'relay',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ClientAuthDBISAR, ClientAuthDBISAR, QAfterFilterCondition>
      relayContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'relay',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ClientAuthDBISAR, ClientAuthDBISAR, QAfterFilterCondition>
      relayMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'relay',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ClientAuthDBISAR, ClientAuthDBISAR, QAfterFilterCondition>
      relayIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'relay',
        value: '',
      ));
    });
  }

  QueryBuilder<ClientAuthDBISAR, ClientAuthDBISAR, QAfterFilterCondition>
      relayIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'relay',
        value: '',
      ));
    });
  }

  QueryBuilder<ClientAuthDBISAR, ClientAuthDBISAR, QAfterFilterCondition>
      schemeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'scheme',
      ));
    });
  }

  QueryBuilder<ClientAuthDBISAR, ClientAuthDBISAR, QAfterFilterCondition>
      schemeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'scheme',
      ));
    });
  }

  QueryBuilder<ClientAuthDBISAR, ClientAuthDBISAR, QAfterFilterCondition>
      schemeEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'scheme',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ClientAuthDBISAR, ClientAuthDBISAR, QAfterFilterCondition>
      schemeGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'scheme',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ClientAuthDBISAR, ClientAuthDBISAR, QAfterFilterCondition>
      schemeLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'scheme',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ClientAuthDBISAR, ClientAuthDBISAR, QAfterFilterCondition>
      schemeBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'scheme',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ClientAuthDBISAR, ClientAuthDBISAR, QAfterFilterCondition>
      schemeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'scheme',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ClientAuthDBISAR, ClientAuthDBISAR, QAfterFilterCondition>
      schemeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'scheme',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ClientAuthDBISAR, ClientAuthDBISAR, QAfterFilterCondition>
      schemeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'scheme',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ClientAuthDBISAR, ClientAuthDBISAR, QAfterFilterCondition>
      schemeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'scheme',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ClientAuthDBISAR, ClientAuthDBISAR, QAfterFilterCondition>
      schemeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'scheme',
        value: '',
      ));
    });
  }

  QueryBuilder<ClientAuthDBISAR, ClientAuthDBISAR, QAfterFilterCondition>
      schemeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'scheme',
        value: '',
      ));
    });
  }

  QueryBuilder<ClientAuthDBISAR, ClientAuthDBISAR, QAfterFilterCondition>
      secretIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'secret',
      ));
    });
  }

  QueryBuilder<ClientAuthDBISAR, ClientAuthDBISAR, QAfterFilterCondition>
      secretIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'secret',
      ));
    });
  }

  QueryBuilder<ClientAuthDBISAR, ClientAuthDBISAR, QAfterFilterCondition>
      secretEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'secret',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ClientAuthDBISAR, ClientAuthDBISAR, QAfterFilterCondition>
      secretGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'secret',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ClientAuthDBISAR, ClientAuthDBISAR, QAfterFilterCondition>
      secretLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'secret',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ClientAuthDBISAR, ClientAuthDBISAR, QAfterFilterCondition>
      secretBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'secret',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ClientAuthDBISAR, ClientAuthDBISAR, QAfterFilterCondition>
      secretStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'secret',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ClientAuthDBISAR, ClientAuthDBISAR, QAfterFilterCondition>
      secretEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'secret',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ClientAuthDBISAR, ClientAuthDBISAR, QAfterFilterCondition>
      secretContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'secret',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ClientAuthDBISAR, ClientAuthDBISAR, QAfterFilterCondition>
      secretMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'secret',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ClientAuthDBISAR, ClientAuthDBISAR, QAfterFilterCondition>
      secretIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'secret',
        value: '',
      ));
    });
  }

  QueryBuilder<ClientAuthDBISAR, ClientAuthDBISAR, QAfterFilterCondition>
      secretIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'secret',
        value: '',
      ));
    });
  }

  QueryBuilder<ClientAuthDBISAR, ClientAuthDBISAR, QAfterFilterCondition>
      serverIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'server',
      ));
    });
  }

  QueryBuilder<ClientAuthDBISAR, ClientAuthDBISAR, QAfterFilterCondition>
      serverIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'server',
      ));
    });
  }

  QueryBuilder<ClientAuthDBISAR, ClientAuthDBISAR, QAfterFilterCondition>
      serverEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'server',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ClientAuthDBISAR, ClientAuthDBISAR, QAfterFilterCondition>
      serverGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'server',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ClientAuthDBISAR, ClientAuthDBISAR, QAfterFilterCondition>
      serverLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'server',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ClientAuthDBISAR, ClientAuthDBISAR, QAfterFilterCondition>
      serverBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'server',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ClientAuthDBISAR, ClientAuthDBISAR, QAfterFilterCondition>
      serverStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'server',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ClientAuthDBISAR, ClientAuthDBISAR, QAfterFilterCondition>
      serverEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'server',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ClientAuthDBISAR, ClientAuthDBISAR, QAfterFilterCondition>
      serverContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'server',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ClientAuthDBISAR, ClientAuthDBISAR, QAfterFilterCondition>
      serverMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'server',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ClientAuthDBISAR, ClientAuthDBISAR, QAfterFilterCondition>
      serverIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'server',
        value: '',
      ));
    });
  }

  QueryBuilder<ClientAuthDBISAR, ClientAuthDBISAR, QAfterFilterCondition>
      serverIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'server',
        value: '',
      ));
    });
  }

  QueryBuilder<ClientAuthDBISAR, ClientAuthDBISAR, QAfterFilterCondition>
      updateTimestampIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'updateTimestamp',
      ));
    });
  }

  QueryBuilder<ClientAuthDBISAR, ClientAuthDBISAR, QAfterFilterCondition>
      updateTimestampIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'updateTimestamp',
      ));
    });
  }

  QueryBuilder<ClientAuthDBISAR, ClientAuthDBISAR, QAfterFilterCondition>
      updateTimestampEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'updateTimestamp',
        value: value,
      ));
    });
  }

  QueryBuilder<ClientAuthDBISAR, ClientAuthDBISAR, QAfterFilterCondition>
      updateTimestampGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'updateTimestamp',
        value: value,
      ));
    });
  }

  QueryBuilder<ClientAuthDBISAR, ClientAuthDBISAR, QAfterFilterCondition>
      updateTimestampLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'updateTimestamp',
        value: value,
      ));
    });
  }

  QueryBuilder<ClientAuthDBISAR, ClientAuthDBISAR, QAfterFilterCondition>
      updateTimestampBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'updateTimestamp',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
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
      sortByConnectionType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'connectionType', Sort.asc);
    });
  }

  QueryBuilder<ClientAuthDBISAR, ClientAuthDBISAR, QAfterSortBy>
      sortByConnectionTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'connectionType', Sort.desc);
    });
  }

  QueryBuilder<ClientAuthDBISAR, ClientAuthDBISAR, QAfterSortBy>
      sortByCreateTimestamp() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createTimestamp', Sort.asc);
    });
  }

  QueryBuilder<ClientAuthDBISAR, ClientAuthDBISAR, QAfterSortBy>
      sortByCreateTimestampDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createTimestamp', Sort.desc);
    });
  }

  QueryBuilder<ClientAuthDBISAR, ClientAuthDBISAR, QAfterSortBy> sortByImage() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'image', Sort.asc);
    });
  }

  QueryBuilder<ClientAuthDBISAR, ClientAuthDBISAR, QAfterSortBy>
      sortByImageDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'image', Sort.desc);
    });
  }

  QueryBuilder<ClientAuthDBISAR, ClientAuthDBISAR, QAfterSortBy> sortByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<ClientAuthDBISAR, ClientAuthDBISAR, QAfterSortBy>
      sortByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
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

  QueryBuilder<ClientAuthDBISAR, ClientAuthDBISAR, QAfterSortBy> sortByRelay() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'relay', Sort.asc);
    });
  }

  QueryBuilder<ClientAuthDBISAR, ClientAuthDBISAR, QAfterSortBy>
      sortByRelayDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'relay', Sort.desc);
    });
  }

  QueryBuilder<ClientAuthDBISAR, ClientAuthDBISAR, QAfterSortBy>
      sortByScheme() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'scheme', Sort.asc);
    });
  }

  QueryBuilder<ClientAuthDBISAR, ClientAuthDBISAR, QAfterSortBy>
      sortBySchemeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'scheme', Sort.desc);
    });
  }

  QueryBuilder<ClientAuthDBISAR, ClientAuthDBISAR, QAfterSortBy>
      sortBySecret() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'secret', Sort.asc);
    });
  }

  QueryBuilder<ClientAuthDBISAR, ClientAuthDBISAR, QAfterSortBy>
      sortBySecretDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'secret', Sort.desc);
    });
  }

  QueryBuilder<ClientAuthDBISAR, ClientAuthDBISAR, QAfterSortBy>
      sortByServer() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'server', Sort.asc);
    });
  }

  QueryBuilder<ClientAuthDBISAR, ClientAuthDBISAR, QAfterSortBy>
      sortByServerDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'server', Sort.desc);
    });
  }

  QueryBuilder<ClientAuthDBISAR, ClientAuthDBISAR, QAfterSortBy>
      sortByUpdateTimestamp() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updateTimestamp', Sort.asc);
    });
  }

  QueryBuilder<ClientAuthDBISAR, ClientAuthDBISAR, QAfterSortBy>
      sortByUpdateTimestampDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updateTimestamp', Sort.desc);
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

  QueryBuilder<ClientAuthDBISAR, ClientAuthDBISAR, QAfterSortBy>
      thenByConnectionType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'connectionType', Sort.asc);
    });
  }

  QueryBuilder<ClientAuthDBISAR, ClientAuthDBISAR, QAfterSortBy>
      thenByConnectionTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'connectionType', Sort.desc);
    });
  }

  QueryBuilder<ClientAuthDBISAR, ClientAuthDBISAR, QAfterSortBy>
      thenByCreateTimestamp() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createTimestamp', Sort.asc);
    });
  }

  QueryBuilder<ClientAuthDBISAR, ClientAuthDBISAR, QAfterSortBy>
      thenByCreateTimestampDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createTimestamp', Sort.desc);
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

  QueryBuilder<ClientAuthDBISAR, ClientAuthDBISAR, QAfterSortBy> thenByImage() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'image', Sort.asc);
    });
  }

  QueryBuilder<ClientAuthDBISAR, ClientAuthDBISAR, QAfterSortBy>
      thenByImageDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'image', Sort.desc);
    });
  }

  QueryBuilder<ClientAuthDBISAR, ClientAuthDBISAR, QAfterSortBy> thenByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<ClientAuthDBISAR, ClientAuthDBISAR, QAfterSortBy>
      thenByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
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

  QueryBuilder<ClientAuthDBISAR, ClientAuthDBISAR, QAfterSortBy> thenByRelay() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'relay', Sort.asc);
    });
  }

  QueryBuilder<ClientAuthDBISAR, ClientAuthDBISAR, QAfterSortBy>
      thenByRelayDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'relay', Sort.desc);
    });
  }

  QueryBuilder<ClientAuthDBISAR, ClientAuthDBISAR, QAfterSortBy>
      thenByScheme() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'scheme', Sort.asc);
    });
  }

  QueryBuilder<ClientAuthDBISAR, ClientAuthDBISAR, QAfterSortBy>
      thenBySchemeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'scheme', Sort.desc);
    });
  }

  QueryBuilder<ClientAuthDBISAR, ClientAuthDBISAR, QAfterSortBy>
      thenBySecret() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'secret', Sort.asc);
    });
  }

  QueryBuilder<ClientAuthDBISAR, ClientAuthDBISAR, QAfterSortBy>
      thenBySecretDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'secret', Sort.desc);
    });
  }

  QueryBuilder<ClientAuthDBISAR, ClientAuthDBISAR, QAfterSortBy>
      thenByServer() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'server', Sort.asc);
    });
  }

  QueryBuilder<ClientAuthDBISAR, ClientAuthDBISAR, QAfterSortBy>
      thenByServerDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'server', Sort.desc);
    });
  }

  QueryBuilder<ClientAuthDBISAR, ClientAuthDBISAR, QAfterSortBy>
      thenByUpdateTimestamp() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updateTimestamp', Sort.asc);
    });
  }

  QueryBuilder<ClientAuthDBISAR, ClientAuthDBISAR, QAfterSortBy>
      thenByUpdateTimestampDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updateTimestamp', Sort.desc);
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
      distinctByConnectionType() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'connectionType');
    });
  }

  QueryBuilder<ClientAuthDBISAR, ClientAuthDBISAR, QDistinct>
      distinctByCreateTimestamp() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createTimestamp');
    });
  }

  QueryBuilder<ClientAuthDBISAR, ClientAuthDBISAR, QDistinct> distinctByImage(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'image', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ClientAuthDBISAR, ClientAuthDBISAR, QDistinct> distinctByName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'name', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ClientAuthDBISAR, ClientAuthDBISAR, QDistinct> distinctByPubkey(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'pubkey', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ClientAuthDBISAR, ClientAuthDBISAR, QDistinct> distinctByRelay(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'relay', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ClientAuthDBISAR, ClientAuthDBISAR, QDistinct> distinctByScheme(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'scheme', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ClientAuthDBISAR, ClientAuthDBISAR, QDistinct> distinctBySecret(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'secret', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ClientAuthDBISAR, ClientAuthDBISAR, QDistinct> distinctByServer(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'server', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ClientAuthDBISAR, ClientAuthDBISAR, QDistinct>
      distinctByUpdateTimestamp() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'updateTimestamp');
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

  QueryBuilder<ClientAuthDBISAR, int, QQueryOperations>
      connectionTypeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'connectionType');
    });
  }

  QueryBuilder<ClientAuthDBISAR, int?, QQueryOperations>
      createTimestampProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createTimestamp');
    });
  }

  QueryBuilder<ClientAuthDBISAR, String?, QQueryOperations> imageProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'image');
    });
  }

  QueryBuilder<ClientAuthDBISAR, String?, QQueryOperations> nameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'name');
    });
  }

  QueryBuilder<ClientAuthDBISAR, String, QQueryOperations> pubkeyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'pubkey');
    });
  }

  QueryBuilder<ClientAuthDBISAR, String?, QQueryOperations> relayProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'relay');
    });
  }

  QueryBuilder<ClientAuthDBISAR, String?, QQueryOperations> schemeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'scheme');
    });
  }

  QueryBuilder<ClientAuthDBISAR, String?, QQueryOperations> secretProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'secret');
    });
  }

  QueryBuilder<ClientAuthDBISAR, String?, QQueryOperations> serverProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'server');
    });
  }

  QueryBuilder<ClientAuthDBISAR, int?, QQueryOperations>
      updateTimestampProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'updateTimestamp');
    });
  }
}
