import 'package:flutter/material.dart';
import 'package:note_app/database/note_database.dart';
import 'package:note_app/models/note.dart';

enum NoteSort { dateNewest, dateOldest, importantFirst }

class NoteProvider extends ChangeNotifier {
  List<Note> _notes = [];
  bool _isLoading = false;
  String _query = '';
  NoteSort _sort = NoteSort.dateNewest;

  bool get isLoading => _isLoading;
  String get query => _query;
  NoteSort get sort => _sort;

  List<Note> get notes {
    final filtered = _notes.where((note) {
      if (_query.trim().isEmpty) return true;
      final q = _query.toLowerCase();
      return note.title.toLowerCase().contains(q) ||
          note.description.toLowerCase().contains(q);
    }).toList();

    switch (_sort) {
      case NoteSort.dateNewest:
        filtered.sort((a, b) => b.createdTime.compareTo(a.createdTime));
      case NoteSort.dateOldest:
        filtered.sort((a, b) => a.createdTime.compareTo(b.createdTime));
      case NoteSort.importantFirst:
        filtered.sort((a, b) {
          if (a.isImportant == b.isImportant) {
            return b.createdTime.compareTo(a.createdTime);
          }
          return (b.isImportant ? 1 : 0).compareTo(a.isImportant ? 1 : 0);
        });
    }

    return filtered;
  }

  Future<void> loadNotes() async {
    _isLoading = true;
    notifyListeners();

    try {
      await NoteDatabase.instance.seedDummyNotesIfEmpty();
      _notes = await NoteDatabase.instance.getAllNotes();
    } catch (error, stackTrace) {
      debugPrint('NoteProvider.loadNotes error: $error');
      debugPrintStack(stackTrace: stackTrace);
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void setSearchQuery(String value) {
    _query = value;
    notifyListeners();
  }

  void setSort(NoteSort value) {
    _sort = value;
    notifyListeners();
  }

  Future<void> addNote(Note note) async {
    await NoteDatabase.instance.create(note);
    await loadNotes();
  }

  Future<void> updateNote(Note note) async {
    await NoteDatabase.instance.updateNote(note);
    await loadNotes();
  }

  Future<void> deleteNoteById(int id) async {
    await NoteDatabase.instance.deleteNoteById(id);
    await loadNotes();
  }

  Future<Note> getNoteById(int id) => NoteDatabase.instance.getNoteById(id);
}
