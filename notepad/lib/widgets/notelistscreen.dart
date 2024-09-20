import 'package:flutter/material.dart';
import 'package:notepad/widgets/noteeditscreen.dart';
import 'package:notepad/widgets/notemodel.dart';
import 'package:notepad/widgets/noteview.dart';
import 'package:notepad/widgets/themeprovider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

////main interface page

class NoteListScreen extends StatefulWidget {
  @override
  _NoteListScreenState createState() => _NoteListScreenState();
}

class _NoteListScreenState extends State<NoteListScreen> {
  List<Note> _notes = [];

  @override
  void initState() {
    super.initState();
    _loadNotes();
  }

  Future<void> _loadNotes() async {
    final prefs = await SharedPreferences.getInstance();
    final noteList = prefs.getString('notes');
    if (noteList != null) {
      setState(() {
        _notes = List<Note>.from(
            json.decode(noteList).map((noteJson) => Note.fromJson(noteJson)));
      });
    }
  }

  Future<void> _saveNotes() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(
        'notes', json.encode(_notes.map((note) => note.toJson()).toList()));
  }

  void _addNote() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NoteEditScreen(
          onSave: (note) {
            setState(() {
              _notes.add(note);
              _saveNotes();
            });
          },
        ),
      ),
    );
  }

  void _editNote(Note note) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NoteEditScreen(
          note: note,
          onSave: (updatedNote) {
            setState(() {
              int index = _notes.indexOf(note);
              if (index != -1) {
                _notes[index] = updatedNote;
                _saveNotes(); // Save notes after editing
              }
            });
          },
        ),
      ),
    );
  }

  void _togglePin(Note note) {
    setState(() {
      note.pinned = !note.pinned;
      _notes.sort((a, b) => b.pinned ? 1 : -1);
      _saveNotes();
    });
  }

  void _deleteNote(Note note) {
    setState(() {
      _notes.remove(note);
      _saveNotes();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Notes',
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontStyle: FontStyle.italic,
            fontSize: 28,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.brightness_6),
            onPressed: () {
              Provider.of<ThemeProvider>(context, listen: false).toggleTheme();
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          // Background image
          Positioned.fill(
            child: Opacity(
              opacity: 0.3, // Set opacity for the background image
              child: Image.asset(
                'assets/avatar1.png', // Path to your background image
                fit: BoxFit.cover, // Cover the whole screen
              ),
            ),
          ),
          // Foreground content
          Column(
            children: [
              const SizedBox(height: 0.2),
              const Divider(thickness: 2.0),
              Expanded(
                child: ListView.separated(
                  itemCount: _notes.length,
                  separatorBuilder: (context, index) => const Divider(
                    thickness: 1.0,
                    color: Colors.grey, // Customize divider color if needed
                  ),
                  itemBuilder: (context, index) {
                    final note = _notes[index];
                    return ListTile(
                      title: Text(note.title), // Show title
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            note.content,
                            maxLines: 3,
                          ), // Show content
                          Text(
                            'Date: ${_formatDateTime(note.lastEdited, context)}',
                            style: const TextStyle(fontSize: 10),
                          ),
                        ],
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => NoteViewScreen(
                              note: note,
                              noteIndex: index,
                              onUpdate: (updateNote) {
                                setState(() {
                                  _notes[index] = updateNote;
                                  _saveNotes(); // Save note after update
                                });
                              },
                              onTogglePin: () => _togglePin(note),
                              onDelete: () => _deleteNote(note),
                            ),
                          ),
                        );
                      },
                      trailing: IconButton(
                        icon: Icon(
                          note.pinned
                              ? Icons.push_pin
                              : Icons.push_pin_outlined,
                        ),
                        onPressed: () => _togglePin(note),
                      ),
                    );
                  },
                ),
              ),
              // Footer with text
              Container(
                padding: const EdgeInsets.all(10.0),
                width: double.infinity,
                child: const Text(
                  'Made by AVI',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNote,
        child: const Icon(Icons.add),
      ),
    );
  }

  String _formatDateTime(DateTime dateTime, BuildContext context) {
    final time = TimeOfDay.fromDateTime(dateTime);
    final formattedTime = time.format(context);
    return '${dateTime.toLocal().toString().split(' ')[0]} $formattedTime';
  }
}
