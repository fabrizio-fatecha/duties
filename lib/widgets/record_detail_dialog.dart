import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../localization/app_strings.dart';
import '../models/tariff_record.dart';
import '../providers/locale_provider.dart';

void showRecordDetailDialog(BuildContext context, TariffRecord record) {
  final strings = context.read<LocaleProvider>().strings;
  final fields = _fields(record, strings);

  showDialog<void>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(strings.detailTitle),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (final field in fields) _DetailRow(label: field.key, value: field.value),
          ],
        ),
      ),
      actions: [
        TextButton.icon(
          onPressed: () => _copyRecord(context, fields, strings),
          icon: const Icon(Icons.copy_all_outlined),
          label: Text(strings.copy),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(strings.close),
        ),
      ],
    ),
  );
}

/// Every column from the CSV, in source order, label -> value.
List<MapEntry<String, String>> _fields(TariffRecord record, AppStrings strings) => [
      MapEntry(strings.ncmLabel, record.ncm),
      MapEntry(strings.descriptionLabel, record.description),
      MapEntry(strings.aecRate, _orEmpty(record.aec, strings)),
      MapEntry(strings.anvLabel, _orEmpty(record.anv, strings)),
      MapEntry(strings.omcLabel, _orEmpty(record.omc, strings)),
      MapEntry(strings.listaLabel, _orEmpty(record.lista, strings)),
      MapEntry(strings.intraLabel, _orEmpty(record.intra, strings)),
      MapEntry(strings.extraLabel, _orEmpty(record.extra, strings)),
      MapEntry(strings.vatIva, _orEmpty(record.iva, strings)),
      MapEntry(strings.rentaLabel, _orEmpty(record.renta, strings)),
      MapEntry(strings.iscLabel, _orEmpty(record.isc, strings)),
      MapEntry(strings.regime, _orEmpty(record.regimen, strings)),
    ];

String _orEmpty(String value, AppStrings strings) => value.isEmpty ? strings.emptyValue : value;

void _copyRecord(BuildContext context, List<MapEntry<String, String>> fields, AppStrings strings) {
  final text = fields.map((field) => '${field.key}: ${field.value}').join('\n');

  Clipboard.setData(ClipboardData(text: text));
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(strings.copied)));
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: Theme.of(context)
                .textTheme
                .labelMedium
                ?.copyWith(color: Theme.of(context).colorScheme.primary),
          ),
          Text(value),
        ],
      ),
    );
  }
}
