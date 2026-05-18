import 'package:note_app/models/note.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class NoteDatabase {
  static final NoteDatabase instance = NoteDatabase._internal();

  static Database? _database;

  NoteDatabase._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('notes.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE ${NoteFields.tableName} (
        ${NoteFields.id} INTEGER PRIMARY KEY AUTOINCREMENT,
        ${NoteFields.isImportant} INTEGER NOT NULL,
        ${NoteFields.number} INTEGER NOT NULL,
        ${NoteFields.title} TEXT NOT NULL,
        ${NoteFields.description} TEXT NOT NULL,
        ${NoteFields.createdTime} TEXT NOT NULL
      )
    ''');
  }

  Future<Note> create(Note note) async {
    final db = await instance.database;
    final id = await db.insert(NoteFields.tableName, note.toJson());
    return note.copy(id: id);
  }

  Future<Note> getNoteById(int id) async {
    final db = await instance.database;

    final maps = await db.query(
      NoteFields.tableName,
      columns: NoteFields.values,
      where: '${NoteFields.id} = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Note.fromJson(maps.first);
    }

    throw Exception('ID $id not found');
  }

  Future<List<Note>> getAllNotes() async {
    final db = await instance.database;

    final orderBy = '${NoteFields.createdTime} DESC';
    final result = await db.query(NoteFields.tableName, orderBy: orderBy);

    return result.map((json) => Note.fromJson(json)).toList();
  }

  Future<void> seedDummyNotesIfEmpty() async {
    final db = await instance.database;
    final countResult = await db.rawQuery(
      'SELECT COUNT(*) as count FROM ${NoteFields.tableName}',
    );
    final count = (countResult.first['count'] as int?) ?? 0;

    if (count > 0) {
      return;
    }

    final now = DateTime.now();
    final dummyNotes = [
      Note(
        isImportant: true,
        number: 5,
        title: 'Welcome to Note App',
        description:
            'Ini note dummy pertama. Kamu bisa edit, hapus, atau pakai sebagai template note penting.',
        createdTime: now.subtract(const Duration(hours: 2)),
      ),
      Note(
        isImportant: false,
        number: 2,
        title: 'Belanja Mingguan',
        description:
            'Susu, roti, telur, buah, dan kopi. Tambahkan kebutuhan lain kalau ada diskon.',
        createdTime: now.subtract(const Duration(days: 1)),
      ),
      Note(
        isImportant: true,
        number: 4,
        title: 'Ide Project',
        description:
            'Buat fitur reminder dan kategori warna biar catatan makin rapi dan gampang dicari.',
        createdTime: now.subtract(const Duration(days: 2)),
      ),
    ];

    final batch = db.batch();
    for (final note in dummyNotes) {
      batch.insert(NoteFields.tableName, note.toJson());
    }
    await batch.commit(noResult: true);
  }

  Future<int> updateNote(Note note) async {
    final db = await instance.database;

    return db.update(
      NoteFields.tableName,
      note.toJson(),
      where: '${NoteFields.id} = ?',
      whereArgs: [note.id],
    );
  }

  Future<int> deleteNoteById(int id) async {
    final db = await instance.database;

    return await db.delete(
      NoteFields.tableName,
      where: '${NoteFields.id} = ?',
      whereArgs: [id],
    );
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
