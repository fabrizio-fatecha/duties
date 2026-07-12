import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/locale_provider.dart';
import '../providers/search_provider.dart';

void showFilterSheet(BuildContext context) {
  showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    builder: (context) => const FilterSheet(),
  );
}

class FilterSheet extends StatelessWidget {
  const FilterSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<SearchProvider>();
    final strings = context.watch<LocaleProvider>().strings;
    final fields = {
      'aec': strings.aecRate,
      'iva': strings.vatIva,
      'regimen': strings.regime,
    };

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(strings.filters, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 16),
          for (final field in fields.keys)
            Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: _FilterDropdown(
                field: field,
                label: fields[field]!,
                allLabel: strings.allOption,
                selected: provider.filters[field],
                options: provider.valuesFor(field),
              ),
            ),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: provider.clearFilters,
              child: Text(strings.clearAll),
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterDropdown extends StatelessWidget {
  const _FilterDropdown({
    required this.field,
    required this.label,
    required this.allLabel,
    required this.selected,
    required this.options,
  });

  final String field;
  final String label;
  final String allLabel;
  final String? selected;
  final List<String> options;

  @override
  Widget build(BuildContext context) {
    final provider = context.read<SearchProvider>();

    return DropdownButtonFormField<String?>(
      initialValue: selected,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        isDense: true,
      ),
      items: [
        DropdownMenuItem(value: null, child: Text(allLabel)),
        for (final option in options) DropdownMenuItem(value: option, child: Text(option)),
      ],
      onChanged: (value) => provider.updateFilter(field, value),
    );
  }
}
