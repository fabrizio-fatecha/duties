import 'package:csv/csv.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show rootBundle;

import '../models/tariff_record.dart';

const _csvAssetPath = 'assets/data.csv';

class CsvLoader {
  /// Loads and parses the bundled CSV off the UI thread via [compute].
  static Future<List<TariffRecord>> load() async {
    final raw = await rootBundle.loadString(_csvAssetPath);
    return compute(_parseCsv, raw);
  }
}

// Top-level so it can run in a background isolate via compute().
List<TariffRecord> _parseCsv(String raw) {
  // The file ships with a UTF-8 BOM on its first line.
  final cleaned = raw.startsWith('﻿') ? raw.substring(1) : raw;

  final rows = const CsvToListConverter(
    fieldDelimiter: ';',
    eol: '\n',
    shouldParseNumbers: false,
  ).convert(cleaned);

  if (rows.isEmpty) return [];

  final dataRows = rows.sublist(1); // drop header row
  return [
    for (var i = 0; i < dataRows.length; i++) TariffRecord.fromRow(i, dataRows[i]),
  ];
}
