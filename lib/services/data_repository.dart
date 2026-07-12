import '../models/tariff_record.dart';
import 'csv_loader.dart';

/// In-memory read-only "database" over the bundled CSV.
///
/// Builds a value -> row-indices index per filterable field so filtering
/// is a set lookup/intersection instead of a full list scan.
class DataRepository {
  static const filterFields = ['aec', 'regimen'];

  List<TariffRecord> _records = [];
  final Map<String, Map<String, Set<int>>> _index = {
    for (final field in filterFields) field: {},
  };

  List<TariffRecord> get records => _records;

  Future<void> loadData() async {
    _records = await CsvLoader.load();
    _buildIndex();
  }

  void _buildIndex() {
    for (var i = 0; i < _records.length; i++) {
      final record = _records[i];
      _addToIndex('aec', record.aec, i);
      _addToIndex('regimen', record.regimen, i);
    }
  }

  void _addToIndex(String field, String value, int recordIndex) {
    _index[field]!.putIfAbsent(value, () => <int>{}).add(recordIndex);
  }

  /// Distinct non-empty values for a filterable field, sorted for display.
  List<String> valuesFor(String field) {
    final values = (_index[field]?.keys ?? const <String>[])
        .where((value) => value.isNotEmpty)
        .toList();
    values.sort();
    return values;
  }

  List<TariffRecord> search(String query, Map<String, String?> filters) {
    Set<int>? candidates;

    for (final field in filterFields) {
      final value = filters[field];
      if (value == null) continue;
      final matches = _index[field]?[value] ?? const <int>{};
      candidates = candidates == null ? {...matches} : candidates.intersection(matches);
    }

    final indices = candidates ?? Set<int>.from(List.generate(_records.length, (i) => i));

    final lowerQuery = query.trim().toLowerCase();
    final results = <TariffRecord>[];
    for (final i in indices) {
      final record = _records[i];
      final matchesText = lowerQuery.isEmpty ||
          record.descriptionLower.contains(lowerQuery) ||
          record.ncm.contains(lowerQuery);
      if (matchesText) results.add(record);
    }

    results.sort((a, b) => a.id.compareTo(b.id));
    return results;
  }
}
