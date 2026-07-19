import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:provider/provider.dart';

import 'providers/locale_provider.dart';
import 'providers/notes_provider.dart';
import 'providers/search_provider.dart';
import 'providers/tab_provider.dart';
import 'screens/root_shell.dart';
import 'services/data_repository.dart';

const _minSplashDuration = Duration(seconds: 5);

void main() {
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  // Keep the splash (and the "Developed by Fabrizio Fatecha" credit) on
  // screen for a fixed minimum time, regardless of how fast the device is.
  Future.delayed(_minSplashDuration, FlutterNativeSplash.remove);

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
        ChangeNotifierProvider(create: (_) => TabProvider()),
        ChangeNotifierProvider(create: (_) => NotesProvider()..init()),
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
        home: const RootShell(),
      ),
    );
  }
}
