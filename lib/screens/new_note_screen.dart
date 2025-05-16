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

  void _cancelNote() {
    Navigator.pop(context); // kembali ke home tanpa menyimpan
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF03100E),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: _cancelNote,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 20,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey[700],
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Text(
                      'CANCEL',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        color: Colors.white70,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 2,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                GestureDetector(
                  onTap: _saveNote,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 20,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF58DAC7),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Text(
                      'SIMPAN',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        color: Color(0xFF03100E),
                        fontWeight: FontWeight.w800,
                        letterSpacing: 2,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}