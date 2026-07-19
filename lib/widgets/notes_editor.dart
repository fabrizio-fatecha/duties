import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/locale_provider.dart';
import '../providers/notes_provider.dart';

class NotesEditor extends StatefulWidget {
  const NotesEditor({super.key, required this.ncm});

  final String ncm;

  @override
  State<NotesEditor> createState() => _NotesEditorState();
}

class _NotesEditorState extends State<NotesEditor> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: context.read<NotesProvider>().noteFor(widget.ncm));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _save() {
    final strings = context.read<LocaleProvider>().strings;
    context.read<NotesProvider>().setNote(widget.ncm, _controller.text);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(strings.noteSaved)));
  }

  @override
  Widget build(BuildContext context) {
    final strings = context.watch<LocaleProvider>().strings;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          strings.notesLabel,
          style: Theme.of(context)
              .textTheme
              .labelMedium
              ?.copyWith(color: Theme.of(context).colorScheme.primary),
        ),
        const SizedBox(height: 4),
        TextField(
          controller: _controller,
          maxLines: 3,
          minLines: 2,
          decoration: InputDecoration(
            hintText: strings.notesHint,
            border: const OutlineInputBorder(),
            isDense: true,
          ),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(onPressed: _save, child: Text(strings.saveNote)),
        ),
      ],
    );
  }
}
