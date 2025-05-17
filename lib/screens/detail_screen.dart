import 'dart:ui';

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

  Future<void> _confirmDelete() async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => Dialog(
            backgroundColor: const Color(0xFF03100E),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.red, width: 2),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.red.withOpacity(0.8),
                            blurRadius: 20,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(16),
                      child: const Icon(
                        Icons.error_outline,
                        size: 48,
                        color: Colors.red,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Yakin dihapus?',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        fontSize: 22,
                        fontFamily: 'Montserrat',
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Kamu yakin catatannya dihapus?\nEnggak bisa dikembalikan loh!',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(
                          child: TextButton(
                            style: TextButton.styleFrom(
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                            onPressed: () => Navigator.of(context).pop(false),
                            child: Text(
                              'Batalkan',
                              style: TextStyle(
                                color: Colors.grey[800],
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: TextButton(
                            style: TextButton.styleFrom(
                              backgroundColor: Colors.red[800],
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                            onPressed: () => Navigator.of(context).pop(true),
                            child: const Text(
                              'Hapus',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
    );

    if (shouldDelete == true) {
      await NoteService.deleteNote(widget.note);
      if (mounted) Navigator.pop(context);
    }
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
      backgroundColor: const Color(0xFF03100E),
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          'Edit Catatan',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontFamily: 'Montserrat',
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: _confirmDelete,
            tooltip: 'Hapus Catatan',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(height: 20),
            TextField(
              controller: _titleController,
              textAlign: TextAlign.left,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w600,
                color: Colors.white,
                fontFamily: 'Montserrat',
              ),
              decoration: const InputDecoration(
                hintText: 'Judul',
                hintStyle: TextStyle(
                  color: Colors.white38,
                  fontFamily: 'Montserrat',
                ),
                border: InputBorder.none,
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: TextField(
                controller: _descController,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w300,
                ),
                // style: const TextStyle(
                //   fontSize: 16,
                //   color: Colors.white,
                //   fontFamily: 'Montserrat',
                //   fontWeight: FontWeight.w300,
                // ),
                maxLines: null,
                decoration: const InputDecoration(
                  hintText: 'Tulis catatanmu...',
                  hintStyle: TextStyle(
                    color: Colors.white54,
                    fontFamily: 'Montserrat',
                  ),
                  // hintStyle: TextStyle(
                  //   color: Colors.white54,
                  //   fontFamily: 'Montserrat',
                  // ),
                  border: InputBorder.none,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.center,
              child: Text(
                'Terakhir diubah: $formattedTime',
                style: const TextStyle(
                  color: Colors.white38,
                  fontSize: 12,
                  fontFamily: 'Montserrat',
                ),
                // style: const TextStyle(
                //   color: Colors.white38,
                //   fontSize: 12,
                //   fontFamily: 'Montserrat',
                // ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
