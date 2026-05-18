import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:note_app/pages/add_edit_note_page.dart';
import 'package:note_app/pages/note_detail_page.dart';
import 'package:note_app/providers/note_provider.dart';
import 'package:note_app/providers/theme_provider.dart';
import 'package:note_app/widgets/note_card_widget.dart';
import 'package:provider/provider.dart';

class NotePage extends StatelessWidget {
  const NotePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const _NotePageView();
  }
}

class _NotePageView extends StatelessWidget {
  const _NotePageView();

  @override
  Widget build(BuildContext context) {
    final noteProvider = context.watch<NoteProvider>();
    final notes = noteProvider.notes;

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Notes'),
        actions: [
          PopupMenuButton<NoteSort>(
            icon: const Icon(Icons.sort),
            initialValue: noteProvider.sort,
            onSelected: noteProvider.setSort,
            itemBuilder: (context) => const [
              PopupMenuItem(
                value: NoteSort.dateNewest,
                child: Text('Sort: Newest'),
              ),
              PopupMenuItem(
                value: NoteSort.dateOldest,
                child: Text('Sort: Oldest'),
              ),
              PopupMenuItem(
                value: NoteSort.importantFirst,
                child: Text('Sort: Importance'),
              ),
            ],
          ),
          IconButton(
            tooltip: 'Toggle Theme',
            onPressed: context.read<ThemeProvider>().toggleTheme,
            icon: Icon(
              context.watch<ThemeProvider>().isDarkMode
                  ? Icons.light_mode_rounded
                  : Icons.dark_mode_rounded,
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              onChanged: noteProvider.setSearchQuery,
              decoration: InputDecoration(
                hintText: 'Search notes...',
                prefixIcon: const Icon(Icons.search_rounded),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: noteProvider.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : notes.isEmpty
                    ? const Center(
                        child: Text(
                          'No Notes',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      )
                    : MasonryGridView.count(
                        key: const ValueKey('notes_grid'),
                        crossAxisCount: 2,
                        mainAxisSpacing: 12,
                        crossAxisSpacing: 12,
                        itemCount: notes.length,
                        itemBuilder: (context, index) {
                          final note = notes[index];

                          return InkWell(
                            borderRadius: BorderRadius.circular(16),
                            onTap: () => Navigator.of(context).push(
                              _buildRoute(NoteDetailPage(noteId: note.id!)),
                            ),
                            child: NoteCardWidget(note: note),
                          );
                        },
                      ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () =>
            Navigator.of(context).push(_buildRoute(const AddEditNotePage())),
        icon: const Icon(Icons.add_rounded),
        label: const Text('Add Note'),
      ),
    );
  }
}

PageRouteBuilder<void> _buildRoute(Widget page) {
  return PageRouteBuilder<void>(
    transitionDuration: const Duration(milliseconds: 250),
    reverseTransitionDuration: const Duration(milliseconds: 220),
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final curved = CurvedAnimation(
        parent: animation,
        curve: Curves.easeOutCubic,
      );
      return FadeTransition(
        opacity: curved,
        child: SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 0.06),
            end: Offset.zero,
          ).animate(curved),
          child: child,
        ),
      );
    },
  );
}
