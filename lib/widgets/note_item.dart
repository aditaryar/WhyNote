import 'package:flutter/material.dart';
import '../models/note_model.dart';

class NoteItem extends StatelessWidget {
  final Note note;
  final bool isSelected;
  final bool isSelectionMode;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  const NoteItem({
    super.key,
    required this.note,
    required this.isSelected,
    required this.isSelectionMode,
    required this.onTap,
    required this.onLongPress,
  });

  static const Color strokeColor = Color.fromARGB(
    255,
    255,
    255,
    255,
  ); // hijau toska terang

  static final List<Color> backgroundColors = [
    Color(0xFF346158),
    Color(0xFF65859C),
    Color(0xFFB37E86),
    Color(0xFF8674BA),
    Color(0xFF739E95),
    Color(0xFFB4A54E),
  ];

  Color getRandomColor(String key) {
    final index = key.hashCode % backgroundColors.length;
    return backgroundColors[index];
  }

  @override
  Widget build(BuildContext context) {
    final bgColor = getRandomColor(note.title);

    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      onSecondaryTap: onLongPress,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(12),
          border:
              isSelectionMode
                  ? Border.all(color: strokeColor.withOpacity(0.5), width: 1.5)
                  : null,
        ),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          note.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600, // SemiBold
                            color: Colors.white,
                            fontFamily: 'Montserrat',
                          ),
                        ),

                        const SizedBox(height: 4),
                        Text(
                          note.description,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w300, // Light
                            color: Colors.white70,
                            fontFamily: 'Montserrat',
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (isSelectionMode)
                    Padding(
                      padding: const EdgeInsets.only(left: 12),
                      child: Checkbox(
                        value: isSelected,
                        onChanged: (_) => onTap(),
                        activeColor: strokeColor,
                        checkColor: Colors.black,
                      ),
                    ),
                ],
              ),
            ),
            if (isSelected)
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(
                      0.2,
                    ), // efek gelap transparan
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
