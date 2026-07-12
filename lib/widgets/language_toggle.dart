import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../localization/app_language.dart';
import '../providers/locale_provider.dart';

class LanguageToggle extends StatelessWidget {
  const LanguageToggle({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<LocaleProvider>();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: SegmentedButton<AppLanguage>(
        segments: const [
          ButtonSegment(value: AppLanguage.en, label: Text('EN')),
          ButtonSegment(value: AppLanguage.es, label: Text('ES')),
        ],
        selected: {provider.language},
        onSelectionChanged: (selection) => provider.toggle(selection.first),
        style: const ButtonStyle(visualDensity: VisualDensity.compact),
      ),
    );
  }
}
