import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:sqflite/sqflite.dart';
import 'package:test/db_helper/db_helper.dart';
import 'package:test/modal_class/notes.dart';
import 'package:test/screens/note_detail.dart';
import 'package:test/utils/widgets.dart';

class NoteList extends StatefulWidget {
  const NoteList({Key? key}) : super(key: key);

  @override
  State<NoteList> createState() => NoteListState();
}

class NoteListState extends State<NoteList> {
  DatabaseHelper databaseHelper = DatabaseHelper();
  List<Note> noteList = [];
  int count = 0;
  int axisCount = 2;

  @override
  void initState() {
    super.initState();
    updateListView();
  }

  @override
  Widget build(BuildContext context) {
    AppBar myAppBar() {
      return AppBar(
        title: Text('Notes', style: Theme.of(context).textTheme.bodyLarge),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
      );
    }

    return Scaffold(
      appBar: myAppBar(),
      body: noteList.isEmpty
          ? const Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
              ),
            )
          : Container(color: Colors.white, child: getNotesList()),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          navigateToDetail(Note('', '', 3, 0), 'Add Note');
        },
        tooltip: 'Add Note',
        shape: const CircleBorder(
            side: BorderSide(color: Colors.black, width: 2.0)),
        child: const Icon(Icons.add, color: Colors.black),
        backgroundColor: Colors.white,
      ),
    );
  }

  Widget getNotesList() {
    return MasonryGridView.builder(
      physics: const BouncingScrollPhysics(),
      gridDelegate: SliverSimpleGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: axisCount),
      itemCount: count,
      mainAxisSpacing: 4.0,
      crossAxisSpacing: 4.0,
      itemBuilder: (BuildContext context, int index) {
        return GestureDetector(
          onTap: () {
            navigateToDetail(noteList[index], 'Edit Note');
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: colors[noteList[index].color],
                border: Border.all(width: 2, color: Colors.black),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            noteList[index].title,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ),
                      ),
                      Text(
                        getPriorityText(noteList[index].priority),
                        style: TextStyle(
                          color: getPriorityColor(noteList[index].priority),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            noteList[index].description ?? '',
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        noteList[index].date,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Color getPriorityColor(int priority) {
    switch (priority) {
      case 1:
        return Colors.red;
      case 2:
        return Colors.yellow;
      case 3:
        return Colors.green;
      default:
        return Colors.yellow;
    }
  }

  String getPriorityText(int priority) {
    switch (priority) {
      case 1:
        return '!!!';
      case 2:
        return '##';
      case 3:
        return '#';
      default:
        return '@';
    }
  }

  void navigateToDetail(Note note, String title) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => NoteDetail(note, title)),
    );
    if (result == true) {
      updateListView();
    }
  }

  void updateListView() {
    databaseHelper.initializeDatabase().then((database) {
      databaseHelper.getNoteList().then((noteList) {
        setState(() {
          this.noteList = noteList;
          count = noteList.length;
        });
      }).catchError((error) {
        print("Error retrieving note list: $error");
      });
    }).catchError((error) {
      print("Error initializing database: $error");
    });
  }
}
