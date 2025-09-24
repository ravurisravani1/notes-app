import 'package:flutter/material.dart';
import 'dart:async';
import '../models/note.dart';
import '../services/api_service.dart';
import 'add_edit_note.dart';

class NotesListScreen extends StatefulWidget {
  @override
  _NotesListScreenState createState() => _NotesListScreenState();
}

class _NotesListScreenState extends State<NotesListScreen> {
  late Future<List<Note>> _futureNotes;
  final TextEditingController _searchController = TextEditingController();
  String _query = '';

  @override
  void initState() {
    super.initState();
    _futureNotes = ApiService.getNotes();
  }

  Future<int?> _askReminderSeconds(BuildContext context) async {
    final controller = TextEditingController(text: '10');
    final seconds = await showDialog<int>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Set reminder (seconds)'),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(hintText: 'e.g. 10'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text('Cancel')),
          TextButton(
            onPressed: () {
              final v = int.tryParse(controller.text.trim());
              Navigator.pop(context, v);
            },
            child: Text('Set'),
          ),
        ],
      ),
    );
    return seconds;
  }

  void refresh() {
    setState(() {
      _futureNotes = ApiService.getNotes();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notes'),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(56),
          child: Padding(
            padding: EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search by title or description...',
                prefixIcon: Icon(Icons.search),
                filled: true,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 12),
              ),
              onChanged: (v) => setState(() => _query = v.trim().toLowerCase()),
            ),
          ),
        ),
      ),
      body: FutureBuilder<List<Note>>(
        future: _futureNotes,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) return Center(child: CircularProgressIndicator());
          if (snapshot.hasError) return Center(child: Text('Error: ${snapshot.error}'));
          final notes = snapshot.data ?? [];
          final filtered = _query.isEmpty
              ? notes
              : notes.where((n) {
                  final t = (n.title).toLowerCase();
                  final d = (n.description).toLowerCase();
                  return t.contains(_query) || d.contains(_query);
                }).toList();
          if (filtered.isEmpty) return Center(child: Text(_query.isEmpty ? 'No notes' : 'No results for "$_query"'));
          return ListView.builder(
            itemCount: filtered.length,
            itemBuilder: (context, i) {
              final n = filtered[i];
              return ListTile(
                title: Text(n.title, style: TextStyle(decoration: n.completed ? TextDecoration.lineThrough : TextDecoration.none)),
                subtitle: Text(n.description),
                leading: IconButton(
                  icon: Icon(n.completed ? Icons.check_box : Icons.check_box_outline_blank),
                  onPressed: () async {
                    await ApiService.updateNote(n.id, n.title, n.description, !n.completed);
                    refresh();
                  },
                ),
                trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                  IconButton(
                    tooltip: 'Remind me',
                    icon: Icon(Icons.alarm),
                    onPressed: () async {
                      final seconds = await _askReminderSeconds(context);
                      if (seconds == null) return;
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Reminder set in ${seconds}s')));
                      Timer(Duration(seconds: seconds), () {
                        if (!mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Reminder: ${n.title}')),
                        );
                      });
                    },
                  ),
                  IconButton(icon: Icon(Icons.edit), onPressed: () async {
                    final res = await Navigator.push(context, MaterialPageRoute(builder: (_) => AddEditNoteScreen(note: n)));
                    if (res == true) refresh();
                  }),
                  IconButton(icon: Icon(Icons.delete), onPressed: () async {
                    await ApiService.deleteNote(n.id);
                    refresh();
                  }),
                ]),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
          final res = await Navigator.push(context, MaterialPageRoute(builder: (_) => AddEditNoteScreen()));
          if (res == true) refresh();
        },
      ),
    );
  }
}
