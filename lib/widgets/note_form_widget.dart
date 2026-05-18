import 'package:flutter/material.dart';

class NoteFormWidget extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final bool isImportant;
  final int number;
  final String title;
  final String description;
  final ValueChanged<bool> onChangedImportant;
  final ValueChanged<int> onChangedNumber;
  final ValueChanged<String> onChangedTitle;
  final ValueChanged<String> onChangedDescription;
  final VoidCallback onSaved;

  const NoteFormWidget({
    super.key,
    required this.formKey,
    required this.isImportant,
    required this.number,
    required this.title,
    required this.description,
    required this.onChangedImportant,
    required this.onChangedNumber,
    required this.onChangedTitle,
    required this.onChangedDescription,
    required this.onSaved,
  });

  @override
  State<NoteFormWidget> createState() => _NoteFormWidgetState();
}

class _NoteFormWidgetState extends State<NoteFormWidget> {
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.title);
    _descriptionController = TextEditingController(text: widget.description);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SwitchListTile.adaptive(
            contentPadding: EdgeInsets.zero,
            title: const Text('Important'),
            value: widget.isImportant,
            onChanged: widget.onChangedImportant,
          ),
          const SizedBox(height: 8),
          Text('Priority: ${widget.number}'),
          Slider(
            value: widget.number.toDouble(),
            min: 0,
            max: 5,
            divisions: 5,
            label: widget.number.toString(),
            onChanged: (value) => widget.onChangedNumber(value.toInt()),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: _titleController,
            decoration: const InputDecoration(
              labelText: 'Title',
              border: OutlineInputBorder(),
            ),
            textInputAction: TextInputAction.next,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Title is required';
              }
              return null;
            },
            onChanged: widget.onChangedTitle,
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _descriptionController,
            decoration: const InputDecoration(
              labelText: 'Description',
              alignLabelWithHint: true,
              border: OutlineInputBorder(),
            ),
            minLines: 6,
            maxLines: 10,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Description is required';
              }
              return null;
            },
            onChanged: widget.onChangedDescription,
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: () {
                if (widget.formKey.currentState!.validate()) {
                  widget.onSaved();
                }
              },
              icon: const Icon(Icons.save_rounded),
              label: const Text('Save Note'),
            ),
          ),
        ],
      ),
    );
  }
}
