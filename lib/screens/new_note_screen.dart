import 'package:flutter/material.dart';
import '../models/note_model.dart';
import '../services/note_service.dart';

class NewNoteScreen extends StatefulWidget {
  final String initialTitle;
  final String initialDesc;

  const NewNoteScreen({
    super.key,
    required this.initialTitle,
    required this.initialDesc,
  });

  @override
  State<NewNoteScreen> createState() => _NewNoteScreenState();
}

class _NewNoteScreenState extends State<NewNoteScreen> {
  late TextEditingController _titleController;
  late TextEditingController _descController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.initialTitle);
    _descController = TextEditingController(text: widget.initialDesc);
  }

  void _saveNote() async {
    final note = Note(
      title: _titleController.text,
      description: _descController.text,
      lastUpdated: DateTime.now(),
    );
    await NoteService.addNote(note);
    Navigator.pop(context); // kembali ke home
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Catatan Panjang'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              style: const TextStyle(fontSize: 20, color: Colors.white),
              decoration: const InputDecoration(
                hintText: 'Judul',
                hintStyle: TextStyle(color: Colors.white54),
                border: InputBorder.none,
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: TextField(
                controller: _descController,
                style: const TextStyle(fontSize: 16, color: Colors.white),
                maxLines: null,
                decoration: const InputDecoration(
                  hintText: 'Deskripsi panjang...',
                  hintStyle: TextStyle(color: Colors.white54),
                  border: InputBorder.none,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: _saveNote,
                child: const Text('SIMPAN'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}