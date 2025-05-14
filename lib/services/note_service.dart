import 'package:hive/hive.dart';
import '../models/note_model.dart';

class NoteService {
  static final _box = Hive.box<Note>('notes');

  static Future<void> addNote(Note note) async {
    await _box.add(note);
  }

  static Future<void> deleteNote(Note note) async {
    await note.delete();
  }

  static Future<void> updateNote(Note note, String newTitle, String newDesc) async {
    note.title = newTitle;
    note.description = newDesc;
    note.lastUpdated = DateTime.now();
    await note.save();
  }
}