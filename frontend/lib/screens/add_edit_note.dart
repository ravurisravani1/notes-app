import 'package:flutter/material.dart';
import '../models/note.dart';
import '../services/api_service.dart';

class AddEditNoteScreen extends StatefulWidget {
  final Note? note;
  AddEditNoteScreen({this.note});

  @override
  _AddEditNoteScreenState createState() => _AddEditNoteScreenState();
}

class _AddEditNoteScreenState extends State<AddEditNoteScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descController;
  bool _completed = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.note?.title ?? '');
    _descController = TextEditingController(text: widget.note?.description ?? '');
    _completed = widget.note?.completed ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.note != null;
    return Scaffold(
      appBar: AppBar(title: Text(isEdit ? 'Edit Note' : 'Add Note')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(labelText: 'Title'),
                validator: (v) => v == null || v.isEmpty ? 'Enter title' : null,
              ),
              TextFormField(
                controller: _descController,
                decoration: InputDecoration(labelText: 'Description'),
                maxLines: 4,
              ),
              Row(children: [
                Checkbox(value: _completed, onChanged: (v) => setState(() => _completed = v ?? false)),
                Text('Completed')
              ]),
              SizedBox(height: 16),
              ElevatedButton(
                child: Text(isEdit ? 'Update' : 'Create'),
                onPressed: () async {
                  if (!_formKey.currentState!.validate()) return;
                  final title = _titleController.text.trim();
                  final desc = _descController.text.trim();
                  try {
                    if (isEdit) {
                      await ApiService.updateNote(widget.note!.id, title, desc, _completed);
                    } else {
                      await ApiService.createNote(title, desc);
                    }
                    Navigator.pop(context, true);
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
