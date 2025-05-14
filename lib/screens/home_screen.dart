import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/note_model.dart';
import '../services/note_service.dart';
import '../widgets/note_item.dart';
import 'new_note_screen.dart';

final List<Note> dummyNotes = [
  Note(
    title: 'Belanja Mingguan',
    description: 'Beli sayur, buah, susu, dan roti di supermarket.',
    lastUpdated: DateTime.now().subtract(const Duration(minutes: 5)),
  ),
  Note(
    title: 'Ide Konten YouTube',
    description: 'Review aplikasi produktivitas terbaik di 2025.',
    lastUpdated: DateTime.now().subtract(const Duration(hours: 1)),
  ),
  Note(
    title: 'Reminder Proyek Kampus',
    description: 'Deadline bab 3 skripsi hari Jumat.',
    lastUpdated: DateTime.now().subtract(const Duration(hours: 3)),
  ),
  Note(
    title: 'Catatan Pertemuan Tim',
    description: 'Diskusi fitur baru untuk aplikasi WhyNote.',
    lastUpdated: DateTime.now().subtract(const Duration(days: 1)),
  ),
  Note(
    title: 'List Buku Dibaca',
    description: 'Atomic Habits, Deep Work, The Power of Habit.',
    lastUpdated: DateTime.now().subtract(const Duration(days: 2)),
  ),
  Note(
    title: 'Rencana Liburan',
    description: 'Jelajahi Bali: Ubud, Canggu, dan Seminyak.',
    lastUpdated: DateTime.now().subtract(const Duration(days: 3)),
  ),
];

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _descController.addListener(_checkParagraphs);
  }

  void _checkParagraphs() {
    final descText = _descController.text;
    final paragraphs = descText.trim().split('\n\n');
    if (paragraphs.length > 3) {
      _descController.removeListener(
        _checkParagraphs,
      ); // stop listening untuk cegah trigger berulang
      Navigator.push(
        context,
        MaterialPageRoute(
          builder:
              (_) => NewNoteScreen(
                initialTitle: _titleController.text,
                initialDesc: _descController.text,
              ),
        ),
      ).then((_) {
        // reset setelah kembali dari NewNoteScreen
        _titleController.clear();
        _descController.clear();
        setState(() {
          _isExpanded = false;
        });
        _descController.addListener(_checkParagraphs); // re-add listener
      });
    }
  }

  void _toggleForm() {
    setState(() => _isExpanded = !_isExpanded);
  }

  void _saveNote() async {
    if (_titleController.text.trim().isEmpty &&
        _descController.text.trim().isEmpty)
      return;

    final note = Note(
      title: _titleController.text,
      description: _descController.text,
      lastUpdated: DateTime.now(),
    );

    await NoteService.addNote(note);

    _titleController.clear();
    _descController.clear();
    setState(() => _isExpanded = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              AnimatedCrossFade(
                duration: const Duration(milliseconds: 300),
                crossFadeState:
                    _isExpanded
                        ? CrossFadeState.showSecond
                        : CrossFadeState.showFirst,
                firstChild: GestureDetector(
                  onTap: _toggleForm,
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey[900],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.white24),
                    ),
                    child: const Text(
                      'Tambahkan Catatan...',
                      style: TextStyle(color: Colors.white54),
                    ),
                  ),
                ),
                secondChild: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey[900],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white24),
                  ),
                  child: Column(
                    children: [
                      TextField(
                        controller: _titleController,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          hintText: 'Judul',
                          hintStyle: TextStyle(color: Colors.white54),
                          border: InputBorder.none,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _descController,
                        style: const TextStyle(color: Colors.white),
                        maxLines: null,
                        decoration: const InputDecoration(
                          hintText: 'Deskripsi',
                          hintStyle: TextStyle(color: Colors.white54),
                          border: InputBorder.none,
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
              ),
              const SizedBox(height: 24),
              Expanded(
                child: ValueListenableBuilder(
                  valueListenable: Hive.box<Note>('notes').listenable(),
                  builder: (context, Box<Note> box, _) {
                    if (box.isEmpty) {
                      return const Center(
                        child: Text(
                          'Belum ada catatan.',
                          style: TextStyle(color: Colors.white38),
                        ),
                      );
                    }
                    final notes = box.values.toList().reversed.toList();
                    return ListView.builder(
                      itemCount: notes.length,
                      itemBuilder: (context, index) {
                        final note = notes[index];
                        return NoteItem(note: note);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
