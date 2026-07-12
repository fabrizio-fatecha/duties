import 'dart:async';

import 'package:flutter/foundation.dart';

import '../models/tariff_record.dart';
import '../services/data_repository.dart';

class SearchProvider extends ChangeNotifier {
  SearchProvider(this.repository);

  final DataRepository repository;

  static const pageSize = 50;
  static const _debounceDelay = Duration(milliseconds: 300);

  bool isLoading = true;
  String query = '';
  final Map<String, String?> filters = {
    'aec': null,
    'iva': null,
    'regimen': null,
  };

  List<TariffRecord> results = [];
  int currentPage = 0;

  Timer? _debounce;

  Future<void> init() async {
    await repository.loadData();
    isLoading = false;
    _applyFilters();
  }

  void updateQuery(String value) {
    query = value;
    _debounce?.cancel();
    _debounce = Timer(_debounceDelay, _applyFilters);
  }

  void updateFilter(String field, String? value) {
    filters[field] = value;
    _applyFilters();
  }

  void clearFilters() {
    for (final field in filters.keys) {
      filters[field] = null;
    }
    query = '';
    _applyFilters();
  }

  int get totalPages => results.isEmpty ? 1 : (results.length / pageSize).ceil();

  List<TariffRecord> get pageResults {
    final start = currentPage * pageSize;
    if (start >= results.length) return [];
    final end = (start + pageSize).clamp(0, results.length);
    return results.sublist(start, end);
  }

  void nextPage() {
    if (currentPage >= totalPages - 1) return;
    currentPage++;
    notifyListeners();
  }

  void previousPage() {
    if (currentPage <= 0) return;
    currentPage--;
    notifyListeners();
  }

  List<String> valuesFor(String field) => repository.valuesFor(field);

  void _applyFilters() {
    results = repository.search(query, filters);
    currentPage = 0;
    notifyListeners();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }
}
