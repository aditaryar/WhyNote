import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_debouncer/flutter_debouncer.dart';

import '../models/note_model.dart';
import '../services/note_service.dart';

class DetailScreen extends StatefulWidget {
  final Note note;

  const DetailScreen({super.key, required this.note});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  late TextEditingController _titleController;
  late TextEditingController _descController;
  late final Debouncer _debouncer;
  late DateTime _lastUpdated;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.note.title);
    _descController = TextEditingController(text: widget.note.description);
    _lastUpdated = widget.note.lastUpdated;

    _debouncer = Debouncer();

    _titleController.addListener(_autoSave);
    _descController.addListener(_autoSave);
  }

  void _autoSave() {
    _debouncer.debounce(
      duration: const Duration(milliseconds: 300),
      onDebounce: () async {
        final updatedTitle = _titleController.text;
        final updatedDesc = _descController.text;

        final updatedNote =
            widget.note
              ..title = updatedTitle
              ..description = updatedDesc
              ..lastUpdated = DateTime.now();

        await NoteService.updateNote(widget.note, updatedTitle, updatedDesc);

        setState(() {
          _lastUpdated = updatedNote.lastUpdated;
        });
      },
    );
  }

  void _deleteNote() async {
    await NoteService.deleteNote(widget.note);
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    _debouncer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final formattedTime = DateFormat('d MMM yyyy, HH:mm').format(_lastUpdated);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          'Edit Catatan',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(icon: const Icon(Icons.delete), onPressed: _deleteNote),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(height: 20),
            TextField(
              controller: _titleController,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              decoration: const InputDecoration(
                hintText: 'Judul',
                hintStyle: TextStyle(color: Colors.white38),
                border: InputBorder.none,
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: TextField(
                controller: _descController,
                style: const TextStyle(fontSize: 16, color: Colors.white),
                maxLines: null,
                decoration: const InputDecoration(
                  hintText: 'Tulis catatanmu...',
                  hintStyle: TextStyle(color: Colors.white54),
                  border: InputBorder.none,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.center,
              child: Text(
                'Terakhir diubah: $formattedTime',
                style: const TextStyle(color: Colors.white38, fontSize: 12),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
