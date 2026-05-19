/// Namecoin name-script encoding/decoding for the ElectrumX
/// `name_show` flow. Lifted from the reference implementations and
/// kept byte-compatible with them:
///
///   * Go:     `mstrofnone/nostrlib-nip05-namecoin/namecoin/script.go`
///   * Kotlin: `vitorpamplona/amethyst` `NameScript.kt`
///   * Dart:   `ethicnology/dart-nostr` `script.dart`
///   * TS:     `nbd-wtf/nostr-tools` PR #533 `nip05namecoin.ts`
///
/// One deliberate divergence from dart-nostr#44: the vout decoder
/// here accepts BOTH `OP_NAME_UPDATE` (0x53 / OP_3) AND
/// `OP_NAME_FIRSTUPDATE` (0x52 / OP_2). Names in their first-update
/// window resolve correctly with this parser; dart-nostr will be
/// fixed separately upstream.
library;

import 'dart:convert';
import 'dart:typed_data';

import 'package:convert/convert.dart';
import 'package:crypto/crypto.dart' as crypto;

const int opNameFirstUpdate = 0x52; // OP_2, repurposed by Namecoin
const int opNameUpdate = 0x53; // OP_3, repurposed by Namecoin
const int op2Drop = 0x6d;
const int opDrop = 0x75;
const int opReturn = 0x6a;
const int opPushData1 = 0x4c;
const int opPushData2 = 0x4d;
const int opPushData4 = 0x4e;

/// Builds the canonical name-index script used by the Namecoin
/// ElectrumX fork to index a name on-chain. SHA-256 (reversed,
/// hex-encoded) of this is the scripthash queried via
/// `blockchain.scripthash.get_history`.
Uint8List buildNameIndexScript(List<int> nameBytes) {
  final out = <int>[];
  out.add(opNameUpdate);
  _pushData(out, nameBytes);
  _pushData(out, const []);
  out
    ..add(op2Drop)
    ..add(opDrop)
    ..add(opReturn);
  return Uint8List.fromList(out);
}

/// Computes the Electrum-style scripthash: SHA-256(script), byte-
/// reversed, hex-encoded.
String electrumScriptHash(List<int> script) {
  final digest = Uint8List.fromList(crypto.sha256.convert(script).bytes);
  for (var i = 0, j = digest.length - 1; i < j; i++, j--) {
    final tmp = digest[i];
    digest[i] = digest[j];
    digest[j] = tmp;
  }
  return hex.encode(digest);
}

/// A parsed `NAME_UPDATE` / `NAME_FIRSTUPDATE` output: `(name, value)`.
class NameScript {
  final String name;
  final String value;
  const NameScript({required this.name, required this.value});
}

/// Extracts `(name, value)` from a `NAME_*` output script.
///
/// Accepted leading opcodes:
///   * `OP_NAME_UPDATE`      (`OP_3`, 0x53): `<name> <value>` pushes
///   * `OP_NAME_FIRSTUPDATE` (`OP_2`, 0x52): `<name> <rand> <value>`
///     pushes — we skip the random nonce and use the third push.
///
/// Returns `null` if [script] doesn't start with a recognised name
/// opcode or the push-data layout is malformed.
NameScript? parseNameScript(List<int> script) {
  if (script.isEmpty) return null;
  final op = script[0];
  if (op != opNameUpdate && op != opNameFirstUpdate) return null;

  var pos = 1;
  final nameRead = _readPushData(script, pos);
  if (nameRead == null) return null;
  pos = nameRead.next;

  _PushRead? valueRead;
  if (op == opNameUpdate) {
    valueRead = _readPushData(script, pos);
  } else {
    // NAME_FIRSTUPDATE: <rand> then <value>. Skip rand.
    final randRead = _readPushData(script, pos);
    if (randRead == null) return null;
    pos = randRead.next;
    valueRead = _readPushData(script, pos);
  }
  if (valueRead == null) return null;

  try {
    return NameScript(
      name: utf8.decode(nameRead.data, allowMalformed: true),
      value: utf8.decode(valueRead.data, allowMalformed: true),
    );
  } on FormatException {
    return null;
  }
}

void _pushData(List<int> out, List<int> data) {
  final n = data.length;
  if (n < opPushData1) {
    out.add(n);
  } else if (n <= 0xff) {
    out
      ..add(opPushData1)
      ..add(n);
  } else {
    out
      ..add(opPushData2)
      ..add(n & 0xff)
      ..add((n >> 8) & 0xff);
  }
  out.addAll(data);
}

class _PushRead {
  final Uint8List data;
  final int next;
  const _PushRead(this.data, this.next);
}

_PushRead? _readPushData(List<int> script, int pos) {
  if (pos >= script.length) return null;
  final op = script[pos];

  if (op == 0x00) {
    return _PushRead(Uint8List(0), pos + 1);
  }
  if (op < opPushData1) {
    final length = op;
    final end = pos + 1 + length;
    if (end > script.length) return null;
    return _PushRead(Uint8List.fromList(script.sublist(pos + 1, end)), end);
  }
  if (op == opPushData1) {
    if (pos + 2 > script.length) return null;
    final length = script[pos + 1];
    final end = pos + 2 + length;
    if (end > script.length) return null;
    return _PushRead(Uint8List.fromList(script.sublist(pos + 2, end)), end);
  }
  if (op == opPushData2) {
    if (pos + 3 > script.length) return null;
    final length = script[pos + 1] | (script[pos + 2] << 8);
    final end = pos + 3 + length;
    if (end > script.length) return null;
    return _PushRead(Uint8List.fromList(script.sublist(pos + 3, end)), end);
  }
  if (op == opPushData4) {
    if (pos + 5 > script.length) return null;
    final length = script[pos + 1] |
        (script[pos + 2] << 8) |
        (script[pos + 3] << 16) |
        (script[pos + 4] << 24);
    final end = pos + 5 + length;
    if (end < 0 || end > script.length) return null;
    return _PushRead(Uint8List.fromList(script.sublist(pos + 5, end)), end);
  }
  return null;
}
