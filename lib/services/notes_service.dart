import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

/// Stores user notes (keyed by NCM code) in a plain text file under the
/// app's own document directory. Survives app updates. Does NOT survive
/// a full uninstall unless the device restores it via Android's own
/// backup — that's a platform limitation, not something the file format
/// changes.
class NotesService {
  static const _fileName = 'notes.txt';

  Future<File> _file() async {
    final dir = await getApplicationDocumentsDirectory();
    return File('${dir.path}/$_fileName');
  }

  Future<Map<String, String>> loadAll() async {
    try {
      final file = await _file();
      if (!await file.exists()) return {};
      final content = await file.readAsString();
      if (content.trim().isEmpty) return {};
      final decoded = jsonDecode(content) as Map<String, dynamic>;
      return decoded.map((key, value) => MapEntry(key, value.toString()));
    } catch (_) {
      return {};
    }
  }

  Future<void> saveAll(Map<String, String> notes) async {
    final file = await _file();
    await file.writeAsString(jsonEncode(notes));
  }
}
