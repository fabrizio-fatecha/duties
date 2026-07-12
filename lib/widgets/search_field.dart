import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/locale_provider.dart';
import '../providers/search_provider.dart';

class SearchField extends StatefulWidget {
  const SearchField({super.key});

  @override
  State<SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: context.read<SearchProvider>().query);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<SearchProvider>();
    final strings = context.watch<LocaleProvider>().strings;

    // Keep the field in sync when the query is reset from outside (e.g. "Clear all").
    if (_controller.text != provider.query) {
      _controller.text = provider.query;
    }

    return TextField(
      controller: _controller,
      autocorrect: false,
      enableSuggestions: false,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.search),
        hintText: strings.searchHint,
        border: const OutlineInputBorder(),
        isDense: true,
      ),
      onChanged: provider.updateQuery,
    );
  }
}
