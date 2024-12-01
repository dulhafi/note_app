import 'package:flutter/material.dart';
import 'package:note_app/database/note_db.dart';
import 'package:note_app/model/note.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:note_app/pages/add_edit_note_page.dart';
import 'package:note_app/pages/note_detail_page.dart';
import 'package:note_app/widgets/note_card_widget.dart';

class HomePages extends StatefulWidget {
  const HomePages({super.key});

  @override
  State<HomePages> createState() => _HomePagesState();
}

class _HomePagesState extends State<HomePages> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notes'),
      ),
      body: FutureBuilder<List<Note>>(
        future: NoteDb.instance.getAllNotes(),
        builder: (BuildContext context, AsyncSnapshot<List<Note>> snapshot) {
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

          if (snapshot.data!.isEmpty) {
            return const Center(
              child: Text('EMPTY'),
            );
          }

          return MasonryGridView.count(
              crossAxisCount: 2,
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final note = snapshot.data![index];
                return GestureDetector(
                    onTap: () async {
                      await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  NoteDetailPage(id: note.id!)));
                    },
                    child: NoteCardWidget(note: note, index: index));
              });
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // final note = Note(
          //   isImportant: false,
          //   number: 0,
          //   title: 'title',
          //   description: 'description',
          //   createdTime: DateTime.now(),
          // );
          // await NoteDb.instance.create(note);
          // setState(() {});

          await Navigator.push(context,
              MaterialPageRoute(builder: (context) => const AddEditNotePage()));
          setState(() {});
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
