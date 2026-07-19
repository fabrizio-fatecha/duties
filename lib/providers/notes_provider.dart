import 'package:flutter/foundation.dart';

import '../services/notes_service.dart';

class NotesProvider extends ChangeNotifier {
  final _service = NotesService();
  Map<String, String> _notes = {};

  Future<void> init() async {
    _notes = await _service.loadAll();
    notifyListeners();
  }

  String noteFor(String ncm) => _notes[ncm] ?? '';

  Future<void> setNote(String ncm, String note) async {
    final trimmed = note.trim();
    if (trimmed.isEmpty) {
      _notes.remove(ncm);
    } else {
      _notes[ncm] = trimmed;
    }
    notifyListeners();
    await _service.saveAll(_notes);
  }
}
