import 'app_language.dart';

/// UI copy for both supported languages. The underlying CSV data (Spanish
/// tariff descriptions) is never translated — only app chrome is.
class AppStrings {
  const AppStrings._({
    required this.appTitle,
    required this.searchHint,
    required this.noResults,
    required this.filters,
    required this.aecRate,
    required this.vatIva,
    required this.regime,
    required this.allOption,
    required this.clearAll,
    required this.close,
    required this.copy,
    required this.copied,
    required this.detailTitle,
    required this.ncmLabel,
    required this.descriptionLabel,
    required this.emptyValue,
  });

  final String appTitle;
  final String searchHint;
  final String noResults;
  final String filters;
  final String aecRate;
  final String vatIva;
  final String regime;
  final String allOption;
  final String clearAll;
  final String close;
  final String copy;
  final String copied;
  final String detailTitle;
  final String ncmLabel;
  final String descriptionLabel;
  final String emptyValue;

  String resultsCount(int count) =>
      this == _en ? '$count results' : '$count resultados';

  String pageOf(int current, int total) =>
      this == _en ? 'Page $current of $total' : 'Página $current de $total';

  static const _en = AppStrings._(
    appTitle: 'Duties',
    searchHint: 'Search by description or NCM code',
    noResults: 'No results found',
    filters: 'Filters',
    aecRate: 'AEC rate',
    vatIva: 'VAT (IVA)',
    regime: 'Regime',
    allOption: 'All',
    clearAll: 'Clear all',
    close: 'Close',
    copy: 'Copy',
    copied: 'Copied to clipboard',
    detailTitle: 'Record details',
    ncmLabel: 'NCM code',
    descriptionLabel: 'Description',
    emptyValue: '—',
  );

  static const _es = AppStrings._(
    appTitle: 'Duties',
    searchHint: 'Buscar por descripción o código NCM',
    noResults: 'No se encontraron resultados',
    filters: 'Filtros',
    aecRate: 'Tasa AEC',
    vatIva: 'IVA',
    regime: 'Régimen',
    allOption: 'Todos',
    clearAll: 'Limpiar todo',
    close: 'Cerrar',
    copy: 'Copiar',
    copied: 'Copiado al portapapeles',
    detailTitle: 'Detalle del registro',
    ncmLabel: 'Código NCM',
    descriptionLabel: 'Descripción',
    emptyValue: '—',
  );

  static AppStrings of(AppLanguage language) =>
      language == AppLanguage.en ? _en : _es;
}
