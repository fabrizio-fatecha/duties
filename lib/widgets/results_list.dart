import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/locale_provider.dart';
import '../providers/search_provider.dart';
import 'result_tile.dart';

/// Renders only the current page (50 records) so the list never grows
/// unbounded — see [SearchProvider.pageResults].
class ResultsList extends StatelessWidget {
  const ResultsList({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<SearchProvider>();

    if (provider.results.isEmpty) {
      final strings = context.watch<LocaleProvider>().strings;
      return Center(child: Text(strings.noResults));
    }

    final page = provider.pageResults;
    return ListView.builder(
      itemCount: page.length,
      itemBuilder: (context, index) => ResultTile(record: page[index]),
    );
  }
}
