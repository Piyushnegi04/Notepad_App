import 'package:flutter/material.dart';
import 'package:notepad/widgets/clickabletext.dart';
import 'package:notepad/widgets/noteeditscreen.dart';
import 'package:notepad/widgets/notemodel.dart';

class NoteViewScreen extends StatelessWidget {
  final Note note;
  final int noteIndex;
  final Function(Note) onUpdate;
  final VoidCallback onTogglePin;
  final VoidCallback onDelete;

  NoteViewScreen({
    required this.note,
    required this.noteIndex,
    required this.onUpdate,
    required this.onTogglePin,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //title: Text(note.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              // Navigate to editscreen
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NoteEditScreen(
                    note: note,
                    onSave: (updateNote) {
                      onUpdate(updateNote);
                      Navigator.pop(context);
                    },
                  ),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text('Delete Note?'),
                    //content: Text('Are you sure you want to delete this note?'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          onDelete(); // Call the delete callback
                          Navigator.of(context)
                              .pop(); // Close the NoteViewScreen
                        },
                        child: const Text('OK'),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              note.title,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Date: ${_formatDateTime(note.lastEdited, context)}',
                      style: const TextStyle(fontSize: 10),
                    ),
                    Text(
                      'Character count: ${note.characterCount}',
                      style: const TextStyle(fontSize: 10),
                    ),
                    const SizedBox(height: 28),
                    Text(note.content),
                    const SizedBox(height: 16),
                    ...note.links.map((link) => ClickableText(link)).toList(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDateTime(DateTime dateTime, BuildContext context) {
    final time = TimeOfDay.fromDateTime(dateTime);
    final formattedTime = time.format(context);
    return '${dateTime.toLocal().toString().split(' ')[0]} $formattedTime';
  }
}
