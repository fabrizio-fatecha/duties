import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/locale_provider.dart';
import '../providers/tab_provider.dart';
import 'photo_screen.dart';
import 'search_screen.dart';

/// Keeps Search and Photo as separate sections (not mixed) via a bottom
/// nav bar. IndexedStack keeps both alive so switching tabs never resets
/// search state.
class RootShell extends StatelessWidget {
  const RootShell({super.key});

  @override
  Widget build(BuildContext context) {
    final tab = context.watch<TabProvider>();
    final strings = context.watch<LocaleProvider>().strings;

    return Scaffold(
      body: IndexedStack(
        index: tab.currentIndex,
        children: const [SearchScreen(), PhotoScreen()],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: tab.currentIndex,
        onDestinationSelected: tab.setIndex,
        destinations: [
          NavigationDestination(icon: const Icon(Icons.search), label: strings.searchTab),
          NavigationDestination(icon: const Icon(Icons.camera_alt_outlined), label: strings.photoTab),
        ],
      ),
    );
  }
}
