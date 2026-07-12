import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../localization/app_strings.dart';
import '../models/tariff_record.dart';
import '../providers/locale_provider.dart';

void showRecordDetailDialog(BuildContext context, TariffRecord record) {
  final strings = context.read<LocaleProvider>().strings;

  showDialog<void>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(strings.detailTitle),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _DetailRow(label: strings.ncmLabel, value: record.ncm),
            _DetailRow(label: strings.descriptionLabel, value: record.description),
            _DetailRow(label: strings.aecRate, value: _orEmpty(record.aec, strings)),
            _DetailRow(label: strings.vatIva, value: _orEmpty(record.iva, strings)),
            _DetailRow(label: strings.regime, value: _orEmpty(record.regimen, strings)),
          ],
        ),
      ),
      actions: [
        TextButton.icon(
          onPressed: () => _copyRecord(context, record, strings),
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

String _orEmpty(String value, AppStrings strings) => value.isEmpty ? strings.emptyValue : value;

void _copyRecord(BuildContext context, TariffRecord record, AppStrings strings) {
  final text = [
    '${strings.ncmLabel}: ${record.ncm}',
    '${strings.descriptionLabel}: ${record.description}',
    '${strings.aecRate}: ${_orEmpty(record.aec, strings)}',
    '${strings.vatIva}: ${_orEmpty(record.iva, strings)}',
    '${strings.regime}: ${_orEmpty(record.regimen, strings)}',
  ].join('\n');

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
