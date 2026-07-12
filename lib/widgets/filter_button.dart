import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/search_provider.dart';
import 'filter_sheet.dart';

class FilterButton extends StatelessWidget {
  const FilterButton({super.key});

  @override
  Widget build(BuildContext context) {
    final activeCount =
        context.watch<SearchProvider>().filters.values.where((value) => value != null).length;

    return Badge(
      label: Text('$activeCount'),
      isLabelVisible: activeCount > 0,
      child: IconButton.filledTonal(
        icon: const Icon(Icons.tune),
        onPressed: () => showFilterSheet(context),
      ),
    );
  }
}
