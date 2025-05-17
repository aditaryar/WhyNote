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
    Navigator.pop(context);
  }

  // InputDecoration customInputDecoration(String hint) {
  //   return InputDecoration(
  //     hintText: hint,
  //     hintStyle: const TextStyle(
  //       color: Colors.white54,
  //       fontFamily: 'Montserrat',
  //     ),
  //     filled: true,
  //     fillColor: const Color(0xFF03100E), // warna fill box
  //     contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
  //     border: OutlineInputBorder(
  //       borderRadius: BorderRadius.circular(12),
  //       borderSide: const BorderSide(
  //         color: Color(0xFF58DAC7), // warna border box
  //         width: 1.5,
  //       ),
  //     ),
  //     enabledBorder: OutlineInputBorder(
  //       borderRadius: BorderRadius.circular(12),
  //       borderSide: const BorderSide(color: Color(0xFF58DAC7), width: 1.5),
  //     ),
  //     focusedBorder: OutlineInputBorder(
  //       borderRadius: BorderRadius.circular(12),
  //       borderSide: const BorderSide(color: Color(0xFF58DAC7), width: 2),
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF03100E),
      // appBar: AppBar(
      //   title: const Text(
      //     'Catatan Panjang',
      //     style: TextStyle(
      //       fontFamily: 'Montserrat',
      //       fontWeight: FontWeight.w600,
      //     ),
      //   ),
      //   backgroundColor: Colors.black,
      //   // foregroundColor: Colors.white,
      // ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              style: const TextStyle(
                fontSize: 20,
                color: Colors.white,
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w600,
              ),
              // decoration: customInputDecoration('Judul'),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: TextField(
                controller: _descController,
                style: const TextStyle(
                  fontSize: 15,
                  color: Colors.white,
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w200,
                ),
                maxLines: null,
                // decoration: customInputDecoration('Deskripsi'),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 20,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Text(
                      'CANCEL',
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        color: Color(0xFF565656),
                        fontWeight: FontWeight.w600,
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
                      color: Color(0xFF58DAC7),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Text(
                      'SIMPAN',
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        color: Color(0xFF03100E),
                        fontWeight: FontWeight.bold,
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
