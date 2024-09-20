import 'package:flutter/material.dart';
import 'package:notepad/widgets/colors.dart';
import 'package:notepad/widgets/notemodel.dart';

class NoteEditScreen extends StatefulWidget {
  final Note? note;
  final Function(Note) onSave;

  NoteEditScreen({this.note, required this.onSave});

  @override
  _NoteEditScreenState createState() => _NoteEditScreenState();
}

class _NoteEditScreenState extends State<NoteEditScreen> {
  late TextEditingController _titleController;
  late TextEditingController _contentController;
  List<TextEditingController> _linkControllers = [];

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.note?.title ?? '');
    _contentController =
        TextEditingController(text: widget.note?.content ?? '');
    _linkControllers = widget.note?.links
            .map((link) => TextEditingController(text: link))
            .toList() ??
        [];
  }

  void _addLink() {
    setState(() {
      _linkControllers.add(TextEditingController());
    });
  }

  void _removeLink(int index) {
    setState(() {
      _linkControllers.removeAt(index);
    });
  }

  void _saveNote() {
    if (_titleController.text.isEmpty &&
        _contentController.text.isEmpty &&
        _linkControllers.every((controller) => controller.text.isEmpty)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cannot save an empty note.')),
      );
      return;
    }

    final updatedNote = Note(
      title: _titleController.text,
      content: _contentController.text,
      pinned: widget.note?.pinned ?? false,
      lastEdited: DateTime.now(),
      links: _linkControllers.map((controller) => controller.text).toList(),
    );
    widget.onSave(updatedNote);
    Navigator.pop(context); //go back to previous screen
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.note == null ? 'New Note' : 'Edit Note',
          style: const TextStyle(
            fontStyle: FontStyle.italic,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: _saveNote,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: _titleController,
                maxLength: 20,
                decoration: const InputDecoration(
                  hintText: 'Enter title',
                  hintStyle: TextStyle(
                    color: CustomColor.hintDark,
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              TextField(
                controller: _contentController,
                maxLines: null,
                decoration: const InputDecoration(
                  hintText: 'Enter your note here...',
                  hintStyle: TextStyle(
                    color: CustomColor.hintDark,
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _linkControllers.length,
                itemBuilder: (context, index) {
                  return Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _linkControllers[index],
                          decoration: const InputDecoration(
                            hintText: 'Enter link',
                            hintStyle: TextStyle(
                              color: CustomColor.hintDark,
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.remove_circle),
                        onPressed: () => _removeLink(index),
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _addLink,
                child: const Text('Add Link'),
              ),
              const SizedBox(height: 16.0),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    final time = TimeOfDay.fromDateTime(dateTime);
    final formattedTime = time.format(context);
    return '${dateTime.toLocal().toString().split(' ')[0]} $formattedTime';
  }
}
