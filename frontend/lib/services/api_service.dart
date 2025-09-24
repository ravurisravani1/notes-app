
    import 'dart:convert';
    import 'package:http/http.dart' as http;
    import '../models/note.dart';

    class ApiService {
      // Change baseUrl to your backend URL
      static const String baseUrl = 'http://localhost:3000';

      static Future<List<Note>> getNotes() async {
        final res = await http.get(Uri.parse('$baseUrl/notes'));
        if (res.statusCode == 200) {
          final List data = json.decode(res.body);
          return data.map((e) => Note.fromJson(e)).toList();
        } else {
          throw Exception('Failed to load notes');
        }
      }

      static Future<Note> createNote(String title, String description) async {
        final res = await http.post(Uri.parse('$baseUrl/notes'),
          headers: {'Content-Type': 'application/json'},
          body: json.encode({'title': title, 'description': description}),
        );
        if (res.statusCode == 201) {
          return Note.fromJson(json.decode(res.body));
        } else {
          throw Exception('Failed to create');
        }
      }

      static Future<Note> updateNote(String id, String title, String description, bool completed) async {
        final res = await http.put(Uri.parse('$baseUrl/notes/$id'),
          headers: {'Content-Type': 'application/json'},
          body: json.encode({'title': title, 'description': description, 'completed': completed}),
        );
        if (res.statusCode == 200) {
          return Note.fromJson(json.decode(res.body));
        } else {
          throw Exception('Failed to update');
        }
      }

      static Future<void> deleteNote(String id) async {
        final res = await http.delete(Uri.parse('$baseUrl/notes/$id'));
        if (res.statusCode != 200 && res.statusCode != 204) {
          throw Exception('Failed to delete');
        }
      }
    }
