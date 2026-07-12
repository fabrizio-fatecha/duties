import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/locale_provider.dart';
import 'providers/search_provider.dart';
import 'screens/search_screen.dart';
import 'services/data_repository.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SearchProvider(DataRepository())..init()),
        ChangeNotifierProvider(create: (_) => LocaleProvider()),
      ],
      child: MaterialApp(
        title: 'Duties',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFFFF7A1A),
            brightness: Brightness.dark,
          ),
          scaffoldBackgroundColor: const Color(0xFF0D0D0D),
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFF161616),
            foregroundColor: Color(0xFFFF7A1A),
          ),
        ),
        home: const SearchScreen(),
      ),
    );
  }
}
