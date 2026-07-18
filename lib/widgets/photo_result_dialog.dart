import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/locale_provider.dart';
import '../providers/search_provider.dart';
import '../providers/tab_provider.dart';

void showPhotoResultDialog(BuildContext context, String translatedLabel) {
  final strings = context.read<LocaleProvider>().strings;

  showDialog<void>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(strings.photoResultTitle),
      content: Text(translatedLabel, style: Theme.of(context).textTheme.headlineSmall),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(strings.close),
        ),
        FilledButton(
          onPressed: () {
            context.read<SearchProvider>().updateQuery(translatedLabel);
            context.read<TabProvider>().goToSearch();
            Navigator.of(context).pop();
          },
          child: Text(strings.searchAction),
        ),
      ],
    ),
  );
}
