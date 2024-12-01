import 'package:flutter/material.dart';
import 'package:note_app/database/note_db.dart';
import 'package:note_app/model/note.dart';
import 'package:note_app/widgets/note_form_widget.dart';

class AddEditNotePage extends StatefulWidget {
  final Note? note;
  const AddEditNotePage({super.key, this.note});

  @override
  State<AddEditNotePage> createState() => _AddEditNotePageState();
}

class _AddEditNotePageState extends State<AddEditNotePage> {
  late bool isImportant;
  late int number;
  late String title;
  late String description;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    isImportant = widget.note?.isImportant ?? false;
    number = widget.note?.number ?? 0;
    title = widget.note?.title ?? '';
    description = widget.note?.description ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          _buildButtonSave(),
        ],
      ),
      body: Form(
        key: _formKey,
        child: NoteFormWidget(
          isImportant: isImportant,
          number: number,
          title: title,
          description: description,
          onChangeIsImportant: (value) {
            setState(() {
              isImportant = value;
            });
          },
          onChangeNumber: (value) {
            setState(() {
              number = value;
            });
          },
          onChangeTitle: (value) {
            title = value;
          },
          onChangeDescription: (value) {
            description = value;
          },
        ),
      ),
    );
  }

  Widget _buildButtonSave() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: ElevatedButton(
        onPressed: () async {
          if (_formKey.currentState!.validate()) {
            if (widget.note != null) {
              await NoteDb.instance.update(widget.note!.copy(
                  isImportant: isImportant,
                  number: number,
                  title: title,
                  description: description,
                  createdTime: DateTime.now()));
            } else {
              await NoteDb.instance.create(Note(
                  isImportant: isImportant,
                  number: number,
                  title: title,
                  description: description,
                  createdTime: DateTime.now()));
            }

            Navigator.pop(context);
          }
        },
        child: const Text("Save"),
      ),
    );
  }
}
