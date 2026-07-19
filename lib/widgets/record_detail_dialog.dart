import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../localization/app_strings.dart';
import '../models/tariff_record.dart';
import '../providers/locale_provider.dart';
import '../providers/notes_provider.dart';
import 'notes_editor.dart';

void showRecordDetailDialog(BuildContext context, TariffRecord record) {
  final strings = context.read<LocaleProvider>().strings;
  final chips = _chipFields(record, strings);

  showDialog<void>(
    context: context,
    builder: (context) => AlertDialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      title: Text(record.ncm, style: Theme.of(context).textTheme.titleMedium),
      content: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 400, maxHeight: 480),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(record.description),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [for (final chip in chips) _FieldChip(label: chip.key, value: chip.value)],
              ),
              const SizedBox(height: 16),
              NotesEditor(ncm: record.ncm),
            ],
          ),
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

/// Short technical fields shown as chips. Empty ones are skipped to keep
/// the popup compact — most rows don't have every field filled in.
List<MapEntry<String, String>> _chipFields(TariffRecord record, AppStrings strings) => [
      MapEntry(strings.aecRate, record.aec),
      MapEntry(strings.anvLabel, record.anv),
      MapEntry(strings.omcLabel, record.omc),
      MapEntry(strings.listaLabel, record.lista),
      MapEntry(strings.intraLabel, record.intra),
      MapEntry(strings.extraLabel, record.extra),
      MapEntry(strings.vatIva, record.iva),
      MapEntry(strings.rentaLabel, record.renta),
      MapEntry(strings.iscLabel, record.isc),
      MapEntry(strings.regime, record.regimen),
    ].where((field) => field.value.isNotEmpty).toList();

void _copyRecord(BuildContext context, TariffRecord record, AppStrings strings) {
  final note = context.read<NotesProvider>().noteFor(record.ncm);
  final lines = [
    '${strings.ncmLabel}: ${record.ncm}',
    '${strings.descriptionLabel}: ${record.description}',
    for (final chip in _chipFields(record, strings)) '${chip.key}: ${chip.value}',
    if (note.isNotEmpty) '${strings.notesLabel}: $note',
  ];

  Clipboard.setData(ClipboardData(text: lines.join('\n')));
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(strings.copied)));
}

class _FieldChip extends StatelessWidget {
  const _FieldChip({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
      ),
      child: RichText(
        text: TextSpan(
          style: DefaultTextStyle.of(context).style.copyWith(fontSize: 13),
          children: [
            TextSpan(text: '$label ', style: TextStyle(color: colorScheme.primary)),
            TextSpan(text: value),
          ],
        ),
      ),
    );
  }
}
