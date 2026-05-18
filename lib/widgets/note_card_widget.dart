import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:note_app/models/note.dart';

class NoteCardWidget extends StatelessWidget {
  final Note note;

  const NoteCardWidget({super.key, required this.note});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = _noteColorFor(
      note.id ?? note.title.hashCode,
      theme.brightness,
    );
    final isDarkCard = color.computeLuminance() < 0.45;
    final textColor = isDarkCard ? Colors.white : const Color(0xFF1D1D1D);
    final subtitleColor = textColor.withValues(alpha: 0.88);
    final chipBackground = isDarkCard
        ? Colors.white.withValues(alpha: 0.16)
        : Colors.black.withValues(alpha: 0.08);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (note.isImportant)
            Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: chipBackground,
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(
                'Important',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: textColor,
                ),
              ),
            ),
          Text(
            note.title,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: textColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            note.description,
            maxLines: max(2, note.number + 1),
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 13, height: 1.35, color: subtitleColor),
          ),
          const SizedBox(height: 12),
          Text(
            DateFormat('MMM dd, yyyy').format(note.createdTime),
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: subtitleColor,
            ),
          ),
        ],
      ),
    );
  }
}

Color _noteColorFor(int seed, Brightness brightness) {
  final random = Random(seed);
  final hue = random.nextDouble() * 360;
  final saturation = brightness == Brightness.dark ? 0.50 : 0.58;
  final lightness = brightness == Brightness.dark ? 0.30 : 0.82;
  return HSLColor.fromAHSL(1, hue, saturation, lightness).toColor();
}
