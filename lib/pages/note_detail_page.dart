import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:note_app/models/note.dart';
import 'package:note_app/pages/add_edit_note_page.dart';
import 'package:note_app/providers/note_provider.dart';
import 'package:provider/provider.dart';

class NoteDetailPage extends StatefulWidget {
  final int noteId;

  const NoteDetailPage({super.key, required this.noteId});

  @override
  State<NoteDetailPage> createState() => _NoteDetailPageState();
}

class _NoteDetailPageState extends State<NoteDetailPage> {
  late Future<Note> _noteFuture;

  @override
  void initState() {
    super.initState();
    _noteFuture = _fetchNote();
  }

  Future<Note> _fetchNote() {
    return context.read<NoteProvider>().getNoteById(widget.noteId);
  }

  Future<void> _refreshNote() async {
    setState(() {
      _noteFuture = _fetchNote();
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Note>(
      future: _noteFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (!snapshot.hasData) {
          return Scaffold(
            appBar: AppBar(),
            body: const Center(child: Text('Note not found')),
          );
        }

        final note = snapshot.data!;

        return Scaffold(
          appBar: AppBar(
            actions: [
              IconButton(
                tooltip: 'Edit',
                icon: const Icon(Icons.edit_rounded),
                onPressed: () async {
                  final updated = await Navigator.of(context).push<bool>(
                    MaterialPageRoute<bool>(
                      builder: (_) => AddEditNotePage(note: note),
                    ),
                  );
                  if (updated == true && context.mounted) {
                    await _refreshNote();
                  }
                },
              ),
              IconButton(
                tooltip: 'Delete',
                icon: const Icon(Icons.delete_outline_rounded),
                onPressed: () async {
                  await context.read<NoteProvider>().deleteNoteById(note.id!);
                  if (context.mounted) Navigator.of(context).pop();
                },
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: ListView(
              children: [
                Text(
                  note.title,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  DateFormat('MMM dd, yyyy • hh:mm a').format(note.createdTime),
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  note.description,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge?.copyWith(height: 1.45),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
