import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:note_app/database/note_db.dart';
import 'package:note_app/model/note.dart';
import 'package:note_app/pages/add_edit_note_page.dart';

class NoteDetailPage extends StatefulWidget {
  final int id;
  const NoteDetailPage({super.key, required this.id});

  @override
  State<NoteDetailPage> createState() => _NoteDetailPageState();
}

class _NoteDetailPageState extends State<NoteDetailPage> {
  Note? note;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          editButton(),
          deleteButton()
        ],
      ),
      body: FutureBuilder<Note>(
        future: NoteDb.instance.getNoteById(widget.id),
        builder: (BuildContext context, AsyncSnapshot<Note> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          }

          note = snapshot.data!;

          return ListView(
            padding: const EdgeInsets.all(8),
            children: [
              Text(
                note!.title,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              Text(
                DateFormat.yMMMd().format(note!.createdTime),
              ),
              const SizedBox(
                height: 8,
              ),
              Text(
                note!.description,
                style: const TextStyle(
                  fontSize: 18,
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget editButton() {
    return IconButton(
      onPressed: () async {
        await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddEditNotePage(note: note),
            ));
        setState(() {});
      },
      icon: const Icon(Icons.edit_outlined), // Icons.delete
    );
  }

  Widget deleteButton() {
    return IconButton(
      onPressed: () async {
        if (note != null) {
          await NoteDb.instance.delete(note!.id!);
          Navigator.pop(context);
        }
      },
      icon: const Icon(Icons.delete), // Icons.delete
    );
  }
}
