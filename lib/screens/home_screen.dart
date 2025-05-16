import 'dart:ui'; // untuk BackdropFilter
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'detail_screen.dart';
import '../models/note_model.dart';
import '../services/note_service.dart';
import '../widgets/note_item.dart';
import 'new_note_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class AssetIcon extends StatelessWidget {
  final String path;
  final double size;
  final Color? color;

  const AssetIcon({super.key, required this.path, this.size = 24, this.color});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      path,
      width: size,
      height: size,
      color:
          color, // hanya bisa kalau file support coloring (misal: SVG atau PNG monokrom)
    );
  }
}

class _HomeScreenState extends State<HomeScreen> {
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  bool _isExpanded = false;
  bool _isSelectionMode = false;
  Set<int> _selectedKeys = {};

  @override
  void initState() {
    super.initState();
    _descController.addListener(_checkParagraphs);
  }

  void _checkParagraphs() {
    final descText = _descController.text;
    final paragraphs = descText.trim().split('\n\n');
    if (paragraphs.length > 2.5) {
      _descController.removeListener(_checkParagraphs);
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
        _titleController.clear();
        _descController.clear();
        setState(() {
          _isExpanded = false;
        });
        _descController.addListener(_checkParagraphs);
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

  void _onLongPress(int key) {
    setState(() {
      _isSelectionMode = true;
      _selectedKeys.add(key);
    });
  }

  void _onTap(int key) {
    if (_isSelectionMode) {
      setState(() {
        if (_selectedKeys.contains(key)) {
          _selectedKeys.remove(key);
          if (_selectedKeys.isEmpty) {
            _isSelectionMode = false;
          }
        } else {
          _selectedKeys.add(key);
        }
      });
    } else {
      final box = Hive.box<Note>('notes');
      final note = box.get(key);
      if (note != null) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => DetailScreen(note: note)),
        );
      }
    }
  }

  void _deleteSelected() async {
    final box = Hive.box<Note>('notes');
    final notesToDelete =
        _selectedKeys.map((key) => box.get(key)).whereType<Note>();
    for (var note in notesToDelete) {
      await NoteService.deleteNote(note);
    }
    setState(() {
      _selectedKeys.clear();
      _isSelectionMode = false;
    });
  }

  Future<bool?> showCustomDeleteDialog(BuildContext context) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => Stack(
            children: [
              // blur background
              BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                child: Container(
                  color: Colors.black.withOpacity(0.3), // gelap transparan
                ),
              ),
              Center(
                child: Dialog(
                  backgroundColor: const Color(0xFF03100E),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: SizedBox(
                      width: 300,
                      height: 300, // tinggi total ditambah agar lebih lega
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 150,
                            height: 150,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                bottom: 12,
                              ), // tambahkan jarak di bawah icon
                              child: Image.asset(
                                'assets/icons/danger.png',
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                          const Text(
                            'Yakin dihapus?',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w900,
                              fontSize: 22,
                            ),
                          ),
                          const SizedBox(height: 12), // jarak antar teks
                          const Text(
                            'Kamu yakin catatanya dihapus?\nEnggak bisa di balikin loh!',
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
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 14,
                                    ),
                                  ),
                                  onPressed:
                                      () => Navigator.of(context).pop(false),
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
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 14,
                                    ),
                                  ),
                                  onPressed:
                                      () => Navigator.of(context).pop(true),
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
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF03100E),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: RichText(
                  text: TextSpan(
                    style: const TextStyle(fontSize: 32, letterSpacing: 2),
                    children: const [
                      TextSpan(
                        text: 'WHY',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Montserrat',
                        ),
                      ),
                      TextSpan(
                        text: 'NOTE',
                        style: TextStyle(
                          color: Color(0xFF58DAC7),
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Center(
              //   child: AnimatedCrossFade(
              //     duration: const Duration(milliseconds: 300),
              //     crossFadeState:
              //         _isExpanded
              //             ? CrossFadeState.showSecond
              //             : CrossFadeState.showFirst,
              //     firstChild: GestureDetector(
              //       onTap: _toggleForm,
              //       child: Padding(
              //         padding: const EdgeInsets.symmetric(horizontal: 16.0),
              //         child: Container(
              //           padding: const EdgeInsets.all(16),
              //           decoration: BoxDecoration(
              //             color: const Color(0xFF03100E),
              //             borderRadius: BorderRadius.circular(12),
              //             border: Border.all(color: const Color(0xFF58DAC7)),
              //           ),
              //           child: const Text(
              //             'Tambahkan Catatan...',
              //             style: TextStyle(
              //               color: Colors.white70,
              //               fontFamily: 'Montserrat',
              //             ),
              //           ),
              //         ),
              //       ),
              //     ),
              //     secondChild: SingleChildScrollView(
              //       child: Container(
              //         padding: const EdgeInsets.all(16),
              //         decoration: BoxDecoration(
              //           color: const Color(0xFF03100E),
              //           borderRadius: BorderRadius.circular(12),
              //           border: Border.all(color: const Color(0xFF58DAC7)),
              //         ),
              //         child: Column(
              //           children: [
              //             TextField(
              //               controller: _titleController,
              //               style: const TextStyle(
              //                 color: Colors.white,
              //                 fontFamily: 'Montserrat',
              //               ),
              //               decoration: const InputDecoration(
              //                 hintText: 'Judul',
              //                 hintStyle: TextStyle(
              //                   color: Color(0xFF58DAC7),
              //                   fontSize: 18,
              //                 ),
              //                 border: InputBorder.none,
              //               ),
              //             ),
              //             const SizedBox(height: 4),
              //             const Divider(color: Color(0xFF58DAC7), thickness: 1),
              //             const SizedBox(height: 2),
              //             TextField(
              //               controller: _descController,
              //               style: const TextStyle(
              //                 color: Colors.white,
              //                 fontFamily: 'Montserrat',
              //                 fontWeight: FontWeight.w300,
              //               ),
              //               maxLines: null,
              //               decoration: const InputDecoration(
              //                 hintText: 'Deskripsi',
              //                 hintStyle: TextStyle(
              //                   color: Color(0xFF58DAC7),
              //                   fontSize: 14,
              //                 ),
              //                 border: InputBorder.none,
              //               ),
              //             ),
              //             const SizedBox(height: 12),
              //             Align(
              //               alignment: Alignment.centerRight,
              //               child: GestureDetector(
              //                 onTap: _saveNote,
              //                 child: Container(
              //                   padding: const EdgeInsets.symmetric(
              //                     vertical: 10,
              //                     horizontal: 20,
              //                   ),
              //                   decoration: BoxDecoration(
              //                     color: const Color(0xFF58DAC7),
              //                     borderRadius: BorderRadius.circular(6),
              //                   ),
              //                   child: const Text(
              //                     'SIMPAN',
              //                     style: TextStyle(
              //                       fontFamily: 'Poppins',
              //                       color: Color(0xFF03100E),
              //                       fontWeight: FontWeight.w800,
              //                       letterSpacing: 2,
              //                     ),
              //                   ),
              //                 ),
              //               ),
              //             ),
              //           ],
              //         ),
              //       ),
              //     ),
              //   ),
              // ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 10.0,
                ),
                child: AnimatedCrossFade(
                  duration: const Duration(milliseconds: 300),
                  crossFadeState:
                      _isExpanded
                          ? CrossFadeState.showSecond
                          : CrossFadeState.showFirst,
                  layoutBuilder: (
                    topChild,
                    topChildKey,
                    bottomChild,
                    bottomChildKey,
                  ) {
                    return Stack(
                      alignment: Alignment.topCenter,
                      children: <Widget>[
                        Positioned(key: bottomChildKey, child: bottomChild),
                        Positioned(key: topChildKey, child: topChild),
                      ],
                    );
                  },
                  firstChild: SizedBox(
                    width: double.infinity,
                    child: GestureDetector(
                      onTap: _toggleForm,
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFF03100E),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFF58DAC7)),
                        ),
                        child: const Text(
                          'Tambahkan Catatan...',
                          style: TextStyle(
                            color: Colors.white70,
                            fontFamily: 'Montserrat',
                          ),
                        ),
                      ),
                    ),
                  ),
                  secondChild: SizedBox(
                    width: double.infinity,
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF03100E),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFF58DAC7)),
                      ),
                      child: Column(
                        children: [
                          TextField(
                            controller: _titleController,
                            style: const TextStyle(
                              color: Colors.white,
                              fontFamily: 'Montserrat',
                            ),
                            decoration: const InputDecoration(
                              hintText: 'Judul',
                              hintStyle: TextStyle(
                                color: Color(0xFF58DAC7),
                                fontSize: 18,
                              ),
                              border: InputBorder.none,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Divider(color: Color(0xFF58DAC7), thickness: 1),
                          const SizedBox(height: 2),
                          TextField(
                            controller: _descController,
                            style: const TextStyle(
                              color: Colors.white,
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.w300,
                            ),
                            maxLines: null,
                            decoration: const InputDecoration(
                              hintText: 'Deskripsi',
                              hintStyle: TextStyle(
                                color: Color(0xFF58DAC7),
                                fontSize: 14,
                              ),
                              border: InputBorder.none,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Align(
                            alignment: Alignment.centerRight,
                            child: GestureDetector(
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
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 14),
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

                    final entries =
                        box.toMap().entries.toList().reversed.toList();

                    return ListView.builder(
                      padding: const EdgeInsets.only(bottom: 100),
                      itemCount: entries.length,
                      itemBuilder: (context, index) {
                        final entry = entries[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10.0),
                          child: NoteItem(
                            note: entry.value,
                            isSelected: _selectedKeys.contains(entry.key),
                            isSelectionMode: _isSelectionMode,
                            onTap: () => _onTap(entry.key),
                            onLongPress: () => _onLongPress(entry.key),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton:
          _isSelectionMode
              ? Padding(
                padding: const EdgeInsets.only(bottom: 40),
                child: Center(
                  heightFactor: 1,
                  child: FloatingActionButton(
                    backgroundColor: Color(0xFF981E1E),
                    onPressed: () async {
                      final shouldDelete = await showCustomDeleteDialog(
                        context,
                      );
                      if (shouldDelete == true) {
                        _deleteSelected();
                      }
                    },
                    shape: const CircleBorder(),
                    child: const AssetIcon(
                      path: 'assets/icons/trash.png',
                      size: 28,
                    ),
                  ),
                ),
              )
              : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
