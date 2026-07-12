import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/locale_provider.dart';
import '../providers/search_provider.dart';
import '../widgets/filter_button.dart';
import '../widgets/language_toggle.dart';
import '../widgets/page_navigator.dart';
import '../widgets/results_list.dart';
import '../widgets/search_field.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<SearchProvider>();
    final strings = context.watch<LocaleProvider>().strings;

    return Scaffold(
      appBar: AppBar(title: Text(strings.appTitle)),
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                const Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(12, 8, 12, 0),
                    child: LanguageToggle(),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.fromLTRB(12, 8, 12, 0),
                  child: Row(
                    children: [
                      Expanded(child: SearchField()),
                      SizedBox(width: 8),
                      FilterButton(),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 8, 12, 4),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      strings.resultsCount(provider.results.length),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                ),
                const Divider(height: 1),
                const Expanded(child: ResultsList()),
                const Divider(height: 1),
                const PageNavigator(),
              ],
            ),
    );
  }
}
