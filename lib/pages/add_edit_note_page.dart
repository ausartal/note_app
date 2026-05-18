import 'package:flutter/material.dart';
import 'package:note_app/models/note.dart';
import 'package:note_app/providers/note_provider.dart';
import 'package:note_app/widgets/note_form_widget.dart';
import 'package:provider/provider.dart';

class AddEditNotePage extends StatefulWidget {
  final Note? note;

  const AddEditNotePage({super.key, this.note});

  @override
  State<AddEditNotePage> createState() => _AddEditNotePageState();
}

class _AddEditNotePageState extends State<AddEditNotePage> {
  final _formKey = GlobalKey<FormState>();
  late bool isImportant;
  late int number;
  late String title;
  late String description;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();

    final note = widget.note;
    isImportant = note?.isImportant ?? false;
    number = note?.number ?? 0;
    title = note?.title ?? '';
    description = note?.description ?? '';
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.note != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Note' : 'Add Note'),
        actions: [
          IconButton(
            icon: _isSaving
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2.2),
                  )
                : const Icon(Icons.save_rounded),
            onPressed: _isSaving ? null : _saveNote,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: NoteFormWidget(
          formKey: _formKey,
          isImportant: isImportant,
          number: number,
          title: title,
          description: description,
          onChangedImportant: (value) => setState(() => isImportant = value),
          onChangedNumber: (value) => setState(() => number = value),
          onChangedTitle: (value) => title = value,
          onChangedDescription: (value) => description = value,
          onSaved: _saveNote,
        ),
      ),
    );
  }

  Future<void> _saveNote() async {
    if (_isSaving) return;
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    try {
      final provider = context.read<NoteProvider>();

      if (widget.note == null) {
        final note = Note(
          isImportant: isImportant,
          number: number,
          title: title.trim(),
          description: description.trim(),
          createdTime: DateTime.now(),
        );
        await provider.addNote(note);
      } else {
        final note = widget.note!.copy(
          isImportant: isImportant,
          number: number,
          title: title.trim(),
          description: description.trim(),
        );
        await provider.updateNote(note);
      }

      if (mounted) Navigator.of(context).pop(true);
    } catch (error, stackTrace) {
      debugPrint('AddEditNotePage _saveNote error: $error');
      debugPrintStack(stackTrace: stackTrace);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal menyimpan note, coba lagi.')),
      );
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }
}
